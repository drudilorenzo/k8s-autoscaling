#!/bin/bash

kubectl apply -f config.yaml     && \
kubectl get service apache-service

if (( $? == 0 )) ; then echo ok ; 

kubectl get service apache-service | grep apache-service | ( \
	read A B C D PORTSTRING F ;
	WITHOUTEND=${PORTSTRING%%\/TCP*};
	PORT=${WITHOUTEND##*:};
	echo PORT ${PORT};

	LINE=`kubectl describe node master | grep InternalIP:`;

    RAW_IP=${LINE##*:};
	IP="${RAW_IP// /}";
	echo service at  http://${IP}:${PORT}/
 )

else		echo errore ; fi
