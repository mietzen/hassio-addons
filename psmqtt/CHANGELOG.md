# Changelog:
## Version 0.3.0

- Fixing Mounts

## Version 0.2.0

- Added full host access for disk metrics (mount at /host/root)
- Added SMART monitoring support with configurable devices
- Added smartmontools package
- Fixed logging level to use uppercase (DEBUG, INFO, WARNING, ERROR)
- Fixed MQTT settings: QoS 1, retain true, clean_session false, reconnect 10s
- Fixed HA discovery always enabled on homeassistant topic

## Version 0.1.0
- Initial release
- Publishes system metrics to MQTT using psmqtt
- Full MQTT configuration from HA UI
- Flexible schedule configuration via YAML
- Home Assistant MQTT auto-discovery support
