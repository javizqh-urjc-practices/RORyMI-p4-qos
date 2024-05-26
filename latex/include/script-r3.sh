#!/bin/sh

tc qdisc del dev eth2 root

tc qdisc add dev eth2 root handle 1:0 dsmark indices 8 set_tc_index

tc filter add dev eth2 parent 1:0 protocol ip prio 1 tcindex mask 0xfc shift 2

tc qdisc add dev eth2 parent 1:0 handle 2:0 htb

tc class add dev eth2 parent 2:0 classid 2:1 htb rate 2.4Mbit
# tc class add dev eth2 parent 2:1 classid 2:10 htb rate 1Mbit ceil 1Mbit
# tc class add dev eth2 parent 2:1 classid 2:20 htb rate 500kbit ceil 500kbit
# tc class add dev eth2 parent 2:1 classid 2:30 htb rate 400kbit ceil 400kbit
# tc class add dev eth2 parent 2:1 classid 2:40 htb rate 200kbit ceil 200kbit

# Nuevas modificaciones
tc class add dev eth2 parent 2:1 classid 2:10 htb rate 1Mbit ceil 2.4Mbit
tc class add dev eth2 parent 2:1 classid 2:20 htb rate 500kbit ceil 2.4Mbit
tc class add dev eth2 parent 2:1 classid 2:30 htb rate 400kbit ceil 2.4Mbit
tc class add dev eth2 parent 2:1 classid 2:40 htb rate 200kbit ceil 2.4Mbit

tc filter add dev eth2 parent 2:0 protocol ip prio 1 handle 0x2e tcindex classid 2:10
tc filter add dev eth2 parent 2:0 protocol ip prio 1 handle 0x1a tcindex classid 2:20
tc filter add dev eth2 parent 2:0 protocol ip prio 1 handle 0x12 tcindex classid 2:30
tc filter add dev eth2 parent 2:0 protocol ip prio 1 handle 0x0a tcindex classid 2:40