ip link set bond0.10 down                    # bring interface down
ip link set bond0.10 name RENAMED            # rename interface
ip link set RENAMED up                       # bring interface up
ip addr                                      # show itfs with ip addresses
ip addr add 50.200.222.38 dev ens192         # assign IP address to interface (does not survive reboot)

ip route add 10.0.0.0/8 via 10.50.232.1               # route lab ips via default gateway (ssh)
ip route del 0/0
ip route add default via 10.50.234.18 dev ens192      # route others via an unassigned ip
echo '' > /etc/resolv.conf                            # remove dns servers
