variable "nic_name" {
  type        = string
}
variable "location" {
  description = "The Azure region where the virtual machine will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual machine."
  type        = string
}

variable "backend_subnet_name" {
  description = "Frontend Wale Subnet ka naam"
  type        = string
}

variable "vnet_name" {
  description = "Vnet ka naam"
  type        = string
}
variable "vm_name" {
  description = "The name of the virtual machine."
  type        = string
}
variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
}
variable "image_publisher" {
  description = "The publisher of the image to use for the virtual machine."
  type        = string
}

variable "image_offer" {
  description = "The offer of the image to use for the virtual machine."
  type        = string
}

variable "image_sku" {
  description = "The SKU of the image to use for the virtual machine."
  type        = string
}

variable "image_version" {
  description = "The version of the image to use for the virtual machine."
  type        = string
}

variable "admin_username" {
    type=string
}
variable "admin_password" {
    type = string
}


