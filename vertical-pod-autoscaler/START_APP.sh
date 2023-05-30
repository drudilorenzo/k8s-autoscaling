#!/bin/bash

kubectl apply -f config.yaml     && \
kubectl get service apache-service

if (( $? == 0 )) ; then echo ok ; 

kubectl get service apache-service | grep apache-service | ( \
	read A B C D PORTSTRING F ;
	WITHOUTEND=${PORTSTRING%%\/TCP*};
	PORT=${WITHOUTEND##*:};
	echo PORT ${PORT};

    IP=`kubectl get service apache-service | awk 'NR==2 {print $3}'`;

	echo service at  http://${IP}:80/
 )

else		echo errore ; fi
