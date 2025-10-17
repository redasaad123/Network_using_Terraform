resource "network_security_group" "web_nsg" {

    name                = "webNSG"
    location            = data.azurerm_resource_group.NetGroup.location
    resource_group_name = data.azurerm_resource_group.NetGroup.name
    
   security_rule {
    name                       = "Allow-From-AzureLoadBalancer"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

   security_rule {
    name                       = "Allow-HTTP-HTTPS"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80-443"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-SSH-from-Jump"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = azurerm_subnet.Jump-subnet.address_prefixes[0]
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "web-subnet-1_assoc" {
subnet_id                 = azurerm_subnet.Web-subnet-1.id
network_security_group_id = azurerm_network_security_group.web_nsg.id   
}

resource "azurerm_subnet_network_security_group_association" "web-subnet-2_assoc" {
subnet_id                 = azurerm_subnet.Web-subnet-2.id
network_security_group_id = azurerm_network_security_group.web_nsg.id   
}


resource "azurerm_linux_virtual_machine_scale_set" "web_vmss" {
    name                = "webVMSS"
    location            = data.azurerm_resource_group.NetGroup.location
    resource_group_name = data.azurerm_resource_group.NetGroup.name
    sku                 = "Standard_B1s"
    instances           = 2
    admin_username      = "webvmuser"

    admin_ssh_key {
        username   = "webvmuser"
        public_key = var.ssh_public_key
    }

    network_interface {
        name    = "webVMSSNIC"
        primary = true

        ip_configuration {
            name                                   = "webVMSSIPConfig"
            subnet_id                              = azurerm_subnet.Web-subnet-1.id
            primary                                = true
        }
    }

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
}

  health_probe_id = azurerm_lb_probe.web_probe.id

  
}
