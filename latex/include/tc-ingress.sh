#!/bin/sh

tc qdisc del dev eth0 ingress
tc qdisc add dev eth0 ingress handle ffff:

tc filter add dev eth0 parent ffff: \
        protocol ip prio 4 u32 \
        match ip src 11.209.0.10/32 \
        police rate 1mbit burst 10k drop flowid :1

tc filter add dev eth0 parent ffff: \
        protocol ip prio 5 u32 \
        match ip src 11.209.0.20/32 \
        police rate 2mbit burst 10k drop flowid :2