#!/bin/bash
#
# Deploys the Kubernetes dashboard when enabled in settings.yaml

set -euxo pipefail

config_path="/vagrant/configs"

DASHBOARD_VERSION=$(grep -E '^\s*dashboard:' /vagrant/settings.yaml | sed -E 's/[^:]+: *//')
echo "OUTPUT VIC PORCA EVA CAZZO DASHBOARD_VERSION \"${DASHBOARD_VERSION}\""
if [ -n "${DASHBOARD_VERSION}" ]; then
  while sudo -i -u vagrant kubectl get pods -A -l k8s-app=metrics-server | awk 'split($3, a, "/") && a[1] != a[2] { print $0; }' | grep -v "RESTARTS"; do
    echo 'Waiting for metrics server to be ready...'
    sleep 5
  done
  echo 'Metrics server is ready. Installing dashboard...'

  sudo -i -u vagrant kubectl create namespace kubernetes-dashboard

  echo "Creating the dashboard user..."

  cat <<EOF | sudo -i -u vagrant kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF

  cat <<EOF | sudo -i -u vagrant kubectl apply -f -
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
  annotations:
    kubernetes.io/service-account.name: admin-user
EOF

  cat <<EOF | sudo -i -u vagrant kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

  echo "Deploying the dashboard..."
  echo "OUTPUT VIC PORCA EVA CAZZO \"https://raw.githubusercontent.com/kubernetes/dashboard/v${DASHBOARD_VERSION}/aio/deploy/recommended.yaml\""
  sudo -i -u vagrant kubectl apply -f "https://raw.githubusercontent.com/kubernetes/dashboard/v${DASHBOARD_VERSION}/aio/deploy/recommended.yaml"

  ## AGGIUNTA DI VIC
  #echo "OUTPUT VIC PORCA EVA CAZZO - ESPONI la DASHBOARD CON NODEPORT ..."
  ##sfrutta il fatto che la directory di progetto e' montata in /vagrant
  #sudo -i -u vagrant kubectl apply -f "/vagrant/ESPONI_DASHBOARD_CON_NODEPORT.yaml"
  ## FINE AGGIUNTA DI VIC


  sudo -i -u vagrant kubectl -n kubernetes-dashboard get secret/admin-user -o go-template="{{.data.token | base64decode}}" >> "${config_path}/token"
  echo "The following token was also saved to: configs/token"
  cat "${config_path}/token"
  echo "
Use it to log in at:
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/overview?namespace=kubernetes-dashboard
"
fi
