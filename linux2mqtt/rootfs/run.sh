#!/usr/bin/env bashio

# ==============================================================================
# linux2mqtt Home Assistant Add-on
# Reads HA config and starts linux2mqtt
# ==============================================================================

MQTT_HOST=$(bashio::config 'mqtt_host')
MQTT_USER=$(bashio::config 'mqtt_user')
MQTT_PASSWORD=$(bashio::config 'mqtt_password')

# Validate required fields
if [ -z "${MQTT_HOST}" ] || [ "${MQTT_HOST}" = "null" ]; then
    bashio::log.fatal "MQTT host is required!"
    bashio::exit.nok
fi

# Export MQTT environment variables
export MQTT_HOST="${MQTT_HOST}"

if bashio::config.has_value 'mqtt_user'; then
    export MQTT_USER="${MQTT_USER}"
fi
if bashio::config.has_value 'mqtt_password'; then
    export MQTT_PASSWORD="${MQTT_PASSWORD}"
fi

# Setup SMART test cron jobs
SMART_SHORT_SCHEDULE=$(bashio::config 'smart_short_test_schedule')
SMART_LONG_SCHEDULE=$(bashio::config 'smart_long_test_schedule')

# Discover SMART-capable devices
SMART_DEVICES=$(smartctl --scan 2>/dev/null | awk '{print $1}')
if [ -n "${SMART_DEVICES}" ]; then
    SHORT_SCRIPT="/opt/linux2mqtt/smart-short-test.sh"
    LONG_SCRIPT="/opt/linux2mqtt/smart-long-test.sh"
    mkdir -p /opt/linux2mqtt

    echo "#!/bin/bash" > "${SHORT_SCRIPT}"
    echo "#!/bin/bash" > "${LONG_SCRIPT}"

    while read -r device; do
        if [ -e "${device}" ]; then
            bashio::log.notice "Adding SMART tests for ${device}"
            echo "smartctl -t short ${device} > /dev/null 2>&1" >> "${SHORT_SCRIPT}"
            echo "smartctl -t long ${device} > /dev/null 2>&1" >> "${LONG_SCRIPT}"
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

bashio::log.notice "Starting linux2mqtt..."

LINUX2MQTT_ARGS="--name home-assistant --interval 60 --cpu=60 --vm --temp --du='/'"

LOG_VERBOSITY=$(bashio::config 'log_verbosity')
VERBOSE_FLAG=$(printf '%0.sv' $(seq 1 "${LOG_VERBOSITY}"))
LINUX2MQTT_ARGS="${LINUX2MQTT_ARGS} -${VERBOSE_FLAG}"

if [ -d "/dev/disk/by-id" ]; then
    LINUX2MQTT_ARGS="${LINUX2MQTT_ARGS} --harddrives"
else
    bashio::log.warning "No /dev/disk/by-id found, skipping hard drive monitoring"
fi

exec /opt/linux2mqtt-venv/bin/linux2mqtt ${LINUX2MQTT_ARGS}
