yum search packagename                             # See what packages exist
yum install -y packagename                         # Install packages
yum install libX11-devel --enablerepo=base,epel    # Enable repos if they were disabled
yum list dependencies packagename                  # List dependencies for package
yum list installed                                 # to see what is installed
yum -y remove "vdcm*"                              # to remove vDCM
yum whatprovides /path                             # See which RPM provided a given path
yum reinstall /tmp/vdcm-smi-10.0.0-17.el7.x86_64.rpm    # reinstall a custom RPM
