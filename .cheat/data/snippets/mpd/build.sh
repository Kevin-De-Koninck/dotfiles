# MPD container
./tools/build/build.sh -p deployer -b test/bundle_config.yml --tag $(whoami)

# Installer
./tools/build/build.sh -p installer -b bundle_config_build/bundle_config_infra.yml --version 1.0.0

# PDF docs
./tools/build/build.sh -p pdf-documentation -b bundle_config_build/bundle_config_infra.yml --version 1.0.0

# Build deployer-base and deployer-dev-base
VERSION_OLD=$(cat buildimages/deployer-base/buildvars | sed -n 's|^DST_VERSION="\(.*\)"$|\1|p')
VERSION_NEW=$(echo $VERSION_OLD | cut -d '-' -f 1)-$(($(echo $VERSION_OLD | cut -d '-' -f 2) + 1))
ls -1 buildimages/deployer*/{Dockerfile,buildvars} | xargs sed -i "s/${VERSION_OLD}/${VERSION_NEW}/g"
git add buildimages/*
git commit -m "Update version to ${VERSION_NEW}"
./tools/build/build.sh -p deployer-base --no-cache --push
./tools/build/build.sh -p deployer-dev-base --no-cache --push

