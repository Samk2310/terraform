module "oag_worker" {
  source       = "../../modules/oag_worker"
  environment  = var.environment
  location     = var.location
  vnet_name    = var.vnet_name
  subnet_id    = var.subnet_id
  oag_admin_ip = var.oag_admin_ip
  oag_token    = var.oag_token
  worker_count = var.worker_count
  oag_disk_id  = var.oag_disk_id
}

variable "environment" {}
variable "location" {}
variable "vnet_name" {}
variable "subnet_id" {}
variable "oag_admin_ip" {}
variable "oag_token" { sensitive = true }
variable "worker_count" {}
variable "oag_disk_id" {}
