# Networking

# Create virtual net
resource "azurerm_virtual_network" "main" {
    name                = "${var.prefix}-network"
    address_space       = [var.vnet_cidr]
    resource_group_name = azurerm_resource_group.main.name
    location            = azurerm_resource_group.main.location
}

# Create  Subnet
resource "azurerm_subnet" "subnet_01" {
  name                 = "subnet_01"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = azurerm_resource_group.main.name
  address_prefixes     = [var.subnet_01_address_prefix]
}

resource "azurerm_network_security_group" "subnet_01" {
  name                = "${var.prefix}-subnet_01-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "allow_SSH"
    description                = "Allow SSH access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.adminSrcAddr
    destination_address_prefix = "*"
  }

#   security_rule {
#     name                       = "allow_HTTPS"
#     description                = "Allow HTTPS access"
#     priority                   = 120
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = var.adminSrcAddr
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "allow_APP_HTTPS"
#     description                = "Allow HTTPS access"
#     priority                   = 130
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "8443"
#     source_address_prefix      = var.adminSrcAddr
#     destination_address_prefix = "*"
#   }

  tags = {
    Name        = "${var.environment}-subnet_01-nsg"
    environment = var.environment
    owner       = var.owner
    group       = var.group
    costcenter  = var.costcenter
    application = var.application
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_01" {
  subnet_id                 = azurerm_subnet.subnet_01.id
  network_security_group_id = azurerm_network_security_group.subnet_01.id
}