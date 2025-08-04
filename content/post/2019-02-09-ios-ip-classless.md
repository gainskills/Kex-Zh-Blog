---
title:      "IOS command:IP classless"
subtitle:   ""
description: "Practice on Cisco IOS Router"
date:       2019-02-09
tags:
    - Cisco
    - IOS
    - Simulator
    - Route
    - Tip
publishDate: 2019-02-09
image:      ""
postWithImg: true
categories:
    - Network
#wechat pay & alipay & Paypal
reward: true
URL: "/2019/02/09/ios-ip-classless/"
---
I wrote down this article in 2009-03-13 when I was looking for my first job. Taking this again today as preparation for CCNP.

##### Topology:
{{< imgproc imgPath="2019/02/02-opt.png" alt="Topology" max-height="130" >}}

##### Configuration

1. Configured IP addresses on the routers<br>
    Note: The subnets of R1's Loopback1 and R2's Loopback1 belong to the class A address.
2. Execute command "ip classless" on both R1 and R2 (The command has been the default since IOS 11.3)
3. Configure static routes

    {{< highlight bash >}}
R1(config)#ip route 0.0.0.0 0.0.0.0 192.168.12.2 {{< /highlight >}}
    {{< highlight bash >}}
R2(config)#ip route 10.1.1.0 255.255.255.0 192.168.12.1 {{< /highlight >}}

4. Ping

    {{< highlight bash >}}
R1#ping 2.2.2.2
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 2.2.2.2, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/1 ms
R1#ping 10.2.2.2
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.2.2.2, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/3 ms{{< /highlight >}}

5. no IP classless

    {{< highlight bash >}}
R1(config)#no ip classless{{< /highlight >}}
    {{< highlight bash >}}
R2(config)#no ip classless{{< /highlight >}}

6. Ping again
    {{< highlight bash "hl_lines=6 7 21 22" >}}
R1#ping 2.2.2.2
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 2.2.2.2, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/4 ms
R1#ping 10.2.2.2.2
% Unrecognized host or address, or protocol not running.
R1#show ip route
Codes: L - local, C - connected, S - static, R - RIP, M - mobile, B - BGP
       D - EIGRP, EX - EIGRP external, O - OSPF, IA - OSPF inter area
       N1 - OSPF NSSA external type 1, N2 - OSPF NSSA external type 2
       E1 - OSPF external type 1, E2 - OSPF external type 2
       i - IS-IS, su - IS-IS summary, L1 - IS-IS level-1, L2 - IS-IS level-2
       ia - IS-IS inter area, * - candidate default, U - per-user static route
       o - ODR, P - periodic downloaded static route, H - NHRP, l - LISP
       a - application route
       + - replicated route, % - next hop override

Gateway of last resort is 192.168.12.2 to network 0.0.0.0

S*    0.0.0.0/0 [1/0] via 192.168.12.2
      10.0.0.0/8 is variably subnetted, 2 subnets, 2 masks
C        10.1.1.0/24 is directly connected, Loopback0
L        10.1.1.1/32 is directly connected, Loopback0
      192.168.12.0/24 is variably subnetted, 2 subnets, 2 masks
C        192.168.12.0/24 is directly connected, Ethernet0/0
L        192.168.12.1/32 is directly connected, Ethernet0/0{{< /highlight >}}

    <strong>On Router1:
    - It failed to ping 10.2.2.2 with default route still present
    - 2.2.2.2 still works</strong>

##### Conclusion

With the default route: 0.0.0.0/0, The connectivity from R1 to 10.2.2.0/24 (on R2) depends on the command: ```ip classless```.

- With 'ip classless'<br>
    The packets will be forwarded by following the default route.
- With '**no** ip classless'<br>
    If the route entry of class A exists in the routing table, the router will forward the packets by following the entry instead of the default route.
