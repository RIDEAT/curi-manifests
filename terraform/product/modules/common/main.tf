data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}


provider "aws" {
  region = data.aws_region.current.id
  alias  = "default"

  default_tags {
    tags = local.tags
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.environment_name
  cidr = local.vpc_cidr
  azs = local.azs

  public_subnets = local.public_subnets
  private_subnets = local.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  create_igw         = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.environment_name}" = "shared"
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.environment_name}" = "shared"
    "kubernetes.io/role/internal-elb" = 1
    "karpenter.sh/discovery" = local.environment_name
  }

  tags = local.tags
}

locals {
  tags = {
    created-by = "rideat"
    env        = local.environment_name
  }

  environment_name = "curi-cluster-product"
  shell_role_name  = "${local.environment_name}-shell-role"
  map_roles = [for i, r in var.eks_role_arns : {
    rolearn  = r
    username = "additional${i}"
    groups   = ["system:masters"]
  }]
}

locals {
  azs            = slice(data.aws_availability_zones.available.names, 0, 3)
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region     = data.aws_region.current.id
}


locals {
  vpc_cidr               = "10.42.0.0/16"
  public_subnets         = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets        = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]

  private_subnet_ids        = length(module.vpc.private_subnets) > 0 ? slice(module.vpc.private_subnets, 0, 3) : []
  primary_private_subnet_id = length(module.vpc.private_subnets) > 0 ? slice(module.vpc.private_subnets, 0, 1) : []
}

