for kind in deploy statefulset replicasets rc pods serviceaccounts secrets configmap services ingress node; do
  echo "Deleting ${kind}..."
  kubectl delete ${kind} --all --force --grace-period=0
  kubectl delete ${kind} --all -n kube-system --force --grace-period=0
done

for ns in $(kubectl get namespaces | grep -ve '^NAME' | awk '{print $1}' | grep -v 'default\|kube-public\|kube-system\|kube-node-lease'); do
  echo "Deleting namespace: ${ns}..."
  kubectl delete namespace ${ns} --force --grace-period=0
done

docker stop $(docker ps -aq)

for svc in kube-apiserver kube-controller-manager kubelet kube-proxy kube-scheduler; do
  echo "Stopping service: ${svc}"
  systemctl disable ${svc}
  systemctl stop ${svc}
done

yum remove -y "docker*" "kube*" "flannel" "etcd"

umount $(mount | grep /var/lib/kubelet/ | awk '{print $3}')
umount $(mount | grep /var/lib/docker/ | awk '{print $3}')

rm -rf /etc/docker/ /etc/etcd/ /etc/kubernetes /etc/sysconfig/flanneld /etc/sysconfig/flanneld.rpmsave /etc/pki/ca-trust/source/anchors/k8s-ca-cert.crt ~/.kube/ /var/run/docker.sock /var/run/flannel/ /var/lib/docker/ /var/lib/kubelet/ /var/lib/kube-proxy/ /var/lib/etcd/ /etc/pki/ca-trust/source/anchors/k8s-ca-cert.crt /usr/lib/systemd/system/kube* /usr/bin/kube*

update-ca-trust extract
