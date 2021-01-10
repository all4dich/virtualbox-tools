#!/bin/bash
# Define port fowarding rule for NAT Network
function usage() {
    echo "--nat-name NAT Network Name"
    echo "--nat-rule NAT Port Forwarding Rule (including the rule name)"
    echo "   > example ssh_1:tcp:[]:2010:[10.0.10.6]:22"

    exit 2
}
ARGUMENTS=$(getopt -a -n alphabet -o n:r: --long nat-name:,nat-rule: -- "$@")
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
    --nat-name)
        NAT_NAME="${2}"
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

VBoxManage natnetwork modify \
  --netname $NAT_NAME --port-forward-4 "$NAT_RULE"

