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


output "curi_rds_endpoint" {
  description = "Endpoint of the RDS database for the curi service"
  value       = module.rds_postgresql.db_instance_endpoint
}
output "curi_rds_master_username" {
  description = "Master username of the RDS database for the curi service"
  value       = "curi_user"
}
output "curi_rds_master_password" {
  description = "Master password of the RDS database for the curi service"
  value       = random_string.curi_db_master.result
}