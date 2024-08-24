module "vpc" {
  source = "../../modules/vpc"

  common_info = local.common_info
  common_tags = local.common_tags
  vpc_info = local.vpc_info
  eks_cluster_info = local.eks_cluster_info
}

module "bastion" {
  source = "../../modules/bastion"

  common_info = local.common_info
  common_tags = local.common_tags
  vpc_info = local.vpc_info
  eks_cluster_info = local.eks_cluster_info
  vpc_id = module.vpc.vpc_id
  subnets_public_ids  = module.vpc.subnets_public_ids
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = " 19.20.0"

  cluster_name    = local.eks_cluster_info.cluster_name
  cluster_version = local.eks_cluster_info.cluster_version

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access  = true

  create_cloudwatch_log_group = false

  cluster_addons = {
    coredns                = {
      most_recent = true
    }
    kube-proxy             = {
      most_recent = true
    }
    vpc-cni                = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.subnets_private_ids
  control_plane_subnet_ids = module.vpc.subnets_private_ids


  # cluster_endpoint_public_access_cidrs=["219.100.37.246/32"] # VPN HardCoding
  cluster_endpoint_public_access_cidrs=["0.0.0.0/0"] # 개발 시에는 속도를 위해 vpn 해제 

  create_node_security_group = false
  eks_managed_node_groups = {
    service = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.large"]

      min_size     = 3
      max_size     = 6
      desired_size = 3
      subnet_ids= module.vpc.subnets_private_ids

      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }

    }
    
    manage = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.large"]

      min_size     = 3
      max_size     = 6
      desired_size = 3
      subnet_ids= module.vpc.subnets_private_ids

      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }

    }
  }
  
  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
   egress_bastion = {
      description   = "bastion all ingress"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      cidr_blocks = ["${module.bastion.bastion_private_ip}/32"]
   }

    egress_all = {
      description   = "allow all egress"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type  = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress_local = {
      description   = "local all ingress"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      cidr_blocks = ["${data.external.local_ip.result.ip}/32"]
   }

  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {

    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }

  tags = {
    Environment = "test"
    Terraform   = "true"
    "karpenter.sh/discovery" = local.eks_cluster_info.cluster_name
  }
}

module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "19.20.0"

  cluster_name                    = local.eks_cluster_info.cluster_name
  irsa_oidc_provider_arn          = module.eks.oidc_provider_arn
  irsa_namespace_service_accounts = ["karpenter:karpenter"]

  create_iam_role      = false

  iam_role_arn    = module.eks.eks_managed_node_groups["service"].iam_role_arn
  irsa_use_name_prefix = false

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

module "alb_controller_irsa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${local.eks_cluster_info.cluster_name}-${var.alb_chart.name}"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    one = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:${var.alb_chart.name}"]
    }
  }
}