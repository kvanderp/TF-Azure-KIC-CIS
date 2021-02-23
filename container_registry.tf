# Container Registry

# resource "azurerm_container_registry" "acr" {
#     name                = lower(replace("${var.prefix}-ContainerRegistry", "-", ""))
#     resource_group_name = azurerm_resource_group.main.name
#     location            = var.location
#     sku                 = "Basic"
#     admin_enabled       = true
# }
