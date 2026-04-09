output "ec2_id" {
  description = "EC2 instance ID"
  value       = aws_instance.app.id
}

output "ec2_public_ip" {
  description = "Public IP of EC2"
  value       = aws_instance.app.public_ip
}

output "ec2_sg_id" {
  description = "Security group ID of EC2"
  value       = aws_security_group.ec2_sg.id
}