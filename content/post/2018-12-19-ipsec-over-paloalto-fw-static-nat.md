---
title:      "IPSec Over Palo Alto FW Static NAT"
subtitle:   ""
description: "A Guide about Palo Alto firewall configuration"
date:       2018-12-19
tags:
    - PaloAlto
    - IPSec
    - Security
    - Tip
    - NAT
published: true 
image:      ""
postWithImg: true
categories:
    - Network
#wechat pay & alipay & Paypal
reward: true
URL: "/2018/12/19/ipsec-over-paloalto-fw-static-nat/"
---
It took me about 2 hours on the following scenario and the root cause was located: lacking a static route on Palo Alto, so I decided to summarize every step here for further reference. Here is the topology on EVE-NG:

{{< imgproc imgPath="2018/12/14-opt.png" alt="Topology" max-height="180" >}}

- The left part is the office, and the right part is Internet
- 10.0.56.5 of R6 was NATed to IP: 10.0.17.3 by Palo Alto which establishes IPSec tunnel with R8: 10.0.78.8
- Traffic from 5.5.5.0/24 to 8.8.8.0/24 will be forward over the #1 IPSec
- All device in ‘LAN’ could access ‘Internet’ via Port Translation

##### 1. Initial Palo Alto

Console access Palo Alto with username/password: admin/admin, and configure MGMT IP 172.16.185.132 (I have bridged the MGMT interface of Palo Alto to my laptop). Here are the commands for the initialization:

~~~bash
configure
edit deviceconfig system
set ip-address 172.16.185.132 netmask 255.255.255.0
commit
~~~

Note: Executing ‘commit’ on CLI or Web GUI after the modification.

##### 2. Navigate https://172.16.185.132 (MGMT IP of Palo Alto Firewall) in the browser

login with the username/password: admin/admin (default username/password)

{{< imgproc imgPath="2018/12/15-opt.png" alt="Dashboard" max-height="180" >}}

##### 3. Configure Interface Profiles

Policy: Permit ping traffic from both LAN and Internet to Palo Alto interfaces for connectives testing

{{< imgproc imgPath="2018/12/16-opt.png" alt="Interface management profile" max-height="500" >}}

##### 4. Configure interface: ethernet1/1

{{< imgproc imgPath="2018/12/17-opt.png" alt="Interface configuration-Zone-1" max-height="400" >}}

{{< imgproc imgPath="2018/12/18-opt.png" alt="Interface configuration-Zone-2" max-height="400" >}}

{{< imgproc imgPath="2018/12/19-opt.png" alt="Interface configuration-IP Address-1" max-height="380" >}}

{{< imgproc imgPath="2018/12/20-opt.png" alt="Interface configuration-IP Address-2" max-height="220" >}}

{{< imgproc imgPath="2018/12/21-opt.png" alt="Interface configuration-Management Profile" max-height="300" >}}

##### 5. Configure interface: ethernet1/2

Almost same steps to ethernet1/1 but with different IP and Zone – IP: 10.0.17.1/24, Zone: Internet.

##### 6. Configured IPs, routing protocol on R5, R6, R7, R8 then run connectivity testing.

- R5: Ethernet0/0 – 10.0.56.5/24, Ethernet0/1 – 10.0.15.5/24, Loopback0: 5.5.5.5/24, Default route with gateway: 10.0.15.1
- R6: Ethernet0/0 – 10.0.56.6/24, Default route with gateway: 10.0.56.5
- R7: Ethernet0/0 – 10.0.78.7/24, Ethernet0/2 – 10.0.17.7/24
- R8: Ethernet0/0 – 10.0.78.8/24, Loopback0 – 8.8.8. /24, Static route to 10.0.17.0/24 with next hop: 10.0.78.7

##### 7. Configure routing on Palo Alto

Default route with next hop: 10.0.17.7

Static route to 10.0.56.0/24 with next hop 10.0.15.5

{{< imgproc imgPath="2018/12/22-opt.png" alt="Route" max-height="360" >}}

##### 8. Configure PAT for Requirement #4: traffic from LAN to Internet

{{< imgproc imgPath="2018/12/23-opt.png" alt="PAT-1" max-height="360" >}}

{{< imgproc imgPath="2018/12/26-opt.png" alt="PAT-2" max-height="360" >}}

{{< imgproc imgPath="2018/12/24-opt.png" alt="PAT-3" max-height="360" >}}

##### 9. Service Group

Creating Service and Security Group before the Security policy for IPSec traffic: UDP 500 and UDP 4500

{{< imgproc imgPath="2018/12/34-opt.png" alt="Service" max-height="280" >}}

{{< imgproc imgPath="2018/12/35-opt.png" alt="Service group" max-height="330" >}}

##### 10. Configure NAT for requirement #3 – IPSec

{{< imgproc imgPath="2018/12/36-opt.png" alt="NAT-1" max-height="330" >}}

Note: The destination Address is the IP of Peer IP, the IP is:10.0.78.8 /32 in my case.

{{< imgproc imgPath="2018/12/25-opt.png" alt="NAT-2" max-height="330" >}}

- Optional: Set Service to ‘Any’ for all applications

    {{< imgproc imgPath="2018/12/29-opt.png" alt="Optional: Service Any" max-height="330" >}}

Palo Alto-NAT/PAT-Overall view of Step 9 and Step 10

{{< imgproc imgPath="2018/12/37-opt.png" alt="NAT/PAT-Overall view of Step 9 and Step 10" max-height="330" >}}

##### 11. Policy for LAN/Internet

Since LAN and Internet are two different zones, security policies are required for the traffic. From LAN to Internet:

{{< imgproc imgPath="2018/12/30-opt.png" alt="Security Policy-1" max-height="330" >}}

{{< imgproc imgPath="2018/12/31-opt.png" alt="Security Policy-2" max-height="330" >}}

{{< imgproc imgPath="2018/12/32-opt.png" alt="Security Policy-3" max-height="330" >}}

{{< imgproc imgPath="2018/12/33-opt.png" alt="Security Policy-4" max-height="330" >}}

##### 12. Security policy for IPSec

{{< imgproc imgPath="2018/12/39-opt.png" alt="Security Policy" max-height="330" >}}

##### 13. Verify connectives on all routers

Note: Security policy for Ping traffic in two different Zones, Ping will fail if only the application: ICMP was permitted, [the service: ‘Ping’ is also required](https://knowledgebase.paloaltonetworks.com/KCSArticleDetail?id=kA10g000000ClIoCAK).

##### 14. Configure IPSec on R6 and R8.

Check all routers configuration from [here](https://gist.github.com/gainskills/29bcf7b9c8bf2a8121e3ae6c8fcbdda5).

##### 15. On R5, execute ‘ping 8.8.8.8 source 5.5.5.5’

~~~bash
LAN-R5#ping 8.8.8.8 source 5.5.5.5
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 8.8.8.8, timeout is 2 seconds:
Packet sent with a source address of 5.5.5.5
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 2/3/7 ms
~~~

~~~bash
LAN-R6#show crypto isakmp sa
IPv4 Crypto ISAKMP SA
dst src state conn-id status
10.0.78.8 10.0.56.6 QM_IDLE 1001 ACTIVE
IPv6 Crypto ISAKMP SA
~~~

~~~bash
Internet-R8#show crypto isakmp sa
IPv4 Crypto ISAKMP SA
dst src state conn-id status
10.0.78.8 10.0.17.3 QM_IDLE 1001 ACTIVE
IPv6 Crypto ISAKMP SA
~~~

##### Others

1. Permit the ICMP traffic to NATed IP for monitoring purpose [Udate @ 2019-02-14]

    - For outside interface (Port Translation)

        It's eth1/2 in this case, please refer to [13. Verify connectives on all routers
](#13-verify-connectives-on-all-routers) - interface management profile configuration.

    - For NATed IP

        Setup the NAT:
        {{< imgproc imgPath="2018/12/45-opt.png" alt="NAT for ICMP from Internet" max-height="330" >}}

        Update both source IP of NAT entry and [Security policy for IPSec](#12-security-policy-for-ipsec) to permit the traffic in.<br>
        Note: For the Security policy: <code>Service</code> field should be <code>any</code>, <code>icmp</code> must be defined in <code>Application</code> field.

        Reference: [Dynamic IP and Port NAT for ICMP traffic](https://knowledgebase.paloaltonetworks.com/KCSArticleDetail?id=kA10g000000ClJuCAK)