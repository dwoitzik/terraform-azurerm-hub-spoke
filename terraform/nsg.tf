# ==========================================
# Zero-Trust Network Security Group (NSG)
# ==========================================

resource "azurerm_network_security_group" "zero_trust" {
  name                = "nsg-zero-trust-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  security_rule {
    name                       = "Allow-VNet-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Deny-Internet-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

# ==========================================
# Subnets & NSG Associations
# ==========================================


resource "azurerm_subnet" "spoke1_default" {
  name                 = "snet-default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke1.name
  address_prefixes     = var.spoke1_subnet_cidr
}


resource "azurerm_subnet" "spoke2_default" {
  name                 = "snet-default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke2.name
  address_prefixes     = var.spoke2_subnet_cidr
}


resource "azurerm_subnet_network_security_group_association" "spoke1_nsg_bind" {
  subnet_id                 = azurerm_subnet.spoke1_default.id
  network_security_group_id = azurerm_network_security_group.zero_trust.id
}


resource "azurerm_subnet_network_security_group_association" "spoke2_nsg_bind" {
  subnet_id                 = azurerm_subnet.spoke2_default.id
  network_security_group_id = azurerm_network_security_group.zero_trust.id

}
