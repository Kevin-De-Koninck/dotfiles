# Generate PDF for release
./tools/build/build.sh -p pdf-documentation -b bundle_config_build/bundle_config_infra.yml --version 1.0.0-10

# Generate installer for release
./tools/build/build.sh -p installer -b bundle_config_build/bundle_config_infra.yml --version 1.0.0-10

# Rename installer to include build number
mv mpd-installer-infra.sh mpd-installer-infra-v1.0.0-10.sh

# Push installer to debug artif and release artif
# http://artifactory01.engit.synamedia.com/artifactory/spvss-mpd-dev/installer/v19.0/
# https://artifactory01.engit.synamedia.com/artifactory/spvss-mpd/installer/v19.0/
artifactory-connection.sh --installers --version v19.0 -p mpd-installer-infra-v1.0.0-10.sh -t debug -a mpd
artifactory-connection.sh --installers --version v19.0 -p mpd-installer-infra-v1.0.0-10.sh -t release -a mpd

# Tag the branch
git tag mpd-infra-v1.0.0-10
git push origin --tags
