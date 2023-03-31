#!/bin/bash

TEMPLATE_DIR="/var/lib/vz/template/cache"
TEMPLATE="ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
POOL="test"
CT_HOSTNAME="server1"
STORAGE="zfs_data"
VID="400"
RAM="512"
IP_CIDR="192.168.10.71/24"
GATEWAY="192.168.10.1"
BRIDGE="vmbr0"
VLAN="10"



pct create $VID $TEMPLATE_DIR/$TEMPLATE \
--hostname $CT_HOSTNAME \
--memory $RAM \
--net0 name=eth0,bridge=$BRIDGE,firewall=1,gw=$GATEWAY,ip=$IP_CIDR,tag=$VLAN,type=veth \
--storage $STORAGE \
--rootfs $STORAGE:8 \
--unprivileged 1 \
--pool $POOL \
--ignore-unpack-errors \
--ssh-public-keys /root/.ssh/authorized_keys \
--ostype ubuntu \
--password="abc-123" \
--start 1
