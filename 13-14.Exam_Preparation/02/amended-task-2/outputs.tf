output "web_url" {
  value = azurerm_linux_web_app.lwa.default_hostname
}

output "web_ips" {
  value = azurerm_linux_web_app.lwa.possible_outbound_ip_addresses
}