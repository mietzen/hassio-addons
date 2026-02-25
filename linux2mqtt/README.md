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
```

The addon automatically monitors:

- CPU usage (60s average)
- Virtual memory
- Temperature sensors
- Hard drives (SMART data)
- Disk usage (`/config`)

## Protection Mode

This addon requires **Protection mode to be disabled** for full host access (disk metrics, SMART monitoring). Navigate to the addon's Info tab and disable "Protection mode".
