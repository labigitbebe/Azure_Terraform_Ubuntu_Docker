resource "azurerm_virtual_network" "BKY-VN" {
  name                = "BKY-Network"
  resource_group_name = azurerm_resource_group.BKY-RG.name
  location            = azurerm_resource_group.BKY-RG.location
  address_space       = ["10.11.0.0/16"]

  tags = {
    environment = "Dev"
  }

}

resource "azurerm_subnet" "BKY-Subnet" {
  name                 = "BKY-Subnet-Dev"
  resource_group_name  = azurerm_resource_group.BKY-RG.name
  virtual_network_name = azurerm_virtual_network.BKY-VN.name
  address_prefixes     = ["10.11.1.0/24"]

}

resource "azurerm_network_security_group" "BKY-SG" {
  name                = "BKY-SG-DEV"
  resource_group_name = azurerm_resource_group.BKY-RG.name
  location            = azurerm_resource_group.BKY-RG.location

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_network_security_rule" "BKY-Dev-Sec_Rule" {
  name                        = "BKY_Dev_SR"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.BKY-RG.name
  network_security_group_name = azurerm_network_security_group.BKY-SG.name

}

resource "azurerm_subnet_network_security_group_association" "BKY-SG-SR-Ass" {
  subnet_id                 = azurerm_subnet.BKY-Subnet.id
  network_security_group_id = azurerm_network_security_group.BKY-SG.id

}

resource "azurerm_public_ip" "BKY_Public_IP" {
  name                = "BKY-PublicIP"
  resource_group_name = azurerm_resource_group.BKY-RG.name
  location            = azurerm_resource_group.BKY-RG.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_network_interface" "BKY-NIC" {
  name                = "BKY-nic"
  location            = azurerm_resource_group.BKY-RG.location
  resource_group_name = azurerm_resource_group.BKY-RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.BKY-Subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.BKY_Public_IP.id

  }

  tags = {
    environment = "Dev"
  }
}