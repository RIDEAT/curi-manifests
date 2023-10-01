provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  config_path    = "~/.kube/config"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}


provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    config_path    = "~/.kube/config"

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}


#tfsec:ignore:aws-eks-enable-control-plane-logging
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.13"

  cluster_name                   = var.environment_name
  cluster_version                = "1.27"
  cluster_endpoint_public_access = true

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  eks_managed_node_groups = {
    initial = {
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 4
      desired_size = 3
    }
  }


  
  tags = var.tags
}

module "eks_blueprints_addons" {
    source = "aws-ia/eks-blueprints-addons/aws"
    version = "~> 1.0" #ensure to update this to the latest/desired version

    cluster_name      = module.eks.cluster_name
    cluster_endpoint  = module.eks.cluster_endpoint
    cluster_version   = module.eks.cluster_version
    oidc_provider_arn = module.eks.oidc_provider_arn

    eks_addons = {
      coredns = {
        most_recent = true
      }
      vpc-cni = {
        most_recent = true
      }
      kube-proxy = {
        most_recent = true
      }
    }

    enable_aws_load_balancer_controller    = true
    enable_kube_prometheus_stack           = true
    enable_metrics_server                  = true
    enable_external_dns                    = true
    enable_argocd                          = true
    enable_cluster_autoscaler              = true
    external_dns_route53_zone_arns = ["arn:aws:route53:::hostedzone/Z0934139S3TFB9Q1ANA7"]

    tags = var.tags
}