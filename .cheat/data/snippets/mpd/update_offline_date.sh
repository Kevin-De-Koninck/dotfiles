# Add RPM to bundle_config file

# Add rpm to offline data en upload offline data tarbal to artifactory
# http://artifactory01.engit.synamedia.com/artifactory/spvss-mpd-dev/buildhelpers/v20.0/
./tools/prepare_offline_data.py -f deployer/orchestration-rke/bundle_config.yml -o bin -m v20.0 -u -v

# get name of data under bin dir and update bundle config file cache parameter
