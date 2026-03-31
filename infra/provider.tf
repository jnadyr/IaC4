terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"        # Boa prática fixar a versão do provider para evitar quebras inesperadas
    }
  }

  required_version = ">= 1.2"   # Especifica a versão mínima do Terraform para garantir compatibilidade
}

provider "aws" {
  region = "us-east-2"          
}

# Copyright IBM Corp. 2017, 2026
# SPDX-License-Identifier: MPL-2.0

 data "aws_eks_cluster" "default" {   #
    depends_on = [module.eks] # Substitua pelo nome do seu recurso/módulo de criação
    name = var.cluster_name
 }

 data "aws_eks_cluster_auth" "default" {  
     depends_on = [module.eks] # Substitua pelo nome do seu recurso/módulo de criação
  name = var.cluster_name
}

provider "kubernetes" {         # Configura o provider Kubernetes para se conectar ao cluster EKS usando os dados obtidos
 host                   = data.aws_eks_cluster.default.endpoint
 cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
 token                  = data.aws_eks_cluster_auth.default.token

}

