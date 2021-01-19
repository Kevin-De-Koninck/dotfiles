# SHow volume group space
vgdisplay
# Create a 55GB Logic Volume (LV)
lvcreate -L +55G --name docker system
# Check logical volume path
lvdisplay
# Make filesystem
mkfs -t ext4 /dev/system/docker

# Create mountpoint
mkdir -vp /docker

# Add entry in fstab
echo '/dev/system/docker  /docker  ext4  defaults 0 0' >> /etc/fstab

# Mount all filesystems mentioned in fstab
mount --all
