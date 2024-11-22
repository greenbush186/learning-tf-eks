module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "5.16.0"
  
    # VPC basic details
    name = var.vpc_name
    cidr = var.vpc_cidr_block
  
    azs             = var.vpc_availability_zones
    private_subnets = var.vpc_private_subnets
    public_subnets  = var.vpc_public_subnets

    # Database subnets
    database_subnets = var.vpc_database_subnets
    create_database_subnet_group = var.vpc_create_database_subnet_group
    create_database_subnet_route_table = var.vpc_create_database_subnet_route_table
#    create_database_internet_gateway_route = true
#    create_database_nat_gateway_route = true
  
    # NAT Gateways
    enable_nat_gateway = var.vpc_enable_nat_gateway
    single_nat_gateway = var.vpc_single_nat_gateway

    # VPC DNS Parameters
    enable_dns_hostnames = true
    enable_dns_support = true
  
    tags = {
      Terraform = "true"
      Environment = local.environment
    }

    # Additional Tags to Subnets
    public_subnet_tags = {
        Type = "Public Subnets"
    }
    private_subnet_tags = {
        Type = "Private Subnets"
    }  
    database_subnet_tags = {
        Type = "Private Database Subnets"
    }
}