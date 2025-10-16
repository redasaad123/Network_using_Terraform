provider "azurerm" {
  features {}

  
}

resource "azurerm_resource_group" "NetGroup" {
  name     = "Network-group"
  location = "West Europe"
}

resource "azurerm_virtual_network" "VNet" {
  name                = "VNet"
  address_space       = ["192.168.0.0/16"]
  location            = azurerm_resource_group.NetGroup.location
  resource_group_name = azurerm_resource_group.NetGroup.name
}
resource "azurerm_subnet" "Jump-subnet" {
  name                 = "Jump-subnet"
  resource_group_name  = azurerm_resource_group.NetGroup.name
  virtual_network_name = azurerm_virtual_network.VNet.name
  address_prefixes     = ["192.168.3.0/24"]
}

resource "azurerm_subnet" "NatGateway-subnet" {
  name                 = "NatGateway-subnet"
  resource_group_name  = azurerm_resource_group.NetGroup.name
  virtual_network_name = azurerm_virtual_network.VNet.name
  address_prefixes     = ["192.168.4.0/24"]
}


resource "azurerm_subnet" "web-subnet-1" {
  name                 = "web-subnet-1"
  resource_group_name  = azurerm_resource_group.NetGroup.name
  virtual_network_name = azurerm_virtual_network.VNet.name
  address_prefixes     = ["192.168.1.0/24"]
}

resource "azurerm_subnet" "web-subnet-2" {
  name                 = "web-subnet-2"
  resource_group_name  = azurerm_resource_group.NetGroup.name
  virtual_network_name = azurerm_virtual_network.VNet.name
  address_prefixes     = ["192.168.2.0/24"]
}


resource "azurerm_public_ip" "PublicIP" {
  name                = "PublicIP"
  location            = azurerm_resource_group.NetGroup.location
  resource_group_name = azurerm_resource_group.NetGroup.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "NSG" {
    name                = "NSG"
    location            = azurerm_resource_group.NetGroup.location
    resource_group_name = azurerm_resource_group.NetGroup.name
    
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
    location            = azurerm_resource_group.NetGroup.location
    resource_group_name = azurerm_resource_group.NetGroup.name
    
    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.Jump-subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.PublicIP.id
    }
  
}

resource "azurerm_nat_gateway" "NatGateway" {
  name                = "NatGateway"
  location            = azurerm_resource_group.NetGroup.location
  resource_group_name = azurerm_resource_group.NetGroup.name
  sku_name            = "Standard"
}

resource "azurerm_subnet_nat_gateway_association" "NatGatewaySubnetAssociation" {
  subnet_id      = azurerm_subnet.NatGateway-subnet.id
  nat_gateway_id = azurerm_nat_gateway.NatGateway.id
}

resource "azurerm_nat_gateway_public_ip_association" "NatGW_IP" {
  nat_gateway_id       = azurerm_nat_gateway.NatGateway.id
  public_ip_address_id = azurerm_public_ip.PublicIP.id
}

resource "azurerm_virtual_machine" "JumpVM" {
  name                  = "JumpVM"
  location              = azurerm_resource_group.NetGroup.location
  resource_group_name   = azurerm_resource_group.NetGroup.name
  network_interface_ids = [azurerm_network_interface.NIC.id]
  vm_size               = "Standard_B1s"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "JumpVM_OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_profile {
    computer_name  = "JumpVM"
    admin_username = "JumpVmUser"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }


}





# resource "azurerm_lb" "LoadBalancer" {
#   name                = "LoadBalancer"
#   location            = azurerm_resource_group.NetGroup.location
#   resource_group_name = azurerm_resource_group.NetGroup.name
#   sku                 = "Standard"

#   frontend_ip_configuration {
#     name                 = "PublicIPAddress"
#     public_ip_address_id = azurerm_public_ip.PublicIP.id
#   }
# }

# resource "azurerm_lb_backend_address_pool" "BackendPool" {
#   name                = "BackendPool"
#   loadbalancer_id     = azurerm_lb.LoadBalancer.id
#     resource_group_name = azurerm_resource_group.NetGroup.name

# }





