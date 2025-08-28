environment    = "dev"
location       = "East US"
vnet_name      = "oag-dev-vnet"
subnet_id      = "/subscriptions/0ed2d3a8-0af8-4119-ada0-c74e2488190e/resourceGroups/oag-dev-rg/providers/Microsoft.Network/virtualNetworks/oag-dev-vnet/subnets/oag-worker-subnet"
oag_admin_ip   = "10.0.0.5" # Private IP of your OAG dev admin node
oag_token      = "your_dev_token"
worker_count   = 1
oag_disk_id    = "/subscriptions/0ed2d3a8-0af8-4119-ada0-c74e2488190e/resourceGroups/AccessGateway/providers/Microsoft.Compute/galleries/ImageGallery/images/Oag-image"
# "/subscriptions/<SUB_ID>/resourceGroups/oag-images/providers/Microsoft.Compute/disks/oag-managed-disk"
