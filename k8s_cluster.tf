#k8s cluster

### k8s_1

resource "azurerm_linux_virtual_machine" "k8s_1" {
    name                  = var.vm_1-name
    location              = var.location
    resource_group_name   = azurerm_resource_group.main.name
    network_interface_ids = [azurerm_network_interface.k8s_1-nic.id]
    size                  = "Standard_DS1_v2"

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

    computer_name  = var.vm_1-name
    admin_username = var.linuxAdminUsername
    disable_password_authentication = true

    custom_data = data.template_cloudinit_config.config.rendered

    admin_ssh_key {
        username       = var.linuxAdminUsername
        public_key     = file("~/.ssh/id_rsa.pub")
    }

    tags = {
        environment = var.environment
    }
}

#Cloud-init
data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    content_type = "text/cloud-config"
    content      = "packages: ['snap']"
  }

  part {
    content_type    = "text/x-shellscript"
    content         = "sudo snap install microk8s"     
  } 
}

resource "azurerm_public_ip" "k8s_1-pub-ip" {
    name = "k8s_1-pub-ip"
    location = var.location
    resource_group_name = azurerm_resource_group.main.name
    allocation_method = "Dynamic"
}

resource "azurerm_network_interface" "k8s_1-nic" {
    name = "k8s_1-nic"
    location = var.location
    resource_group_name = azurerm_resource_group.main.name

    ip_configuration {
        name = "k8s_1-nic-conf"
        subnet_id = azurerm_subnet.subnet_01.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.k8s_1-pub-ip.id

    }

}

resource "azurerm_network_interface_security_group_association" "k8s_1-sga" {
    network_interface_id = azurerm_network_interface.k8s_1-nic.id
    network_security_group_id = azurerm_network_security_group.subnet_01.id
}