module "prod" {
  source = "../../infra"                  # Caminho relativo para o módulo. O infra é o source do modulo.
  
  nome_repositorio = "producao"  # Nome do repositório ECR para o ambiente de produção
  cluster_name     = "producao" # Nome do cluster EKS
  }
output endereco {
  value       = module.prod.URL    # URL do serviço de produção
}

  