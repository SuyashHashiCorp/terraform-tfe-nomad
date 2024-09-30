resource "aws_instance" "instance" {
  count                  = var.instance_count
  ami                    = var.ami_id
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  instance_type          = var.instance_type
  private_ip             = var.private_ip[count.index]
  key_name               = aws_key_pair.tfe_nomad_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  subnet_id              = aws_subnet.public_subnet_1.id

  root_block_device {
    volume_size = var.volume_size
  }

  tags = {
    Name = var.instance_name[count.index]
  }

  user_data = file("${path.module}/scripts/${var.userscripts[count.index]}")

  depends_on = [
    aws_key_pair.tfe_nomad_key_pair,
    aws_iam_role.tfe_nomad_role,
    aws_vpc.nomad_tfe_vpc,
    aws_subnet.public_subnet_1
  ]
}
