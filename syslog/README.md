# Syslog Home Assistant add-on

**Mirror of [ha-addon-syslog](https://github.com/mib1185/ha-addon-syslog) with [RFC5424 patches of IngmarStein](https://github.com/mib1185/ha-addon-syslog/pull/30) applied.**

Copy of the original [LICENSE](LICENSE) is provided.

You can checkout the original [Apache License 2.0](https://github.com/mib1185/ha-addon-syslog/blob/main/LICENSE) and code at: [https://github.com/mib1185/ha-addon-syslog](https://github.com/mib1185/ha-addon-syslog)

## Changes from upstream

- Replaced HA builder pattern (`ARG BUILD_FROM` / `build.yaml`) with standalone `debian:trixie-slim` base image and manually installed bashio/tempio
- Replaced s6-overlay shebang (`#!/usr/bin/with-contenv bashio`) with `#!/usr/bin/env bashio`
- Updated image name to `mietzen/hass-addon-syslog`
- Added integration tests
- Removed `build.yaml` and `bashio_info.sh` (no longer needed)

---

## How to use

This add-on allows you to send your HAOS logs to a remote syslog server.

## Configuration

Add-on configuration:

```yaml
syslog_host: syslog.local
syslog_port: 514
syslog_protocol: udp
syslog_ssl: false
syslog_ssl_verify: false
syslog_format: RFC3164
```

| key | name | description |
| --- | ---- | ----------- |
| `syslog_host` | Syslog host | The hostname or IP address of the remote syslog server to send HAOS logs to. |
| `syslog_port` | Syslog port | The port of the remote syslog server to send HAOS logs to. |
| `syslog_protocol` | Transfer protocol | The protocol to be used to send HAOS logs. |
| `syslog_ssl` | SSL encryption | Whether or not to to use ssl encryption (only supported with tcp). |
| `syslog_ssl_verify` | SSL verify | Whether or not to verify ssl certificate. |
| `syslog_format` | Syslog format | The format of the syslog message (`RFC3164` or `RFC5424`). |

## Support

In case you've found a bug, please [open an issue on GitHub][issue].

[issue]: https://github.com/mietzen/hassio-addons/issues
