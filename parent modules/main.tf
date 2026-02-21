module "resource_group" {
  source                  = "../modules/azurerm_resource_group"
  resource_group_name     = var.resource_group_name
  resource_group_location = var.location
}

module "virtual_network" {
  depends_on               = [module.resource_group]
  source                   = "../modules/azurerm_virtual_network"
  virtual_network_name     = var.virtual_network_name
  virtual_network_location = var.location
  resource_group_name      = var.resource_group_name
  address_space            = var.address_space
}

module "FrontedVM_subnet" {
  depends_on           = [module.virtual_network, module.resource_group]
  source               = "../modules/azurerm_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  subnet_name          = var.Frontend_vm_subnet_name
  address_prefixes     = var.Frontend_address_prefix
}

module "Bastion_subnet_subnet" {
  depends_on           = [module.virtual_network, module.resource_group]
  source               = "../modules/azurerm_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  subnet_name          = var.Bastion_vm_subnet_name
  address_prefixes     = var.Bastion_address_prefix
}

module "Application_gateway_subnet" {
  depends_on           = [module.virtual_network, module.resource_group]
  source               = "../modules/azurerm_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  subnet_name          = var.app_gateway_subnet_name
  address_prefixes     = var.app_gateway_address_prefix
}


module "Frontend_vm1" {
  depends_on          = [module.resource_group, module.virtual_network, module.FrontedVM_subnet]
  source              = "../modules/azurerm_virtual_machine"
  resource_group_name = var.resource_group_name
  location            = var.location
  vm_name             = var.Frontend_vm1
  vm_size             = var.vm_size
  image_publisher     = var.image_publisher
  image_offer         = var.image_offer
  image_sku           = var.image_sku
  image_version       = var.image_version
  nic_name            = var.starbuck1_nic_name
  vnet_name           = var.virtual_network_name
  subnet              = var.Frontend_vm_subnet_name
  admin_username      = "devopsadmin"
  admin_password      = "welcome@123"
}

module "Frontend_vm2" {
  depends_on          = [module.resource_group, module.virtual_network, module.FrontedVM_subnet]
  source              = "../modules/azurerm_virtual_machine"
  resource_group_name = var.resource_group_name
  location            = var.location
  vm_name             = var.Frontend_vm2
  vm_size             = var.vm_size
  image_publisher     = var.image_publisher
  image_offer         = var.image_offer
  image_sku           = var.image_sku
  image_version       = var.image_version
  nic_name            = var.starbuck2_nic_name
  vnet_name           = var.virtual_network_name
  subnet              = var.Frontend_vm_subnet_name
  admin_username      = "devopsadmin"
  admin_password      = "welcome@123"
}

module "public_ip_bastion" {
  depends_on          = [module.resource_group]
  source              = "../modules/azurerm_public_ips"
  public_ip_name      = var.bastion_pip
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

module "public_ip_load_balancer" {
  depends_on          = [module.resource_group]
  source              = "../modules/azurerm_public_ips"
  public_ip_name      = var.LB_pip
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

module "public_ip_app_gateway" {
  depends_on          = [module.resource_group]
  source              = "../modules/azurerm_public_ips"
  public_ip_name      = var.app_gateway_pip
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}


module "bastion" {
  depends_on   = [module.resource_group, module.virtual_network, module.public_ip_bastion]
  source       = "../modules/azurerm_bastion"
  subnet_name  = var.Bastion_vm_subnet_name
  vnet_name    = var.virtual_network_name
  rg_name      = var.resource_group_name
  pip_name     = var.bastion_pip
  bastion_name = var.Bastion_name
  location     = var.location
}

# #### LB Configuration #####
module "loadbalancer" {
  depends_on                   = [module.resource_group, module.public_ip_load_balancer]
  source                       = "../modules/azurerm_Loadbalancer"
  LoadBalancer_name            = var.LoadBalancer_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  frontend_ip_LB_configuration = var.frontend_ip_configuration_name
  public_IP_LB_Attached        = var.LB_pip
  backendpoolname              = var.backendpoolname
  lb_probe                     = var.lb_probe
  lb_rule                      = var.lb_rule
}

module "Frontendvm1toLbjod" {
  depends_on            = [module.resource_group, module.Frontend_vm1]
  source                = "../modules/azurerm_nic_lb_association"
  nic_name              = var.starbuck1_nic_name
  resource_group_name   = var.resource_group_name
  backend_address_pool  = var.backend_address_pool
  lb_name               = var.LoadBalancer_name
  ip_configuration_name = "internal"
}

module "Frontendvm2toLbjod" {
  depends_on            = [module.resource_group, module.Frontend_vm2]
  source                = "../modules/azurerm_nic_lb_association"
  nic_name              = var.starbuck2_nic_name
  resource_group_name   = var.resource_group_name
  backend_address_pool  = var.backend_address_pool
  lb_name               = var.LoadBalancer_name
  ip_configuration_name = "internal"
}

module "nic_appgw_assoc_first_vm" {
  source                = "../modules/azurerm_nic_appgw_association"
  depends_on            = [module.resource_group, module.Frontend_vm1,module.application_gateway]
  resource_group_name   = var.resource_group_name
  nic_name              = var.starbuck1_nic_name
  backend_pool_id       = module.application_gateway.backend_pool_id
  ip_configuration_name = "internal"
}

module "nic_appgw_assoc_second_vm" {
  source                = "../modules/azurerm_nic_appgw_association"
  depends_on            = [module.resource_group, module.Frontend_vm2,module.application_gateway]
  resource_group_name   = var.resource_group_name
  nic_name              = var.starbuck2_nic_name
  backend_pool_id       = module.application_gateway.backend_pool_id
  ip_configuration_name = "internal"
}


module "network_security_group_frontendvm1" {
  depends_on          = [module.resource_group, module.Frontend_vm1]
  source              = "../modules/azurerm_network_security_group"
  nsg_name            = var.frontend_nsg_first
  resource_group_name = var.resource_group_name
  location            = var.location
  nic_name_nsg        = var.starbuck1_nic_name
}

module "network_security_group_frontendvm2" {
  depends_on          = [module.resource_group, module.Frontend_vm2]
  source              = "../modules/azurerm_network_security_group"
  nsg_name            = var.frontend_nsg_second
  resource_group_name = var.resource_group_name
  location            = var.location
  nic_name_nsg        = var.starbuck2_nic_name
}

module "application_gateway" {
  source                               = "../modules/azurerm_application_gateway"
  depends_on                           = [module.resource_group, module.virtual_network, module.Application_gateway_subnet, module.public_ip_app_gateway]
  application_gateway_name             = var.application_gateway_name
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  virtual_network_name                 = var.virtual_network_name
  app_gw_gateway_ip_configuration      = var.app_gw_gateway_ip_configuration
  appgatwaysubnet                      = var.appgatwaysubnet
  appgetwayfrontenport                 = var.appgetwayfrontenport
  appgw_frontend_ip_configuration_name = var.appgw_frontend_ip_configuration_name
  appgatwaypublicip                    = var.appgatwaypublicip
  appgw_backend_address_pool_name      = var.appgw_backend_address_pool_name
  appgw_backend_http_setting_name      = var.appgw_backend_http_setting_name
  appgw_listener_name                  = var.appgw_listener_name
  appgw_request_routing_rule_name      = var.appgw_request_routing_rule_name
}

###bhai appgw k backedn mai VMS bhi too attached kerna hoga na 

#Extra:
####################@@@@@@@@@@@@@###########
# module "backend_subnet" {
#   depends_on           = [module.resource_group, module.virtual_network]
#   source               = "../modules/azurerm_subnet"
#   resource_group_name  = "rg-jeet"
#   virtual_network_name = "vnet-LB"
#   subnet_name          = "backend-subnet"
#   address_prefixes     = ["10.0.1.0/24"]
# }


# module "BackendVM_subnet" {
#   depends_on           = [module.virtual_network, module.resource_group]
#   source               = "../modules/azurerm_subnet"
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = var.virtual_network_name
#   subnet_name          = var.Backend_vm_subnet_name
#   address_prefixes     = var.Backend_address_prefix
# }
