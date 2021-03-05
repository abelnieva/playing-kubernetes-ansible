resource "azurerm_virtual_machine" "nfs" {
  name                  = "nfsvm"
  location              = azurerm_resource_group.k8s.location
  resource_group_name   = azurerm_resource_group.k8s.name
  network_interface_ids = [azurerm_network_interface.nfs.id]
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
    name              = "nfsvmosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"

  }

  storage_data_disk {
    name            = azurerm_managed_disk.nfs.name
    managed_disk_id = azurerm_managed_disk.nfs.id
    create_option   = "Attach"
    lun             = 0
    disk_size_gb    = azurerm_managed_disk.nfs.disk_size_gb
  }

  os_profile {
    computer_name  = "nfs"
    admin_username = "abel"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/abel/.ssh/authorized_keys"
      key_data = file("${path.module}/files/key.pub")
    }
  }

tags = merge(var.tags, map ("TipoRecurso","NFS"))
}

resource "null_resource" "nfs" {

  depends_on = ["azurerm_virtual_machine.nfs"]
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
"bash /tmp/playbooks/ansible.sh ${azurerm_network_interface.nfs.private_ip_address} nfs nfs" # ip / nodename /  tipo de nodo 
    ]

  }
}


