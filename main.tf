module "new-vpc"{
  source = "./modules/vpc"
  prefix = var.prefix
  vpc_cidr_block = var.vpc_cidr_block
}

module "eks" {
  source = "./modules/eks"
  vpc_id = module.new-vpc.vpc_id // get vpc_id from vpc module. When a module needs data from another module, the only way is using output file
  prefix = var.prefix
  cluster_name = var.cluster_name
  retention_days = var.retention_days
  subnet_ids = module.new-vpc.subnet_ids
  desired_size = var.desired_size
  max_size = var.max_size
  min_size = var.min_size
}