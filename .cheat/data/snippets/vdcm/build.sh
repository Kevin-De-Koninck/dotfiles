cd DCM.git/DCM_MFP/Application                                                  # go to 'Application' folder of the thing you want to build
make -j 6                                                                       # start build for software vDCM   (select: SW_CENTOS7)
dcm-make                                                                        # start build for Hardware DCM   (only from aurora)

# ONLY BUILD SPECIFIC RPM
./Build  --epoch 1 --version 10.0.0 --release 17 projects/vdcm-smi
yum reinstall /tmp/vdcm-smi-10.0.0-17.el7.x86_64.rpm                            # install it on vdcm

### SERVER DISTRO
# Full build
rm .built_targets
./Build --version 8.0.0 --release 77                                            # built: specify which version en the release number must be higher than the latest build number
scp vdcm-installer-8.0.0-77.sh 10.50.234.137:/root/                             # Copy to a vDCM
./vdcm-installer-8.0.0-77.sh -k                                                 # ssh to vdcm machine and from there install using the -k parameter (keyless)

# only rebuild 'self-extracting-install'
ll yum-repository                                                               # check if all files are on the correct version, let's say 200
vim .built_targets                                                              # delete the line 'self-extracting-install'
./Build --version 8.0.0 --release 200 --continue                                # rebuild by using the --continue argument

# continue from existing installer
ssh 10.50.234.29                                                                # ssh to a device
cd /tmp                                                                         # go to tmp
wget http://engci-maven-master.cisco.com/artifactory/spvss-vdcm-yum/vdcm/debug/9.0/vdcm-installer-9.0.0-78.sh  # download an installer from artifactory
chmod +x vdcm-installer-9.0.0-78.sh                                             # make it executable
./vdcm-installer-9.0.0-78.sh -e /tmp/EXTRACT                                    # extract the installer
#
cd /home/kdekonin/kevin/CLEAN_DCM_GIT/DCM.git/ServerDistro                      # go to our build location en server distro
cd yum-repository                                                               # open yum-repository
rm -rf *                                                                        # remove all
scp -r 10.50.234.29:/tmp/EXTRACT/ .                                             # copy our extract to here
cd ..                                                                           # now go back to the root dir
echo clean > .built_targets && ls -1d external-packages/* projects/* \          # Create the .built_targets if neccesary (e.g. missing a lot that you don't want to rebuild)
             meta-packages/* platform/* self-extracting-install >> .built_targets
vim .built_targets                                                              # remove the packeges that you want to rebuild (be sure to remove self-extracting-install)
./Build --version 9.0.0 --release 76 --continue                                 # start build, use buildnumber of the installer that you've downloaded
./Build --version 9.0.0 --release 82 --continue --skip-deps                     # and to go really fast, we can skip the dependency check (will only produce offline installer)

###EVEN FASTER BUILD FROM EXISTING BUILD        password: jenkins_gpk
## 8 zit op build 1
## 9 zit op build 2
## 10 zit op build 3
BUILD_SERVER=3
MAJOR=10
MINOR=0
BUGFIX=1
BUILD_VERSION=98

VERSION=${MAJOR}.${MINOR}.${BUGFIX}
cd yum-repository/
rm -rf *
scp jenkins_gpk@vdcm-build${BUILD_SERVER}.cisco.com:/home/jenkins_gpk/workspace/vDCM_Build_${MAJOR}.${MINOR}/vdcm-${VERSION}-${BUILD_VERSION}/ServerDistro/yum-repository/'*rpm' .
createrepo .
cd ..
scp jenkins_gpk@vdcm-build${BUILD_SERVER}.cisco.com:/home/jenkins_gpk/workspace/vDCM_Build_${MAJOR}.${MINOR}/vdcm-${VERSION}-${BUILD_VERSION}/ServerDistro/'.built_targets' .
vim .built_targets
./Build --version ${VERSION} --release ${BUILD_VERSION} --continue

# DOWNLOAD FULL SELF EXTRACTING INSTALLER:
BUILD_SERVER=1
MAJOR=8
MINOR=0
BUGFIX=2
BUILD_VERSION=225
VERSION=${MAJOR}.${MINOR}.${BUGFIX}
scp jenkins_gpk@vdcm-build${BUILD_SERVER}.cisco.com:/home/jenkins_gpk/workspace/vDCM_Build_${MAJOR}.${MINOR}/vdcm-${VERSION}-${BUILD_VERSION}/ServerDistro/vdcm-installer-${VERSION}-${BUILD_VERSION}.sh .

# DOWNLOAD FULL SELF EXTRACTING INSTALLER FROM A PROXY
ARTIFACTORY_URL=http://engci-maven-master.cisco.com/artifactory/spvss-vdcm-yum/vdcm/debug/11.0/vdcm-installer-11.0.0-31.sh
curl --proxy "http://10.50.201.11:3128" -s -o vdcm-installer.sh $ARTIFACTORY_URL && chmod +x vdcm-installer.sh

