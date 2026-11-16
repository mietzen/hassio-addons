# Home Assistant Add-on: AppDaemon Store

Manage AppDaemon apps from GitHub repositories (HACS replacement for AppDaemon).

## Configuration Options

### Option: `apps_dir` (Optional)

Override path to the AppDaemon `apps` directory. Leave empty (`""`) to auto-detect the directory from `/addon_configs/a0d7b954_appdaemon/appdaemon.yaml` or fall back to `/addon_configs/a0d7b954_appdaemon/apps`.

### Option: `repositories` (Optional)

List of GitHub repositories (`owner/repo` or full GitHub URL) to track at startup in addition to repositories added via the Web UI.

### Option: `github_token` (Optional)

GitHub personal access token used to raise GitHub API rate limits and access private repositories.

### Option: `auto_update` (Optional)

Automatically install updates when background checks detect a newer release, tag, or commit. Defaults to `false`.

### Option: `check_interval_hours` (Optional)

Interval in hours (`1` to `168`) between scheduled background update checks. Defaults to `6`.

### Option: `log_level` (Optional)

Log verbosity (`debug`, `info`, `warning`, `error`). Defaults to `info`.

## Accessing the Web UI

Ingress is enabled by default (`ingress_port: 8099`), adding an **AppDaemon Store** panel to the Home Assistant sidebar. Port `8099/tcp` can optionally be exposed directly in the Network settings if you want direct LAN access outside Ingress.

## Mapped Directories & Permissions

The add-on mounts `homeassistant_config:rw` (`/homeassistant`) and `all_addon_configs:rw` (`/addon_configs`) and uses `hassio_api: true` (`hassio_role: manager`) and `homeassistant_api: true` so it can detect AppDaemon's `apps` folder, migrate legacy HACS AppDaemon installs, sync `requirements.txt` Python packages into AppDaemon's configuration, and post update notifications.
