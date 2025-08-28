resource "azurerm_resource_group" "oag_rg" {
  name     = "oag-${var.environment}-rg"
  location = var.location
}

resource "azurerm_network_interface" "oag_nic" {
  count               = var.worker_count
  name                = "oag-worker-${var.environment}-${count.index}-nic"
  location            = azurerm_resource_group.oag_rg.location
  resource_group_name = azurerm_resource_group.oag_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "oag_worker_vm" {
  count               = var.worker_count
  name                = "oag-worker-${var.environment}-${count.index}-vm"
  location            = azurerm_resource_group.oag_rg.location
  resource_group_name = azurerm_resource_group.oag_rg.name
  size                = "Standard_DS2_v2" # Customize as needed
  network_interface_ids = [azurerm_network_interface.oag_nic[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    #managed_disk_id      = var.oag_disk_id # Re-use the prepared managed disk
  }

  source_image_id = var.oag_disk_id # Re-use the prepared managed disk

  custom_data = base64encode(templatefile("${path.module}/cloud-init.tpl", {
    oag_admin_ip = var.oag_admin_ip
    oag_token    = var.oag_token
  }))

  admin_username = "oktaadmin"
  disable_password_authentication = true
}
