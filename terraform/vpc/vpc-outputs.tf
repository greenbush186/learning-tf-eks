output "vpc_id" {
    description = "VPC ID"
    value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
    description = "VPC CIDR Block"
    value = module.vpc.vpc_cidr_block
}

output "private_subnets" {
    description = "Private Subnets"
    value = module.vpc.private_subnets
}

output "public_subnets" {
    description = "Public Subnets"
    value = module.vpc.public_subnets
}

output "database_subnets" {
    description = "Database Subnets"
    value = module.vpc.database_subnets
}

output "nat_public_ips" {
    description = "List of public Elastic IPs created for AWS NAT Gateway"
    value = module.vpc.nat_public_ips
}

output "azs" {
    description = "Availability Zones"
    value = module.vpc.azs
}