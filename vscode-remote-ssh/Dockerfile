FROM debian:bullseye-20240926-slim

ENV LANG C.UTF-8

# Copy script
COPY rootfs /
RUN chmod a+x /run.sh && \
    mkdir -p /run/sshd

# Install prerequisites
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        ca-certificates \
        curl \
        git \
        jq \
        nano \
        openssh-server \
        python3 \
        python3-pip \
        rsync \
        vim \
        wget \
        zsh \
    && \
    rm -rf /tmp/* /var/{cache,log}/* /var/lib/apt/lists/*

# Setup ohmyzsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    chsh -s $(which zsh)

# Add bashio
ARG BASHIO_VERSION=v0.14.3
RUN wget -O /tmp/bashio.tar.gz "https://github.com/hassio-addons/bashio/archive/${BASHIO_VERSION}.tar.gz" && \
    mkdir /tmp/bashio && \
    tar zxvf tmp/bashio.tar.gz --strip 1 -C /tmp/bashio && \
    mv /tmp/bashio/lib /usr/lib/bashio && \
    ln -s /usr/lib/bashio/bashio /usr/bin/bashio

# Add tempio and cli
ARG TEMPIO_VERSION=2021.09.0
ARG HA_CLI_VERSION=4.18.0
RUN case $(uname -m) in \
        "x86_64") dl_arch="amd64" ;; \
        "aarch64") dl_arch="aarch64" ;; \
        "armv7l") dl_arch="armv7" ;; \
        "armv6l") dl_arch="armhf" ;; \
        "i386") dl_arch="i386" ;; \
        *) echo "unsupported architecture ${TARGETPLATFORM}" && exit 1 ;; \
    esac && \
    wget -O /usr/bin/tempio "https://github.com/home-assistant/tempio/releases/download/${TEMPIO_VERSION}/tempio_${dl_arch}" && \
    chmod a+x /usr/bin/tempio && \
    wget -O /usr/bin/ha "https://github.com/home-assistant/cli/releases/download/${HA_CLI_VERSION}/ha_${dl_arch}" && \
    chmod a+x /usr/bin/ha

# Start Server
CMD [ "/run.sh" ]

ARG VERSION
LABEL \
    io.hass.name="Visual Studio Code Remote SSH Server" \
    io.hass.description="This add-on lets you use Visual Studio Code Remote SSH to edit your Home Assistant config." \
    io.hass.version="${VERSION}" \
    io.hass.type="addon" \
    io.hass.arch="armhf|aarch64|i386|amd64|armv7" \
    maintainer="Nils Stein <social.nst@mailbox.org>" \
    org.opencontainers.image.title="Visual Studio Code Remote SSH Server" \
    org.opencontainers.image.description="This add-on lets you use Visual Studio Code Remote SSH to edit your Home Assistant config." \
    org.opencontainers.image.vendor="Nils Home Assistant Add-ons" \
    org.opencontainers.image.authors="Nils Stein <social.nst@mailbox.org>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/mietzen/hassio-addons" \
    org.opencontainers.image.documentation="https://github.com/mietzen/hassio-addons/blob/main/vscode-remote-ssh/README.md"
