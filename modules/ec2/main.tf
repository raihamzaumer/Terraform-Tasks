#############################################
# DATA SOURCES
#############################################
# Get the latest Amazon Linux 2 AMI by default
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

#############################################
# IAM ROLE & POLICY FOR SSM
#############################################
resource "aws_iam_role" "ssm_role" {
  count = var.create_ssm_role ? 1 : 0

  name = "${var.name_prefix}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  count = var.create_ssm_role ? 1 : 0

  role       = aws_iam_role.ssm_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  count = var.create_ssm_role ? 1 : 0

  name = "${var.name_prefix}-ssm-profile"
  role = aws_iam_role.ssm_role[0].name
}

#############################################
# SECURITY GROUP
#############################################
resource "aws_security_group" "ec2_sg" {
  name        = "${var.name_prefix}-ec2-sg"
  description = "EC2 Security Group"
  vpc_id      = var.vpc_id

  # Allow SSH only from your IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }
  ingress {
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}


  # Allow HTTP (Nginx) from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # All outbound traffic allowed
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-ec2-sg"
  }
}

#############################################
# EC2 INSTANCE
#############################################
resource "aws_instance" "app" {
  ami           = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.ec2_sg.id] # best practice in VPC :contentReference[oaicite:0]{index=0}

  associate_public_ip_address = var.associate_public_ip

  iam_instance_profile = var.create_ssm_role ? aws_iam_instance_profile.ssm_instance_profile[0].name : null

  user_data = file(var.user_data_file)

  tags = {
    Name = "${var.name_prefix}-ec2"
  }
}