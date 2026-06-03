module "mysql_sg" {

  #source = "../aws-SG-module"
  source         = "git::https://github.com/Giribabu1492/aws-sg-module.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "mysql"
  sg_description = "security group for mysql servers"
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  common_tags    = var.common_tags
}

module "backend_sg" {
  #source = "../aws-SG-module"
  source         = "git::https://github.com/Giribabu1492/aws-sg-module.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "backend"
  sg_description = "security group for backend servers"
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  common_tags    = var.common_tags
}

module "frontend_sg" {
  #source = "../aws-SG-module"
  source         = "git::https://github.com/Giribabu1492/aws-sg-module.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "frontend"
  sg_description = "security group for frontend servers"
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  common_tags    = var.common_tags
}

module "bastion" {
  #source = "../aws-SG-module"
  source         = "git::https://github.com/Giribabu1492/aws-sg-module.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "bastion"
  sg_description = "security group for bastion servers"
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  common_tags    = var.common_tags
}

module "app_alb_sg" {
  #source = "../aws-SG-module"
  source         = "git::https://github.com/Giribabu1492/aws-sg-module.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "app-alb"
  sg_description = "security group for app-alb servers"
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  common_tags    = var.common_tags
}




module "web_alb_sg" {
  #source = "../aws-SG-module"
  source         = "git::https://github.com/Giribabu1492/aws-sg-module.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "web-alb"
  sg_description = "security group for web-alb servers"
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  common_tags    = var.common_tags
}



#accept traffic from bastion to app-alb on port 80
resource "aws_security_group_rule" "app_alb_bastion_inbound" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.app_alb_sg.sg_id
}

resource "aws_security_group_rule" "bastion_public_inbound" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #replace with your ip
  security_group_id = module.bastion.sg_id

}


module "vpn_sg" {
  #source = "../aws-SG-module"
  source         = "git::https://github.com/Giribabu1492/aws-sg-module.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "vpn"
  sg_description = "security group for vpn servers"
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  common_tags    = var.common_tags
}




resource "aws_security_group_rule" "vpn_public" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  #it should be static ip
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule" "vpn_443" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  #it should be static ip
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
  type      = "ingress"
  from_port = 943
  to_port   = 943
  protocol  = "tcp"
  #it should be static ip
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule" "vpn_1194" {
  type      = "ingress"
  from_port = 1194
  to_port   = 1194
  protocol  = "tcp"
  #it should be static ip
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule" "app_alb_vpn_inbound" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id        = module.app_alb_sg.sg_id
}

resource "aws_security_group_rule" "mysql_bastion_inbound" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.mysql_sg.sg_id

}

resource "aws_security_group_rule" "mysql_vpn_inbound" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id        = module.mysql_sg.sg_id

}




resource "aws_security_group_rule" "backend_vpn_ssh_inbound" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id        = module.backend_sg.sg_id

}

resource "aws_security_group_rule" "backend_vpn_http_inbound" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id        = module.backend_sg.sg_id

}


resource "aws_security_group_rule" "backend_app_alb_inbound" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.app_alb_sg.sg_id
  security_group_id        = module.backend_sg.sg_id

}
resource "aws_security_group_rule" "mysql_backend_inbound" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.backend_sg.sg_id
  security_group_id        = module.mysql_sg.sg_id

}

resource "aws_security_group_rule" "web_alb_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.web_alb_sg.sg_id
}

resource "aws_security_group_rule" "app_alb_frontend_inbound" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.web_alb_sg.sg_id
}


resource "aws_security_group_rule" "frontend_web_alb_inbound" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.web_alb_sg.sg_id
  security_group_id        = module.frontend_sg.sg_id
}

# usually you should configure frontend using private ip from VPN only
resource "aws_security_group_rule" "frontend_public_inbound" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.frontend_sg.sg_id
}