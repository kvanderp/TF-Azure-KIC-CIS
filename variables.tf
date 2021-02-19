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
}

# Network
variable "vnet_cidr" {
    type = string
    default = "172.24.0.0/16"
}
variable "subnet_address_prefix" {
    type = string
    default = "172.24.1.0/24"
}

# VM conf
variable "vm_admin" {
    type = string
    description = "admin username for k8s nodes"
    default = "azureadmin"
}
variable "vm_name" { default = "k8s"}
variable "vm_count" { default = 1 }
variable "vm_size" { default = "Standard_DS1_v2"}

# Tags
variable purpose { default = "f5purpose" }
variable environment { default = "f5env" } #ex. dev/staging/prod
variable owner { default = "f5owner" }
variable group { default = "f5group" }
variable costcenter { default = "f5costcenter" }
variable application { default = "f5application" }

