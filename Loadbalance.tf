resource "azurerm_public_ip" "lb_pub" {
    name                = "lbPublicIP"
    location            = data.azurerm_resource_group.NetGroup.location
    resource_group_name = data.azurerm_resource_group.NetGroup.name
    allocation_method   = "Static"
    sku                 = "Standard"
}


resource "azurerm_lb" "web_lb" {
    name                = "webLoadBalancer"
    location            = data.azurerm_resource_group.NetGroup.location
    resource_group_name = data.azurerm_resource_group.NetGroup.name
    sku                 = "Standard"

    frontend_ip_configuration {
        name                 = "LoadBalancerFrontEnd"
        public_ip_address_id = azurerm_public_ip.lb_pub.id
    }

}


resource "azurerm_lb_backend_address_pool" "web_backend_pool" {
    name                = "webBackendPool"
    loadbalancer_id     = azurerm_lb.web_lb.id    
}



resource "azurerm_lb_probe" "web_health_probe" {
    name                = "webHealthProbe"
    loadbalancer_id     = azurerm_lb.web_lb.id
    protocol            = "Tcp"
    port                = 80
    interval_in_seconds = 15
    number_of_probes    = 2
}


resource "azurerm_lb_rule" "web_lb_rule" {
    name                           = "webLoadBalancerRule"
    loadbalancer_id                = azurerm_lb.web_lb.id
    protocol                       = "Tcp"
    frontend_port                  = 80
    backend_port                   = 80
    frontend_ip_configuration_name = "LoadBalancerFrontEnd"
    backend_address_pool_ids       = [azurerm_lb_backend_address_pool.web_backend_pool.id]
    probe_id                       = azurerm_lb_probe.web_health_probe.id
}




