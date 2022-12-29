ARG BUILD_FROM=debian:bullseye-slim
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# Copy script
COPY rootfs /
RUN chmod a+x /run.sh

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        openssh-server \
        wget \
        sudo \
        ca-certificates \
        curl \
        jq \
    && \
    rm -rf /tmp/* /var/{cache,log}/* /var/lib/apt/lists/*

# Add bashio
RUN wget -O /tmp/bashio.tar.gz https://github.com/hassio-addons/bashio/archive/v0.14.3.tar.gz && \
    mkdir /tmp/bashio && \
    tar zxvf tmp/bashio.tar.gz --strip 1 -C /tmp/bashio && \
    mv /tmp/bashio/lib /usr/lib/bashio && \
    ln -s /usr/lib/bashio/bashio /usr/bin/bashio 

# Add tempio and cli
ARG BUILD_ARCH
RUN wget -O /usr/bin/tempio "https://github.com/home-assistant/tempio/releases/download/2021.09.0/tempio_${BUILD_ARCH}" && \
    chmod a+x /usr/bin/tempio && \
    wget -O /usr/bin/ha "https://github.com/home-assistant/cli/releases/download/4.18.0/ha_${BUILD_ARCH}" && \
    chmod a+x /usr/bin/ha

# Run script
CMD [ "/run.sh" ]
