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
      repository                      = null
      repository_key_file             = null
      repository_cert_file            = null
      repository_ca_file              = null
      repository_username             = null
      repository_password             = null
      devel                           = null
      verify                          = null
      keyring                         = null
      timeout                         = null
      disable_webhooks                = null
      reuse_values                    = null
      reset_values                    = true
      force_update                    = true
      recreate_pods                   = null
      cleanup_on_fail                 = true
      max_history                     = 3
      atomic                          = null
      skip_crds                       = null
      render_subchart_notes           = null
      disable_openapi_validation      = null
      wait                            = true
      wait_for_jobs                   = null
      dependency_update               = null
      replace                         = null
      description                     = null
      lint                            = true
      create_namespace                = null
      values                          = null
      set               = {
        name = ""
        type = null
      }
      set_sensitive     = {
        name = ""
        type = null
      }
      postrender        = {
        binary_path = ""
        args = null
      }
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
        for config in ["postrender"] :
        config => merge(local.default.helm_release[config], local.helm_release_values[helm_release][config])
      },
      {
        for config in ["set", "set_sensitive"] :
        config => {
          for key in keys(lookup(var.helm_release[helm_release], config, {})) :
          key => merge(local.default.helm_release[config], local.helm_release_values[helm_release][config][key])
        }
      }
    )
  }
}
