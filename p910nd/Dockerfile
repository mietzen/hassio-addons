FROM debian:bookworm-20241016-slim

# Install prerequisites
RUN apt-get update && \
    apt-get install -y p910nd && \
    rm -rf /tmp/* /var/{cache,log}/* /var/lib/apt/lists/*

RUN mkdir -p /var/lock/p910nd && touch /var/lock/p910nd/p9100d

# Run p910nd
CMD ["/usr/sbin/p910nd","-d"]

ARG VERSION
LABEL \
    io.hass.name="p910nd" \
    io.hass.description="Exposes the raw printer socket via network." \
    io.hass.version="${VERSION}" \
    io.hass.type="addon" \
    io.hass.arch="armhf|aarch64|i386|amd64|armv7" \
    maintainer="Nils Stein <social.nst@mailbox.org>" \
    org.opencontainers.image.title="p910nd" \
    org.opencontainers.image.description="Exposes the raw printer socket via network." \
    org.opencontainers.image.vendor="Nils Home Assistant Add-ons" \
    org.opencontainers.image.authors="Nils Stein <social.nst@mailbox.org>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/mietzen/hassio-addons" \
    org.opencontainers.image.documentation="https://github.com/mietzen/hassio-addons/blob/main/p910nd/README.md"
