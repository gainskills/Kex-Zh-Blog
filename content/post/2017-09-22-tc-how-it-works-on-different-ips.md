---
layout:     post
title:      "tc-How it work on different IPs"
subtitle:   ""
description: "A sample"
date:       "2017-09-22"
tags:
    - Tip
    - Linux
    - tc
    - Traffic Control
published: true
image:      ""
categories:
    - OS
    - Network
URL: "/2017/09/22/tc-how-it-works-on-different-ips/"
#wechat pay & alipay & Paypal
reward: true
---
~~~bash
#!/bin/bash
interface=eth0
ip1=192.168.1.1
ip2=172.16.1.1
delay1=100ms
delay2=200ms
tc qdisc add dev $interface root handle 1: prio
tc qdisc add dev $interface parent 1:1 netem delay $delay1 10ms 25%
tc filter add dev $interface parent 1: protocol ip prio 1 u32 match ip dst $ip1 flowid 1:1
tc qdisc add dev $interface parent 1:2 netem delay $delay2 10ms 25%
tc filter add dev $interface parent 1: protocol ip prio 2 u32 match ip dst $ip2 flowid 1:2
~~~
