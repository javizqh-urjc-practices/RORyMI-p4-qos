#!/bin/sh

tc qdisc del dev eth0 ingress
tc qdisc del dev eth1 root

tc qdisc add dev eth0 ingress handle ffff:

tc filter add dev eth0 parent ffff: protocol ip prio 4 u32 match ip src 12.209.0.30/32 \
		match ip dst 16.209.0.60/32 police rate 400kbit burst 10k continue flowid :5
tc filter add dev eth0 parent ffff: protocol ip prio 5 u32 match ip src 12.209.0.30/32 \
		match ip dst 16.209.0.60/32 police rate 300kbit burst 10k continue flowid :6
tc filter add dev eth0 parent ffff: protocol ip prio 6 u32 match ip src 12.209.0.30/32 \
		police rate 100kbit burst 10k drop flowid :7

tc qdisc add dev eth1 root handle 1:0 dsmark indices 4

tc class change dev eth1 classid 1:1 dsmark mask 0x3 value 0x68
tc class change dev eth1 classid 1:2 dsmark mask 0x3 value 0x48
tc class change dev eth1 classid 1:3 dsmark mask 0x3 value 0x28

tc filter add dev eth1 parent 1:0 protocol ip prio 1 handle 1 tcindex classid 1:1
tc filter add dev eth1 parent 1:0 protocol ip prio 2 handle 2 tcindex classid 1:2
tc filter add dev eth1 parent 1:0 protocol ip prio 3 handle 2 tcindex classid 1:3