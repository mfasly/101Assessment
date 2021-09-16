resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = var.iam_role_arn
  version  = var.eks_version

  vpc_config {
    subnet_ids         = var.subnet_id_list
    #security_group_ids = var.security_group_ids
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = var.cluster_name
  node_group_name = join("-", [var.cluster_name, "ng"])
  node_role_arn   = var.iam_node_role_arn
  subnet_ids      = var.subnet_id_list

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  depends_on = [aws_eks_cluster.eks]
}