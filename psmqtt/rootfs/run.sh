#!/usr/bin/env bashio

# ==============================================================================
# psmqtt Home Assistant Add-on
# Generates psmqtt.yaml from HA addon configuration and starts psmqtt
# ==============================================================================

CONFIG_FILE="/opt/psmqtt/conf/psmqtt.yaml"

# Read MQTT configuration
MQTT_HOST=$(bashio::config 'mqtt_host')
MQTT_PORT=$(bashio::config 'mqtt_port')
MQTT_USERNAME=$(bashio::config 'mqtt_username')
MQTT_PASSWORD=$(bashio::config 'mqtt_password')
MQTT_CLIENTID=$(bashio::config 'mqtt_clientid')
MQTT_QOS=$(bashio::config 'mqtt_qos')
MQTT_RETAIN=$(bashio::config 'mqtt_retain')
MQTT_CLEAN_SESSION=$(bashio::config 'mqtt_clean_session')
MQTT_RECONNECT=$(bashio::config 'mqtt_reconnect_period_sec')
MQTT_PREFIX=$(bashio::config 'mqtt_publish_topic_prefix')
HA_DISC_ENABLED=$(bashio::config 'mqtt_ha_discovery_enabled')
HA_DISC_TOPIC=$(bashio::config 'mqtt_ha_discovery_topic')
HA_DISC_DEVICE=$(bashio::config 'mqtt_ha_discovery_device_name')
LOG_LEVEL=$(bashio::config 'logging_level')
SCHEDULE_YAML=$(bashio::config 'schedule_yaml')

# Validate required fields
if [ -z "${MQTT_HOST}" ] || [ "${MQTT_HOST}" = "null" ]; then
    bashio::log.fatal "MQTT host is required!"
    bashio::exit.nok
fi

bashio::log.notice "Generating psmqtt configuration..."

# Write structured MQTT section
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

# Add remaining MQTT options
cat >> "${CONFIG_FILE}" << YAML_END
  clientid: ${MQTT_CLIENTID}
  clean_session: ${MQTT_CLEAN_SESSION}
  qos: ${MQTT_QOS}
  retain: ${MQTT_RETAIN}
  reconnect_period_sec: ${MQTT_RECONNECT}
YAML_END

# Add optional topic prefix
if bashio::config.has_value 'mqtt_publish_topic_prefix'; then
    echo "  publish_topic_prefix: \"${MQTT_PREFIX}\"" >> "${CONFIG_FILE}"
fi

# Add HA discovery section
cat >> "${CONFIG_FILE}" << YAML_END
  ha_discovery:
    enabled: ${HA_DISC_ENABLED}
    topic: ${HA_DISC_TOPIC}
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
