output "ingress_controller_nlb" {
  description = "NLB hostname for the NGINX ingress controller"
  value       = helm_release.nginx_ingress.status["loadBalancer"]["ingress"][0]["hostname"]
}