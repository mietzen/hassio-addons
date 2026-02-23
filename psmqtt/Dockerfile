FROM debian:trixie-20260202-slim

ENV LANG=C.UTF-8

# Copy script
COPY rootfs /
RUN chmod a+x /run.sh

# Install prerequisites
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        ca-certificates \
        curl \
        jq \
        python3 \
        python3-pip \
        python3-venv \
        cron \
        smartmontools \
        wget \
    && \
    rm -rf /tmp/* /var/{cache,log}/* /var/lib/apt/lists/*

# Install psmqtt in a venv (Debian trixie enforces PEP 668)
RUN python3 -m venv /opt/psmqtt-venv && \
    /opt/psmqtt-venv/bin/pip install --no-cache-dir psmqtt

# Add bashio
ARG BASHIO_VERSION=v0.17.5
RUN wget -O /tmp/bashio.tar.gz "https://github.com/hassio-addons/bashio/archive/${BASHIO_VERSION}.tar.gz" && \
    mkdir /tmp/bashio && \
    tar zxvf tmp/bashio.tar.gz --strip 1 -C /tmp/bashio && \
    mv /tmp/bashio/lib /usr/lib/bashio && \
    ln -s /usr/lib/bashio/bashio /usr/bin/bashio

# Add tempio
ARG TEMPIO_VERSION=2024.11.2
RUN case $(uname -m) in \
        "x86_64") dl_arch="amd64" ;; \
        "aarch64") dl_arch="aarch64" ;; \
        *) echo "unsupported architecture" && exit 1 ;; \
    esac && \
    wget -O /usr/bin/tempio "https://github.com/home-assistant/tempio/releases/download/${TEMPIO_VERSION}/tempio_${dl_arch}" && \
    chmod a+x /usr/bin/tempio

# Create config directory
RUN mkdir -p /opt/psmqtt/conf

# Start psmqtt
CMD [ "/run.sh" ]

ARG VERSION
LABEL \
    io.hass.name="psmqtt" \
    io.hass.description="Publishes host system metrics to MQTT using psmqtt." \
    io.hass.version="${VERSION}" \
    io.hass.type="addon" \
    io.hass.arch="aarch64|amd64" \
    maintainer="Nils Stein <social.nst@mailbox.org>" \
    org.opencontainers.image.title="psmqtt" \
    org.opencontainers.image.description="Publishes host system metrics to MQTT using psmqtt." \
    org.opencontainers.image.vendor="Nils Home Assistant Add-ons" \
    org.opencontainers.image.authors="Nils Stein <social.nst@mailbox.org>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/mietzen/hassio-addons" \
    org.opencontainers.image.documentation="https://github.com/mietzen/hassio-addons/blob/main/psmqtt/README.md"
