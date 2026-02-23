# Home Assistant Add-on: psmqtt

Publishes host system metrics to MQTT using psmqtt.

## Configuration Options

### Option: `mqtt_host`

The hostname or IP address of your MQTT broker. **Required.**

### Option: `mqtt_port`

The port number of your MQTT broker. Defaults to `1883`.

### Option: `mqtt_username` (Optional)

Username for MQTT broker authentication.

### Option: `mqtt_password` (Optional)

Password for MQTT broker authentication.

### Option: `mqtt_clientid` (Optional)

The MQTT client ID used by psmqtt. Defaults to `psmqtt`.

### Option: `mqtt_qos` (Optional)

MQTT Quality of Service level. Can be `0`, `1`, or `2`. Defaults to `0`.

### Option: `mqtt_retain` (Optional)

Whether to set the retain flag on published MQTT messages. Defaults to `false`.

### Option: `mqtt_clean_session` (Optional)

Whether to use a clean MQTT session on each connection. Defaults to `true`.

### Option: `mqtt_reconnect_period_sec` (Optional)

Seconds to wait before reconnecting to the MQTT broker after a disconnect. Defaults to `5`.

### Option: `mqtt_publish_topic_prefix` (Optional)

Optional prefix prepended to all MQTT topics.

### Option: `mqtt_ha_discovery_enabled` (Optional)

Enable Home Assistant MQTT auto-discovery for psmqtt sensors. Defaults to `true`.

### Option: `mqtt_ha_discovery_topic` (Optional)

The MQTT topic prefix used for Home Assistant discovery. Defaults to `homeassistant`.

### Option: `mqtt_ha_discovery_device_name` (Optional)

Custom device name for Home Assistant discovery. Leave empty to use the hostname.

### Option: `logging_level` (Optional)

The logging verbosity level for psmqtt. Can be `debug`, `info`, `warning`, or `error`. Defaults to `info`.

### Option: `schedule_yaml`

The full psmqtt schedule configuration in YAML format. This defines which system metrics to collect, how often, and which MQTT topics to publish to.

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
```

For all available tasks (CPU, memory, disk, network, temperature, fans, battery, processes), see the [psmqtt documentation](https://github.com/eschava/psmqtt/blob/master/doc/usage.md).
