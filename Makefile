# Makefile
create-cluster:
	sh ./kind-cluster.sh

setup-ingress:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

setup-cert-manager: 
	kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.0.2/cert-manager.yaml

gen-cert:
	kubectl apply -f cert-issuer.yaml

init-argocd:
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

setup-argocd: init-argocd
	kubectl apply -f ingress.yaml

argocd-pass:
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
	

delete-cluster:
	kind delete cluster

