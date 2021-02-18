# Variables

# Azure
variable "sp_subscription_id" {
    type = string
    description = "Service Principal subscription ID"
}

variable "sp_client_id" {
    type = string
    description = "Service Principal application ID"
}

variable "sp_client_secret" {
    type = string
    description = "Service Principal secret"
}

variable "sp_tenant_id" {
    type = string
    description = "Service Principal tenant ID"
}

variable "location" {
  type = string
  description = "Azure region"
  default = "northeurope"
}

variable "adminSrcAddr" {
    type = string
    description = "Trusted source network for access"
    default = "0.0.0.0/0"
}

variable "prefix" {
  type = string
  description = "Prefix for all created objects"
  default = "ag_demo_123"
}

# Network
variable "vnet_cidr" {
    type = string
    default = "172.24.0.0/16"
}

variable "subnet_01_address_prefix" {
    type = string
    default = "172.24.1.0/24"
}

# k8s
variable "linuxAdminUsername" {
    type = string
    description = "admin username for k8s nodes"
    default = "azureuser"
}

variable vm_1-name {default = "k8s-1"}

# Tags
variable purpose { default = "prototyping" }
variable environment { default = "f5group" } #ex. dev/staging/prod
variable owner { default = "f5owner" }
variable group { default = "f5group" }
variable costcenter { default = "f5costcenter" }
variable application { default = "f5app" }

