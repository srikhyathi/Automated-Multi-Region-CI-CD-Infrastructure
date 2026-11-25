module "vpc_primary" {
  source       = "./modules/vpc"
  providers    = { aws = aws.primary }
  region       = var.primary_region
  vpc_cidr     = var.primary_vpc_cidr
  cluster_name = "primary-eks-${var.environment}"
}

module "vpc_secondary" {
  source       = "./modules/vpc"
  providers    = { aws = aws.secondary }
  region       = var.secondary_region
  vpc_cidr     = var.secondary_vpc_cidr
  cluster_name = "secondary-eks-${var.environment}"
}

module "eks_primary" {
  source       = "./modules/eks"
  providers    = { aws = aws.primary }
  cluster_name = "primary-eks-${var.environment}"
  subnet_ids   = module "vpc_primary.private_subnet_ids"
}

module "eks_secondary" {
  source       = "./modules/eks"
  providers    = { aws = aws.secondary }
  cluster_name = "secondary-eks-${var.environment}"
  subnet_ids   = module "vpc_secondary.private_subnet_ids"
}
