variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "virtual_network_name" {
  type = string
}
variable "address_space" {
  type = list(string)
}
variable "Frontend_vm_subnet_name" {
  type = string
}
variable "Frontend_address_prefix" {
  type = list(string)
}

# variable "Backend_vm_subnet_name" {
#   type = string
# }
# variable "Backend_address_prefix" {
#   type = list(string)
# }

variable "Frontend_vm1" {
  type=string
}
variable "vm_size" {}
variable "image_publisher" {}
variable "image_offer" {}
variable "image_sku" {}
variable "image_version" {}
variable "starbuck1_nic_name" {}
variable "Frontend_vm2" {}
variable "starbuck2_nic_name" {}
variable "bastion_pip" {}
variable "LB_pip" {}
variable "Bastion_vm_subnet_name"{}
variable "Bastion_address_prefix"{}
variable "Bastion_name" {}
variable "LoadBalancer_name" { } 
variable "frontend_ip_configuration_name" {}
variable "backendpoolname" {}
variable "lb_probe" {}
variable "lb_rule" {}
variable "backend_address_pool" {}
variable "frontend_nsg_first" {}
variable "frontend_nsg_second" {}

###App gateway resource networking part ######
variable "app_gateway_subnet_name" {}
variable "app_gateway_address_prefix" {}
variable "app_gateway_pip" {}

#### AB main application k resources ######
variable "application_gateway_name" {}
variable "app_gw_gateway_ip_configuration" {}
variable "appgatwaysubnet" {}
variable "appgetwayfrontenport" {}
variable "appgw_frontend_ip_configuration_name" {}
variable "appgatwaypublicip" {}
variable "appgw_backend_address_pool_name" {}
variable "appgw_backend_http_setting_name"{}
variable "appgw_listener_name" {}
variable "appgw_request_routing_rule_name" {}


  


  


  

  

  



  

  



  


