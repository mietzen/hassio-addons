#!/usr/bin/env bashio

if [ -n "${NO_SUPERVISOR}" ]; then
    # Make root home persistent
    if ! [ -d /data/root ]; then
        echo 'Moving home directory to persistent storage.'
        mv /root /data/
        echo 'Copy default zsh config.'
        rm -rf /data/root/.zshrc
        cp /etc/default/ohmyzsh/zshrc /data/root/.zshrc
    fi
    echo 'Symlinking home directory to persistent storage.'
    rm -rf /root
    ln -s /data/root /root

    CONFIG_PATH=/data/options.json
    # Copy authorized keys
    if jq 'has("ssh_keys")' ${CONFIG_PATH}; then
        mkdir -p /root/.ssh
        while read -r key; do
            echo "${key}" >> /root/.ssh/authorized_keys
            echo "Added ${key} to /root/.ssh/authorized_keys"
        done <<< "$(jq -r '.ssh_keys  | join("\n")' ${CONFIG_PATH})"
    else
        echo "Error no ssh_keys found in ${CONFIG_PATH}" && exit 1
    fi

    exec /usr/sbin/sshd -D
else
    # Make root home persistent
    if ! [ -d /data/root ]; then
        bashio::log.notice 'Moving home directory to persistent storage.'
        mv /root /data/
        bashio::log.notice 'Copy default zsh config.'
        rm -rf /data/root/.zshrc
        cp /etc/default/ohmyzsh/zshrc /data/root/.zshrc
    fi
    bashio::log.notice 'Symlinking home directory to persistent storage.'
    rm -rf /root
    ln -s /data/root /root

    # Check ssh_keys
    if bashio::config.is_empty 'ssh_keys'; then
        bashio::log.fatal 'Invalid configuration.'
        bashio::log.fatal 'Please set a authorized key!'
        bashio::exit.nok
    fi

    # Copy authorized keys
    if bashio::config.has_value 'ssh_keys'; then
        mkdir -p /root/.ssh
        while read -r key; do
            echo "${key}" >> /root/.ssh/authorized_keys
            bashio::log.notice "Added ${key} to /root/.ssh/authorized_keys"
        done <<< "$(bashio::config 'ssh_keys')"
    fi

    exec /usr/sbin/sshd -D
fi