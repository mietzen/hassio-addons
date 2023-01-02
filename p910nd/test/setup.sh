#!/usr/bin/env bash

set -xe
docker run -d --rm \
    --name ${ADDON} \
    --platform ${PLATFORM} \
    "${DOCKER_USER}/hass-addon-${ADDON}:${VERSION}-${ARCH}-${BUILD_NR}"

# Install tools needed for inspect
docker exec -u 0 ${ADDON} apt-get update
docker exec -u 0 ${ADDON} apt-get install net-tools procps -y
