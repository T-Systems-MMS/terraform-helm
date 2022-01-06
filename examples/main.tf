module "helm_controller" {
  source = "../modules/azure/terraform-helm"
  helm_release = {
    akv2k8s = {
      repository = "https://charts.spvapi.no"
      chart      = "akv2k8s"
      description = "Azure Key Vault to Kubernetes Controller"
      reset_values = true
      force_update = true
      cleanup_on_fail = true
      max_history = 3
      lint = true
    }
    nginx-ingress = {
      repository = "https://charts.helm.sh/stable"
      chart = "nginx-ingress"
      description = "Nginx Controller"
      reset_values = true
      force_update = true
      cleanup_on_fail = true
      max_history = 3
      lint = true
      values = []
    }
  }
}
module "helm_certificates" {
  source = "../modules/azure/terraform-helm"
  helm_release = {
    wildcard-certificate = {
      chart = "../../helm/akv2k8s/sync-certificate"
      description = "Sync Certificate into Kubernetes Secret"
      reset_values = true
      force_update = true
      cleanup_on_fail = true
      max_history = 3
      lint = false
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
