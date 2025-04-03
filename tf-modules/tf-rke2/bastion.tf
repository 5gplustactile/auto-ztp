
module "bastion_host" { 
  count = var.enable_bastion_host ? 1 : 0
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"
  
  timeouts = {
    create = "1h30m"
    update = "2h"
    delete = "20m"
  }

  ami = local.ami
  name = var.name_bastion_host
  instance_type = local.instance_type_outpost
  key_name = var.key_name
  monitoring = var.monitoring
  source_dest_check = false
#  vpc_security_group_ids = [aws_security_group.rke2_cluster_sgs.id,aws_security_group.sgs_vpc_peering.id]
  vpc_security_group_ids = var.cidr_block_vpc_digital_twins != null && var.cidr_block_vpc_digital_twins != "" ? [aws_security_group.rke2_cluster_sgs.id, aws_security_group.sgs_vpc_peering[0].id] : [aws_security_group.rke2_cluster_sgs.id]  
  subnet_id = aws_subnet.tf_outpost_subnet_edge[0].id
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
    EOF

  root_block_device = []
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    CloudWatchAgentServerRole = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  }
  tags = var.tags
}

resource "aws_network_interface" "second_nic_bastion" {
  count = var.enable_bastion_host ? 1 : 0
  subnet_id = aws_subnet.tf_outpost_subnet_edge_local[0].id
#  private_ip  = local.list_private_ips[count.index]
  security_groups = [ module.security_group.security_group_id ]
  tags = var.tags
  
}

resource "aws_network_interface_attachment" "attach_local_nic_bastion" {
  count = var.enable_bastion_host ? 1 : 0
  instance_id          = module.bastion_host[0].id
  network_interface_id = aws_network_interface.second_nic_bastion[count.index].id
  device_index         = 1

  depends_on = [ module.bastion_host ]
}