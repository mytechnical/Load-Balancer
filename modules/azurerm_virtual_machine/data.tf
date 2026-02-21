data "azurerm_subnet" "subnet" {
  name                 = var.subnet
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

