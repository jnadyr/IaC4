module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name    = var.cluster_name 
  kubernetes_version = "1.35"          

  vpc_id     = module.vpc.vpc_id            
  subnet_ids = module.vpc.private_subnets

  endpoint_public_access  = true   # Desabilita o acesso público ao endpoint do EKS para aumentar a segurança, garantindo que o cluster só seja acessível via rede privada
  endpoint_private_access = true    # Habilita o acesso privado ao endpoint do EKS para maior segurança, evitando exposição pública
  
  enable_cluster_creator_admin_permissions = true # Concede permissões administrativas ao criador do cluster, facilitando a gestão inicial do EKS

  # Configuração de Add-ons (Nível de Cluster)
  addons = {                              # Configura os add-ons essenciais para o funcionamento do cluster EKS, garantindo a integração e o gerenciamento eficiente dos recursos
    vpc-cni = {
      before_compute              = true        # Garante que o add-on VPC CNI seja instalado antes dos recursos de computação, assegurando a configuração correta da rede para os pods
      most_recent                 = true        # Utiliza a versão mais recente do add-on VPC CNI para garantir compatibilidade e acesso às últimas melhorias e correções de segurança
      resolve_conflicts_on_create = "OVERWRITE" # Resolve conflitos durante a criação do add-on VPC CNI sobrescrevendo as configurações existentes, garantindo uma instalação limpa e funcional
      resolve_conflicts_on_update = "OVERWRITE" # Resolve conflitos durante a atualização do add-on VPC CNI sobrescrevendo as configurações existentes, mantendo o add-on atualizado e funcional sem erros de configuração
    }
    kube-proxy = {
      most_recent                 = true        # Utiliza a versão mais recente do add-on kube-proxy para garantir compatibilidade e acesso às últimas melhorias e correções de segurança
      resolve_conflicts_on_create = "OVERWRITE" # Resolve conflitos durante a criação do add-on kube-proxy sobrescrevendo as configurações existentes, garantindo uma instalação limpa e funcional
      resolve_conflicts_on_update = "OVERWRITE" # Resolve conflitos durante a atualização do add-on kube-proxy sobrescrevendo as configurações existentes, mantendo o add-on atualizado e funcional sem erros de configuração
    }
    coredns = {
      most_recent                 = true        # Utiliza a versão mais recente do add-on coredns para garantir compatibilidade e acesso às últimas melhorias e correções de segurança
      resolve_conflicts_on_create = "OVERWRITE" # Resolve conflitos durante a criação do add-on coredns sobrescrevendo as configurações existentes, garantindo uma instalação limpa e funcional
      resolve_conflicts_on_update = "OVERWRITE" # Resolve conflitos durante a atualização do add-on coredns sobrescrevendo as configurações existentes, mantendo o add-on atualizado e funcional sem erros de configuração  
    }
  }

  # Configuração de Nodes
  eks_managed_node_groups = {                   # Configura os grupos de nós gerenciados pelo EKS, facilitando a gestão e escalabilidade dos recursos de computação do cluster
     django = {                                 # Define um grupo de nós específico para a aplicação Django, permitindo uma alocação dedicada de recursos e melhor desempenho para a aplicação
      ami_type       = "AL2023_x86_64_STANDARD" # Especifica o tipo de AMI otimizada para EKS, garantindo compatibilidade e desempenho ideal para os nós do cluster
      instance_types = ["t3.micro"]              # Define os tipos de instância EC2 a serem usados para os nós do grupo, escolhendo opções econômicas e adequadas para cargas de trabalho leves

      min_size     = 1                          # Configura o número mínimo de nós no grupo, garantindo que haja sempre pelo menos um nó disponível para executar as cargas de trabalho
      max_size     = 10                         # Configura o número máximo de nós no grupo, permitindo escalabilidade automática conforme a demanda aumenta
      desired_size = 3                          # Configura o número desejado de nós no grupo, definindo a quantidade inicial de recursos alocados para as cargas de trabalho

      # Injetando o SG de SSH adicional
      additional_security_group_ids = [aws_security_group.ssh_cluster.id] # Adiciona um grupo de segurança adicional para permitir acesso SSH aos nós do cluster, facilitando a administração e solução de problemas
    }
    alura = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.micro"]

      min_size     = 1
      max_size     = 10
      desired_size = 3

      # Injetando o SG de SSH adicional
      additional_security_group_ids = [aws_security_group.ssh_cluster.id] # Adiciona um grupo de segurança adicional para permitir acesso SSH aos nós do cluster, facilitando a administração e solução de problemas
    }
  }
}
