# `main.tf`

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Configure the Azure Provider
provider "azurerm" {
  features {}
}

# Create a Resource Group
resource "azurerm_resource_group" "oag_dev_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a Virtual Network
resource "azurerm_virtual_network" "oag_vnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.oag_dev_rg.location
  resource_group_name = azurerm_resource_group.oag_dev_rg.name
}

# Create a Subnet for the OAG nodes
resource "azurerm_subnet" "oag_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.oag_dev_rg.name
  virtual_network_name = azurerm_virtual_network.oag_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a Network Security Group
resource "azurerm_network_security_group" "oag_nsg" {
  name                = "oag-nsg"
  location            = azurerm_resource_group.oag_dev_rg.location
  resource_group_name = azurerm_resource_group.oag_dev_rg.name

  security_rule {
    name                       = "allow_admin_access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22" # Allow SSH for troubleshooting
    source_address_prefix      = "Your_IP_CIDR" # Change to your IP address range
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_oag_traffic"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["8000-8002", "8443", "443", "80"] # Required OAG ports
    source_address_prefix      = "Your_IP_CIDR" # Refine source IP as needed
    destination_address_prefix = "*"
  }
}

# Create a Public IP Address
resource "azurerm_public_ip" "oag_worker_public_ip" {
  name                = "${var.oag_worker_name}-pip"
  location            = azurerm_resource_group.oag_dev_rg.location
  resource_group_name = azurerm_resource_group.oag_dev_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create a Network Interface
resource "azurerm_network_interface" "oag_worker_nic" {
  name                = "${var.oag_worker_name}-nic"
  location            = azurerm_resource_group.oag_dev_rg.location
  resource_group_name = azurerm_resource_group.oag_dev_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.oag_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.oag_worker_public_ip.id
  }
}

# Attach the NSG to the NIC
resource "azurerm_network_interface_security_group_association" "oag_nic_nsg_association" {
  network_interface_id      = azurerm_network_interface.oag_worker_nic.id
  network_security_group_id = azurerm_network_security_group.oag_nsg.id
}

# Create a Custom Data Disk from the OAG VHD
resource "azurerm_managed_disk" "oag_worker_disk" {
  name                 = "${var.oag_worker_name}-disk"
  location             = azurerm_resource_group.oag_dev_rg.location
  resource_group_name  = azurerm_resource_group.oag_dev_rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Import"
  source_uri           = var.oag_image_vhd_uri
  disk_size_gb         = 40 # Adjust based on image size
  os_type              = "Linux"
}

# Create the VM
resource "azurerm_linux_virtual_machine" "oag_worker_vm" {
  name                = var.oag_worker_name
  location            = azurerm_resource_group.oag_dev_rg.location
  resource_group_name = azurerm_resource_group.oag_dev_rg.name
  size                = var.vm_size
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.oag_worker_nic.id]

  os_disk {
    name                 = "${var.oag_worker_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 64
  }

  source_image_id = azurerm_managed_disk.oag_worker_disk.id

  custom_data = base64encode(templatefile("${path.module}/cloud-init.tftpl", {
    oag_service_key = var.oag_service_key
    oag_admin_ip    = var.oag_admin_ip
  }))

  # Use SSH for access
  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }
}
