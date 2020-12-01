yum install -y yum-utils
yum-config-manager --enable extras,updates,base,yum.dockerproject.org_repo_main_centos_7,dockerrepo
yum repolist
yum-config-manager --disable '*'
yum repolist
