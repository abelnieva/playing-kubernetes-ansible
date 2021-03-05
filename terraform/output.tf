output "Bastion_IP" {
    value = azurerm_public_ip.bastion.ip_address
}