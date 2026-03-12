output "vpc_id" {
  description = "VPC ID for downstream modules."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "VPC CIDR block."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "Internet gateway ID."
  value       = aws_internet_gateway.this.id
}

output "nat_gateway_id" {
  description = "NAT gateway ID when enabled; null otherwise."
  value       = try(aws_nat_gateway.this[0].id, null)
}

output "private_route_table_id" {
  description = "Private route table used by private subnets."
  value       = aws_route_table.private.id
}
