
resource "azurerm_lb" "LB" {
  name                = var.LoadBalancer_name
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = var.frontend_ip_LB_configuration
    public_ip_address_id = data.azurerm_public_ip.pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "poolsefrontednvmattached" {  #jo backedn mai vm ha LB k frontend vm wo attahced hogi
  name            = var.backendpoolname
  loadbalancer_id = azurerm_lb.LB.id
}

resource "azurerm_lb_probe" "probe" {
  name                = var.lb_probe
  loadbalancer_id     = azurerm_lb.LB.id
  protocol            = "Tcp"      # "Tcp" ya "Http" use kar sakte ho
  port                = 80         # VM ka service port (HTTP ke liye 80)
}

#Ip and Port based routing
resource "azurerm_lb_rule" "rule" {
  name                           = var.lb_rule
  loadbalancer_id                = azurerm_lb.LB.id
  protocol                       = "Tcp"
  frontend_port                  = 80      # client se aane wala port
  backend_port                   = 80      # VM pe chalne wala port
  frontend_ip_configuration_name = var.frontend_ip_LB_configuration
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.poolsefrontednvmattached.id]
  probe_id                       = azurerm_lb_probe.probe.id
}



