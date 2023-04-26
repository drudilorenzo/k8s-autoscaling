
echo Running load generator against: $1

kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -O - http://10.0.0.10:32150; done"
