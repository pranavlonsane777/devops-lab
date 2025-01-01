output "kubeconfig" {
  value = <<EOT
  apiVersion: v1
  clusters:
  - cluster:
      server: ${aws_eks_cluster.eks_cluster.endpoint}
      certificate-authority-data: ${aws_eks_cluster.eks_cluster.certificate_authority[0].data}
    name: ${aws_eks_cluster.eks_cluster.name}
  contexts:
  - context:
      cluster: ${aws_eks_cluster.eks_cluster.name}
      user: ${aws_eks_cluster.eks_cluster.name}
    name: ${aws_eks_cluster.eks_cluster.name}
  current-context: ${aws_eks_cluster.eks_cluster.name}
  kind: Config
  users:
  - name: ${aws_eks_cluster.eks_cluster.name}
    user:
      token: $(aws eks get-token --cluster-name ${aws_eks_cluster.eks_cluster.name} --query 'status.token' --output text)
  EOT
}
