#!/bin/bash
set -x 
VM_NAME=${1}
CONTROLLER_NAME=${2}
PORT_NUMBER=${3}
DISK_FILE_PATH=${4}
VBoxManage storageattach ${VM_NAME} --storagectl ${CONTROLLER_NAME} --port ${PORT_NUMBER} --device 0 \
       --type hdd --medium ${DISK_FILE_PATH}
set +x