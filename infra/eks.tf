#eks cluster
resource "aws_eks_cluster" "eks_cluster" {
  name = "eks_cluster"

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }
  

  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.31"

  vpc_config {
    subnet_ids = [
      aws_subnet.public_subnets[0].id,
      aws_subnet.public_subnets[1].id,
      aws_subnet.private_subnets[0].id,
      aws_subnet.private_subnets[1].id
    ]
    # security_group_ids = [aws_security_group.eks_cluster_sg.id]
    endpoint_private_access = false
    endpoint_public_access  = true
  }
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

#node group
resource "aws_iam_role" "nodes" {
  name = "eks-node-group-nodes"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}
resource "aws_iam_role_policy_attachment" "nodes_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}
resource "aws_iam_role_policy_attachment" "nodes_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "aws_eks_node_group" "aws_eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "aws_eks_node_group"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = aws_subnet.private_subnets[*].id
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
  capacity_type  = "SPOT"
  instance_types = ["t3.medium"]
  update_config {
    max_unavailable = 1
  }
  depends_on = [
    aws_iam_role_policy_attachment.nodes_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes_AmazonEC2ContainerRegistryReadOnly,
  ]
  
}