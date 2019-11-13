---
title:      "MAC OS-Wireshark/VNC与EVE-NG(UNL)的集成"
subtitle:   ""
description: "EVE(UNL) and wireshark"
date:       2018-12-17
tags:
    - Simulator
    - OSX
    - Translation
    - Wireshark
published: true 
image:      ""
Lang: "zh"
categories:
    - Network
#wechat pay & alipay & Paypal
reward: true
URL: "/2018/12/17/wireshark-vnc-integrate-eve-ngunlonosx/"
---
##### 版权声明：以下链接是本文的原文，对本文及原文任何内容、链接的转发、引用请务必标注以下链接:

- [https://www.802101.com/unetlab-and-wireshark-for-osx-update/](https://www.802101.com/unetlab-and-wireshark-for-osx-update/)
- [https://www.802101.com/wireshark-integration-with-unetlab-on-osx/](https://www.802101.com/wireshark-integration-with-unetlab-on-osx/)

解决思路：

MAC OX上没有为URL中’capture://’前缀协议关联程序，我们可以编辑系统中已经存在的条目，但按需添加并不简单。

所以需要创建一个关联程序，并由它调用WireShark。此功能可以通过AppleScript实现，并实现关联’capture://’及调用Wireshark.

wireshark集成工具的下载链接： [Google Drive](https://sites.google.com/site/802101files/books/UNL_WiresharkV2.zip?attredirects=0)

[百度网盘](https://pan.baidu.com/s/1clyzlKwI9zZ6QgA-6qRsqw) 提取码: iycy  解压密码：www.802101.com

工具Demo video： [Youtube](https://www.youtube.com/watch?time_continue=4&v=JRk9ZsgNwr4),  [秒拍](https://www.802101.com/changing-url-handlers-in-osx/)

扩展：

- [VNC远程桌面集成](https://www.802101.com/changing-url-handlers-in-osx/)
- EVE-NG专业版已经实现wireshark的集成，可忽略此方案