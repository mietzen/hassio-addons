#!/usr/bin/env bash

set -xe

echo "Setup"
docker run -d --rm \
    --name ${ADDON} \
    --platform ${PLATFORM} \
    --cap-add SYS_RAWIO \
    --cap-add SYS_ADMIN \
    -v $(pwd)/test/resources/options.json:/data/options.json \
    -v $(pwd)/test/resources/bashio.sh.mok:/usr/lib/bashio/bashio.sh \
    -v $(pwd)/test/resources/bashio-config.sh.mok:/usr/lib/bashio/config.sh \
    "${DOCKER_USER}/hass-addon-${ADDON}:${VERSION}-${ARCH}-${BUILD_NR}"

# Wait for container to start and verify it's running
sleep 10
if ! docker inspect --format='{{.State.Running}}' ${ADDON} 2>/dev/null | grep -q true; then
    echo "Container failed to start. Logs:"
    docker logs ${ADDON} 2>&1 || true
    exit 1
fi

# Install tools needed for inspect
docker exec -u 0 ${ADDON} apt-get update
docker exec -u 0 ${ADDON} apt-get install net-tools procps -y

echo "Test"
inspec exec ./test/integration -t docker://${ADDON}
echo "Teardown"
docker container stop ${ADDON}
