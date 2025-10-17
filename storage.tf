
# # resource "azurerm_resource_group" "NetGroup" {
# # name     = "Network-group"
# # location = "West Europe"
# # }


# resource "azurerm_storage_account" "storage_project" {
# name                     = "storage_tfstate"
# resource_group_name      = azurerm_resource_group.name
# location                 = azurerm_resource_group.location
# account_tier             = "Standard"
# account_replication_type = "LRS"
# }

# resource "azurerm_storage_container" "container_project" {
# name                  = "container_tfstate"
# storage_account_name  = azurerm_storage_account.storage_project.name
# container_access_type = "private"
# }






