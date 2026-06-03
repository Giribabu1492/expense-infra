resource "aws_ssm_parameter" "mysql_sg_id" {
  name  = "/${var.project_name}/${var.environment}/mysql_sg_id"
  type  = "String"
  value = module.mysql_sg.sg_id
}

resource "aws_ssm_parameter" "backend_sg_id" {
  name  = "/${var.project_name}/${var.environment}/backend_sg_id"
  type  = "String"
  value = module.backend_sg.sg_id
}

resource "aws_ssm_parameter" "frontend_sg_id" {
  name  = "/${var.project_name}/${var.environment}/frontend_sg_id"
  type  = "String"
  value = module.frontend_sg.sg_id
}

resource "aws_ssm_parameter" "bastion_sg_id" {
  name  = "/${var.project_name}/${var.environment}/bastion_sg_id"
  type  = "String"
  value = module.bastion.sg_id
}

resource "aws_ssm_parameter" "app_alb_sg_id" {
  name  = "/${var.project_name}/${var.environment}/app_alb_sg_id"
  type  = "String"
  value = module.app_alb_sg.sg_id
}

resource "aws_ssm_parameter" "vpn_sg_id" {
  name  = "/${var.project_name}/${var.environment}/vpn_sg_id"
  type  = "String"
  value = module.vpn_sg.sg_id
}


resource "aws_ssm_parameter" "web_alb_sg_id" {
  name  = "/${var.project_name}/${var.environment}/web_alb_sg_id"
  type  = "String"
  value = module.web_alb_sg.sg_id
}



resource "aws_ssm_parameter" "eks_control_plane_sg_id" {
  name      = "/expense/dev/eks_control_plane_sg_id"
  type      = "String"
  value     = aws_security_group.eks_control_plane.id
  overwrite = true
}

resource "aws_ssm_parameter" "eks_node_sg_id" {
  name      = "/expense/dev/eks_node_sg_id"
  type      = "String"
  value     = aws_security_group.eks_node.id
  overwrite = true
}
