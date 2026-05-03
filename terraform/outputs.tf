output "hub_vnet_id" {
  description = "The ID of the Hub Virtual Network"
  value       = azurerm_virtual_network.hub.id
}

output "spoke1_vnet_id" {
  description = "The ID of the Spoke 1 Virtual Network"
  value       = azurerm_virtual_network.spoke1.id
}

output "spoke2_vnet_id" {
  description = "The ID of the Spoke 2 Virtual Network"
  value       = azurerm_virtual_network.spoke2.id
}