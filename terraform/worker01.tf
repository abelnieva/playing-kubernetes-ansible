resource "azurerm_virtual_machine" "worker01" {
  name                  = "worker01vm"
  location              = azurerm_resource_group.k8s.location
  resource_group_name   = azurerm_resource_group.k8s.name
  network_interface_ids = [azurerm_network_interface.worker01.id]
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
    name              = "worker01vmosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb = "0"
  }


  os_profile {
    computer_name  = "worker01"
    admin_username = "abel"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/abel/.ssh/authorized_keys"
      key_data = file("${path.module}/files/key.pub")
    }
  }

tags = merge(var.tags, map ("TipoRecurso","Worker01"))

}

resource "null_resource" "worker01" {

  depends_on = ["azurerm_virtual_machine.worker01", "null_resource.master"]
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
"bash /tmp/playbooks/ansible.sh ${azurerm_network_interface.worker01.private_ip_address} worker01 worker" # ip / nodename /  tipo de nodo 
    ]

  }
}


