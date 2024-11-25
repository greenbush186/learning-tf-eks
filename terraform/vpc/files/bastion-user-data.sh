#!/bin/bash

# Install kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.2/2024-11-15/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Update eks context
aws eks update-kubeconfig --region ${data.aws_region.current.name} --name ${aws_eks_cluster.eks_cluster.id}

# Install eksctl
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz"
tar -xzf eksctl_Linux_amd64.tar.gz -C /tmp && rm eksctl_Linux_amd64.tar.gz
sudo mv /tmp/eksctl /usr/local/bin

# Update EKS aws-auth config map
eksctl create iamidentitymapping \
  --cluster ${aws_eks_cluster.eks_cluster.id} \
  --region ${data.aws_region.current.name} \
  --arn ${aws_iam_role.bastion_role.arn} \
  --group system:masters \
  --username bastion

# eksctl create iamidentitymapping --cluster devops-dev-eksdemo1 --region ap-southeast-2 --arn arn:aws:iam::640168424446:role/devops-dev-BastionRole --group system:masters --username bastion 