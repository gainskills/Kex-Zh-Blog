---
title:      "Dynagen/Dynamips error: netio_desc_create_udp: unable to connect to"
subtitle:   ""
description: "A Dynagen/Dynamips error"
date:       "2013-12-20"
tags:
    - Troubleshooting
    - Simulator
    - GNS3
    - Dynagen
published: true
image:      ""
categories:
    - Network
URL: "/2013/12/20/dynagen-dynamips-error-netio_desc-create-udp-unable-to-connect-to/"
#wechat pay & alipay & Paypal
reward: true
---
- OS: CentOS 6.5 x86_64 installed on vmware
- Dynamips 0.2.10

There is an error when loading a .net file named as test.net with 100 devices in Dynagen.0.11.0:

~~~bash
netio_desc_create_udp: unable to connect to
~~~

I searched on the Internet about this error msg, most of posts shared a method: specified UDP port of dynamips instance in .net file. But it doesn’t work for me.

As I found a Dynagen description in [GNS3 website](http://www.gns3.net/dynagen/):
however Dynagen is still updated and developed for GNS3, this means you can download [GNS3 sources](http://www.gns3.net/download/), find Dynagen in it.

I downloaded it and found Dynagen version in the package is **0.13.1**, newer than official one: **0.11.0**; and the _test.net_ can be loaded successfully:

~~~bash
chmod +x dynagen.py
./dynagen.py test.net
~~~
