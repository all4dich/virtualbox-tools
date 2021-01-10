#!/bin/bash
BASE_DIR="/mnt/work/virtualbox"
function usage() {
    echo "--vm-name | -n VM Name"
    echo "--image-path | -i ISO Image path"
    echo "--base-dir | -b base directory, default = ${BASE_DIR}"
    echo "--vrde-port | -v port number for vrde"
    echo "--cpus | -c Number of cpus"
    echo "--memory-size | -m Memory Size ( in MB )"
    echo "--video-memory-size Video Memory Size ( in MB ), default = 64"
    echo "--ostype | -o OS Type (--ostype on vboxmanage createvm)"
    echo "--root-disk-size Root disk size in MB, default = 15000"
    exit 2
}

ARGUMENTS=$(getopt -a -n alphabet -o n:i:b:v:c:h --long vm-name:,image-path:,base-dir:,vrde-port:,cpus:,memory-size:,video-memory-size:,os-type:,root-disk-size: -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi
echo "ARGUMENTS is $ARGUMENTS"
eval set -- "$ARGUMENTS"
while :
do
  case "$1" in
    -h | --help)
        usage
        ;;
    -n | --vm-name)
        VM_NAME="${2}"
        shift 2
        ;;
    -i | --image-path)
        IMAGE_PATH="$2"
        shift 2
        ;;
    -b | --base-dir)
        BASE_DIR="$2"
        shift 2
        ;;
    -v | --vrde-port)
        VRDE_PORT="$2"
        shift 2
        ;;
    -c | --cpus)
        CPUS="$2"
        shift 2
        ;;
    -m | --memory-size)
        MEMORY_SIZE="$2"
        shift 2
        ;;
    --video-memory-size)
        VIDEO_MEMORY_SIZE="$2"
        shift 2
        ;;
    -o | --os-type)
        OS_TYPE="$2"
        shift 2
        ;;
    --root-disk-size)
        ROOT_DISK_SIZE="$2"
        shift 2
        ;;
    --) shift; break ;;
    *) echo "Unexpected option: $1 - this should not happen."
       usage ;;
  esac
done

if [ -z $VM_NAME ] || [ -z $IMAGE_PATH ]
then
    echo "ERROR: VM name( -n ) = "$VM_NAME
    echo "ERROR: Image path( -i ) = "$IMAGE_PATH
    exit 1
fi
if [ -z $CPUS ]
then
    CPUS=$(expr `nproc` / 2 )
fi
if [ -z $MEMORY_SIZE ]
then
    MEMORY_SIZE=8192
fi
if [ -z $OS_TYPE ]
then
    OS_TYPE="Ubuntu_64"
fi
if [ -z $VIDEO_MEMORY_SIZE ]
then
    VIDEO_MEMORY_SIZE="64"
fi
if [ -z $ROOT_DISK_SIZE ]
then
    ROOT_DISK_SIZE="20000"
fi

VM_PATH="$BASE_DIR/$VM_NAME"
MEDIUM_PATH="${VM_PATH}/${VM_NAME}_disk.vdi"
echo "INFO: VM name = "$VM_NAME
echo "INFO: VM directory = "$VM_PATH
echo "INFO: Image path = "$IMAGE_PATH
echo "INFO: Base directory = " $BASE_DIR
echo "INFO: Default disk file path = " $MEDIUM_PATH

vboxmanage createvm --name $VM_NAME \
    --ostype $OS_TYPE \
    --basefolder $BASE_DIR \
    --register

vboxmanage modifyvm $VM_NAME \
    --ostype  $OS_TYPE \
    --memory $MEMORY_SIZE \
    --vram $VIDEO_MEMORY_SIZE \
    --cpus $CPUS \
    --nic1 hostonly \
    --hostonlyadapter1 vboxnet0
    --graphicscontroller vmsvga
if [ -z $VRDE_PORT ]
then
    echo "INFO: VRDE is disabled"
else
set -x
vboxmanage modifyvm $VM_NAME \
    --vrde on \
    --vrdeport ${VRDE_PORT}
fi
vboxmanage createmedium  disk --filename ${MEDIUM_PATH} \
    --size ${ROOT_DISK_SIZE} \
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
    --medium  ${MEDIUM_PATH}
VBoxManage storagectl $VM_NAME --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach $VM_NAME --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $IMAGE_PATH
VBoxManage unattended install $VM_NAME --iso=$IMAGE_PATH --user ubuntu --password ubuntu --full-user-name ubuntu --install-additions --country=KR --time-zone="Asia/Seoul" --hostname="${VM_NAME}.local" --start-vm=headless
set +x
