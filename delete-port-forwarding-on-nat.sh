#!/bin/bash
function usage() {
    echo "--vm-name  VM_NAME"
    echo "--rule-name Rule name"
    echo "--net-number Network interface number"
    exit 2
}
ARGUMENTS=$(getopt -a -n alphabet -o v: --long vm-name:,rule-name:,net-number: -- "$@")
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

        ;;
    --vm-name)
        VM_NAME="${2}"
        shift 2
        ;;
    --rule-name)
        RULE_NAME="${2}"
        shift 2
        ;;
    --net-number)
        NET_NUMBER="${2}"
        shift 2
        ;;
    --) shift; break ;;
    *) echo "Unexpected option: $1 - this should not happen."
       usage ;;
  esac
done

VBoxManage modifyvm ${VM_NAME} --natpf${NET_NUMBER} delete ${RULE_NAME}