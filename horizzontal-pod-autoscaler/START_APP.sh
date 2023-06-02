#!/bin/bash

kubectl apply -f php-apache.yaml     && \
kubectl get service php-apache

if (( $? == 0 ))
then
    echo ok
else
    echo errore
fi