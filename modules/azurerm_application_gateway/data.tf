data "azurerm_subnet" "appgwsubnet" {
  name                 = var.appgatwaysubnet
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_public_ip" "appgwpublicip" {
  name                = var.appgatwaypublicip
  resource_group_name = var.resource_group_name
}


