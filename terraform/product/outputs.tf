output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = "aws eks --region ${module.common.region} update-kubeconfig --name ${module.common.environment_name}"
}
output "curi_rds_endpoint" {
  description = "Endpoint of the RDS database for the curi service"
  value       = module.common.curi_rds_endpoint
}
output "curi_rds_master_username" {
  description = "Master username of the RDS database for the curi service"
  value       = module.common.curi_rds_master_username 
}
output "curi_rds_master_password" {
  description = "Master password of the RDS database for the curi service"
  value       = module.common.curi_rds_master_password
}