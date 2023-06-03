# Vertical Pod Autoscaler

_What follows is a brief explanation on how VPA works and how you should use it, if you are interested in the demo go to [Run the VPA demo](./README.md#run-the-vpa-demo)_

`Vertical Pod Autoscaler` (VPA) is a Kubernetes component that enables automatic CPU and memory requests and limits adjustments based on historical resource usage measurements. So it is a component that can help to efficiently and automatically allocate resources. 

VPA has two different types of resource configurations that is possible to manage:
- *Requests*: the minimum amount of resources that containers need;
- *Limits*: the maximum amount of resources that a given container can consume.

VPA deployment has three main components:
- *VPA Recommender*: monitor resources utilization, looks at metric history, and the VPA deployment spec, and suggests fair requests;
- *VPA Updater*: decides which pods should be restarted based on resources allocation recommendation calculated by the Recommender;
- *VPA Admission Controller*: triggers when new pods are created and checks if it is covered by a VPA.

VPA might recommend more resources than available in the cluster, thus causing the pod not to be assigned to a node (due to insufficient resources) and therefore never run. To overcome this limitation, it’s a good idea to set the LimitRange to the maximum available resources. This will ensure that pods do not ask for more resources than the LimitRange defines.

The Kubernetes Vertical Pod Autoscaler is still in beta version, a `run-time update version` is not yet developed and some limitations are present:
- the pod may be recreated on a different node;
- since the pod is deleted and then recreated, it is not guaranteed succesfully recreation;
- **VPA SHOULD NOT BE USED WITH THE HPA**;
- VPA performance has not been tested in large clusters;
- VPA might recommend more resources than available in the cluster, thus causing the pod to not be assigned to a node (due to insufficient resources) and therefore never run. To overcome this limitation, it’s a good idea to set the LimitRange to the maximum available resources. This will ensure that pods do not ask for more resources than the LimitRange defines.

Kubernetes VPA has 4 different update modes:
1. *Off*: VPA will only provide the recommendations, and it will not automatically change resource requirements;
2. *Initial*: VPA only assigns resource requests on pod creation and never changes them later;
3. *Recreate*:  VPA assigns resource requests on pod creation time and updates them on existing pods by evicting and recreating them;
4. *Auto mode* (default): it recreates the pod based on the recommendation.

## Setup

To enable VPA, it is necessary to install the VPA components and configure the VPA deployment. If you are using the demo provided in this repository these steps are already done for you and you can skip this section.
If you wish to edit the demo configuration look into the [config.yaml](./config.yaml) file.

### Install VPA

To install VPA, you need to run the following command in a bash inside the cluster's master node:
```bash
git clone https://github.com/kubernetes/autoscaler.git # clone the autoscaler repository
cd autoscaler/vertical-pod-autoscaler # move to the VPA folder
./hack/vpa-up.sh  # install VPA components
./hack/vpa-process-yamls.sh print # print the configuration
```

For a more in depth explanation check the [official documentation](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler). 

### Configuration

To attach a VPA to a deployment you can use a configuration similar to this one:

```yaml
apiVersion: "autoscaling.k8s.io/v1"
kind: VerticalPodAutoscaler
metadata:
  name: apache-vpa
spec:
  targetRef: # Target deployment
    apiVersion: "apps/v1"
    kind: Deployment
    name: apache-deployment
  resourcePolicy:
    containerPolicies:
      - containerName: '*' # Match all containers in the deployment
        minAllowed:
          cpu: 10m
          memory: 50Mi
        maxAllowed:
          cpu: 600m
          memory: 300Mi
        controlledResources: ["cpu", "memory"]
```

## Run the VPA demo

If you havent started the cluster you can follow the instructions [here](../vagrant-kubeadm-kubernetes//README.md).

1. Enter the directory `vertical-pod-autoscaler`:
```bash
cd vertical-pod-autoscaler
```

2. Create a simple Deployment with two replicas and the Vertical Autoscaler:
```bash
./START_APP
```
Current VPA limits:
- min: CPU 10m and memory 50Mi;
- max: CPU 100m and memory 300Mi.

The container used does a big computation every time receives a new request.

3. Generates workload:
```bash
./RUN_LOAD_GENERATOR
```
It is a simple infinite loop which does a get request every 0.01s.

4. To watch the autoscaler open a new bash and run:
```bash
./WATCH_AUTOSCALER
```
5. End test:
```bash
./STOP_LOAD_GENERATOR && ./STOP_APP
```
