
resource "azurerm_resource_group" "NetGroup" {
  name     = "Network-group"
  location = "West Europe"
}


terraform {
    backend "azurerm" {
        resource_group_name  = "Network-group"
        storage_account_name  = "storage_tfstate"
        container_name        = "container_tfstate"
        key                   = "terraform.tfstate"
    }

}