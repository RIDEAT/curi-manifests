




module "common" {
    source = "./modules/common"
}

module "eks" {
    source = "./modules/eks"
    environment_name = module.common.environment_name
    vpc_id = module.common.vpc_id
    private_subnets = module.common.private_subnets
    tags = module.common.tags
}