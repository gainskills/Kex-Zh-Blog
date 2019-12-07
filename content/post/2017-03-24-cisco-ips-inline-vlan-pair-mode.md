---
title:      "Cisco IPS–Inline VLAN Pair mode"
subtitle:   ""
description: "Cisco IPS"
date:       2017-03-24
tags:
    - Cisco
    - Simulator
    - Cisco IPS
    - Security
published: true
image:      ""
postWithImg: true
categories:
    - Network
#wechat pay & alipay & Paypal
reward: true
URL: "/2017/03/24/cisco-ips-inline-vlan-pair-mode/"
---
1. Setup Cisco IPS on EVE

    I failed to setup Cisco IPS on EVE(ver 2.0.3-53). I Downloaded Cisco IPS ova file via [certcollection](http://certcollection.org/forum/topic/270568-ips-4240-ver-7-unholy-darkness/page__hl__%20cisco%20%20ips) ([mega](https://mega.nz/#!W99UnTIa!-3k6bQwiD_DhNCDFfL6TWlU69KoRwIYeaJE9JlDOASY))

    Followed the [instructions](http://certcollection.org/forum/topic/266792-emulating-ips-on-unl/ http://www.cznetlab.cz/index.php?cat=cciesec&subcat=unlips) for IPS Interfaces.

    and met the issue:

    Cisco IPS failed to ping anything out of it, I run traffic capture on IPS’s interface, no packet out when I execute the ping command.

    Related [post](http://www.unetlab.com/forum/viewtopic.php?f=5&t=55&sid=25184c5b3a889925218c20bffb2f180f) on EVE official forum, and the official answer is: This image is corrupted and not working neither on UNL nor EVE

    So, I deploy it on VMware vShpere

    {{< imgproc imgPath="2017/03/1-opt.png" alt="vmware-1" max-height="90" >}}

    Setup VM networks as well

    {{< imgproc imgPath="2017/03/2-opt.png" alt="vmware-2" max-height="300" >}}

    Change VM-IPS’s networks

    {{< imgproc imgPath="2017/03/3-opt.png" alt="vmware-Network-1" max-height="300" >}}

    Change VM-EVE’s networks

    {{< imgproc imgPath="2017/03/4-opt.png" alt="vmware-Network-2" max-height="300" >}}

2. Start the VMS and setup a Lab in EVE

    {{< imgproc imgPath="2017/03/5-opt.png" alt="Topo" max-height="300" >}}

3. Initialize Cisco IPS

    I initialized the device from Cisco IPS console interface.

    {{< imgproc imgPath="2017/03/6-opt.png" alt="Console" max-height="120" >}}

    The default username/password is cisco/ciscoips123

    then enter the command ‘setup‘ to initial the device.

    The most import thing is to disable HTTPS. Cisco IPS enabled https by default and its cert was not supported by most browsers(Chrome/Firefox/IE) now. Execute the following commands:

    ~~~bash
    service web-server
    enable-tls false
    port 80
    exit
    ~~~

    Then access IPS by HTTP, it will prompt you to lunch IDSM(* Java required)

    {{< imgproc imgPath="2017/03/7-opt.png" alt="IPs DM" max-height="320" >}}

    {{< imgproc imgPath="2017/03/8-opt.png" alt="IPs DM Main UI" max-height="320" >}}

4. Configure Interface Pairs

    Before Cisco IPS Interface Pair

    {{< imgproc imgPath="2017/03/9-opt.png" alt="Ping-1" max-height="90" >}}

    Configure Interface Pair

    {{< imgproc imgPath="2017/03/10-opt.png" alt="Interface Pair" max-height="280" >}}

    After Cisco IPS Interface Pair

    {{< imgproc imgPath="2017/03/11-opt.png" alt="Ping-2" max-height="90" >}}

5. Bind vs

    {{< imgproc imgPath="2017/03/12-opt.png" alt="VS-1" max-height="300" >}}

6. Exercise 1 - Recognize ICMP as Attack

    {{< imgproc imgPath="2017/03/13-opt.png" alt="Sig-1" max-height="330" >}}

    {{< imgproc imgPath="2017/03/14-opt.png" alt="Sig-2" max-height="300" >}}

    {{< imgproc imgPath="2017/03/15-opt.png" alt="Sig-3" max-height="120" >}}

    {{< imgproc imgPath="2017/03/16-opt.png" alt="Sig-4" max-height="400" >}}

    Verification: Execute ping command on R1

    {{< imgproc imgPath="2017/03/17-opt.png" alt="ping-3" max-height="90" >}}

    Cisco IPS Event

    {{< imgproc imgPath="2017/03/18-opt.png" alt="Event-1" max-height="360" >}}

    {{< imgproc imgPath="2017/03/19-opt.png" alt="Event-2" max-height="300" >}}
