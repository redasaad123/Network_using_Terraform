resource "azurerm_route_table" "RouteTablePublic" {
  name                = "RouteTablePublic"
  location            = data.azurerm_resource_group.NetGroup.location
  resource_group_name = data.azurerm_resource_group.NetGroup.name

  route {
    name                   = "ToInternet"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
  }

}

resource "azurerm_route_table" "RouteTablePrivate" {
  name                = "RouteTablePrivate"
  location            = data.azurerm_resource_group.NetGroup.location
  resource_group_name = data.azurerm_resource_group.NetGroup.name

  route {
    name                   = "ToInternetViaNAT"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_nat_gateway.NatGateway.id
  }
  
}


resource "azurerm_subnet_route_table_association" "PublicSubnetRouteTableAssociation" {
  subnet_id      = azurerm_subnet.Jump-subnet.id
  route_table_id = azurerm_route_table.RouteTablePublic.id
}


resource "azurerm_subnet_route_table_association" "PrivateSubnet1RouteTableAssociation" {
  subnet_id      = azurerm_subnet.Web-subnet-1.id
  route_table_id = azurerm_route_table.RouteTablePrivate.id
}

resource "azurerm_subnet_route_table_association" "PrivateSubnet2RouteTableAssociation" {
  subnet_id      = azurerm_subnet.Web-subnet-2.id
  route_table_id = azurerm_route_table.RouteTablePrivate.id
}









