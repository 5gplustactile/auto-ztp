module "ec2_instance" { 
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"
  
  timeouts = {
    create = "1h30m"
    update = "2h"
    delete = "20m"
  }

  for_each = var.instances

  ami = each.value.ami
  name = each.key
#  instance_type = "${var.instance_edge ? local.instance_type_outpost : local.instance_type_region}"
  instance_type = each.value.instance_in_edge ? local.instance_type_outpost : var.instance_type_region
  key_name = var.key_name
  monitoring = var.monitoring
  vpc_security_group_ids = [aws_security_group.sgs_instance.id]
#  subnet_id = "${var.instance_edge ? aws_subnet.tf_outpost_subnet_edge[0].id: module.vpc.private_subnets[0]}"
  subnet_id = each.value.instance_in_edge ? aws_subnet.tf_outpost_subnet_edge[0].id : aws_subnet.private_region_subnet[0].id
  associate_public_ip_address = false
  iam_role_description = "IAM Role to EC2 intances"
  create_iam_instance_profile = true

  user_data = <<-EOF
                #!/bin/bash
                exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
                echo "Hello, World!"
                sudo snap install amazon-ssm-agent --classic
                sudo snap list amazon-ssm-agent
                sudo snap start amazon-ssm-agent
                sudo snap services amazon-ssm-agent
             
                sudo adduser --disabled-password --gecos "" guest
                sudo echo "guest:password" | sudo chpasswd
                sudo adduser --disabled-password --gecos "" labuser
                sudo echo "labuser:password" | sudo chpasswd
                
                sudo mkdir /home/guest/.ssh
                sudo touch /home/guest/.ssh/authorized_keys
                sudo chown -R guest:guest /home/guest/.ssh
                sudo chmod 700 /home/guest/.ssh
                sudo chmod 600 /home/guest/.ssh/authorized_keys
                
                sudo mkdir /home/labuser/.ssh
                sudo touch /home/labuser/.ssh/authorized_keys
                sudo chown -R labuser:labuser /home/labuser/.ssh
                sudo chmod 700 /home/labuser/.ssh
                sudo chmod 600 /home/labuser/.ssh/authorized_keys
                
                sudo echo "
                Match User guest
                    AllowTcpForwarding yes
                    PermitOpen any
                    PermitTunnel yes
                    PasswordAuthentication yes
                " | sudo tee -a /etc/ssh/sshd_config
                
                sudo echo "
                Match User labuser
                    AllowTcpForwarding yes
                    PermitOpen any
                    PermitTunnel yes
                    PasswordAuthentication yes
                " | sudo tee -a /etc/ssh/sshd_config
                
                sudo service ssh restart

                sudo usermod -aG sudo labuser

                sudo wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
                
                sudo dpkg -i /amazon-cloudwatch-agent.deb
                
                sudo apt update && sudo apt install awscli -y

                #sudo aws s3 cp s3://mgmt-config-files/amazon-cloudwatch-agent.json /opt/aws/amazon-cloudwatch-agent/amazon-cloudwatch-agent.json

                #sudo amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/amazon-cloudwatch-agent.json

                sudo apt update -y
                sudo apt install netplan.io -y

                sudo echo "
                network:
                  version: 2
                  renderer: networkd
                  ethernets:
                    ens6:
                      dhcp4: true
                      dhcp4-overrides:
                        use-routes: false
                      routes:
                        - to: 10.11.0.0/16
                          via: 10.11.29.1
                        - to: 10.182.32.0/24
                          via: 10.11.29.1                
                " | sudo tee -a /etc/netplan/ens6.yaml

                netplan apply && ip link set ens6 up
    EOF

  root_block_device = "${each.value.instance_in_edge ? [] : local.root_block_device}"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    CloudWatchAgentServerRole = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  }

  instance_tags = var.tags
  tags = var.tags
}