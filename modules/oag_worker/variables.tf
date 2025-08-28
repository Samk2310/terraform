variable "environment" {
  description = "The deployment environment (e.g., dev, prod)."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Azure Resource Group."
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet for the worker node."
  type        = string
}

variable "hostname" {
  description = "The hostname for the OAG worker node."
  type        = string
}

variable "oag_image_uri" {
  description = "The URI of the OAG managed disk image."
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
  default     = "Standard_DS2_v2"
}

