#!/bin/bash
BASE_DIR="/mnt/work/virtualbox"
while getopts ":n:i:b:v:h" opt; do
    case $opt in
    h|\?)
        echo "-n VM Name"
        echo "-i ISO Image path"
        echo "-b base directory, default = ${BASE_DIR}"
        echo "-v port number for vrde"
        exit 1
        ;;
    n)
        VM_NAME=${OPTARG}
        ;;
    i)
        IMAGE_PATH=${OPTARG}
        ;;
    b)
        BASE_DIR=${OPTARG}
        ;;
    v)
        VRDE_PORT=${OPTARG}
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    esac
done

if [ -z $VM_NAME ] || [ -z $IMAGE_PATH ]
then
    echo "ERROR: VM name( -n ) = "$VM_NAME
    echo "ERROR: Image path( -i ) = "$IMAGE_PATH
    exit 1
fi
VM_PATH="$BASE_DIR/$VM_NAME"
MEDIUM_PATH="${VM_PATH}/${VM_NAME}_disk.vdi"
echo "INFO: VM name = "$VM_NAME
echo "INFO: VM directory = "$VM_PATH
echo "INFO: Image path = "$IMAGE_PATH
echo "INFO: Base directory = " $BASE_DIR
echo "INFO: Default disk file path = " $MEDIUM_PATH

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
    --nic2 hostonly \
    --hostonlyadapter2 vboxnet0

if [ -n ${VRDE_PORT} ]; then
vboxmanage modifyvm $VM_NAME \
    --vrde on \
    --vrdeport ${VRDE_PORT}
fi

vboxmanage createmedium  disk --filename ${MEDIUM_PATH} \
    --size 15000 \
    --format VDI \
    --variant Standard

sata_control_name="${VM_NAME}_SATA-storage1"
vboxmanage storagectl $VM_NAME \
    --name "${sata_control_name}" \
    --add sata \
    --controller IntelAHCI \
    --bootable on

vboxmanage storageattach $VM_NAME \
    --storagectl "${sata_control_name}" \
    --port 0 \
    --device 0 \
    --type hdd \
    --medium  ${MEDIUM_PATH} \

VBoxManage storagectl $VM_NAME --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach $VM_NAME --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $IMAGE_PATH
VBoxManage startvm $VM_NAME --type=headless



