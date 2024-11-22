output "bastion_public_ip" {
    description = "Bastion Host Public IP"
    value = module.ec2_public.public_ip
}