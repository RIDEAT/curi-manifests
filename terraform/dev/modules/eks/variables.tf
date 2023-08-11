variable "environment_name" {
  description = "eks cluster name"
}

variable "vpc_id" {
    description = "vpc id"
}

variable "private_subnets" {
    description = "vpc private subnets"
}

variable "tags" {
    description = "eks cluster tags"
}