resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.joindevops.id
  instance_type          = "t3.micro"
  subnet_id              = local.public_subnet_ids
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
  associate_public_ip_address = true
  tags = merge(var.common_tags, {

    Name = "${var.project_name}-${var.environment}-bastion"
  })
}