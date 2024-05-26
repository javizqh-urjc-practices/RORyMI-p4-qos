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

tc qdisc add dev eth1 root handle 1: tbf rate 1.5Mbit burst 10k latency 20s

tc qdisc add dev eth1 parent 1:0 handle 10:0 prio
tc filter add dev eth1 parent 10:0 prio 1 protocol ip u32 match ip src 11.209.0.10/32 flowid 10:1
tc filter add dev eth1 parent 10:0 prio 2 protocol ip u32 match ip src 11.209.0.20/32 flowid 10:2