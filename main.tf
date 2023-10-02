data "azurerm_public_ip" "bky-ip-data" {
  name                = azurerm_public_ip.BKY_Public_IP.name
  resource_group_name = azurerm_resource_group.BKY-RG.name
}

output "public_ip_address" {
  value = "${azurerm_linux_virtual_machine.BKY_VM_ubuntu.name} : ${data.azurerm_public_ip.bky-ip-data.ip_address}"
}