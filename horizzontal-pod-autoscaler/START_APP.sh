#!/bin/bash

kubectl apply -f php-apache.yaml     && \
kubectl get service php-apache

if (( $? == 0 )) ; then echo ok ; 

kubectl get service php-apache | grep php-apache | ( \
	read A B IP D E F ;
    echo service at  http://${IP}:80/
 )
 
else		echo errore ; fi