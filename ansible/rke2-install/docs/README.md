## Manual Process to install rke2 in HA in AWS

It works using the v1.27 and later Kubernetes versions

master-0: 
----------
```
# curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v1.27 INSTALL_RKE2_TYPE="server"  sh -

# cat /etc/rancher/rke2/config.yaml 
-----------
disable:
  - rke2-ingress-nginx
cloud-provider-name: external
node-taint:
  - CriticalAddonsOnly=true:NoExecute
tls-san:
  - ip-172-0-0-243.eu-west-3.compute.internal 
  - new-nlb-tf-655c3cac4dcd6cb7.elb.eu-west-3.amazonaws.com
-----------

# systemctl start rke2-server

### install aws cloud provider
# helm repo add aws-cloud-controller-manager https://kubernetes.github.io/cloud-provider-aws

# helm repo update

# helm upgrade --install aws-cloud-controller-manager -n kube-system aws-cloud-controller-manager/aws-cloud-controller-manager --values /home/labuser/values.yaml

### If present, edit the DaemonSet to remove the default node selector node-role.kubernetes.io/control-plane: ""
kubectl edit daemonset aws-cloud-controller-manager -n kube-system

### (Optional) Verify that the cloud controller manager update succeeded:
kubectl rollout status daemonset -n kube-system aws-cloud-controller-manager

### Get the instance ID from the metadata service
# INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

### Get the availability zone from the metadata service
# AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

### Get the node name
# NODE_NAME=$(hostname)

### Construct the provider ID
# PROVIDER_ID="aws:///${AVAILABILITY_ZONE}/${INSTANCE_ID}"

### Update the node
# kubectl patch node "${NODE_NAME}" -p "{\"spec\":{\"providerID\":\"${PROVIDER_ID}\"}}"

kubectl taint nodes <node-name> node.cloudprovider.kubernetes.io/uninitialized=false:NoSchedule-

```

master-1-X:
-----------
```
# curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v1.27 INSTALL_RKE2_TYPE="server"  sh -

# cat config.yaml 
---------
disable:
  - rke2-ingress-nginx
cloud-provider-name: external
node-taint:
  - CriticalAddonsOnly=true:NoExecute
server: https://new-nlb-tf-655c3cac4dcd6cb7.elb.eu-west-3.amazonaws.com:9345
token: token: K105ed75f67c3b9499308b3::server:140aeee802846e0c9
tls-san:
  - ip-172-0-0-243.eu-west-3.compute.internal 
  - new-nlb-tf-655c3cac4dcd6cb7.elb.eu-west-3.amazonaws.com
---------

# systemctl start rke2-server

### Get the instance ID from the metadata service
# INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

### Get the availability zone from the metadata service
# AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

### Get the node name
# NODE_NAME=$(hostname)

### Construct the provider ID
# PROVIDER_ID="aws:///${AVAILABILITY_ZONE}/${INSTANCE_ID}"

### Update the node
# kubectl patch node "${NODE_NAME}" -p "{\"spec\":{\"providerID\":\"${PROVIDER_ID}\"}}"

kubectl taint nodes <node-name> node.cloudprovider.kubernetes.io/uninitialized=false:NoSchedule-

```

worker-0-X:
---------
```
# curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v1.27 INSTALL_RKE2_TYPE="agent"  sh -

# cat config.yaml 
------------
disable:
  - rke2-ingress-nginx
cloud-provider-name: external
node-label:
  - "node=region"
  - "cluster=cluster-mgmt"
server: https://new-nlb-tf-655c3cac4dcd6cb7.elb.eu-west-3.amazonaws.com:9345
token: K105ed75f67c3b9499308b3::server:140aeee802846e0c9
------------

### Get the instance ID from the metadata service
# INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

### Get the availability zone from the metadata service
# AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

### Get the node name
# NODE_NAME=$(hostname)

### Construct the provider ID
# PROVIDER_ID="aws:///${AVAILABILITY_ZONE}/${INSTANCE_ID}"

### Update the node
# kubectl patch node "${NODE_NAME}" -p "{\"spec\":{\"providerID\":\"${PROVIDER_ID}\"}}"

kubectl taint nodes <node-name> node.cloudprovider.kubernetes.io/uninitialized=false:NoSchedule-

```

troubleshoot:
-------------
```
$ journalctl -u rke2-server
$ journalctl -u rke2-agent

# Some systemd configurations may also write combined logs to /var/log/syslog

# The Containerd logs are written to /var/lib/rancher/rke2/agent/containerd/containerd.log.

# The kubelet logs are written to /var/lib/rancher/rke2/agent/logs/kubelet.log.

# Logs from each Kubernetes Pod can be accessed with kubectl: /var/lib/rancher/rke2/bin/kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml logs -n kube-system -l component=kube-apiserver

# Logs from each container are written to /var/log/pods or can be accessed with crictl. 
```
