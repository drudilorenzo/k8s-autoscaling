#!/bin/bash

kubectl apply -f php-apache-NodePort.yaml     && \
kubectl get service php-apache

if (( $? == 0 )) ; then echo ok ; 

kubectl get service php-apache | grep php-apache | ( \
	read A B C D MAPPAPORTE F ;
	SENZAFINE=${MAPPAPORTE%%\/TCP*};
	PORTA=${SENZAFINE##*:};
	echo PORTA ${PORTA};
        # directory SistemiVirtualizzati/KubeVagrantVirtualbox/vagrant-kubeadm-kubernetes
	# LINE=`kubectl describe node master-node | grep InternalIP:`;
        # directory SistemiVirtualizzati/KubeVagrantVirtualbox/vagrant_k8s
	LINE=`kubectl describe node master | grep InternalIP:`;
        # directory SistemiVirtualizzati/KubeVagrantVirtualbox/1_vagrant_k8s
	# LINE=`kubectl describe node master1k8s | grep InternalIP:`;
        # directory SistemiVirtualizzati/KubeVagrantVirtualbox/1-vagrant-kubeadm-kubernetes
	# LINE=`kubectl describe node master1v | grep InternalIP:`;
    RAW_IP=${LINE##*:};
	IP="${RAW_IP// /}";
	echo servizio at  http://${IP}:${PORTA}/
 )

else		echo errore ; fi
