provider "azurerm" {
  version = "~> 2.0"
  features {}
}

resource "azurerm_resource_group" "k8s" {
  name     = "kubernetes-cluster"
  location = "WestUS2"
}