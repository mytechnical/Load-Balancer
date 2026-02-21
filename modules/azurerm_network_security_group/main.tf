data "azurerm_network_interface" "nic_id" {
  name                = var.nic_name_nsg
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nic2nsg_jod" {
  network_interface_id      = data.azurerm_network_interface.nic_id.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
