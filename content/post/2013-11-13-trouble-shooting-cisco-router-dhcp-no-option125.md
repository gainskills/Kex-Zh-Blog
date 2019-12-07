---
title:      "Trouble shooting: Cisco router DHCP No option 125"
subtitle:   ""
description: "DHCP Option 125"
date:       2013-11-13
tags:
    - Cisco
    - DHCP
    - IOS
    - IPPhone
    - Troubleshooting
published: true
image:      ""
postWithImg: true
categories:
    - Network
URL: "/2013/11/13/trouble-shooting-cisco-router-dhcp-no-option125/"
#wechat pay & alipay & Paypal
reward: true
---
Topology:

{{< imgproc imgPath="2013/11/1-opt.png" alt="Topo" max-height="300" >}}

Configure DHCP on Cisco router 2811 to assign a static IP to the italkBB: Cisco SPA 1202.

1. start DHCP service by command:

    ~~~bash
    service dhcp
    ~~~


2. debug on Cisco router to check DHCP request by the commands:

    ~~~bash
    debug ip dhcp server packet
    terminal monitor
    ~~~

    Debug info :

    ~~~log
    DHCPD: DHCPREQUEST received from client 0100.1c23.3541.98
    ~~~


3. configure DHCP

    ~~~bash
    ip dhcp pool ItalkBB
        host 10.0.0.127 255.255.255.0 //no mask configured, IP’s class mask assigned
        client-identifier 0100.1c23.3541
        default-router 10.10.10.99
    ~~~

    But italkBB can’t get IP from Cisco router 2811, and the error msg in debug info is:

    ~~~
    DHCPD: client’s VPN is .
    DHCPD: No option 125
    ~~~

    Checked DHCPREQUEST on Cisco Router in debugging mode:

    ~~~
    DHCPD: DHCPREQUEST received from client 0100.1c23.3541.98
    ~~~


4. change client-identifier by command:

    ~~~bash
    client-identifier  0100.1c23.3541.98
    ~~~

ItalkBB works.

Note: from my understanding, the MAC of the iTalkBB should be '0100.1c23.3541', in fact, the suffix: '.98' is required as a part of the identifier.

The basic config file  for configuring DHCP SERVER on Cisco router

~~~bash
service dhcp
no ip dhcp conflict logging
!
ip dhcp pool 1
 network 11.0.0.0 255.0.0.0
 default-router 11.0.0.1
!
interface GigabitEthernet0/1
 ip address 11.0.0.1 255.0.0.0
~~~

A case from blog : [Embedded System Testing Blog](http://www.embeddedsystemtesting.com/2013/07/no-option-125-error-from-cisco-dhcp.html)

> “No option 125” error from Cisco DHCP server
> Problem : “No option 125” error was continuously repeating and DHCP Server on Cisco was not offering any IP address to the clients.
> ~~~log
Jul 24 05:36:21.147: DHCPD: No option 125
Jul 24 05:36:21.147: DHCPD: DHCPDISCOVER received from client 001e.e5dc.ae.c0 on interface GigabitEthernet0/1.
Jul 24 05:36:30.707: DHCPD: client’s VPN is .
Jul 24 05:36:30.707: DHCPD: No option 125
~~~
> Solution: After some debugging, came to know that the problem is with the subnet configured on the Gigabit ethernet. For DHCP Server to offer the IP address at least one interface should be in the same network as the pool is defined. Once the subnet is properly configured, the Server started replying.
