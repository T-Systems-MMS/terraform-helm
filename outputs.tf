output "helm_release" {
  description = "helm_release results"
  value = {
    for release in keys(helm_release.release) :
    release => {
      name      = helm_release.release[release].name
      namespace = helm_release.release[release].namespace
      metadata  = helm_release.release[release].metadata
    }
  }
}
