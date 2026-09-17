# Hub Virtual Network
resource "azurerm_virtual_network" "hub" {
  name                = var.hub_vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.hub_address_space

  tags = {
    environment = "hub"
    managed_by  = "terraform"
  }
}

# Firewall Subnet — name is fixed by Azure, cannot be renamed
resource "azurerm_subnet" "firewall" {
  count                = var.deploy_firewall ? 1 : 0
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.firewall_subnet_prefix]
}

# Bastion Subnet — name is fixed by Azure, cannot be renamed
resource "azurerm_subnet" "bastion" {
  count                = var.deploy_bastion ? 1 : 0
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.bastion_subnet_prefix]
}

# Gateway Subnet — name is fixed by Azure, cannot be renamed
resource "azurerm_subnet" "gateway" {
  count                = var.deploy_vpn_gateway ? 1 : 0
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.gateway_subnet_prefix]
}

# Public IP for Firewall
resource "azurerm_public_ip" "firewall" {
  count               = var.deploy_firewall ? 1 : 0
  name                = "pip-fw-${var.hub_vnet_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "hub"
    managed_by  = "terraform"
  }
}

# Azure Firewall
resource "azurerm_firewall" "hub" {
  count               = var.deploy_firewall ? 1 : 0
  name                = "fw-${var.hub_vnet_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = azurerm_subnet.firewall[0].id
    public_ip_address_id = azurerm_public_ip.firewall[0].id
  }

  tags = {
    environment = "hub"
    managed_by  = "terraform"
  }
}

# Firewall Policy — spokes reference this to add rules
resource "azurerm_firewall_policy" "hub" {
  count               = var.deploy_firewall ? 1 : 0
  name                = "fwpolicy-${var.hub_vnet_name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = {
    environment = "hub"
    managed_by  = "terraform"
  }
}

# Public IP for Bastion
resource "azurerm_public_ip" "bastion" {
  count               = var.deploy_bastion ? 1 : 0
  name                = "pip-bastion-${var.hub_vnet_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "hub"
    managed_by  = "terraform"
  }
}

# Azure Bastion Host
resource "azurerm_bastion_host" "hub" {
  count               = var.deploy_bastion ? 1 : 0
  name                = "bastion-${var.hub_vnet_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Basic"

  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = azurerm_subnet.bastion[0].id
    public_ip_address_id = azurerm_public_ip.bastion[0].id
  }

  tags = {
    environment = "hub"
    managed_by  = "terraform"
  }
}