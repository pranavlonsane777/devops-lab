resource "aws_eks_access_entry" "eks_cluster_access_entry" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = "arn:aws:iam::711387107942:user/pranav"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks_cluster_access_entry_admin_policy" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = "arn:aws:iam::711387107942:user/pranav"

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_policy_association" "eks_cluster_access_entry_cluster_admin_policy" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = "arn:aws:iam::711387107942:user/pranav"

  access_scope {
    type = "cluster"
  }
}
