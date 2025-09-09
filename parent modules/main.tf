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

module "backend_subnet" {
  depends_on           = [module.virtual_network]
  source               = "../modules/azurerm_subnet"
  resource_group_name  = "rg-jeet"
  virtual_network_name = "vnet-LB"
  subnet_name          = "backend-subnet"
  address_prefixes     = ["10.0.1.0/24"]
}

module "backendpoolvm1" {
  depends_on = [module.backend_subnet, module.backend_subnet, module.resource_group]
  source     = "../modules/azurerm_virtual_machine"

  resource_group_name     = "rg-jeet"
  location                = "centralindia"
  vm_name                 = "backednpool-vm1"
  vm_size                 = "Standard_B1s"
  image_publisher         = "Canonical"
  image_offer             = "0001-com-ubuntu-server-focal"
  image_sku               = "20_04-lts"
  image_version           = "latest"
  nic_name                = "nic-vm1"
  backendpool_ip_name     = "pip-todoapp-backend1"
  vnet_name               = "vnet-LB"
  backendpool_subnet_name = "backend-subnet"
  admin_username          = "devopsadmin"
  admin_password          = "welcome@123"
}

module "backendpoolvm2" {
  depends_on              = [module.backend_subnet]
  source                  = "../modules/azurerm_virtual_machine"
  resource_group_name     = "rg-jeet"
  location                = "centralindia"
  vm_name                 = "backednpool-vm2"
  vm_size                 = "Standard_B1s"
  image_publisher         = "Canonical"
  image_offer             = "0001-com-ubuntu-server-focal"
  image_sku               = "20_04-lts"
  image_version           = "latest"
  nic_name                = "nic-vm2"
  backendpool_ip_name     = "pip-todoapp-backend2"
  vnet_name               = "vnet-LB"
  backendpool_subnet_name = "backend-subnet"
  admin_username          = "devopsadmin"
  admin_password          = "welcome@123"
}

module "TestLoadBalancer" {
  depends_on          = [module.resource_group, module.virtual_network, module.backendpoolvm1, module.backendpoolvm2]
  source              = "../modules/azurerm_LB"
  Loadbalancername    = "test-LB"
  publicIPLB          = "testpublicip"
  frontend_ip_LB      = "publicLBIP"
  resource_group_name = "rg-jeet"
  location            = "centralindia"
  backendpooladrress  = "backendpool"
  probe_name          = "Http-probe"
  LB-rule             = "helath-rule"
  vm1nic              = "backend-nic-1"
  vm2nic              = "backend-nic-2"
}




