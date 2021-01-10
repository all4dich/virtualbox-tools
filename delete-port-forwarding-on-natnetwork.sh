#!/bin/bash
function usage() {
    echo "--nat-name NAT Network Name"
    echo "--rule-name Rule name"
    exit 2
}
ARGUMENTS=$(getopt -a -n alphabet -o n:r: --long nat-name:,rule-name: -- "$@")
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
    -n | --nat-name)
        NAT_NAME="${2}"
        shift 2
        ;;
    -r | --rule-name)
        RULE_NAME="${2}"
        shift 2
        ;;
    --) shift; break ;;
    *) echo "Unexpected option: $1 - this should not happen."
       usage ;;
  esac
done
VBoxManage natnetwork modify --netname $NAT_NAME --port-forward-4 delete $RULE_NAME