resource "aws_iam_role" "bastion_role" {
    name               = "${local.name}-BastionRole"
    assume_role_policy = jsonencode({
      Version : "2012-10-17"
      Statement : [
        {
          Action : "sts:AssumeRole"
          Effect : "Allow"
          Principal : {
            Service : [
                "ec2.amazonaws.com",
                "eks.amazonaws.com"
            ]
          }
        }
      ]
    })
}

resource "aws_iam_policy" "bastion_policy" {
    name        = "${local.name}-BastionPolicy"
    description = "Permissions for the Bastion Host"
    policy      = jsonencode({
      Version : "2012-10-17"
      Statement : [
        {
          # Allow listing and describing EKS clusters
          Effect   : "Allow"
          Action   : [
            "eks:ListClusters",
            "eks:DescribeCluster"
          ]
          Resource : "*"
        },
        {
          # Allow IAM Role assumption for EKS cluster API access
          Effect   : "Allow"
          Action   : [
            "sts:AssumeRole"
          ]
          Resource : "${aws_iam_role.eks_nodegroup_role.arn}"
        }
      ]
    })
}

resource "aws_iam_role_policy_attachment" "bastion_role_attachment" {
    role       = aws_iam_role.bastion_role.name
    policy_arn = aws_iam_policy.bastion_policy.arn
}

resource "aws_iam_instance_profile" "bastion_instance_profile" {
    name = "${local.name}-BastionInstanceProfile"
    role = aws_iam_role.bastion_role.name
}
