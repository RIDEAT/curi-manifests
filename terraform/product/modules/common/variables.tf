variable "eks_role_arns" {
  type        = list(string)
  default     = []
  description = "Additional IAM roles that should be added to the AWS auth config map"
}
