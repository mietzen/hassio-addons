# Home Assistant Add-on: linux2mqtt

Publishes Home Assistant host system metrics to MQTT.

## Configuration Options

### Option: `mqtt_host`

The hostname or IP address of your MQTT broker. Defaults to `core-mosquitto` (the built-in Mosquitto addon).

### Option: `mqtt_user` (Optional)

Username for MQTT broker authentication.

### Option: `mqtt_password` (Optional)

Password for MQTT broker authentication.

### Option: `smart_monitoring` (Optional)

Enables SMART hard drive monitoring and SMART self-test scheduling. Defaults to `false`. When enabled, the addon discovers SMART-capable devices, publishes their data to MQTT, and schedules short/long self-tests. **Requires Protection mode to be disabled** and a host that exposes SMART data (not available on Home Assistant OS VMs).

### Option: `smart_short_test_schedule` (Optional)

Cron schedule for SMART short self-tests on all detected drives. Defaults to `0 3 * * 0` (weekly on Sunday at 3:00 AM). Uses standard cron syntax. Only applies when `smart_monitoring` is enabled.

### Option: `smart_long_test_schedule` (Optional)

Cron schedule for SMART extended self-tests on all detected drives. Defaults to `0 4 1 * *` (monthly on the 1st at 4:00 AM). Uses standard cron syntax. Only applies when `smart_monitoring` is enabled.

### Option: `disk_usage` (Optional)

Enables disk usage monitoring of the `/` mount. Defaults to `false`. **Requires Protection mode to be disabled**.

## Monitored Metrics

The addon publishes the following metrics every 60 seconds:

- **CPU**: Usage percentage (60 second average)
- **Virtual Memory**: Usage statistics
- **Temperature**: All available temperature sensors
- **Hard Drives**: SMART data from all detected drives (only when `smart_monitoring` is enabled)
- **Disk Usage**: Usage of the `/` mount (only when `disk_usage` is enabled)

All metrics are published with Home Assistant MQTT auto-discovery, so sensors appear automatically in HA.

## Protection Mode

SMART monitoring (`smart_monitoring`) and disk usage monitoring (`disk_usage`) require **Protection mode to be disabled** in the addon settings for full host access. Navigate to the addon's Info tab and disable "Protection mode".

Both options are **disabled by default**, so the addon runs fine with Protection mode enabled when you only need CPU, memory and temperature metrics. Enable `smart_monitoring` and/or `disk_usage` only if you need those metrics and are willing to disable Protection mode.
