# Networking

# Create virtual net
resource "azurerm_virtual_network" "main" {
    name                = "${var.prefix}-network"
    address_space       = [var.vnet_cidr]
    resource_group_name = azurerm_resource_group.main.name
    location            = azurerm_resource_group.main.location

    tags = {
        purpose     = var.purpose
        environment = var.environment
        owner       = var.owner
        group       = var.group
        costcenter  = var.costcenter
        application = var.application
    }
}

# Create Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = azurerm_resource_group.main.name
  address_prefixes     = [var.subnet_address_prefix]

}

# Create Security group
resource "azurerm_network_security_group" "subnet" {
  name                = "${var.prefix}-subnet-nsg"
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

  security_rule {
    name                       = "allow_ingress_http"
    description                = "Allow ingress http access"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = var.adminSrcAddr
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_ingress_https"
    description                = "Allow ingress HTTPS access"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = var.adminSrcAddr
    destination_address_prefix = "*"
  }

  tags = {
    purpose     = var.purpose
    environment = var.environment
    owner       = var.owner
    group       = var.group
    costcenter  = var.costcenter
    application = var.application
  }
}

# Attach Security Group to Subnet
resource "azurerm_subnet_network_security_group_association" "subnet" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.subnet.id
}