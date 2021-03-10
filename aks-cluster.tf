resource "azurerm_kubernetes_cluster" "aks-cluster" {
    name = "${var.prefix}-aks"
    location = var.location
    resource_group_name = azurerm_resource_group.main.name
    dns_prefix = "${var.prefix}-k8s"

    default_node_pool {
      name  = "nodepool"
      node_count = 2
      vm_size =  var.vm_size
      os_disk_size_gb = 30
    }

    identity {
      type = "SystemAssigned"
    }

}