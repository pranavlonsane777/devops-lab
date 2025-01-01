# resource "aws_security_group" "eks_node_sg" {
#   name        = "eks_node_sg"
#   description = "EKS Worker Nodes Security Group"
#   vpc_id      = aws_vpc.vpc.id

#   ingress {
#     from_port   = 0
#     to_port     = 65535
#     protocol    = "tcp"
#     cidr_blocks = [aws_subnet.private_subnets[*].cidr_block]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "eks_node_sg"
#   }
# }
