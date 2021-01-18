#!/bin/bash
set -x
VM_NAME=${1}
SATA_CONTROLLER_NAME=${2}
VBoxManage storagectl ${VM_NAME} \
    --name "${SATA_CONTROLLER_NAME}" \
    --add sata \
    --controller IntelAHCI \
    --bootable on
    set +x