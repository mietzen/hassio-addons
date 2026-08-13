## **Status: Experimental**

# Home Assistant Add-on: linux2mqtt

Publishes Home Assistant host system metrics to MQTT.

## About

This add-on runs [linux2mqtt](https://github.com/mietzen/linux2mqtt) to collect system metrics (CPU, memory, temperature, disk usage, SMART data) from your Home Assistant host and publish them to an MQTT broker with HA auto-discovery.

## Installation

1. Navigate in your Home Assistant frontend to **Settings** -> **Add-ons** -> **Add-on Store** and add this URL as an additional repository: `https://github.com/mietzen/hassio-addons`
2. Refresh your browser.
3. Find the "linux2mqtt" add-on and click the "INSTALL" button.
4. Configure the MQTT connection, then click "START".

## Configuration

_Example configuration_:

```yaml
mqtt_host: core-mosquitto
mqtt_user: "mqtt_user"
mqtt_password: "mqtt_pass"
smart_monitoring: false
disk_usage: false
```

The addon monitors by default:

- CPU usage (60s average)
- Virtual memory
- Temperature sensors

Optional metrics (disabled by default, require Protection mode to be disabled):

- Hard drives (SMART data) — enable `smart_monitoring`
- Disk usage (`/`) — enable `disk_usage`

## Protection Mode

SMART monitoring (`smart_monitoring`) and disk usage monitoring (`disk_usage`) require **Protection mode to be disabled** for full host access. Navigate to the addon's Info tab and disable "Protection mode".

Both options are **disabled by default**, so the addon runs fine with Protection mode enabled when you only need CPU, memory and temperature metrics. Enable them only if you need those metrics and are willing to disable Protection mode.
