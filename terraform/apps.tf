resource "null_resource" "apps" {

  depends_on = ["azurerm_virtual_machine.worker01", "null_resource.master", "null_resource.worker01", "null_resource.worker02"]
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
"bash /tmp/playbooks/apps.sh ${azurerm_network_interface.k8s.private_ip_address} apps apps" # ip / nodename /  tipo de nodo 
    ]

  }
}