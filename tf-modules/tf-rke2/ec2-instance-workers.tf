resource "aws_network_interface" "ec2_network_interface" {
  for_each = var.workers

  subnet_id       = each.value.zone == "edge" ? aws_subnet.tf_outpost_subnet_edge[0].id : (each.value.zone == "wvl" ? aws_subnet.tf_subnet_wvl[0].id : aws_subnet.vpc_private_subnets[0].id)
  security_groups = each.value.zone == "wvl" ? [aws_security_group.sgs_wvl[0].id] : (var.cidr_block_vpc_digital_twins != null && var.cidr_block_vpc_digital_twins != "" ? [aws_security_group.rke2_cluster_sgs.id, aws_security_group.sgs_vpc_peering[0].id] : [aws_security_group.rke2_cluster_sgs.id])

  tags = {
    Name = each.key
  }
}


resource "aws_instance" "ec2_instance_workers" {
  for_each = var.workers

  ami             = var.ami
  instance_type   = each.value.zone == "edge" ? var.instance_type_outpost : var.instance_type_region
  key_name        = var.key_name
  monitoring      = var.monitoring
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  network_interface {
    device_index          = 0
    network_interface_id  = aws_network_interface.ec2_network_interface[each.key].id
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 80
    volume_type = "gp2"
  }

  tags = {
    Name = each.key
  }

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

                sudo aws s3 cp s3://mgmt-config-files/amazon-cloudwatch-agent.json /opt/aws/amazon-cloudwatch-agent/amazon-cloudwatch-agent.json

                sudo amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/amazon-cloudwatch-agent.json
                
  EOF
}
