resource "kubernetes_deployment" "django-api" {   # Define um recurso de implantação do Kubernetes para a aplicação Django, gerenciando a criação e atualização dos pods que executam a aplicação
  metadata {
    name = "django-api"
    labels = {
      nome = "django"
    }
  }

  spec {                    # Especifica a configuração da implantação, incluindo o número de réplicas, os seletores de rótulos e o template dos pods
    replicas = 3

    selector {              # Define os seletores de rótulos para identificar os pods gerenciados por esta implantação, garantindo que apenas os pods com o rótulo "nome=django" sejam selecionados e gerenciados por esta implantação
      match_labels = {
        nome = "django"
      }
    }

    template {              # Especifica o template dos pods, definindo a configuração dos contêineres que serão executados nos pods gerenciados por esta implantação  
      metadata {
        labels = {
          nome = "django"
        }
      }

      spec {
        container {
          image = "545131826695.dkr.ecr.us-east-2.amazonaws.com/producao:v1"
          name  = "django"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/clientes/"
              port = 8000

            }

            initial_delay_seconds = 10
            period_seconds        = 15
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "load_balancer" {   # Define um recurso de serviço do Kubernetes para expor a aplicação Django, criando um balanceador de carga que distribui o tráfego entre os pods gerenciados pela implantação  
  metadata {
    name = "load-balancer-django-api"
  }
  spec {
    selector = {
      nome = "django"
    }
   # session_affinity = "ClientIP"
       
    port {
      port        = 8000
      target_port = 8000
    }
    type = "LoadBalancer"
  }
}
data "kubernetes_service" "nomeDNS" {         # Define um recurso de dados do Kubernetes para obter informações sobre o serviço de balanceamento de carga criado, permitindo acessar o status e o endereço DNS do serviço para uso posterior
  metadata {
    name = "load-balancer-django-api"
  }
}
output URL {
    value = data.kubernetes_service.nomeDNS.status # Define uma saída para o endereço DNS do serviço de balanceamento de carga, permitindo que o endereço seja facilmente acessado e utilizado em outras partes da infraestrutura ou para fins de monitoramento e teste
  }