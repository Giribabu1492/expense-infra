variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project     = "expense"
    Environment = "dev"
    Terraform   = "true"
  }
}

variable "domain_name" {

  default = "shrihan.online"
}

variable "zone_id" {
  default = "Z03274013KI64SWNAI87G"
}