
resource "azurerm_storage_account" "storage_project" {
name                     = "storagetfstate2345678"
resource_group_name      = azurerm_resource_group.NetGroup.name
location                 = azurerm_resource_group.NetGroup.location
account_tier             = "Standard"
account_replication_type = "LRS"

depends_on = [ azurerm_resource_group.NetGroup ]
}

resource "azurerm_storage_container" "container_project" {
name                  = "containertfstate2345678"
storage_account_name  = azurerm_storage_account.storage_project.name
container_access_type = "private"
}






