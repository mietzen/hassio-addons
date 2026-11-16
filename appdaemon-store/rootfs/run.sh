#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# AppDaemon Store Home Assistant Add-on
# Reads HA options via bashio when /data/options.json exists, or preserves
# environment variables in standalone Docker Compose mode, then execs server.
# ==============================================================================

log() {
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

# Read an option via bashio under Supervisor/mocked CI, or jq locally when no
# Supervisor API is available to avoid spurious Supervisor curl errors.
read_option() {
    local key="$1"
    if [[ -n "${SUPERVISOR_TOKEN:-}" ]] || grep -q '/data/options.json' /usr/lib/bashio/config.sh; then
        if bashio::config.has_value "${key}"; then
            bashio::config "${key}"
        fi
        return 0
    fi

    jq -r --arg k "${key}" '
        .[$k] |
        if . == null then empty
        elif type == "array" then .[]
        elif type == "boolean" then tostring
        elif . == "" then empty
        else tostring
        end
    ' /data/options.json
}

load_ha_options() {
    # shellcheck disable=SC1091
    source /usr/lib/bashio/bashio.sh

    bashio::log.notice "Loading Home Assistant add-on configuration..."

    local apps_dir
    apps_dir=$(read_option 'apps_dir')
    if [[ -n "${apps_dir}" ]]; then
        export APPDAEMON_STORE_APPS_DIR="${apps_dir}"
    fi

    local repos_raw
    repos_raw=$(read_option 'repositories')
    if [[ -n "${repos_raw}" ]]; then
        APPDAEMON_STORE_REPOSITORIES=$(
            printf '%s\n' "${repos_raw}" \
                | jq -Rsc 'split("\n") | map(select(length > 0))'
        )
        export APPDAEMON_STORE_REPOSITORIES
    else
        export APPDAEMON_STORE_REPOSITORIES="[]"
    fi

    local github_token
    github_token=$(read_option 'github_token')
    if [[ -n "${github_token}" ]]; then
        export APPDAEMON_STORE_GITHUB_TOKEN="${github_token}"
    fi

    local auto_update
    auto_update=$(read_option 'auto_update')
    case "${auto_update,,}" in
        true|1|yes|on|enabled)
            export APPDAEMON_STORE_AUTO_UPDATE="true"
            ;;
        *)
            export APPDAEMON_STORE_AUTO_UPDATE="false"
            ;;
    esac

    local check_hours
    check_hours=$(read_option 'check_interval_hours')
    if [[ -n "${check_hours}" ]]; then
        export APPDAEMON_STORE_CHECK_HOURS="${check_hours}"
    fi

    local log_level
    log_level=$(read_option 'log_level')
    if [[ -n "${log_level}" ]]; then
        export APPDAEMON_STORE_LOG_LEVEL="${log_level}"
    fi

    bashio::log.notice "Starting AppDaemon Store..."
}

if [[ -f /data/options.json && -f /usr/lib/bashio/bashio.sh ]]; then
    load_ha_options
else
    log "No /data/options.json found; running in standalone mode with environment variables."
    log "Starting AppDaemon Store..."
fi

exec /opt/appdaemon-store-venv/bin/appdaemon-store
