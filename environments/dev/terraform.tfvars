environment    = "dev"
location       = "East US"
vnet_name      = "oag-dev-vnet"
subnet_id      = "/subscriptions/<SUB_ID>/resourceGroups/oag-dev-rg/providers/Microsoft.Network/virtualNetworks/oag-dev-vnet/subnets/oag-worker-subnet"
oag_admin_ip   = "10.0.1.4" # Private IP of your OAG dev admin node
oag_token      = "your_dev_token"
worker_count   = 1
oag_disk_id    = "/subscriptions/<SUB_ID>/resourceGroups/oag-images/providers/Microsoft.Compute/disks/oag-managed-disk"
