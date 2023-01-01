#!/usr/bin/env bash

docker run -d --rm \
    --name ${ADDON} \
    --platform ${PLATFORM} \
    -v $(pwd)/test/resources/options.json:/data/options.json \
    -v $(pwd)/test/resources/bashio-mok:/usr/lib/bashio/bashio.sh \
    "${DOCKER_USER}/hass-addon-${ADDON}:${VERSION}-${ARCH}-${BUILD_NR}"

docker exec -u 0 ${ADDON} apt-get update
docker exec -u 0 ${ADDON} apt-get install net-tools procps -y

exit 0