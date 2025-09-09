FROM debian:bookworm-20250908-slim

RUN apt-get update && \
    apt-get install -y \
        sane \
        scanbd \
        imagemagick \
        exactimage \
        pdftk \
        tesseract-ocr \
        tesseract-ocr-eng \
        libusb-dev \
        smbclient \
        jq \
    && rm -rf /tmp/* /var/{cache,log}/* /var/lib/apt/lists/*

COPY ./scan.sh /scan.sh
RUN chmod +x /scan.sh

RUN sed -i '/action scan {/,/}/s|script = ".*"|script = "/scan.sh"|' /etc/scanbd/scanbd.conf

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

ARG VERSION
LABEL \
    io.hass.name="scanbd2smb" \
    io.hass.description="Scan from your USB Scanner to a SMB Folder." \
    io.hass.version="${VERSION}" \
    io.hass.type="addon" \
    io.hass.arch="armhf|aarch64|i386|amd64|armv7" \
    maintainer="Nils Stein <social.nst@mailbox.org>" \
    org.opencontainers.image.title="scanbd2smb" \
    org.opencontainers.image.description="Scan from your USB Scanner to a SMB Folder." \
    org.opencontainers.image.vendor="Nils Home Assistant Add-ons" \
    org.opencontainers.image.authors="Nils Stein <social.nst@mailbox.org>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/mietzen/hassio-addons" \
    org.opencontainers.image.documentation="https://github.com/mietzen/hassio-addons/blob/main/p910nd/README.md"
