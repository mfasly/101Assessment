provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "vpc" {
  source          = "../../modules/vpc"
  project         = var.project
  env             = var.env
  cidr_block      = var.vpc_cidr_block
  public_subnets  = var.vpc_public_subnets
  private_subnets = var.vpc_private_subnets
}

module "iam" {
  source  = "../../modules/iam"
  project = var.project
  env     = var.env
}

module "eks" {
  source = "../../modules/eks"
  cluster_name            = var.eks_cluster_name
  iam_role_arn            = module.iam.aws_eks_cluster_role_arn
  eks_version             = var.eks_eks_version
  subnet_id_list          = module.vpc.public_subnets
  #security_group_ids      = [module.vpc.security_group_id]
  iam_node_role_arn       = module.iam.aws_eks_cluster_node_role
  node_group_desired_size = var.eks_node_group_desired_size
  node_group_max_size     = var.eks_node_group_max_size
  node_group_min_size     = var.eks_node_group_min_size

  depends_on = [
    module.iam,
    module.vpc
  ]
}

module "apigw" {
  source      = "../../modules/apigw"
  apigw_name        = "${var.project}-${var.env}-apigw"
}
