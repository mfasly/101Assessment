output "aws_eks_cluster_role_arn" {
  value      = aws_iam_role.eks_cluster_role.arn
  depends_on = [aws_iam_role.eks_cluster_role]
}

output "aws_eks_cluster_node_role" {
  value      = aws_iam_role.eks_cluster_node_role.arn
  depends_on = [aws_iam_role.eks_cluster_node_role]
}