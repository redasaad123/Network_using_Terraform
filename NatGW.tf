resource "azurerm_nat_gateway" "NatGateway" {
    name                = "NatGateway"
    location            = azurerm_resource_group.NetGroup.location
    resource_group_name = azurerm_resource_group.NetGroup.name
    sku_name            = "Standard"
    # remove public_ip_address_ids here
}
# keep azurerm_nat_gateway_public_ip_association


resource "azurerm_public_ip" "NatpublicIP" {
name                = "NatpublicIP"
location            = azurerm_resource_group.NetGroup.location
resource_group_name = azurerm_resource_group.NetGroup.name
allocation_method   = "Static"
sku                 = "Standard"

}

resource "azurerm_subnet_nat_gateway_association" "NatGatewaySubnetAssociation" {
subnet_id      = azurerm_subnet.NatGateway-subnet.id
nat_gateway_id = azurerm_nat_gateway.NatGateway.id
}

resource "azurerm_nat_gateway_public_ip_association" "NatGW_IP" {
nat_gateway_id       = azurerm_nat_gateway.NatGateway.id
public_ip_address_id = azurerm_public_ip.NatpublicIP.id
}
