output "load_balancer_url" {
  description = "The DNS name of the Load Balancer"
  # We use status.0 because 'status' is a list, and we want the first entry
  value = "http://${kubernetes_service.app_service.status.0.load_balancer.0.ingress.0.hostname}"
}