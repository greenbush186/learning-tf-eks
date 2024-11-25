# Bastion Host - EC2 Instance that will be created in VPC Public Subnet
module "ec2_public" {
    source  = "terraform-aws-modules/ec2-instance/aws"
    version = "5.7.1"  

    depends_on = [
        module.vpc,
        aws_key_pair.bastion_key_pair,
        aws_iam_instance_profile.bastion_instance_profile,
        aws_eks_cluster.eks_cluster
    ]
  
    name = "${local.name}-BastionHost"
    ami                    = var.instance_ami
    instance_type          = var.instance_type
    key_name               = aws_key_pair.bastion_key_pair.key_name
    #monitoring             = true
    subnet_id              = module.vpc.public_subnets[0]
    vpc_security_group_ids = [aws_security_group.public_bastion_sg.id]
    associate_public_ip_address = true
    iam_instance_profile    = aws_iam_instance_profile.bastion_instance_profile.name

    # User Data Script
    user_data = templatefile("${path.module}/files/bastion-user-data.sh", {
        region = data.aws_region.current.name
        cluster_id = aws_eks_cluster.eks_cluster.id
        bastion_role_arn = aws_iam_role.bastion_role.arn
    })
    
    tags = local.common_tags
}

resource "aws_key_pair" "bastion_key_pair" {
    key_name   = "bastion" # Name of the SSH key in AWS
    public_key = file("${path.module}/files/id_rsa.pub")
}