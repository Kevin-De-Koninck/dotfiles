# Download the offline data
BUNDLE="vn-k8s"
MPD_VERSION="v20.1"
./mpd_framework/tools/prepare_offline_data.py -f deployer/${BUNDLE}/bundle_config.yml -o bin -m "${MPD_VERSION}" -t

# ---

# Create a deployer container
./mpd_framework/tools/build/build.sh -p deployer -b test/bundle_config.yml --tag $(whoami) -v 1.2.3

# Create and run a test container
./mpd_framework/tools/run-develop-container.sh --build
export PYTHONPATH=${PWD}/tools/pytest
export ANSIBLE_ACTION_PLUGINS=$(pwd)/mpd_framework/plugins/action/
export ANSIBLE_FORCE_COLOR=True
export IMAGE_TO_TEST=spvss-linear-video-deployer-devel-docker.dockerhub.synamedia.com/media-plane-deployer-test:kdekoninck

# ---

# (Optionally) Run all tests locally
echo "BUILDING DEPLOYER IMAGE..."; export IMAGE_TO_TEST=$(tools/build/build_deployer.sh -t kdekonin 2> /dev/null | grep 'docker run --rm -i -t ' | sed 's/docker run --rm -i -t //' | sed 's| ./perform.sh||')
grep -hr 'pytest ' tools/CICD/jobs | sed -e 's/\(--junitxml.*xml\)/-sx/g' | sed -e 's/\(--rootdir=${PWD}\)//g' | while read line ;do set -e; echo "$line ----------------------------"; eval $line ; set +e; done
