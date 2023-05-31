kubectl run -i --tty load-generator --rm --image=busybox:1.28 -- /bin/sh -c "while sleep 0.01; do wget -O- -q http://apache-service; done"
