#!/usr/bin/env bashio

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
