# MPD container
./tools/build/build.sh -p deployer -b test/bundle_config.yml --tag $(whoami)

# Installer
./tools/build/build.sh -p installer -b bundle_config_build/bundle_config_infra.yml --version 1.0.0

# PDF docs
./tools/build/build.sh -p pdf-documentation -b bundle_config_build/bundle_config_infra.yml --version 1.0.0
