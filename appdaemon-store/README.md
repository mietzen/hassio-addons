## **Status: Experimental**

# Home Assistant Add-on: AppDaemon Store

Manage AppDaemon apps from GitHub repositories (HACS replacement for AppDaemon).

## About

This add-on runs [appdaemon-store](https://github.com/mietzen/appdaemon-store) to browse, install, and update AppDaemon apps directly from GitHub repositories via an Ingress Web UI, with automatic AppDaemon path detection and Python requirement syncing on Home Assistant OS.

## Installation

1. Navigate in your Home Assistant frontend to **Settings** -> **Add-ons** -> **Add-on Store** and add this URL as an additional repository: `https://github.com/mietzen/hassio-addons`
2. Refresh your browser.
3. Find the "AppDaemon Store" add-on and click the "INSTALL" button.
4. Configure the options if needed, click "START", and open the Web UI from the sidebar.

## Configuration

_Example configuration_:

```yaml
apps_dir: ""
repositories:
  - "owner/appdaemon-app"
github_token: ""
auto_update: false
check_interval_hours: 6
log_level: info
```

## Standalone Docker Compose

The container image can also run outside Home Assistant OS without Supervisor using environment variables (for example `APPDAEMON_STORE_APPS_DIR`, `APPDAEMON_STORE_REPOSITORIES`, `APPDAEMON_STORE_GITHUB_TOKEN`, `APPDAEMON_STORE_AUTO_UPDATE`, `APPDAEMON_STORE_CHECK_HOURS`, and `APPDAEMON_STORE_LOG_LEVEL`) and port `8099`.
