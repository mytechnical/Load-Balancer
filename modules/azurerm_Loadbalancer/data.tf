
data "azurerm_public_ip" "pip" {
  name                = var.public_IP_LB_Attached
  resource_group_name = var.resource_group_name
}
