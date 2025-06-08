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

# Conditionally persist SSH host keys to survive container updates
if bashio::config.true 'persist_ssh_host_keys'; then
    bashio::log.notice "Host key persistence is enabled."

    # On first run, move the original /etc/ssh directory to the persistent /data location
    if ! [ -d /data/ssh ]; then
        bashio::log.notice 'Initializing persistent SSH directory from /etc/ssh...'
        mv /etc/ssh /data/ssh
    fi

    # Ensure the standard /etc/ssh path is always a symlink to our persistent storage
    bashio::log.notice 'Linking /etc/ssh to persistent storage at /data/ssh.'
    rm -rf /etc/ssh
    ln -s /data/ssh /etc/ssh

    # If no host keys exist in the persistent directory, generate the full default set.
    if ! find /data/ssh -name "ssh_host_*_key" -print -quit | grep -q .; then
        bashio::log.warning 'No SSH host keys found in persistent storage. Generating new set for first-time use...'
        ssh-keygen -A
        bashio::log.notice 'Default set of host keys generated in /data/ssh.'
    fi

    # Enforce secure permissions on the host keys and configuration
    bashio::log.notice 'Verifying permissions for persistent SSH files...'
    chmod 600 /data/ssh/ssh_host_*_key 2>/dev/null || true
    chmod 644 /data/ssh/ssh_host_*_key.pub 2>/dev/null || true
    chmod 644 /data/ssh/sshd_config 2>/dev/null || true
else
    bashio::log.notice "Host key persistence is disabled. Keys will be ephemeral."
fi

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
