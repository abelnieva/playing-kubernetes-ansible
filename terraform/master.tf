resource "azurerm_virtual_machine" "k8s" {
  name                  = "k8svm"
  location              = azurerm_resource_group.k8s.location
  resource_group_name   = azurerm_resource_group.k8s.name
  network_interface_ids = [azurerm_network_interface.k8s.id]
  vm_size               = "Standard_DS2_v2"

  delete_os_disk_on_termination = true

  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_3"
    version   = "latest"
  }

  storage_os_disk {
    name              = "k8svmosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }


  os_profile {
    computer_name  = "k8s-master"
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
  }
  #Auto_Shutdown = "no"
}

resource "null_resource" "master" {

  depends_on = ["azurerm_virtual_machine.k8s"]
  connection {
    type        = "ssh"
    host        = azurerm_public_ip.bastion.ip_address
    private_key = file("${path.module}/files/key")
    user        = "abel"

  }
  provisioner "file" {
    source      = "../playbooks"
    destination = "/tmp"
  }
  provisioner "file" {
    source      = "./files"
    destination = "/tmp/playbooks"
  }
    provisioner "remote-exec" {
    inline = [
      "sudo bash /tmp/playbooks/init.sh"
    ]

  }

  provisioner "remote-exec" {
    inline = [
"bash /tmp/playbooks/ansible.sh ${azurerm_network_interface.k8s.private_ip_address} master master"  # ip / nodename /  tipo de nodo 
    ]

  }
}


