#!/bin/bash
# Create controller
VBoxManage storagectl ubuntu-1804 --name SATA_controller \
       --add sata --controller IntelAHCI --bootable on
# Add a storage to controller
VBoxManage storageattach ubuntu-1804 --storagectl SATA_controller --port 0 --device 0 \
       --type hdd --medium /vol/users/gatekeeper.tvsw/VirtualBox\ VMs/ubuntu-1804/ubuntu-64.vdi 
# Add a storage to controller
VBoxManage storageattach ubuntu-1804 --storagectl SATA_controller --port 1 --device 0  \
       --type hdd --medium /vol/users/gatekeeper.tvsw/VirtualBox\ VMs/ubuntu-1804/ubuntu-1804_1.vdi