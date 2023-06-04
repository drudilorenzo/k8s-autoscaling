#!/bin/bash

kubectl apply -f config.yaml     && \
kubectl get service apache-service

if (( $? == 0 ))
then
    echo ok
else
    echo errore
fi
