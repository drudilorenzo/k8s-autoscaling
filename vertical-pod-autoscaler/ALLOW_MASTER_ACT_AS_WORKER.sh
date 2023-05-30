# Run to allow master to act as worker
# so that we can run pods on master node also

kubectl taint nodes --all node-role.kubernetes.io/master-
