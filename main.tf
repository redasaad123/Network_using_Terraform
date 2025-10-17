provider "azurerm" {
  features {}

  client_id = var.client_id
  client_secret = var.client_secret
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id

  
}



# resource "azurerm_virtual_network" "VNet" {
#   name                = "VNet"
#   address_space       = ["192.168.0.0/16"]
#   location            = azurerm_resource_group.NetGroup.location
#   resource_group_name = azurerm_resource_group.NetGroup.name
# }
# resource "azurerm_subnet" "Jump-subnet" {
#   name                 = "Jump-subnet"
#   resource_group_name  = azurerm_resource_group.NetGroup.name
#   virtual_network_name = azurerm_virtual_network.VNet.name
#   address_prefixes     = ["192.168.3.0/24"]
# }

# resource "azurerm_subnet" "NatGateway-subnet" {
#   name                 = "NatGateway-subnet"
#   resource_group_name  = azurerm_resource_group.NetGroup.name
#   virtual_network_name = azurerm_virtual_network.VNet.name
#   address_prefixes     = ["192.168.4.0/24"]
# }


# resource "azurerm_subnet" "web-subnet-1" {
#   name                 = "web-subnet-1"
#   resource_group_name  = azurerm_resource_group.NetGroup.name
#   virtual_network_name = azurerm_virtual_network.VNet.name
#   address_prefixes     = ["192.168.1.0/24"]
# }

# resource "azurerm_subnet" "web-subnet-2" {
#   name                 = "web-subnet-2"
#   resource_group_name  = azurerm_resource_group.NetGroup.name
#   virtual_network_name = azurerm_virtual_network.VNet.name
#   address_prefixes     = ["192.168.2.0/24"]
# }









# # resource "azurerm_lb" "LoadBalancer" {
# #   name                = "LoadBalancer"
# #   location            = azurerm_resource_group.NetGroup.location
# #   resource_group_name = azurerm_resource_group.NetGroup.name
# #   sku                 = "Standard"

# #   frontend_ip_configuration {
# #     name                 = "PublicIPAddress"
# #     public_ip_address_id = azurerm_public_ip.PublicIP.id
# #   }
# # }

# # resource "azurerm_lb_backend_address_pool" "BackendPool" {
# #   name                = "BackendPool"
# #   loadbalancer_id     = azurerm_lb.LoadBalancer.id
# #     resource_group_name = azurerm_resource_group.NetGroup.name

# # }





