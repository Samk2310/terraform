# `variables.tf`

variable "resource_group_name" {
  description = "Name of the Azure Resource Group."
  type        = string
  default     = "oag-dev-rg"
}

variable "location" {
  description = "Azure region to deploy resources."
  type        = string
  default     = "eastus"
}

variable "oag_worker_name" {
  description = "Name of the OAG worker virtual machine."
  type        = string
  default     = "oag-dev-worker01"
}

variable "vnet_name" {
  description = "Name of the Virtual Network."
  type        = string
  default     = "oag-vnet"
}

variable "subnet_name" {
  description = "Name of the Subnet for OAG nodes."
  type        = string
  default     = "oag-subnet"
}

variable "oag_service_key" {
  description = "The Okta Access Gateway service key for joining the cluster."
  type        = string
  sensitive   = true
}

variable "oag_admin_ip" {
  description = "The IP address of the Okta Access Gateway Admin Node."
  type        = string
}

variable "storage_account_name" {
  description = "The name of the Azure Storage Account holding the OAG image."
  type        = string
}

variable "storage_container_name" {
  description = "The name of the container holding the OAG image."
  type        = string
}

variable "oag_image_vhd_uri" {
  description = "The URI of the OAG VHD image in the storage account."
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
  default     = "Standard_DS2_v2"
}

variable "ssh_public_key" {
  description = "The SSH public key to be used for the VM."
  type        = string
}

variable "oag_admin_user" {
  description = "The username for the OAG admin account."
  type        = string
  default     = "oagadmin"
}
