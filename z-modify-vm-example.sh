#!/bin/bash
VM_NAME=${1}
OS_TYPE="Ubuntu_64"
MEMORY_SIZE=8192
VIDEO_MEMORY_SIZE="64"
CPUS=$(expr `nproc` / 2 )


#vboxmanage modifyvm $VM_NAME \
#    --ostype  $OS_TYPE \
#    --memory $MEMORY_SIZE \
#    --vram $VIDEO_MEMORY_SIZE \
#    --cpus $CPUS \
#    --nic1 hostonly \
#    --hostonlyadapter1 vboxnet0
#    --nic2 nat \
#    --graphicscontroller vmsvga

vboxmanage modifyvm $VM_NAME \
    --nic1 hostonly \
    --hostonlyadapter1 vboxnet0 \
    --nic2 nat \
    --graphicscontroller vmsvga

# Set a nic' type as 'NAT Network' and assign in to one of the nat networks
# Required arguments
#     --nic[1-4]
#     --nat-network[1-4]
vboxmanage modifyvm $VM_NAME \
    --nic3 natnetwork\
    --nat-network3 NatNetwork

vboxmanage modifyvm u2004-hostonly-1 \
    --nic1 natnetwork \
    --nat-network1 NatNetwork \
    --nic2 none \
    --nic3 none
vboxmanage modifyvm u2004-hostonly-3 \
    --nic1 natnetwork \
    --nat-network1 NatNetwork \
    --nic2 none \
    --nic3 none