#!/bin/bash
BASE_DIR="/mnt/work/virtualbox"
#Create a default vm
VM_NAME="testvm-linux"
FULL_DIR="$BASE_DIR/$VM_NAME"
MEDIUM_PATH="${FULL_DIR}/${VM_NAME}_disk.vdi"
vboxmanage createvm --name $VM_NAME \
    --ostype  Ubuntu_64 \
    --basefolder $BASE_DIR \
    --register

vboxmanage modifyvm $VM_NAME \
    --ostype  Ubuntu_64 \
    --memory 8192 \
    --vram 64 \
    --cpus 8 \
    --nic1 nat \
    --graphicscontroller vmsvga \
    --vrde on \
    --vrdeport 1905 \
    --nic2 hostonly \
    --hostonlyadapter2 vboxnet0

vboxmanage createmedium  disk --filename ${MEDIUM_PATH} \
    --size 15000 \
    --format VDI \
    --variant Standard

vboxmanage storagectl $VM_NAME \
    --name "SATA-storage1" \
    --add sata \
    --controller IntelAHCI \
    --bootable on

vboxmanage storageattach $VM_NAME \
    --storagectl "SATA-storage1" \
    --port 0 \
    --device 0 \
    --type hdd \
    --medium  ${MEDIUM_PATH} \

VBoxManage storagectl $VM_NAME --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach $VM_NAME --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium /mnt/tools/archives/ubuntu-18.04.3-server-amd64.iso
#VBoxManage storageattach $VM_NAME --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium /mnt/tools/archives/ubuntu-18.04.4-desktop-amd64.iso
#VBoxManage storageattach $VM_NAME --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium /mnt/tools/archives/ubuntu-20.04-desktop-amd64.iso
#VBoxManage modifyvm $VM_NAME  --vrde on --vrdevideochannel on
#VBoxManage modifyvm $VM_NAME  --vrde on
#VBoxManage modifyvm $VM_NAME  --vrdeport 1905
#VBoxManage modifyvm $VM_NAME  --vrdemulticon on --vrdeport 1905
#VBoxHeadless --startvm $VM_NAME
VBoxManage startvm $VM_NAME --type=headless



