
provider "azurerm" {
  features {}

  client_id = var.client_id
  client_secret = var.client_secret
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id


}


data "azurerm_resource_group" "NetGroup" {
  name     = "NetGroup"
  
}

resource "azurerm_storage_account" "storage_project" {
name                     = "storagetfstate2345678"
resource_group_name      = data.azurerm_resource_group.NetGroup.name
location                 = data.azurerm_resource_group.NetGroup.location
account_tier             = "Standard"
account_replication_type = "LRS"

depends_on = [ data.azurerm_resource_group.NetGroup ]
}

resource "azurerm_storage_container" "container_project" {
name                  = "containertfstate2345678"
storage_account_name  = azurerm_storage_account.storage_project.name
container_access_type = "private"
}






