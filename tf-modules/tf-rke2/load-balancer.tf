# Create a security group for the network load balancer
resource "aws_security_group" "nlb_sg" {
  name = "${var.name_lb}-nlb-sg"
  description = "Allow traffic to NLB"
  vpc_id = aws_vpc.vpc.id

  # Allow inbound traffic from anywhere on port 6443
  ingress {
    protocol    = "tcp"
    from_port   = 6443
    to_port     = 6443
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound traffic from anywhere on port 9345
  ingress {
    protocol    = "tcp"
    from_port   = 9345
    to_port     = 9345
    cidr_blocks = ["0.0.0.0/0"]
  }

 # Allow inbound traffic from anywhere on port 22
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic to anywhere on any port 
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# Create a network load balancer and attach it to the public subnets and security group
resource "aws_lb" "nlb" {
  
  name               = var.name_lb
  internal           = true
  load_balancer_type = "network"
  subnets            = [aws_subnet.vpc_private_subnets[1].id, aws_subnet.vpc_private_subnets[2].id, aws_subnet.vpc_private_subnets[3].id]
  security_groups    = [aws_security_group.nlb_sg.id]

  tags = var.tags
}

# Create a target group for the network load balancer and register the EC2 instances as targets
resource "aws_lb_target_group" "nlb_tg" {
  name     = "${var.name_lb}-nlb-tg-tf-masters"
  port     = 6443
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id

  # Use instance ID as target type
  target_type = "instance"

  tags = var.tags

}
resource "aws_lb_target_group" "nlb_tg_server" {
  name     = "${var.name_lb}-nlb-tg-tf-server"
  port     = 9345
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id

  # Use instance ID as target type
  target_type = "instance"

  tags = var.tags

}

resource "aws_lb_target_group" "nlb_tg_edge_workers" {
  name     = "${var.name_lb}-nlb-tg-tf-edge"
  port     = 22
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id

  # Use instance ID as target type
  target_type = "instance"

  tags = var.tags

}

# Attach the EC2 instances to the target group
resource "aws_lb_target_group_attachment" "nlb_tg_attachment" {
  count            = length(local.list_ec2)
  target_group_arn = aws_lb_target_group.nlb_tg.arn
  target_id        = element(local.list_ec2, count.index)
}

# Attach the EC2 instances to the target group
resource "aws_lb_target_group_attachment" "nlb_tg_attachment_server" {
  count            = length(local.list_ec2)
  target_group_arn = aws_lb_target_group.nlb_tg_server.arn
  target_id        = element(local.list_ec2, count.index)
}

# Attach the EC2 instances to the target group
resource "aws_lb_target_group_attachment" "nlb_tg_attachment_edge_workers" {
  count = length(local.worker_in_edge_ids)
  target_group_arn = aws_lb_target_group.nlb_tg_edge_workers.arn
  target_id        = values(local.worker_in_edge_ids)[count.index]
}

# Create a listener for the network load balancer and forward traffic to the target group
resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 6443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }

  tags = var.tags
}


resource "aws_lb_listener" "nlb_listener_server" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 9345
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg_server.arn
  }

  tags = var.tags
}

resource "aws_lb_listener" "nlb_listener_server_ssh" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 22
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg_edge_workers.arn
  }

  tags = var.tags
}