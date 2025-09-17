
resource "azurerm_lb" "lb_name" {
  name                = "hrsaheb-lb"
  location            = "centralindia"
  resource_group_name = "rg-jeet"

  frontend_ip_configuration {
    name                 = "NetflixPublicIPAddress"
    public_ip_address_id = data.azurerm_public_ip.ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "pool1" {
  name            = "lb-Backendaddresspool1"
  loadbalancer_id = azurerm_lb.lb_name.id
}


resource "azurerm_lb_probe" "probe" {
  name                = "Netflix-probe"
  loadbalancer_id     = azurerm_lb.lb_name.id
  protocol            = "Tcp"      # "Tcp" ya "Http" use kar sakte ho
  port                = 80         # VM ka service port (HTTP ke liye 80)
 
}

#Ip and Port based routing
resource "azurerm_lb_rule" "rule" {
  name                           = "NetflixRule"
  loadbalancer_id                = azurerm_lb.lb_name.id
  protocol                       = "Tcp"
  frontend_port                  = 80      # client se aane wala port
  backend_port                   = 80      # VM pe chalne wala port
  frontend_ip_configuration_name = "NetflixPublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.pool1.id]
  probe_id                       = azurerm_lb_probe.probe.id
}


