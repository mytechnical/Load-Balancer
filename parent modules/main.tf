module "resource_group" {
  source                  = "../modules/azurerm_resource_group"
  resource_group_name     = "rg-jeet"
  resource_group_location = "centralindia"
}

module "virtual_network" {
  depends_on               = [module.resource_group]
  source                   = "../modules/azurerm_virtual_network"
  virtual_network_name     = "vnet-LB"
  virtual_network_location = "centralindia"
  resource_group_name      = "rg-jeet"
  address_space            = ["10.0.0.0/16"]
}


module "bastion_subnet" {
  depends_on = [module.virtual_network]
  source     = "../modules/azurerm_subnet"

  resource_group_name  = "rg-jeet"
  virtual_network_name = "vnet-LB"
  subnet_name          = "AzureBastionSubnet"
  address_prefixes     = ["10.0.2.0/24"]
}

module "public_ip_bastion" {
  source              = "../modules/azurerm_public_ip_lb"
  public_ip_name      = "bastion_ip"
  resource_group_name = "rg-jeet"
  location            = "centralindia"
  allocation_method   = "Static"
}

module "bastion" {
  source       = "../modules/azurerm_bastion"
  depends_on   = [module.bastion_subnet, module.public_ip_bastion]
  subnet_name  = "AzureBastionSubnet"
  vnet_name    = "vnet-LB"
  rg_name      = "rg-jeet"
  pip_name     = "bastion_ip"
  bastion_name = "vnet-lb-bastion"
  location     = "centralindia"
}

module "backend_subnet" {
  depends_on           = [module.resource_group,module.virtual_network]
  source               = "../modules/azurerm_subnet"
  resource_group_name  = "rg-jeet"
  virtual_network_name = "vnet-LB"
  subnet_name          = "backend-subnet"
  address_prefixes     = ["10.0.1.0/24"]
}


module "chinki_vm" {
  depends_on = [module.resource_group, module.virtual_network,module.backend_subnet]
  source     = "../modules/azurerm_virtual_machine"

  resource_group_name = "rg-jeet"
  location            = "centralindia"
  vm_name             = "chinki-vm"
  vm_size             = "Standard_B1s"
  image_publisher     = "Canonical"
  image_offer         = "0001-com-ubuntu-server-focal"
  image_sku           = "20_04-lts"
  image_version       = "latest"
  nic_name            = "nic-chinki-vm"
  vnet_name           = "vnet-LB"
  backend_subnet_name = "backend-subnet"
  admin_username      = "devopsadmin"
  admin_password      = "welcome@123"
}

module "pinki_vm" {
  depends_on          = [module.resource_group, module.virtual_network,module.backend_subnet]
  source              = "../modules/azurerm_virtual_machine"
  resource_group_name = "rg-jeet"
  location            = "centralindia"
  vm_name             = "pinki-vm"
  vm_size             = "Standard_B1s"
  image_publisher     = "Canonical"
  image_offer         = "0001-com-ubuntu-server-focal"
  image_sku           = "20_04-lts"
  image_version       = "latest"
  nic_name            = "nic-pinki-vm"
  vnet_name           = "vnet-LB"
  backend_subnet_name = "backend-subnet"
  admin_username      = "devopsadmin"
  admin_password      = "welcome@123"
}

#### LB Configuration #####

module "public_ip_lb" {
  depends_on          = [module.resource_group]
  source              = "../modules/azurerm_public_ip_lb"
  public_ip_name      = "loadbalancer_ip"
  resource_group_name = "rg-jeet"
  location            = "centralindia"
  allocation_method   = "Static"
}

# LB, frontend_ip_configuration,backend address pool, rule
module "lb" {
  depends_on = [module.resource_group,module.public_ip_lb]
  source     = "../modules/azurerm_Loadbalancer"

}
module "chinki2lb_jod_yojna" {
depends_on = [ module.resource_group,module.chinki_vm ]
  source                = "../modules/azurerm_nic_lb_association"
  nic_name              = "nic-chinki-vm"
  resource_group_name   = "rg-jeet"
  bap_name              = "lb-backendpool1"
  lb_name               = "hrsaheb-lb"
  ip_configuration_name = "internal"
}

module "pinki2lb_jod_yojna" {
  depends_on = [ module.resource_group,module.pinki_vm ]
  source                = "../modules/azurerm_nic_lb_association"
  nic_name              = "nic-pinki-vm"
  resource_group_name   = "rg-jeet"
  bap_name              = "lb-backendpool1"
  lb_name               = "hrsaheb-lb"
  ip_configuration_name = "internal"
}




