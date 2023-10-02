resource "azurerm_linux_virtual_machine" "BKY_VM_ubuntu" {
  name                  = "BKY-VM-Ubuntu"
  resource_group_name   = azurerm_resource_group.BKY-RG.name
  location              = azurerm_resource_group.BKY-RG.location
  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.BKY-NIC.id]

  custom_data = filebase64("custom-data.tpl")

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/ssh-bky-azure.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-config.tpl", {
      hostname     = self.public_ip_address,
      user         = "adminuser",
      identityfile = "~/.ssh/ssh-bky-azure"

    })

    interpreter = var.host_os == "Windows" ? ["Powershell", "Command"] : ["bash", "-c"]

  }

  tags = {
    environment = "Dev"
  }
}

