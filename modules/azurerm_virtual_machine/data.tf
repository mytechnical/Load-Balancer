
data "azurerm_subnet" "backend_subnet" {
  name                 = var.backendpool_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

