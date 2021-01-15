#!/bin/bash
# Define port fowarding rule for NAT Network
function usage() {
    echo "--nat-name NAT Network Name"
    #echo "--nat-rule NAT Port Forwarding Rule (including the rule name)"
    #echo "   > example ssh_1:tcp:[]:2010:[10.0.10.6]:22"
    echo "--rule-name NAT Network Rule Name"
    echo "--host-ip   Host IP for NAT Network Rule, default = ''"
    echo "--host-port Host port for NAT Network"
    echo "--guest-ip Guest OS IP on NAT Network"
    echo "--guest-port Guest OS PORT on Guest IP"

    exit 2
}
ARGUMENTS=$(getopt -a -n alphabet -o n:r: --long nat-name:,rule-name:,host-ip:,host-port:,guest-ip:,guest-port: -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi
echo "ARGUMENTS is $ARGUMENTS"
eval set -- "$ARGUMENTS"
FORWARD_PROTOCOL="tcp"
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
    --rule-name)
        RULE_NAME="${2}"
        shift 2
        ;;
    --host-ip)
        HOST_IP="${2}"
        shift 2
        ;;
    --host-port)
        HOST_PORT="${2}"
        shift 2
        ;;
    --guest-ip)
        GUEST_IP="${2}"
        shift 2
        ;;
    --guest-port)
        GUEST_PORT="${2}"
        shift 2
        ;;
    --) shift; break ;;
    *) echo "Unexpected option: $1 - this should not happen."
       usage ;;
  esac
done
if [ -z "${HOST_IP}" ]; then
  HOST_IP=""
fi
NAT_RULE="${RULE_NAME}:${FORWARD_PROTOCOL}:[${HOST_IP}]:${HOST_PORT}:[${GUEST_IP}]:${GUEST_PORT}"
echo "NAT Network = ${NAT_NAME}"
echo "NAT Rule = ${NAT_RULE}"
VBoxManage natnetwork modify \
  --netname $NAT_NAME --port-forward-4 "$NAT_RULE"