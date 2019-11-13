---
title:      "Run NX-OSv 9000 on EVE(UNL)"
subtitle:   ""
description: "Eve/UNL trick"
date:       2017-01-08
tags:
    - Cisco
    - Simulator
    - DataCenter
    - Nexus9K
    - Tip
published: true 
image:      ""
postWithImg: true
categories:
    - Network
#wechat pay & alipay & Paypal
reward: true
URL: "/2017/01/08/run-nx-osv-9000-on-eve-unl/"
---
Refer to [how to add NX-OXv 9000 to GNS3](https://adosztal.blogspot.com/2016/12/how-to-add-nx-osv-9000-to-gns3.html)

#### 1. Download image files

Here is the NX-OSv9k [image](https://software.cisco.com/download/release.html?mdfid=286312239&flowid=81422&softwareid=282088129&release=7.0(3)I5(1)&relind=AVAILABLE&rellifecycle=&reltype=latest) file from Cisco (nxosv-final.7.0.3.I5.1.qcow2). Please note that you must have a service contract with Cisco in order to download it.

**No I can’t provide the image with anyone.**

#### 2. Copy image to eve(UNL)

change file name to ‘hda.qcow2’

copy source file to ‘/opt/unetlab/addons/qemu/nxosv9k-7.0.3.I5.1’

run

~~~bash
/opt/unetlab/wrappers/unl_wrapper -a fixpermissions
~~~

#### 3. Add a New node for nxosv9k

Copy the [php file](https://gitlab.com/hanbaobao2005/eve-ng-public/blob/master/html/templates/nxosv9k.php) to '/opt/unetlab/html/templates/'

Change the Console type to ‘telnet’

#### 4. Start the node

Note: Change the Console to 'telnet' before you start the node.

This step needs your patient because the terminal will be shown as a blank screen for a while(about 15 – 20 seconds). The boot process takes about minutes, then t will prompts you:

~~~bash
Abort Auto Provisioning and continue with normal setup ?(yes/no)[n]: y
~~~

#### 5. Done

{{< imgproc imgPath="2017/01/1-opt.png" alt="Done" max-height="300" >}}

The advantage of eve is it already improved Qemu with UEFI for Cisco Nexus9Kv.
More info:

* [How to run OVMF (Qemu with UEFI fireware)](https://github.com/tianocore/tianocore.github.io/wiki/How-to-run-OVMF)

* Refer to the files in /opt/unetlab/html/templates for hda folder name
* Refer to the specified file in /opt/unetlab/html/templates for hda file name

    E.g.: You could learn that ‘nxosv-final.7.0.3.I5.1.qcow2’ should be changed to ‘hda.qcow2’ from file : nxosv9k.php
* Comment from Sergey for reload issue

    There is a known issue about Nexus reload/shut down:[http://www.cisco.com/c/en/us/td/docs/switches/datacenter/nexus9000/sw/7-x/nx-osv/configuration/guide/b_NX-OSv_9000/b_NX-OSv_9000_chapter_010.html](http://www.cisco.com/c/en/us/td/docs/switches/datacenter/nexus9000/sw/7-x/nx-osv/configuration/guide/b_NX-OSv_9000/b_NX-OSv_9000_chapter_010.html)

    **How to prevent VM from dropping into “loader >” prompt**

    As soon as you set up your NX-OSv 9000 (following set up of POAP interface), you need to configure the boot image in your system to avoid dropping to the “loader >” prompt after reload/shut down.
    Example:

    ~~~bash
    config t
    boot nxos n9000-dk9.7.0.3.I2.0.454.bin
    copy running starting
    ~~~
