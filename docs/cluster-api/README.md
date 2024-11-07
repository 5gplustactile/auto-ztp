# Cluster API

## Requirements
- Access to the CLUSTER MGMT API Kuberbetes (ex: able to do kubectl commands)

## Installation procedure

```
# aws cli

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# clusterctl

curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v1.5.1/clusterctl-linux-amd64 -o clusterctl

sudo install -o root -g root -m 0755 clusterctl /usr/local/bin/clusterctl

clusterctl version

# clusterawsadm 

curl -L https://github.com/kubernetes-sigs/cluster-api-provider-aws/releases/download/v2.2.1/clusterawsadm-linux-amd64 -o clusterawsadm

chmod +x clusterawsadm

# check the ami available
clusterawsadm ami list --kubernetes-version=v1.18.12 --os=ubuntu-20.04  --region=eu-west-3
clusterawsadm ami list # it retrieves all amis available

install clusterawsadm /usr/local/bin/clusterawsadm

export AWS_REGION=eu-west-3 # This is used to help encode your environment variables
export AWS_ACCESS_KEY_ID=<your-access-key>
export AWS_SECRET_ACCESS_KEY=<your-secret-access-key>
export AWS_SESSION_TOKEN=<session-token> # If you are using Multi-Factor Auth.

# The clusterawsadm utility takes the credentials that you set as environment
# variables and uses them to create a CloudFormation stack in your AWS account
# with the correct IAM resources.
clusterawsadm bootstrap iam create-cloudformation-stack --region eu-west-3

# Create the base64 encoded credentials using clusterawsadm.
# This command uses your environment variables and encodes
# them in a value to be stored in a Kubernetes Secret.
export AWS_B64ENCODED_CREDENTIALS=$(clusterawsadm bootstrap credentials encode-as-profile)

# Finally, initialize the management cluster
clusterctl init --infrastructure aws

# check installation
$ kubectl -n capa-system get pods
```