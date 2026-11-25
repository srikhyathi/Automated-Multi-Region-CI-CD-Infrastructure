variable "cluster_name" { type = string }
variable "subnet_ids" { type = list(string) }

resource "aws_iam_role" "cluster_role" {
  name = "${var.cluster_name}-eks-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster_role.arn
  version  = "1.30"

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

output "cluster_name" { value = aws_eks_cluster.eks.name }
output "endpoint" { value = aws_eks_cluster.eks.endpoint }
output "arn" { value = aws_eks_cluster.eks.arn }
