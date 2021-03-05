resource "azurerm_network_interface" "bastion" {
  name                = "k8s-bastion"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name

  ip_configuration {
    name                          = "bastionsconfiguration1"
    subnet_id                     = azurerm_subnet.k8s.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion.id
  }
}


resource "azurerm_public_ip" "bastion" {
  name                         = "bastionpip"
  location                     = azurerm_resource_group.k8s.location
  resource_group_name          = azurerm_resource_group.k8s.name
  allocation_method   = "Static"
}

resource "azurerm_virtual_machine" "bastion" {
  name                  = "bastion"
  location              = azurerm_resource_group.k8s.location
  resource_group_name   = azurerm_resource_group.k8s.name
  network_interface_ids = [azurerm_network_interface.bastion.id]
  vm_size               = "Standard_B1ms"

  delete_os_disk_on_termination = true

  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_3"
    version   = "latest"
  }

  storage_os_disk {
    name              = "bastion"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "bastion"
    admin_username = "abel"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/abel/.ssh/authorized_keys"
      key_data = file("${path.module}/files/key.pub")
    }
  }

  tags = {
    environment = "staging"
    Auto_Shutdown = "no"
  }
}
