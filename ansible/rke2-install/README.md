# Deploy RKE2 using ansible

## Dependencies
- ansible
- Helm
- Kubectl

```
## install ansible 
# Update the system's package index
sudo apt update

# Install software-properties-common (if not already installed)
sudo apt install software-properties-common

# Add the Ansible PPA (Personal Package Archive) to your system's Software Source
sudo add-apt-repository --yes --update ppa:ansible/ansible

# Install Ansible
sudo apt install ansible

## install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod +x get_helm.sh
./get_helm.sh

## install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

# install ktail
curl -L https://github.com/atombender/ktail/releases/download/v1.4.0/ktail-linux-amd64 > /home/ubuntu/ktail 
sudo install /home/ubuntu/ktail /usr/local/bin/ktail


```

### 1. Deploy RKE2 software in ec2 instances

- RKE2 by default will install the packages below. However you can disable them in the `/etc/rancher/rke2/config.yaml`:
  - ingress-nginx
  - rke2-canal

#### Prodedure

- Modify the `ansible/inventory` file including the ansible host to each group
- Modify the `ansible/common_vars.yml` file including the DNS to nlb and additional variables
- Execute

```
$ sudo ansbile-playbook deploy.yaml -i inventory
```
