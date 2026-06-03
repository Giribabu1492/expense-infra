variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = "true"
    }
}

variable "zone_id" {
    default = "Z00389572HRJTNJ3RVKCP"
}

variable "domain_name" {
    default = "shrihan.online"
}

# variable "db_password" {
#   default = "ExpenseApp1"
# }