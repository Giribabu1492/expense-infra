resource "aws_key_pair" "eks" {
  key_name   = "expense-eks"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCYckUq2Y+yvoQwNsbm4/eM0gWBncsHEAImi/GQoOn5JyThwNzqdALgrIjNL0Vh2+j7Q4xuQ2uy1leLW4nNDif0DVWm+XcFAo9h+YzP7NqZuEuzo5U8gCk9cMyiyz4vzYajgO9BYInQ0UB0dRNY0Rf+nTiicBtxZ7FvoPSscLuermOGkMrPyc2Fh8Xpgxa3cnMmflTU50nVy7nKyTciM0cckrneUmdi8DIKhg773MXP+RTpA/l3x+IRyPoGCWY4rehv/eFmci0M5JW9xhRhRpFVL21nRWa5ck54IkqW49UBAmQhFTNwikJi01GWfKCb8vae3o5PIMdkfkWzzCEI0sATq9DvNpFrNy9Pi8klP6r3AZrulPQOE1oylVQDBjWkWQZewGm35v3u/80ssxhCGCrfTMHDLw8NX57uJQTpQMVFw3UrYVjPYSQN1hZ9eN+OvE3sTQRV2rXgUlQthopMk8GM3M167tAZzwBITyC+qxs+QmGC6cJ7jBu0i+LQyL3rxSskY4yQyMDo++r+eclk6lSQAgh3fbTxDuZOE11F4KNdKmr8v7qj8Wi9AUCyo0BsQX/a5Fd8m4rU5rArIS9MDyBSvisFCmBkj80rY/QRJoFzy0mFwCRnZdmfb0Bycz1c13AQOPBehfjuJ40HIlII3GfcO+uhKvBH8Z9PtVQh2jE3KQ== jinagagiribabu123@gmail.com"


}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name                  = local.name
  cluster_version               = "1.32" # later we upgrade 1.32
  create_node_security_group    = false
  create_cluster_security_group = false
  cluster_security_group_id     = local.eks_control_plane_sg_id
  node_security_group_id        = local.eks_node_sg_id

  #bootstrap_self_managed_addons = false
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
    metrics-server         = {}
  }

  # Optional
  cluster_endpoint_public_access = false

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = local.vpc_id
  subnet_ids               = local.private_subnet_ids
  control_plane_subnet_ids = local.private_subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.small"]
  }

  eks_managed_node_groups = {
    /* blue = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      #ami_type       = "AL2_x86_64"
      instance_types = ["t3.micro"]
      key_name = aws_key_pair.eks.key_name

      min_size     = 2
      max_size     = 10
      desired_size = 2
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonEFSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
        AmazonEKSLoadBalancingPolicy = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
      }
    } */

    green = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      #ami_type       = "AL2_x86_64"
      instance_types = ["t3.small"]
      key_name       = aws_key_pair.eks.key_name

      min_size     = 2
      max_size     = 6
      desired_size = 2
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy     = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonEFSCSIDriverPolicy     = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
        AmazonEKSLoadBalancingPolicy = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
      }
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = local.name
    }
  )
}