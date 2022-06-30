module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "alb"
  description = "Security group for the ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "alb"

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.alb_sg.security_group_id]

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 31000
      target_type      = "instance"
      targets          = {}
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
}

resource "aws_autoscaling_attachment" "attachments" {
  for_each = {
    for pair in setproduct(module.eks.eks_managed_node_groups_autoscaling_group_names, module.alb.target_group_arns) : "${pair[0]}_${pair[1]}" => pair
  }

  autoscaling_group_name = each.value[0]
  lb_target_group_arn    = each.value[1]
}
