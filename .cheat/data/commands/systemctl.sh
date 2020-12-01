systemctl | grep running | grep kube              # Grep running kube services
systemctl start kubernetes.service                # start a service
systemctl list-dependencies vdcm.built_target     # List dependencies (and show runnign or not) of a target
cat /usr/lib/systemd/system/kube-proxy.service
