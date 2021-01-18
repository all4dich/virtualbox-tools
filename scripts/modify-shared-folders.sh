#!/bin/bash
set -x
VBoxManage sharedfolder add ${1} --name="starfish" --hostpath="/starfish" --automount --auto-mount-point="/starfish"
VBoxManage sharedfolder add ${1} --name="home_sunjoo" --hostpath="/home/sunjoo" --automount --auto-mount-point="/home/sunjoo"
set +x