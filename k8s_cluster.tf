#k8s cluster

### k8s nodes

resource "azurerm_linux_virtual_machine" "node" {
    count                   = var.vm_count
    name                    = "${var.prefix}-${var.vm_name}-${count.index}"
    location                = var.location
    resource_group_name     = azurerm_resource_group.main.name
    network_interface_ids   = [azurerm_network_interface.node_nic[count.index].id]
    size                    = var.vm_size

    os_disk {
        caching           = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "${var.vm_name}-${count.index}"
    admin_username = var.vm_admin
    disable_password_authentication = true

    #custom_data = data.cloudinit_config.config.rendered
    custom_data = base64encode(data.template_file.cloudconfig.rendered)

    admin_ssh_key {
        username       = var.vm_admin
        public_key     = file("~/.ssh/id_rsa.pub")
    }

    tags = {
        name = "Server ${var.vm_name}-${count.index}"
        purpose     = var.purpose
        environment = var.environment
        owner       = var.owner
        group       = var.group
        costcenter  = var.costcenter
        application = var.application
    }
}

#Cloud-init
# data "cloudinit_config" "config" {
#   gzip          = true
#   base64_encode = true

#   vars = {
#       username = var.vm_admin
#   }

#   # Main cloud-config configuration file.
#   part {
#     content_type = "text/cloud-config"
#     content      = file("${path.module}/scripts/node_cloudinit.yaml")
#   }
# }

data "template_file" "cloudconfig" {
    template = file("${path.module}/scripts/node_cloudinit.yaml")

    vars = {
      username = var.vm_admin
  }
}

resource "azurerm_public_ip" "node_public_ip" {
    count               = var.vm_count
    name                = "${var.prefix}-node_public_ip-${count.index}"
    location            = var.location
    resource_group_name = azurerm_resource_group.main.name
    allocation_method   = "Dynamic"

    tags = {
        purpose     = var.purpose
        environment = var.environment
        owner       = var.owner
        group       = var.group
        costcenter  = var.costcenter
        application = var.application
    }
}

resource "azurerm_network_interface" "node_nic" {
    count               = var.vm_count
    name                = "${var.prefix}-node_nic-${count.index}"
    location            = var.location
    resource_group_name = azurerm_resource_group.main.name

    ip_configuration {
        name = "node_nic_conf-${count.index}"
        subnet_id = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.node_public_ip[count.index].id

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

resource "azurerm_network_interface_security_group_association" "node_sga" {
    count = var.vm_count
    network_interface_id = azurerm_network_interface.node_nic[count.index].id
    network_security_group_id = azurerm_network_security_group.subnet.id
}