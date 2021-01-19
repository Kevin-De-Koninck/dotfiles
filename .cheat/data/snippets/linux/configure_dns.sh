# Configure DNS
sed -i '/\[main\]/a dns=none' /etc/NetworkManager/NetworkManager.conf
systemctl reload NetworkManager
echo 'search synamedia.com' > /etc/resolv.conf
echo 'nameserver 10.209.120.105' >> /etc/resolv.conf
echo 'nameserver 10.209.120.106' >> /etc/resolv.conf

# Test DNS
if ping kor-svt-ntp01 -c 1 > /dev/null 2>&1; then
    echo "All good."
else
    echo "DNS is not configured properly..."
fi

