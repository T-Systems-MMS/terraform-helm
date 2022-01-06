# resource definition
variable "helm_release" {
  type    = any
  default = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}

locals {
  default = {
    # resource definition
    helm_release = {
      namespace  = "default"
      repository = ""
      chart      = ""
      description = ""
      version    = "latest"
      wait       = true
      reuse_values  = false
      reset_values  = false
      force_update  = false
      recreate_pods = false
      cleanup_on_fail = false
      max_history = 0
      dependency_update  = false
      replace  = false
      lint  = false
      create_namespace = false
      values = []
      set = {}
      set_sensitive = {}
      postrender  = {}
    }
  }

  # merge custom and default values
  helm_release = {
    # get all config
    for config in keys(var.helm_release) :
    config => merge(local.default.helm_release, var.helm_release[config])
  }
}
