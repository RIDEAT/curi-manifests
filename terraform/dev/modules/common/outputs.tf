output "environment_name" {
  description = "eks cluster name"
  value = local.environment_name
}

output "vpc_id" {
    description = "vpc id"
    value = module.vpc.vpc_id
}

output "private_subnets" {
    description = "vpc private subnets"
    value = module.vpc.private_subnets
}

output "tags" {
    description = "eks cluster tags"
    value = local.tags
}

output "region" {
    description = "vpc region name"
    value = data.aws_region.current.id
}