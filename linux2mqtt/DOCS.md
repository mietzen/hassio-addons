# Home Assistant Add-on: linux2mqtt

Publishes Home Assistant host system metrics to MQTT.

## Configuration Options

### Option: `mqtt_host`

The hostname or IP address of your MQTT broker. Defaults to `core-mosquitto` (the built-in Mosquitto addon).

### Option: `mqtt_user` (Optional)

Username for MQTT broker authentication.

### Option: `mqtt_password` (Optional)

Password for MQTT broker authentication.

### Option: `smart_short_test_schedule` (Optional)

Cron schedule for SMART short self-tests on all detected drives. Defaults to `0 3 * * 0` (weekly on Sunday at 3:00 AM). Uses standard cron syntax.

### Option: `smart_long_test_schedule` (Optional)

Cron schedule for SMART extended self-tests on all detected drives. Defaults to `0 4 1 * *` (monthly on the 1st at 4:00 AM). Uses standard cron syntax.

## Monitored Metrics

The addon publishes the following metrics every 60 seconds:

- **CPU**: Usage percentage (60 second average)
- **Virtual Memory**: Usage statistics
- **Temperature**: All available temperature sensors
- **Hard Drives**: SMART data from all detected drives
- **Disk Usage**: Usage of `/config` mount

All metrics are published with Home Assistant MQTT auto-discovery, so sensors appear automatically in HA.

## Protection Mode

This addon requires **Protection mode to be disabled** in the addon settings for full host access (disk metrics, SMART monitoring). Navigate to the addon's Info tab and disable "Protection mode".
