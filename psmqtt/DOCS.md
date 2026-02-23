# Home Assistant Add-on: psmqtt

Publishes host system metrics to MQTT using psmqtt.

## Configuration Options

### Option: `mqtt_host`

The hostname or IP address of your MQTT broker. **Required.** Use `core-mosquitto` for the built-in Mosquitto addon.

### Option: `mqtt_port`

The port number of your MQTT broker. Defaults to `1883`.

### Option: `mqtt_username` (Optional)

Username for MQTT broker authentication.

### Option: `mqtt_password` (Optional)

Password for MQTT broker authentication.

### Option: `mqtt_clientid` (Optional)

The MQTT client ID used by psmqtt. Defaults to `psmqtt`.

### Option: `mqtt_publish_topic_prefix` (Optional)

Optional prefix prepended to all MQTT topics.

### Option: `mqtt_ha_discovery_device_name` (Optional)

Custom device name for Home Assistant discovery. Leave empty to use the hostname.

### Option: `smart_devices` (Optional)

List of block device paths to monitor with SMART (e.g., `/dev/sda`, `/dev/sdb`). The addon includes `smartmontools` and runs with `SYS_RAWIO` capability for SMART access. HA OS does not include SMART tools, so this addon handles it internally.

### Option: `smart_short_test_schedule` (Optional)

Cron schedule for SMART short self-tests. Defaults to `0 3 * * 0` (weekly on Sunday at 3:00 AM). Uses standard cron syntax.

### Option: `smart_long_test_schedule` (Optional)

Cron schedule for SMART extended self-tests. Defaults to `0 4 1 * *` (monthly on the 1st at 4:00 AM). Uses standard cron syntax.

### Option: `logging_level` (Optional)

The logging verbosity level for psmqtt. Can be `DEBUG`, `INFO`, `WARNING`, or `ERROR`. Defaults to `INFO`.

### Option: `schedule_yaml`

The full psmqtt schedule configuration in YAML format. This defines which system metrics to collect, how often, and which MQTT topics to publish to.

The host root filesystem is mounted read-only at `/host/root` inside the container. Use this path for `disk_usage` tasks to report host disk usage.

Example:

```yaml
- cron: "every 5 minutes"
  tasks:
    - task: cpu_percent
      topic: "psmqtt/{hostname}/cpu/percent"
      ha_discovery:
        name: "CPU Usage"
        icon: "mdi:cpu-64-bit"
        unit_of_measurement: "%"
        state_class: "measurement"
    - task: virtual_memory
      params: [percent]
      topic: "psmqtt/{hostname}/memory/percent"
      ha_discovery:
        name: "Memory Usage"
        icon: "mdi:memory"
        unit_of_measurement: "%"
        state_class: "measurement"
    - task: disk_usage
      params: ["/host/root", percent]
      topic: "psmqtt/{hostname}/disk/percent"
      ha_discovery:
        name: "Disk Usage"
        icon: "mdi:harddisk"
        unit_of_measurement: "%"
        state_class: "measurement"
```

For all available tasks (CPU, memory, disk, network, temperature, fans, battery, processes, SMART), see the [psmqtt documentation](https://github.com/eschava/psmqtt/blob/master/doc/usage.md).

## Fixed MQTT Settings

The following MQTT settings are fixed for optimal HA integration and cannot be changed:

| Setting | Value |
|---|---|
| QoS | 1 |
| Retain | true |
| Clean Session | false |
| Reconnect Period | 10 seconds |
| HA Discovery | enabled |
| HA Discovery Topic | homeassistant |

## Protection Mode

This addon requires **Protection mode to be disabled** in the addon settings for full host access (disk metrics, SMART monitoring). Navigate to the addon's Info tab and disable "Protection mode".
