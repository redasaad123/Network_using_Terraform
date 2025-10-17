output "jump_public_ip" {
  description = "Public IP of Jump Server"
  value       = azurerm_public_ip.jump_pub.ip_address
}

output "lb_public_ip" {
  description = "Public IP of Load Balancer (web frontend)"
  value       = azurerm_public_ip.lb_pub.ip_address
}