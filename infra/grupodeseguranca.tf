resource "aws_security_group" "ssh_cluster" {  # Security group para acesso SSH ao cluster EKS
  name        = "ssh_cluster"
  description = "security group for SSH access"
  vpc_id      = module.vpc.vpc_id               # Referencia o VPC criado no módulo VPC para associar o security group ao VPC correto
}
resource "aws_security_group_rule" "ssh_cluster_in" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
   # ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = aws_security_group.ssh_cluster.id  # Permitir tráfego de entrada para SSH de qualquer lugar
}
resource "aws_security_group_rule" "ssh_cluster_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  # ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = aws_security_group.ssh_cluster.id # Permitir tráfego de saída para qualquer destino
}



