#!/bin/sh

tc qdisc del dev eth0 ingress
tc qdisc del dev eth1 root

tc qdisc add dev eth0 ingress handle ffff:

tc filter add dev eth0 parent ffff: \
        protocol ip prio 4 u32 \
        match ip src 11.209.0.10/32 \
        police rate 1mbit burst 10k drop flowid :1

tc filter add dev eth0 parent ffff: \
        protocol ip prio 5 u32 \
        match ip src 11.209.0.20/32 \
        police rate 2mbit burst 10k drop flowid :2

tc qdisc add dev eth1 root handle 1:0 htb

tc class add dev eth1 parent 1:0 classid 1:1 htb rate 1.2Mbit
# tc class add dev eth1 parent 1:1 classid 1:2 htb rate 700kbit ceil 700kbit
tc class add dev eth1 parent 1:1 classid 1:2 htb rate 700kbit ceil 1.2Mbit
# tc class add dev eth1 parent 1:1 classid 1:3 htb rate 500kbit ceil 500kbit
tc class add dev eth1 parent 1:1 classid 1:3 htb rate 500kbit ceil 1.2Mbit

tc filter add dev eth1 parent 1:0 protocol ip prio 1 u32 match ip src 11.209.0.10 flowid 1:2
tc filter add dev eth1 parent 1:0 protocol ip prio 1 u32 match ip src 11.209.0.20 flowid 1:3