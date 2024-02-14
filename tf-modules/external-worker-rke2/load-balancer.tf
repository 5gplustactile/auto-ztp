#resource "aws_lb_target_group" "nlb_tg_ext_workers" {
#  name     = "nlb-tg-tf-external-workers"
#  port     = 9345
#  protocol = "TCP"
#  vpc_id   = var.ext_vpc_id
#
#  # Use instance ID as target type
#  target_type = "ip"
#
#  tags = var.tags
#
#}
#
## Attach the EC2 instances to the target group
#resource "aws_lb_target_group_attachment" "nlb_tg_attachment_edge_workers" {
#  count = length(local.worker_in_edge_private_ip)
#  target_group_arn = aws_lb_target_group.nlb_tg_ext_workers.arn
#  target_id        = values(local.worker_in_edge_private_ip)[count.index]
#}
#
## Create a listener for the network load balancer and forward traffic to the target group
#resource "aws_lb_listener" "nlb_listener_rke2_6443" {
#  load_balancer_arn = var.lb_arn
#  port              = 6443
#  protocol          = "TCP"
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.nlb_tg_ext_workers.arn
#  }
#
#  tags = var.tags
#}
#
#
#resource "aws_lb_listener" "nlb_listener_rke2_9345" {
#  load_balancer_arn = var.lb_arn
#  port              = 9345
#  protocol          = "TCP"
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.nlb_tg_ext_workers.arn
#  }
#
#  tags = var.tags
#}
#
#resource "aws_lb_listener" "nlb_listener_rke2_ssh" {
#  load_balancer_arn = var.lb_arn
#  port              = 22
#  protocol          = "TCP"
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.nlb_tg_ext_workers.arn
#  }
#
#  tags = var.tags
#}