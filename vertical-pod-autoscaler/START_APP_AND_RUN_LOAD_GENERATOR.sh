#!/bin/bash

./START_APP.sh

IP=`kubectl get service apache-service | awk 'NR==2 {print $3}'`;

kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -O - http://${IP}:80; done"
