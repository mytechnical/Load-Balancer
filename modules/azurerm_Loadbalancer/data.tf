
data "azurerm_public_ip" "ip" {
  name                = "loadbalancer_ip"
  resource_group_name = "rg-jeet"
}
