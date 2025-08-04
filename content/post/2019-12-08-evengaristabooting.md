---
title:      "Run Arista VM 4.2.2 and later version on EVE(UNL)"
subtitle:   ""
description: "Eve/UNL trick"
date:       2019-12-08
tags:
    - Arista
    - Simulator
    - DataCenter
    - Tip
publishDate: 2019-12-08
image:      ""
postWithImg: true
categories:
    - Network
#wechat pay & alipay & Paypal
reward: true
URL: "/2019/12/08/evengaristabooting/"
---
One of my friends did his VXLAN practices, he came to me for help because he was unable to start the Arista instance on EVE-NG.

The Arista vm can be started and stuck at:

{{< imgproc imgPath="2019/12/3-opt.png" alt="Issue" max-height="350" >}}

I did a search and found a clue in the Arista forum, the instance began to work after changed the CPU number to 2:

{{< imgproc imgPath="2019/12/4-opt.png" alt="Issue" max-height="120" >}}
