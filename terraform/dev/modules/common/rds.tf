module "rds_postgresql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.6.0"

  identifier = "${local.environment_name}-rds"

  create_db_option_group    = false
  create_db_parameter_group = false

  engine               = "postgres"
  engine_version       = "11.19" # PostgreSQL 13.3을 예시로 적었으니 필요에 따라 바꿔주세요
  family               = "postgres11" # DB parameter group
  major_engine_version = "11"      # DB option group
  instance_class       = "db.t3.small"

  allocated_storage = 20

  db_name                = "curiboard"
  username               = "curi_user"
  create_random_password = false
  password               = random_string.curi_db_master.result
  port                   = 5432

  create_db_subnet_group = true
  db_subnet_group_name   = "${local.environment_name}-rds"
  subnet_ids             = local.private_subnet_ids
  vpc_security_group_ids = [module.curi_rds_ingress.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  backup_retention_period = 0

  tags = local.tags
}

resource "random_string" "curi_db_master" {
  length  = 10
  special = false
}

module "curi_rds_ingress" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "${local.environment_name}-curi-rds"
  description = "curi RDS security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_source_security_group_id = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      description              = "PostgreSQL access from within VPC"
      source_security_group_id = aws_security_group.curi_rds_ingress.id
    },
  ]

  tags = local.tags
}

resource "aws_security_group" "curi_rds_ingress" {
  #checkov:skip=CKV2_AWS_5:This is attached in the workshop
  name        = "${local.environment_name}-curi"
  description = "Applied to curi application pods"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow inbound HTTP API traffic"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    description = "Allow all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}
