# E.g. you want to update Ansible to 2.7.*, do the following on a vDCM:
# On a vDCM, find the correct package name (e.g. ansible.noarch)
yum list --enablerepo=base,epel,update  | grep -i 'ansible'

# On a vDCM, download the RPM and its dependecies:
mkdir ~/rpms; cd ~/rpms
yumdownloader --resolve --enablerepo=base,epel,update ansible.noarch

# On the dev-server, copy the downloaded content to ~/tmp:
scp 10.50.234.133:/root/rpm/* ~/tmp
From within the ServerDistro repo use the following script to upload the data to here:

# Username/password, see /auto/kjk_esw/login_config/login.config
artifactory-connection.sh -x -a mpd -v v20.0 -r /users/kdekoninck/git/media_plane_deployer-CLEAN/rpm --username mpddpl.gen --password Lam36Tr50
# Now you can ue the packages in the Dockerfile.
