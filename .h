# Show some help messages
h() {
cat << EOF
============ Screen =============
F1                               new screen (C-a c)
F2,F3                            split vertical (C-a |), horizontal (C-a S)
F4                               delete regions apart current (C-a Q)
F5,F6                            go to prev,next region (C-a <tab>)
F7,F8                            scroll mode start (C-a [), stop (C-a ])
F9                               start/stop monitoring activity (C-a _)
F10,F11                          go to prev window (C-a p),next window (C-a n)
F12                              show window list (C-a ")
============ Ansible ============
- debug: var=hostvars[inventory_hostname]
============ Git ================
git pull --rebase --prune && git submodule update --init --recursive [--remote]
============ MPD ================
./tools/build/build.sh -p deployer -b test/bundle_config.yml --tag test --version 1.2.3-45
#
./mpd_framework/tools/run-develop-container.sh --build

export PYTHONPATH=${PWD}/tools/pytest
export ANSIBLE_ACTION_PLUGINS=$(pwd)/mpd_framework/plugins/action/
export ANSIBLE_FORCE_COLOR=True

export IMAGE_TO_TEST=spvss-linear-video-deployer-devel-docker.dockerhub.synamedia.com/media-plane-deployer-test:1.2.3-45
#
./mpd_framework/tools/prepare_offline_data.py -f deployer/vn-k8s/bundle_config.yml -o bin -m v20.0 -t
EOF
}
