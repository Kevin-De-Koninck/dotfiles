# Variables
DOMAIN=registry.apps.k8s-4.plat.krk.synamedialabs.com
NODE_IP=10.50.x.x

# Copy certificate from a node
scp root@${NODE_IP}:/etc/pki/ca-trust/source/anchors/registry.crt /tmp/registry.crt
mkdir -p "/etc/docker/certs.d/${DOMAIN}/"
mv /tmp/registry.crt "/etc/docker/certs.d/${DOMAIN}/registry.crt"

# Push images
./mpd-linear-vdcm push-images --provider local --local-registry "${DOMAIN}" --local-registry-scheme https --local-registry-prefix mpd-test

