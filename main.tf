/**
 * # helm
 *
 * This module manages helm releases.
 *
*/

/** helm release */
resource "helm_release" "release" {
  for_each = var.helm_release

  name              = local.helm_release[each.key].name == "" ? each.key : local.helm_release[each.key].name
  namespace                       = local.helm_release[each.key].namespace
  chart                           = local.helm_release[each.key].chart
  repository                      = local.helm_release[each.key].repository
  repository_key_file             = local.helm_release[each.key].repository_key_file
  repository_cert_file            = local.helm_release[each.key].repository_cert_file
  repository_ca_file              = local.helm_release[each.key].repository_ca_file
  repository_username             = local.helm_release[each.key].repository_username
  repository_password             = local.helm_release[each.key].repository_password
  devel                           = local.helm_release[each.key].devel
  version                         = local.helm_release[each.key].version
  verify                          = local.helm_release[each.key].verify
  keyring                         = local.helm_release[each.key].keyring
  timeout                         = local.helm_release[each.key].timeout
  disable_webhooks                = local.helm_release[each.key].disable_webhooks
  reuse_values                    = local.helm_release[each.key].reuse_values
  reset_values                    = local.helm_release[each.key].reset_values
  force_update                    = local.helm_release[each.key].force_update
  recreate_pods                   = local.helm_release[each.key].recreate_pods
  cleanup_on_fail                 = local.helm_release[each.key].cleanup_on_fail
  max_history                     = local.helm_release[each.key].max_history
  atomic                          = local.helm_release[each.key].atomic
  skip_crds                       = local.helm_release[each.key].skip_crds
  render_subchart_notes           = local.helm_release[each.key].render_subchart_notes
  disable_openapi_validation      = local.helm_release[each.key].disable_openapi_validation
  wait                            = local.helm_release[each.key].wait
  wait_for_jobs                   = local.helm_release[each.key].wait_for_jobs
  dependency_update               = local.helm_release[each.key].dependency_update
  replace                         = local.helm_release[each.key].replace
  description                     = local.helm_release[each.key].description
  lint                            = local.helm_release[each.key].lint
  create_namespace                = local.helm_release[each.key].create_namespace

  values                          = local.helm_release[each.key].values

  dynamic "set" {
    for_each = local.helm_release[each.key].set
    content {
      name  = local.helm_release[each.key].set[set.key].name == "" ? set.key : local.helm_release[each.key].set[set.key].name
      value = local.helm_release[each.key].set[set.key].value
      type = local.helm_release[each.key].set[set.key].type
    }
  }

  dynamic "set_sensitive" {
    for_each = local.helm_release[each.key].set_sensitive
    content {
      name  = local.helm_release[each.key].set_sensitive[set_sensitive.key].name == "" ? set_sensitive.key : local.helm_release[each.key].set_sensitive[set_sensitive.key].name
      value = local.helm_release[each.key].set_sensitive[set_sensitive.key].value
      type = local.helm_release[each.key].set_sensitive[set_sensitive.key].type
    }
  }

  dynamic "postrender" {
    for_each = local.helm_release[each.key].postrender.binary_path != "" ? [1] : []
    content {
      binary_path = local.helm_release[each.key].postrender.binary_path
      args = local.helm_release[each.key].postrender.args
    }
  }
}
