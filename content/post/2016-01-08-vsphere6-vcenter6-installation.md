---
layout:     post
title:      "VSphere6, VCenter6 Installation"
subtitle:   ""
description: "VMware6 Installation"
date:       2016-01-08
tags:
    - VMWare
    - Installation
    - Troubleshooting
    - Windows
published: true
image:      ""
postWithImg: true
categories:
    - Network
    - OS
#wechat pay & alipay & Paypal
reward: true
URL: "/2016/01/08/vsphere6-vcenter6-installation/"
---
1. Crash happened when I install Vsphere on my PC

    Solution: Disable option "Limit Maximum CPUID" in Bios

2. VCenter appliance deployment

    Vmware doesn't provide vcenter appliance in ova/ovf format anymore, follow the [instruction](http://www.vladan.fr/vmware-vcenter-6-0-u1-vcsa-how-to-install-configure/) to deploy it.

3. Inventory is empty in the VCenter webpage

    The most important thing: Don't login vcenter by the account 'root', instead of it using SSO account. the account in the format: 'administrator@domain-name'

    Also, Vmware has a KB about this issue:

    To resolve the time synchronization problem, ensure that the system times on the vSphere Web Client system and vCenter Server system differ by no more than 5 minutes

    Access: https://vcenter:5480 to configure the server's time

4. Error Installing VMRC 8.0 on Windows 10

    Follow the [instruction](http://www.virtual-allan.com/?p=610): The solution is to start the installer from an elevated command prompt "Run as Administrator", and then run the MSI packages from here.

5. Serial port over network

    {{< imgproc imgPath="2016/01/1-opt.jpg" alt="Setting1" max-height="200" >}}

    Make sure the service was permitted in:

    {{< imgproc imgPath="2016/01/2-opt.jpg" alt="Setting2" max-height="300" >}}
