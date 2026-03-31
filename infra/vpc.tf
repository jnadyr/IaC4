module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.19"  # Isso garante que ele use a versão 5.x mais recente, evitando a 6.0

  name = "vpc-ecs"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]      # Especifica as zonas de disponibilidade
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]   # Subnets privadas para os serviços ECS
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"] # Subnets públicas para o ALB

# Habilita o NAT Gateway
  enable_nat_gateway = true       # Habilita o NAT Gateway para permitir que as instâncias em subnets privadas acessem a internet
  single_nat_gateway = true       # Use 'true' para economizar custos em dev (apenas 1 NAT para todas as AZs)

 # enable_vpn_gateway = true      # Habilita o VPN Gateway para conexões VPN, se necessário  
  
  enable_dns_hostnames = true     # Habilita os hostnames DNS para as instâncias na VPC
  enable_dns_support   = true     # Habilita o suporte a DNS para a VPC, necessário para resolver nomes de domínio dentro da VPC

  public_subnet_tags = {          # Tags para as subnets públicas, necessárias para o ALB
    "kubernetes.io/role/elb" = 1  # Tag para indicar que essas subnets são usadas para o Elastic Load Balancer (ALB)
    "kubernetes.io/cluster/producao" = "owned"  # Tag para associar as subnets ao cluster EKS de produção
  }

  private_subnet_tags = {         # Tags para as subnets privadas, necessárias para o EKS
    "kubernetes.io/role/internal-elb" = 1       # Tag para indicar que essas subnets são usadas para o Elastic Load Balancer interno (ALB interno)  
    "kubernetes.io/cluster/producao" = "owned"  # Tag para associar as subnets ao cluster EKS de produção
  }
}