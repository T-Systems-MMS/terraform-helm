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
  namespace         = local.helm_release[each.key].namespace
  repository        = local.helm_release[each.key].repository
  chart             = local.helm_release[each.key].chart
  description       = local.helm_release[each.key].description
  wait              = local.helm_release[each.key].wait
  reuse_values      = local.helm_release[each.key].reuse_values
  reset_values      = local.helm_release[each.key].reset_values
  force_update      = local.helm_release[each.key].force_update
  recreate_pods     = local.helm_release[each.key].recreate_pods
  cleanup_on_fail   = local.helm_release[each.key].cleanup_on_fail
  max_history       = local.helm_release[each.key].max_history
  dependency_update = local.helm_release[each.key].dependency_update
  replace           = local.helm_release[each.key].replace

  lint             = local.helm_release[each.key].lint
  create_namespace = local.helm_release[each.key].create_namespace

  values = local.helm_release[each.key].values

  dynamic "set" {
    for_each = local.helm_release[each.key].set
    content {
      name  = local.helm_release[each.key].set[set.key].name
      value = local.helm_release[each.key].set[set.key].value
    }
  }
  dynamic "set_sensitive" {
    for_each = local.helm_release[each.key].set_sensitive
    content {
      name  = local.helm_release[each.key].set_sensitive[set_sensitive.key].name
      value = local.helm_release[each.key].set_sensitive[set_sensitive.key].value
    }
  }
  dynamic "postrender" {
    for_each = local.helm_release[each.key].postrender
    content {
      binary_path = local.helm_release[each.key].postrender[postrender.key].binary_path
    }
  }
}
