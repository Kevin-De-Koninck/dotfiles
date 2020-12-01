# Prepare the offline data
./tools/prepare_offline_data.py -f deployer/orchestration-rke/bundle_config.yml -o bin -m v19.0 -t

# Deploy everything
./deployer/perform.sh -b orchestration-rke -i inventories/k8s-4/rke/orchestration.yml -a redeploy -v
mkdir -p ~/.kube/ && cp inventories/k8s-4/rke/config/kube_config_cluster.yml ~/.kube/config

# Set certificate registry
sudo mkdir -p /etc/docker/certs.d/registry.apps.k8s-4.plat.krk.synamedialabs.com/
scp -i ~/.ssh/id_dsa 10.50.232.233:/etc/docker/certs.d/registry.apps.k8s-4.plat.krk.synamedialabs.com/registry.crt /tmp/registry.crt
sudo mv /tmp/registry.crt /etc/docker/certs.d/registry.apps.k8s-4.plat.krk.synamedialabs.com/registry.crt

./mpd-demo push-images -p local --local-registry registry.apps.k8s-4.plat.krk.synamedialabs.com --local-registry-scheme https --verbose
