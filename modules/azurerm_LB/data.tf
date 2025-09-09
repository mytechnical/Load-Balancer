data "azurerm_network_interface" "nic1" {
  name                = var.network_interface_name
  resource_group_name = var.resource_group_name
}

data "azurerm_network_interface" "nic2" {
  name                = var.network_interface_name
  resource_group_name = var.resource_group_name
}