# When you can't push to a registry, it usually means that there is disk presure (kubectl describe pod ....). The following example cleans k8s-1 (we push our images here):
# k8s-1
# Log in to node 1 (the registry runs here)
ssh 

# Remove all images
for REPO in $(ls -1 /var/lib/registry/docker/registry/v2/repositories/ 2> /dev/null); do
        echo -e "Cleaning '${REPO}'"
        rm -rf /var/lib/registry/docker/registry/v2/repositories/"${REPO}"
done
echo -e "Running the garbage collector now\n"
kubectl -n docker-registry exec $(kubectl get pods -n docker-registry --no-headers | cut -f1 -d ' ') -- /bin/registry garbage-collect /etc/docker/registry/config.yml


# Log in to a vDCM device
ssh ....

# Install docker
yum install -y docker
systemctl start docker

# Download the latest lam bundle: http://artifactory01.engit.synamedia.com/artifactory/spvss-mpd-dev/
wget http://artifactory01.engit.synamedia.com/artifactory/spvss-mpd-dev/.....

# Install it
chmod +x mpd-installer-lam-v20.0.0-37.sh
./mpd-installer-lam-v20.0.0-37.sh

# Copy the certificate
scp root@10.50.233.168:/etc/pki/ca-trust/source/anchors/registry.crt /tmp/registry.crt
mkdir -p /etc/docker/certs.d/registry.apps.k8s-1.plat.krk.synamedialabs.com
mv /tmp/registry.crt /etc/docker/certs.d/registry.apps.k8s-1.plat.krk.synamedialabs.com/registry.crt
./mpd-lam push-images --provider local --local-registry registry.apps.k8s-1.plat.krk.synamedialabs.com --local-registry-scheme https

# Restart all broken containers on node 1

# Uninstall LAM, stop docker on the vDCM and reboot the node
./mpd-installer-lam-v20.0.0-37.sh -u
systemctl stop docker
systemctl disable docker
reboot

# --------------------

# NON WORKING SCRIPT (IN PROGRESS)
#!/bin/bash
for REPO in $(ls -1 /var/lib/registry/docker/registry/v2/repositories/ 2> /dev/null); do
	echo -e "\nCleaning '${REPO}'"
	echo -e "\tCleaning revisions"
	for HASH in $(ls -1 /var/lib/registry/docker/registry/v2/repositories/"${REPO}"/_manifests/revisions/sha256/ 2> /dev/null); do
		echo -e "\t\tCleaning hash: $HASH"
		curl -X DELETE https://registry.apps.k8s-1.plat.krk.synamedialabs.com/v2/"${REPO}"/manifests/sha256:${HASH} --connect-timeout 1 --max-time 1 2> /dev/null 1>&2
		rm -rf /var/lib/registry/docker/registry/v2/repositories/"${REPO}"/_manifests/revisions/sha256/${HASH}
	done
	echo -e "\tCleaning all tags"
	for TAG in $(ls -1 /var/lib/registry/docker/registry/v2/repositories/"${REPO}"/_manifests/tags/ 2> /dev/null); do
		echo -e "\t\tCleaning tag: ${TAG}"
		for HASH in $(ls -1 /var/lib/registry/docker/registry/v2/repositories/"${REPO}"/_manifests/tags/${TAG}/index/sha256/ 2> /dev/null); do
			echo -e "\t\tCleaning hash: $HASH"
			curl -X DELETE https://registry.apps.k8s-1.plat.krk.synamedialabs.com/v2/"${REPO}"/manifests/sha256:${HASH} --connect-timeout 1 --max-time 1 2> /dev/null 1>&2
			rm -rf /var/lib/registry/docker/registry/v2/repositories/"${REPO}"/_manifests/tags/${TAG}/index/sha256/${HASH}
		done
	done
done
echo -e "Running the garbage collector now\n"
kubectl -n docker-registry exec $(kubectl get pods -n docker-registry --no-headers | cut -f1 -d ' ') -- /bin/registry garbage-collect /etc/docker/registry/config.yml
