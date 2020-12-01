ip route add 10.0.0.0/8 via 10.50.232.1               # route lab ips via default gateway (ssh)
ip route del 0/0
ip route add default via 10.50.234.18 dev ens192      # route others via an unassigned ip
echo '' > /etc/resolv.conf                            # remove dns servers
