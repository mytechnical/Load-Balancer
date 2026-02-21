resource "azurerm_application_gateway" "appgateway" {
  name                = var.application_gateway_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 6
  }

  gateway_ip_configuration {
    name      = var.app_gw_gateway_ip_configuration
    subnet_id = data.azurerm_subnet.appgwsubnet.id
  }

  frontend_port {
    name = var.appgetwayfrontenport
    port = 80
  }

  frontend_ip_configuration {
    name                 = var.appgw_frontend_ip_configuration_name
    public_ip_address_id = data.azurerm_public_ip.appgwpublicip.id
  }

  backend_address_pool {
    name = var.appgw_backend_address_pool_name
  }

  backend_http_settings {
    name                  = var.appgw_backend_http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = var.appgw_listener_name
    frontend_ip_configuration_name = var.appgw_frontend_ip_configuration_name
    frontend_port_name             = var.appgetwayfrontenport
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = var.appgw_request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         =var.appgw_listener_name
    backend_address_pool_name  = var.appgw_backend_address_pool_name
    backend_http_settings_name = var.appgw_backend_http_setting_name
  }

}




