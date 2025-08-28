resource "azurerm_network_interface" "oag_worker_nic" {
  name                = "${var.hostname}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.oag_worker_ip.id
  }
}

resource "azurerm_public_ip" "oag_worker_ip" {
  name                = "${var.hostname}-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_linux_virtual_machine" "oag_worker" {
  name                  = "${var.hostname}-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = var.vm_size
  admin_username        = "oag-mgmt"
  network_interface_ids = [azurerm_network_interface.oag_worker_nic.id]
  disable_password_authentication = true

  admin_ssh_key {
    username   = "oag-mgmt"
    public_key = file("~/.ssh/id_rsa.pub") // Ensure this path is correct
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 64
  }

  source_image_id = var.oag_image_uri
}

output "worker_private_ip" {
  value = azurerm_network_interface.oag_worker_nic.private_ip_address
}

output "worker_public_ip" {
  value = azurerm_public_ip.oag_worker_ip.ip_address
}

