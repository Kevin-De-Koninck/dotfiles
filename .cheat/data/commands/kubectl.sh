# See which pod runs on which node
kubectl get pod -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName --all-namespaces

# Log into the vDCM pod
kubectl exec -ti $(kubectl get pods | grep vdcm | awk '{ print $1 }') -- env TERM=xterm COLUMNS=200 /bin/bash

# Deploy a busybox pod
kubectl run -i --tty busybox --rm --image=busybox:1.28 --restart=Never -- sh

# Show all resources
kubectl get nodes --no-headers | awk '{print $1}' | xargs -I {} sh -c 'echo {}; kubectl describe node {} | grep Allocated -A 5 | grep -ve Event -ve Allocated -ve percent -ve -- ; echo'
