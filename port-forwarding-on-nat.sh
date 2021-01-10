#!/bin/bash
function usage() {
    echo "--vm-name  VM_NAME"
    echo "--nat-rule NAT Port Forwarding Rule (including the rule name)"
    echo "   > example guestssh,tcp,,2222,10.0.2.19,22"
    echo "--net-number Network interface number"
    exit 2
}
ARGUMENTS=$(getopt -a -n alphabet -o v --long vm-name:,nat-rule:,net-number: -- "$@")
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
    --vm-name)
        VM_NAME="${2}"
        shift 2
        ;;
    --net-number)
        NET_NUMBER="${2}"
        shift 2
        ;;
    --nat-rule)
        NAT_RULE="${2}"
        shift 2
        ;;
    --) shift; break ;;
    *) echo "Unexpected option: $1 - this should not happen."
       usage ;;
  esac
done
VBoxManage modifyvm ${VM_NAME} --natpf${NET_NUMBER} "${NAT_RULE}"