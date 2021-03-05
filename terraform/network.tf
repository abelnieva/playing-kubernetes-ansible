resource "azurerm_virtual_network" "k8s" {
  name                = "k8s-network"
  address_space       = ["192.168.2.0/24"]
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
}

resource "azurerm_subnet" "k8s" {
  name                 = "k8s"
  resource_group_name  = azurerm_resource_group.k8s.name
  virtual_network_name = azurerm_virtual_network.k8s.name
  address_prefixes       = ["192.168.2.0/24"]
}

resource "azurerm_network_interface" "k8s" {
  name                = "k8sif-master"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name

  ip_configuration {
    name                          = "k8sconfiguration1"
    subnet_id                     = azurerm_subnet.k8s.id
    private_ip_address_allocation = "Static"
    private_ip_address = "192.168.2.110"
  }
}

resource "azurerm_network_interface" "nfs" {
  name                = "k8network-nfs"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name

  ip_configuration {
    name                          = "k8sconfiguration1"
    subnet_id                     = azurerm_subnet.k8s.id
    private_ip_address_allocation = "Static"
    private_ip_address = "192.168.2.115"
  }
}

resource "azurerm_network_interface" "worker01" {
  name                = "k8network-worker01"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name

  ip_configuration {
    name                          = "k8sconfiguration1"
    subnet_id                     = azurerm_subnet.k8s.id
    private_ip_address_allocation = "Static"
    private_ip_address = "192.168.2.111"
  }
}

resource "azurerm_network_interface" "worker02" {
  name                = "k8network-worker02"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name

  ip_configuration {
    name                          = "k8sconfiguration1"
    subnet_id                     = azurerm_subnet.k8s.id
    private_ip_address_allocation = "Static"
    private_ip_address = "192.168.2.112"
  }
}