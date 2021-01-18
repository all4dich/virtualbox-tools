#!/bin/bash
set -x
MEDIUM_PATH=${1}
ROOT_DISK_SIZE=${2}
vboxmanage createmedium  disk --filename ${MEDIUM_PATH} \
    --size ${ROOT_DISK_SIZE} \
    --format VDI \
    --variant Standard
set +x