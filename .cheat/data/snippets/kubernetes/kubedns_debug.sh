# DEBUGGING kube-dns problems
# let's walk through the dependency chain
kubectl get serviceaccounts --all-namespaces                                    # you should have 1 serviceaccount per namespace
#That account should have 1 secret (auto created):
kubectl get secret --namespace=kube-system $(kubectl get serviceaccount default --namespace=kube-system -o template --template '{{(index .secrets 0).name}}')
# That secret should have 2 data (also auto-created). One should be a token, and one a ca.crt:
echo -ne "token: "; test -n "$(kubectl get secret --namespace=kube-system $(kubectl get serviceaccount default --namespace=kube-system -o template --template '{{(index .secrets 0).name}}') -o template --template '{{index .data "token"}}')" && echo yes || echo no
echo -ne "ca-crt: "; test -n "$(kubectl get secret --namespace=kube-system $(kubectl get serviceaccount default --namespace=kube-system -o template --template '{{(index .secrets 0).name}}') -o template --template '{{index .data "ca.crt"}}')" && echo yes || echo no
# If you have all of those, you MIGHT have hit a race. Specifically DNS's pod might have been created before the secret:
echo -ne "pod has secret: "; [[ $(kubectl get pod -l "k8s-app=kube-dns" --namespace=kube-system -o template --template "{{len (index .items 0).spec.volumes}}") -ge 1 ]] && echo yes || echo no
