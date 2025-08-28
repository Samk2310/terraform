variable "environment" {
  description = "The environment (e.g., dev, prod)."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources."
  type        = string
}

variable "vnet_name" {
  description = "The name of the existing VNet."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet for the worker node."
  type        = string
}

variable "oag_admin_ip" {
  description = "The private IP address of the OAG admin node."
  type        = string
}

variable "oag_token" {
  description = "The shared token from the OAG admin node to join the cluster."
  type        = string
  sensitive   = true
}

variable "worker_count" {
  description = "The number of worker nodes to deploy."
  type        = number
  default     = 1
}

variable "oag_disk_id" {
  description = "The ID of the managed disk containing the OAG image."
  type        = string
}
