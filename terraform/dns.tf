# ==========================================
# Enterprise Private DNS Zones (Hub)
# ==========================================

variable "private_dns_zones" {
  type        = list(string)
  description = "List of Private DNS Zones to create in the Hub"
  default = [
    "privatelink.blob.core.windows.net",
    "privatelink.database.windows.net",
    "privatelink.vaultcore.azure.net",
    "privatelink.azurecr.io"
  ]
}

resource "azurerm_private_dns_zone" "enterprise_zones" {
  for_each            = toset(var.private_dns_zones)
  name                = each.key
  resource_group_name = azurerm_resource_group.rg.name

  tags = var.tags

  # DINE Bypass: Prevents Azure Policy from overriding Terraform State
  lifecycle {
    ignore_changes = [
      tags["hidden-title"],
      tags["CreatedByPolicy"]
    ]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub_links" {
  for_each              = azurerm_private_dns_zone.enterprise_zones
  name                  = "link-to-hub-${each.value.name}"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = each.value.name
  virtual_network_id    = azurerm_virtual_network.hub.id

  # Ensure the link doesn't get destroyed if policy enforces it
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
