resource "azurerm_public_ip" "Jump-PublicIP" {
name                = "PublicIP"
location            = data.azurerm_resource_group.NetGroup.location
resource_group_name = data.azurerm_resource_group.NetGroup.name
allocation_method   = "Static"
sku                 = "Standard"


}

resource "azurerm_network_security_group" "NSG" {
    name                = "NSG"
    location            = data.azurerm_resource_group.NetGroup.location
    resource_group_name = data.azurerm_resource_group.NetGroup.name
    
    security_rule {
        name                       = "Allow-SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}


resource "azurerm_subnet_network_security_group_association" "JumpSubnetNSGAssociation" {
subnet_id                 = azurerm_subnet.Jump-subnet.id
network_security_group_id = azurerm_network_security_group.NSG.id
}


resource "azurerm_network_interface" "NIC" {
    name                = "NIC"
    location            = data.azurerm_resource_group.NetGroup.location
    resource_group_name = data.azurerm_resource_group.NetGroup.name

    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.Jump-subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.Jump-PublicIP.id
    }

}


resource "azurerm_linux_virtual_machine" "JumpVM" {
name                  = "JumpVM"
location              = data.azurerm_resource_group.NetGroup.location
resource_group_name   = data.azurerm_resource_group.NetGroup.name
size               = "Standard_B1s"
admin_username        = "JumpServeruser"
network_interface_ids = [azurerm_network_interface.NIC.id]



admin_ssh_key {
    username   = "JumpServeruser"
    public_key = var.ssh_public_key
}


os_disk {
    name              = "JumpVM_OSDisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
}

source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
}


}
