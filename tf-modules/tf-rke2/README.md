# Terraform RKE2 AWS

## Bastion telefonica

```

# install ansible
sudo apt -y install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt install ansible -y
sudo ansible-galaxy collection install community.kubernetes


# install kubectl
$ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
$ sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
$ kubectl 
$ rm -rf kubectl

# get the private key of instances once deployed

# git and credentials
$ ssh-keygen -t rsa -b 4096 -C "alvaroandres.anayaamariles@telefonica.com" 
# get the public key and store that in the keys of github
$ cat  ~/.ssh/id_rsa.pub
$ git config --global user.name "andresanaya21"
$ git config --global user.email alvaroandres.anayaamariles@telefonica.com

# install helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm -y

# install ktail
curl -L https://github.com/atombender/ktail/releases/download/v1.4.0/ktail-linux-amd64 > /home/ubuntu/ktail 
sudo install /home/ubuntu/ktail /usr/local/bin/ktail

```
## Dependencies

- Before execute this module, execute the s3-bucket module if not already deployed. It has the configurations files to execute automations in cloud-init EC2 intances.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.23.0 |
| <a name="provider_external"></a> [external](#provider\_external) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2_instance"></a> [ec2\_instance](#module\_ec2\_instance) | terraform-aws-modules/ec2-instance/aws | 5.5.0 |
| <a name="module_ec2_instance_workers"></a> [ec2\_instance\_workers](#module\_ec2\_instance\_workers) | terraform-aws-modules/ec2-instance/aws | 5.5.0 |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloud9_environment_ec2.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloud9_environment_ec2) | resource |
| [aws_iam_policy.aws_lb_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.rke2_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_lb.nlb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.nlb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.nlb_listener_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.nlb_tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.nlb_tg_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.nlb_tg_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.nlb_tg_attachment_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_network_interface.second_nic_masters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_network_interface.second_nic_workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_network_interface_attachment.attach_local_nic_masters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface_attachment) | resource |
| [aws_network_interface_attachment.attach_local_nic_workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface_attachment) | resource |
| [aws_route_table.rtb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.rta](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.nlb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.rke2_cluster_sgs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.tf_outpost_subnet_edge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.tf_outpost_subnet_edge_local](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [external_external.current_ip](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| <a name="input_bastion_host"></a> [bastion\_host](#input\_bastion\_host) | cloud9 bastion host to access to the cluster rke2 | `bool` | `false` |
| <a name="input_cidr_block_snet_op_local"></a> [cidr\_block\_snet\_op\_local](#input\_cidr\_block\_snet\_op\_local) | value of the cidr to the subnet created in the outpost. This subnet will be used to connect the instances to on-premise. Please keep in mind the var.vpc\_cidr variable | `string` | `"172.0.5.0/24"` |
| <a name="input_cidr_block_snet_op_region"></a> [cidr\_block\_snet\_op\_region](#input\_cidr\_block\_snet\_op\_region) | value of the cidr to the subnet created in the outpost. This subnet will be used to connect the instances to region. Please keep in mind the var.vpc\_cidr variable | `string` | `"172.0.4.0/24"` |
| <a name="input_control_plane_edge"></a> [control\_plane\_edge](#input\_control\_plane\_edge) | control plane in Outpost (edge) | `bool` | `false` |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | name of key | `string` | `"tactile5g"` |
| <a name="input_masters"></a> [masters](#input\_masters) | Map of master nodes | <pre>map(object({<br>    private_ip = string<br>  }))</pre> | <pre>{<br>  "backup-cluster-mgmt-rke2-master-0": {<br>    "private_ip": "172.0.5.10"<br>  },<br>  "backup-cluster-mgmt-rke2-master-1": {<br>    "private_ip": "172.0.5.11"<br>  }<br>}</pre> |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | true/false enabling monitoring | `bool` | `true` |
| <a name="input_name_lb"></a> [name\_lb](#input\_name\_lb) | name of the lb | `string` | `"new-nlb-tf"` |
| <a name="input_tags"></a> [tags](#input\_tags) | set of tags | `map(string)` | <pre>{<br>  "environment": "Outpost-edge",<br>  "owner": "alvaroandres.anayaamariles@telefonica.com",<br>  "project": "tactile5g"<br>}</pre> |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | cird to vpc | `string` | `"172.0.0.0/16"` |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | name of vpc | `string` | `"new-tf-vpc-outpost"` |
| <a name="input_workers"></a> [workers](#input\_workers) | Map of worker nodes | <pre>map(object({<br>    private_ip = string<br>    worker_in_edge = bool<br>  }))</pre> | <pre>{<br>  "backup-cluster-mgmt-rke2-worker-0": {<br>    "private_ip": "172.0.5.12",<br>    "worker_in_edge": true<br>  },<br>  "backup-cluster-mgmt-rke2-worker-1": {<br>    "private_ip": "172.0.5.13",<br>    "worker_in_edge": true<br>  }<br>}</pre> |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_ami"></a> [ec2\_ami](#output\_ec2\_ami) | n/a |
| <a name="output_ec2_length"></a> [ec2\_length](#output\_ec2\_length) | n/a |
| <a name="output_ec2_name"></a> [ec2\_name](#output\_ec2\_name) | n/a |
| <a name="output_private_ips"></a> [private\_ips](#output\_private\_ips) | n/a |
| <a name="output_username"></a> [username](#output\_username) | n/a |
<!-- END_TF_DOCS -->