output "ec2nodeclass_name" {
  value       = kubernetes_manifest.ec2nodeclass.manifest["metadata"]["name"]
  description = "Name of the EC2NodeClass resource."
}

output "provisioner_name" {
  value       = kubernetes_manifest.provisioner.manifest["metadata"]["name"]
  description = "Name of the Provisioner resource."
}