---
layout:     post
title:      "Adding Realtek 8139 Driver to ESXi6"
subtitle:   ""
description: "VMware EXSi Driver"
date:       2016-11-29
tags:
    - VMWare
    - Linux
    - Driver
    - Installation
    - Troubleshooting
published: true
image:      ""
postWithImg: true
categories:
    - OS
#wechat pay & alipay & Paypal
reward: true
URL: "/2016/11/29/adding-realtek-8139-driver-to-esxi6/"
---
#### Note: This is not an official guide, backup is required before you apply the driver.

My Dell PC has two NICs:

1. Intel I217-LM
2. Realtek RTl-8139

and #2 Realtek 8139 is not supported by VMware EXSi.

There are some guides about customizing EXSi installation ISO to support the NIC, but I’m trying to find a way to apply the driver without reinstall EXSi.

Here is a page which contains many NIC drivers:
[https://vibsdepot.v-front.de/wiki/index.php/List_of_currently_available_ESXi_packages](https://vibsdepot.v-front.de/wiki/index.php/List_of_currently_available_ESXi_packages)

+ Download the offline bundle driver for Realteck 8139 and follow the instruction

    [http://www.vladan.fr/patch-esxi-5-5-to-esxi-6-0/](http://www.vladan.fr/patch-esxi-5-5-to-esxi-6-0/)

+ upload offline bundle to EXSi host
+ change EXSi host to maintenance mode
+ SSH to EXSi

    Apply the driver by command:

    ~~~bash
    esxcli software vib install -d /vmfs/volumes/storage name/net-r8139too-0.9.28-1-offline_bundle.zip –no-sig-check
    ~~~

    you might get the prompt:

    ~~~text
    VIB Realtek_bootbank_net-r8139too_0.9.28-1’s acceptance level is community, which is not compliant with the ImageProfile acceptance level partner
    To change the host acceptance level, use the ‘esxcli software acceptance set’ command.
    ~~~

+ Change the Host Acceptance Level

    Follow the instruction to update the host acceptance level:

    [https://pubs.vmware.com/vsphere-51/index.jsp?topic=%2Fcom.vmware.vsphere.install.doc%2FGUID-6A3AD878-5DE9-4C38-AC86-78CAEED0F710.html](https://pubs.vmware.com/vsphere-51/index.jsp?topic=%2Fcom.vmware.vsphere.install.doc%2FGUID-6A3AD878-5DE9-4C38-AC86-78CAEED0F710.html)

    Command:

    ~~~bash
    esxcli software acceptance set –level=CommunitySupported
    ~~~

+ Apply the driver again:

    ~~~bash
    esxcli software vib install -d /vmfs/volumes/storage name/net-r8139too-0.9.28-1-offline_bundle.zip –no-sig-check
    ~~~

    Installation Result

    ~~~bash
    Message: The update completed successfully, but the system needs to be rebooted for the changes to be effective.
    Reboot Required: true
    VIBs Installed: Realtek_bootbank_net-r8139too_0.9.28-1
    VIBs Removed:
    VIBs Skipped:
    ~~~

+ Reboot EXSi host and Exit maintenance mode

The NIC can be recognized by VMware now:

{{< imgproc imgPath="2016/11/1-opt.png" alt="All Set." max-height="300" >}}
