
terraform {
    backend "azurerm" {
        resource_group_name  = "NetGroup"
        storage_account_name  = "storagetfstate2345678"
        container_name        = "containertfstate2345678"
        key                   = "terraform.tfstate"
    }

}