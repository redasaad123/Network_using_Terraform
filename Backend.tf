terraform {
    backend "azurerm" {
        resource_group_name  = azurerm_resource_group.name
        storage_account_name  = azurerm_storage_account.storage_project.name
        container_name        = azurerm_storage_container.container_project.name
        key                   = "terraform.tfstate"
    }

    
}