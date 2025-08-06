# Load and apply all manifests automatically
locals {
  manifest_files = fileset("${path.module}/manifests", "**/*.yaml")
  domain_name    = "cloudcraftlab.work"
}
