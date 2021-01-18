#!/bin/bash
VM_NAME=${1}
CONTROLLER_NAME=${2}
VBoxManage storagectl $VM_NAME --name "${CONTROLLER_NAME}" --remove