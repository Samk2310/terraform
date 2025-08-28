#cloud configuration
runcmd:
  - echo "Configuring OAG worker node..."
  - /usr/local/bin/oagadm cluster join --host ${oag_admin_ip} --token ${oag_token}
  - echo "OAG worker node joined successfully."
