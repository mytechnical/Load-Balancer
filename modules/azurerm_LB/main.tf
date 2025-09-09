resource "azurerm_public_ip" "example" {
  name                = var.publicIPLB
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

# LB creation with frontend IP attached
resource "azurerm_lb" "example" {
  name                = var.Loadbalancername
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = var.frontend_ip_LB
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

resource "azurerm_lb_backend_address_pool" "example" {
  name            = var.backendpooladrress
  loadbalancer_id = azurerm_lb.example.id
}

# Backend Pool Associations with NIC 
resource "azurerm_network_interface_backend_address_pool_association" "nic_vm1_assoc" {
  network_interface_id    = data.azurerm_network_interface.nic1.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_vm2_assoc" {
  network_interface_id    = data.azurerm_network_interface.nic2.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
}

resource "azurerm_lb_probe" "example" {
  name                = var.probe_name
  loadbalancer_id     = azurerm_lb.example.id
  protocol            = "Tcp"      # "Tcp" ya "Http" use kar sakte ho
  port                = 80         # VM ka service port (HTTP ke liye 80)
  interval_in_seconds = 5          # probe check interval
  number_of_probes    = 2          # fail hone par unhealthy mark karne ke liye
}

resource "azurerm_lb_rule" "example" {
  name                           = var.LB-rule
  loadbalancer_id                = azurerm_lb.example.id
  protocol                       = "Tcp"
  frontend_port                  = 80      # client se aane wala port
  backend_port                   = 80      # VM pe chalne wala port
  frontend_ip_configuration_name = var.frontend_ip_LB
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.example.id]
  probe_id                       = azurerm_lb_probe.example.id
}



