# run as another user (e.g. run as dcm)
sudo -u dcm /opt/cisco/vdcm/bin/vdcm-configure check

# to change user, but this does not work on vDCM -> dcm has no login or shell
su - dcm

# to start bash as dcm user
runuser -u dcm bash

