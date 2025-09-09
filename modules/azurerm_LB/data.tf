data "azurerm_network_interface" "nic1" {
  name                = var.vm1nic
  resource_group_name = var.resource_group_name
}

data "azurerm_network_interface" "nic2" {
  name                = var.vm2nic
  resource_group_name = var.resource_group_name
}