#!/bin/bash

kubectl apply -f config.yaml     && \
kubectl get service apache-service

if (( $? == 0 )) ; then echo ok ; 

kubectl get service apache-service | grep apache-service | ( \
	read A B IP D E F ;
    echo service at  http://${IP}:80/
 )
 
else		echo errore ; fi
