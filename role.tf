# Create IAM Role for EC2 with trust relationship for EC2
resource "aws_iam_role" "tfe_nomad_role" {
  name = "tfe-nomad-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}


# Attach the AdministratorAccess policy to the role
resource "aws_iam_role_policy_attachment" "ec2_admin_policy_attachment" {
  role       = aws_iam_role.tfe_nomad_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


# Create IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.tfe_nomad_role.name
}
