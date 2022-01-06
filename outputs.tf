output "helm_release" {
  description = "helm_release results"
  value = {
    for release in keys(helm_release.release) :
    release => {
      metadata = helm_release.release[release].metadata
    }
  }
}
