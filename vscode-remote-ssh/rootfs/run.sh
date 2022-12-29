#!/usr/bin/env bashio

ssh_user=''
ssh_user_home=''

# Check ssh_keys
if bashio::config.is_empty 'ssh_keys'; then
    bashio::log.fatal 'Invalid Configuration.'
    bashio::log.fatal 'Please set a authorized key!'
    bashio::exit.nok
fi

# Check user
if bashio::config.is_empty 'user' || [[ $(bashio::config 'user') == "root" ]]; then
    bashio::log.warning "It's not recommended to use the root user"
    ssh_user='root'
    ssh_user_home='/root'
    echo 'PermitRootLogin prohibit-password' >> /etc/ssh/sshd_config
else
    ssh_user="$(bashio::config 'user')"
    ssh_user_home="/home/$ssh_user"
    echo 'PermitRootLogin no' >> /etc/ssh/sshd_config
fi

# Setup user
if bashio::config.has_value 'user'; then
    useradd -m -s /bin/bash -G sudo -u 1000 "${ssh_user}"
    echo "${ssh_user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/010_${ssh_user}-nopasswd"
fi

# Copy authorized keys
if bashio::config.has_value 'ssh_keys'; then
    mkdir -p ${ssh_user_home}/.ssh
    while read -r key; do
        echo "${key}" >> ${ssh_user_home}/.ssh/authorized_keys
        bashio::log.notice "Added ${key} to ${ssh_user_home}/.ssh/authorized_keys"
    done <<< "$(bashio::config 'ssh_keys')"
fi

exec /usr/sbin/sshd -D