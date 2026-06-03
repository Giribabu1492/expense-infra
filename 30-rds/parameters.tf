# resource "aws_ssm_parameter" "db_password" {
#   name  = "/${var.project_name}/${var.environment}/db_password"
#   type  = "String"
#   value = var.db_password
# }