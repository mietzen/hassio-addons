#!/usr/bin/env bashio

# ==============================================================================
# psmqtt Home Assistant Add-on
# Generates psmqtt.yaml from HA addon configuration and starts psmqtt
# ==============================================================================

CONFIG_FILE="/opt/psmqtt/conf/psmqtt.yaml"

# Setup SMART monitoring for configured devices
SMART_DEVICES=$(bashio::config 'smart_devices')
if [ -n "${SMART_DEVICES}" ] && [ "${SMART_DEVICES}" != "null" ]; then
    bashio::log.notice "Setting up SMART monitoring..."

    SMART_SHORT_SCHEDULE=$(bashio::config 'smart_short_test_schedule')
    SMART_LONG_SCHEDULE=$(bashio::config 'smart_long_test_schedule')

    SHORT_SCRIPT="/opt/psmqtt/smart-short-test.sh"
    LONG_SCRIPT="/opt/psmqtt/smart-long-test.sh"

    # Build short test script (weekly)
    echo "#!/bin/bash" > "${SHORT_SCRIPT}"
    # Build long test script (monthly)
    echo "#!/bin/bash" > "${LONG_SCRIPT}"

    while read -r device; do
        if [ -e "${device}" ]; then
            bashio::log.notice "Adding SMART tests for ${device}"
            echo "smartctl -t short ${device} > /dev/null 2>&1" >> "${SHORT_SCRIPT}"
            echo "smartctl -t long ${device} > /dev/null 2>&1" >> "${LONG_SCRIPT}"
        else
            bashio::log.warning "Device ${device} not found, skipping"
        fi
    done <<< "${SMART_DEVICES}"
    chmod +x "${SHORT_SCRIPT}" "${LONG_SCRIPT}"

    # Run initial short test
    bashio::log.notice "Running initial SMART short test..."
    "${SHORT_SCRIPT}"

    # Install cron jobs
    CRONTAB_CONTENT=""
    if [ -n "${SMART_SHORT_SCHEDULE}" ] && [ "${SMART_SHORT_SCHEDULE}" != "null" ]; then
        CRONTAB_CONTENT="${SMART_SHORT_SCHEDULE} ${SHORT_SCRIPT}"
        bashio::log.notice "SMART short test schedule: ${SMART_SHORT_SCHEDULE}"
    fi
    if [ -n "${SMART_LONG_SCHEDULE}" ] && [ "${SMART_LONG_SCHEDULE}" != "null" ]; then
        CRONTAB_CONTENT="${CRONTAB_CONTENT}
${SMART_LONG_SCHEDULE} ${LONG_SCRIPT}"
        bashio::log.notice "SMART long test schedule: ${SMART_LONG_SCHEDULE}"
    fi

    if [ -n "${CRONTAB_CONTENT}" ]; then
        echo "${CRONTAB_CONTENT}" | crontab -
        cron
        bashio::log.notice "SMART cron jobs installed"
    fi
fi

# Read configurable MQTT options
MQTT_HOST=$(bashio::config 'mqtt_host')
MQTT_PORT=$(bashio::config 'mqtt_port')
MQTT_USERNAME=$(bashio::config 'mqtt_username')
MQTT_PASSWORD=$(bashio::config 'mqtt_password')
MQTT_CLIENTID=$(bashio::config 'mqtt_clientid')
MQTT_PREFIX=$(bashio::config 'mqtt_publish_topic_prefix')
HA_DISC_DEVICE=$(bashio::config 'mqtt_ha_discovery_device_name')
LOG_LEVEL=$(bashio::config 'logging_level')
SCHEDULE_YAML=$(bashio::config 'schedule_yaml')

# Validate required fields
if [ -z "${MQTT_HOST}" ] || [ "${MQTT_HOST}" = "null" ]; then
    bashio::log.fatal "MQTT host is required!"
    bashio::exit.nok
fi

bashio::log.notice "Generating psmqtt configuration..."

# Write config with fixed MQTT settings
cat > "${CONFIG_FILE}" << YAML_END
logging:
  level: ${LOG_LEVEL}

mqtt:
  broker:
    host: ${MQTT_HOST}
    port: ${MQTT_PORT}
YAML_END

# Add optional MQTT auth
if bashio::config.has_value 'mqtt_username'; then
    echo "    username: \"${MQTT_USERNAME}\"" >> "${CONFIG_FILE}"
fi
if bashio::config.has_value 'mqtt_password'; then
    echo "    password: \"${MQTT_PASSWORD}\"" >> "${CONFIG_FILE}"
fi

# Add fixed MQTT options
cat >> "${CONFIG_FILE}" << YAML_END
  clientid: ${MQTT_CLIENTID}
  clean_session: false
  qos: 1
  retain: true
  reconnect_period_sec: 10
YAML_END

# Add optional topic prefix
if bashio::config.has_value 'mqtt_publish_topic_prefix'; then
    echo "  publish_topic_prefix: \"${MQTT_PREFIX}\"" >> "${CONFIG_FILE}"
fi

# Add fixed HA discovery section
cat >> "${CONFIG_FILE}" << YAML_END
  ha_discovery:
    enabled: true
    topic: homeassistant
YAML_END

if bashio::config.has_value 'mqtt_ha_discovery_device_name'; then
    echo "    device_name: \"${HA_DISC_DEVICE}\"" >> "${CONFIG_FILE}"
fi

# Add the schedule section (raw YAML from user config)
echo "" >> "${CONFIG_FILE}"
echo "schedule:" >> "${CONFIG_FILE}"
echo "${SCHEDULE_YAML}" >> "${CONFIG_FILE}"

bashio::log.notice "Configuration written to ${CONFIG_FILE}"
bashio::log.notice "Starting psmqtt..."

# Set the config path and execute psmqtt
export PSMQTTCONFIG="${CONFIG_FILE}"
exec /opt/psmqtt-venv/bin/psmqtt
