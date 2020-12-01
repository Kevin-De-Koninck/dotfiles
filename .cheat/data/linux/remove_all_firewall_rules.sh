iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

# Or script wise:
iptables -F
iptables -X
iptables -Z
for table in $(</proc/net/ip_tables_names)
do
  iptables -t $table -F
  iptables -t $table -X
  iptables -t $table -Z
done
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
