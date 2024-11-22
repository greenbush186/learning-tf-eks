# Bastion Host - EC2 Instance that will be created in VPC Public Subnet
module "ec2_public" {
    source  = "terraform-aws-modules/ec2-instance/aws"
    version = "5.7.1"  
  
    name = "${local.name}-BastionHost"
    ami                    = var.instance_ami
    instance_type          = var.instance_type
    key_name               = aws_key_pair.bastion_key_pair.key_name
    #monitoring             = true
    subnet_id              = module.vpc.public_subnets[0]
    vpc_security_group_ids = [aws_security_group.public_bastion_sg.id]
    associate_public_ip_address = true
    
    tags = local.common_tags
}

resource "aws_key_pair" "bastion_key_pair" {
    key_name   = "bastion" # Name of the SSH key in AWS
    public_key = file("files/id_rsa.pub")
}