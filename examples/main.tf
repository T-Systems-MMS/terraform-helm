module "helm_controller" {
  source = "../modules/azure/terraform-helm"
  helm_release = {
    akv2k8s = {
      repository      = "https://charts.spvapi.no"
      chart           = "akv2k8s"
      description     = "Azure Key Vault to Kubernetes Controller"
      reset_values    = true
      force_update    = true
      cleanup_on_fail = true
      max_history     = 3
      lint            = true
    }
    nginx-ingress = {
      repository      = "https://helm.nginx.com/stable"
      chart           = "nginx-ingress"
      name            = local.resource_name-kubernetes_cluster_controller
      description     = "Nginx Controller"
      reset_values    = true
      force_update    = true
      cleanup_on_fail = true
      max_history     = 3
      lint            = true
      values = [
        yamlencode({
          "defaultBackend" : {
            "nodeSelector" : {
              "beta.kubernetes.io/os" : "linux"
            }
          }
        })
      ]
    }
  }
}
module "helm_certificates" {
  source = "../modules/azure/terraform-helm"
  helm_release = {
    wildcard-certificate = {
      chart           = "../../helm/akv2k8s/sync-certificate"
      description     = "Sync Certificate into Kubernetes Secret"
      reset_values    = true
      force_update    = true
      cleanup_on_fail = true
      max_history     = 3
      lint            = false
      values = [
        yamlencode({
          "certificate" : {
            "vault" : {
              "name" : data.azurerm_key_vault.key_vault_mgmt.name
              "object" : {
                "name" : data.azurerm_key_vault_secret.wildcard-certificate.name
              }
            }
            "output" : {
              "secret" : {
                "name" : "wildcard-certificate"
              }
            }
          }
        })
      ]
    }
  }
}
