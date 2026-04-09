# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# Public Subnet IDs
output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

# Private Subnet IDs
output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = aws_subnet.private[*].id
}

# Internet Gateway ID
output "igw_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}