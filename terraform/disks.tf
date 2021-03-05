resource "azurerm_managed_disk" "nfs" {
  name                 = "k8sdisk-master"
  location             = azurerm_resource_group.k8s.location
  resource_group_name  = azurerm_resource_group.k8s.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "10"
}