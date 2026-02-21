data "azurerm_network_interface" "nic" {
  name                = var.nic_name
  resource_group_name = var.resource_group_name
}


# Backend Pool appgw Associations with NIC 
resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "appgwvmassociation" {
  network_interface_id    = data.azurerm_network_interface.nic.id
  ip_configuration_name   = var.ip_configuration_name
  backend_address_pool_id = var.backend_pool_id
}



