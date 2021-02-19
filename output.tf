data "azurerm_public_ip" "public_ip" {
  count = var.vm_count
  name = azurerm_public_ip.node_public_ip[count.index].name
  resource_group_name = azurerm_resource_group.main.name
  depends_on = [ azurerm_public_ip.node_public_ip, azurerm_linux_virtual_machine.node ]
}

output "instance-pub-ip" {
    value = formatlist("%s: %s", azurerm_linux_virtual_machine.node.*.name, data.azurerm_public_ip.public_ip.*.ip_address) 
}

output "test" {
    value = data.template_file.cloudconfig.rendered
}