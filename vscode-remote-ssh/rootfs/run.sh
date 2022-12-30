#!/usr/bin/env bashio

# Make root home persistent
mv /root /data/home
ln -s /data/home /root

# Check ssh_keys
if bashio::config.is_empty 'ssh_keys'; then
    bashio::log.fatal 'Invalid Configuration.'
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