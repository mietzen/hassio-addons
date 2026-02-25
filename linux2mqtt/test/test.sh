#!/usr/bin/env bash

set -xe

echo "Setup"
docker run -d --rm \
    --name ${ADDON} \
    --platform ${PLATFORM} \
    -v $(pwd)/test/resources/options.json:/data/options.json \
    -v $(pwd)/test/resources/bashio.sh.mok:/usr/lib/bashio/bashio.sh \
    -v $(pwd)/test/resources/bashio-config.sh.mok:/usr/lib/bashio/config.sh \
    "${DOCKER_USER}/hass-addon-${ADDON}:${VERSION}-${ARCH}-${BUILD_NR}"

# Install tools needed for inspect
docker exec -u 0 ${ADDON} apt-get update
docker exec -u 0 ${ADDON} apt-get install net-tools procps -y

echo "Test"
inspec exec ./test/integration -t docker://${ADDON}
echo "Teardown"
docker container stop ${ADDON}
