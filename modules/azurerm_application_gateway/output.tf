output "backend_pool_id" {
  value = [for b in azurerm_application_gateway.appgateway.backend_address_pool : b.id][0]
}