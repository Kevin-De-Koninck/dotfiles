systemctl disable vdcm.target
systemctl stop vdcm.target
yum -y remove "vdcm*"
rm -rf /opt/cisco/vdcm* /etc/opt/cisco/vdcm* /var/log/vdcm* /opt/cisco/embgui /etc/yum.repos.d/vdcm* /etc/sysctl.d/99-vdcm-rpfilter.conf
userdel dcm
groupdel dcm
rm -rf /etc/opt/cisco/ott
reboot
