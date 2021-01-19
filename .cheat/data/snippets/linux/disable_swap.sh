# Disable swap
swapoff --all
sed -i '/ swap / s/^/#/' /etc/fstab
