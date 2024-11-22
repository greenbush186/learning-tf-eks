variable vpc_name {
    type        = string
    description = "VPC Name"
}

variable vpc_cidr_block {
    type        = string
    description = "VPC CIDR Block"
}

variable vpc_availability_zones {
    type        = list(string)
    description = "VPC Availability Zones"
}

variable vpc_public_subnets {
    type        = list(string)
    description = "VPC Public Subnets"
}

variable vpc_private_subnets {
    type        = list(string)
    description = "VPC Private Subnets"
}

variable vpc_database_subnets {
    type        = list(string)
    description = "VPC Database Subnets"
}

variable vpc_create_database_subnet_group {
    type        = bool
    description = "VPC Create Database Subnet Group"    
}

variable vpc_create_database_subnet_route_table {
    type        = bool
    description = "VPC Create Database Subnet Route Table"
}

variable vpc_enable_nat_gateway {
    type        = bool
    description = "VPC Enable NAT Gateway"
}

variable vpc_single_nat_gateway {
    type        = bool
    description = "VPC Single NAT Gateway"
}