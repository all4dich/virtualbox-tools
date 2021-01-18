#!/bin/bash
#https://stackoverflow.com/questions/41463588/how-to-detach-vmdk-using-vboxmanage-cli
set -x
VM_NAME=${1}
CONTROLLER_NAME=${2}
PORT_NUMBER=${3}
VBoxManage storageattach $VM_NAME --storagectl $CONTROLLER_NAME --port $PORT_NUMBER --medium none
set +x