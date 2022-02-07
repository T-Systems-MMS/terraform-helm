variable "helm_release" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}

locals {
  default = {
    # resource definition
    helm_release = {
      name              = ""
      namespace         = "default"
      repository        = ""
      chart             = ""
      description       = ""
      version           = "latest"
      wait              = true
      reuse_values      = false
      reset_values      = false
      force_update      = false
      recreate_pods     = false
      cleanup_on_fail   = false
      max_history       = 0
      dependency_update = false
      replace           = false
      lint              = false
      create_namespace  = false
      values            = []
      set               = {}
      set_sensitive     = {}
      postrender        = {}
    }
  }

  # compare and merge custom and default values
  helm_release_values = {
    for helm_release in keys(var.helm_release) :
    helm_release => merge(local.default.helm_release, var.helm_release[helm_release])
  }
  # merge all custom and default values
  helm_release = {
    for helm_release in keys(var.helm_release) :
    helm_release => merge(
      local.helm_release_values[helm_release],
      {
        for config in ["set", "set_sensitive", "postrender"] :
        config => merge(local.default.helm_release[config], local.helm_release_values[helm_release][config])
      }
    )
  }
}
