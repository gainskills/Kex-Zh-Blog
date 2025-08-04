---
title:      "Mininet-ImportError: customClass"
subtitle:   ""
description: "A note about Mininet installation"
date:       2018-07-20
tags:
    - Simulator
    - Mininet
    - Troubleshooting
    - Network
    - Python
publishDate: 2018-07-20
image:      ""
postWithImg: true
categories:
    - Code
#wechat pay & alipay & Paypal
reward: true
URL: "/2018/07/20/mininet-importerror-customclass/"
---
I tried to run miniedit.py after I have mininet installed, unfortunately, I got the error:

~~~python
ImportError: cannot import name customClass.
~~~

{{< imgproc imgPath="2018/07/2-opt.png" alt="Error" max-height="100" >}}

Checked the py file: ~/mininet/mininet/util.py and miniedity.py, find nothing is wrong, search on the Internet, got no clue.

Suddenly I found the version is not the version I wanted to install (I forgot to take a screenshot, the version should be 2.2.2daily something).

I guess there must be something wrong with the latest version, or there is something conflict with my previous version (mininet 2.0.0 was installed on the PC before).

**Resolution:**

Follow the [official guide](http://mininet.org/download/) to remove all mininet by following [Option3](http://mininet.org/download/#option-3-installation-from-packages), and install it again by following [Option2](http://mininet.org/download/#option-2-native-installation-from-source), it works then:

{{< imgproc imgPath="2018/07/3-opt.png" alt="run mininet" max-height="300" >}}
