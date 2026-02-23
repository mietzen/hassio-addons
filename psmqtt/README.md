## **Status: Experimental**

# Home Assistant Add-on: psmqtt

Publishes host system metrics to MQTT using psmqtt.

## About

This add-on runs [psmqtt](https://github.com/eschava/psmqtt) to collect system metrics (CPU, memory, disk, network) from your Home Assistant host and publish them to an MQTT broker. Supports Home Assistant MQTT auto-discovery.

## Installation

1. Navigate in your Home Assistant frontend to **Settings** -> **Add-ons** -> **Add-on Store** and add this URL as an additional repository: `https://github.com/mietzen/hassio-addons`
2. Refresh your browser.
3. Find the "psmqtt" add-on and click the "INSTALL" button.
4. Configure the MQTT connection and schedule, then click "START".

## Configuration

_Example configuration_:

```yaml
mqtt_host: "192.168.1.100"
mqtt_port: 1883
mqtt_username: "mqtt_user"
mqtt_password: "mqtt_pass"
schedule_yaml: |
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
        params: ["/", percent]
        topic: "psmqtt/{hostname}/disk/percent"
        ha_discovery:
          name: "Disk Usage"
          icon: "mdi:harddisk"
          unit_of_measurement: "%"
          state_class: "measurement"
```

For all available tasks and configuration options, see the [psmqtt documentation](https://github.com/eschava/psmqtt/blob/master/doc/usage.md).
