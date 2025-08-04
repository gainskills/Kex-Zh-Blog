---
title:      "Run PaloAlto VM on EVE(UNL)/virtualbox/OSX"
subtitle:   ""
description: "Eve/UNL trick"
date:       2018-01-25
tags:
    - PaloAlto
    - Simulator
    - Security
    - IPSec
publishDate: 2018-01-25
image:      ""
postWithImg: true
categories:
    - Network
#wechat pay & alipay & Paypal
reward: true
URL: "/2018/01/25/run-paloalto-vm-on-eve-unl-virtualbox-osx/"
---
I tried to run Palo Alto on EVE/Virtualbox/Apple MAC OS and found it fails to start the Palo Alto Firewall. So I decided to find the root cause. (EVE suggests the users use VMware, I used VirtualBox instead because I don’t have a VMware Fusion license)

1. I went through EVE logs 1st.

    System -> System logs -> unl_wrapper.txt

    {{< imgproc imgPath="2018/01/13-opt.png" alt="Log" max-height="200" >}}

    and found the log:

    ~~~text
    Jan 25 05:18:13 INFO: starting /opt/unetlab/wrappers/qemu_wrapper -T 0 -D 3 -t "PaloAlto" -F /opt/qemu/bin/qemu-system-x86_64 -d 0 -- -nographic -device e1000,netdev=net0,mac=50:00:00:03:00:00 -netdev tap,id=net0,ifname=vunl0_3_0,script=no -device e1000,netdev=net1,mac=50:00:00:03:00:01 -netdev tap,id=net1,ifname=vunl0_3_1,script=no -device e1000,netdev=net2,mac=50:00:00:03:00:02 -netdev tap,id=net2,ifname=vunl0_3_2,script=no -device e1000,netdev=net3,mac=50:00:00:03:00:03 -netdev tap,id=net3,ifname=vunl0_3_3,script=no -smp 2 -m 4096 -name PaloAlto -uuid 934e653f-accd-4ce0-a243-369f853b4add -drive file=virtioa.qcow2,if=virtio,bus=0,unit=0,cache=none -machine type=pc-1.0,accel=kvm -nographic -rtc base=utc > /opt/unetlab/tmp/0/a0fab94b-9b39-4226-884b-894ff4942d65/3/wrapper.txt 2>&1 &

    Jan 25 05:18:13 INFO: CWD is /opt/unetlab/tmp/0/a0fab94b-9b39-4226-884b-894ff4942d65/3

    Jan 25 05:18:13 ERROR: QEMU Arch is not set (80015).
    ~~~

2. Start Palo Alto manually

    From the log, you can find the qemu command, so I copied the command and run it from the console, got the error

    ~~~bash
    Could not access KVM kernel module
    ~~~

    I followed the [link](https://stackoverflow.com/questions/14542754/qemu-kvm-kernel-module-no-such-file-or-directory/14542779#14542779) about KVM kernel module and found the CPU doesn’t support KVM.

    also found VirtualBox [Ticket#4032](https://www.virtualbox.org/ticket/4032).

3. make it work

    Depends on #2, edit Palo Alto VM and remove ‘,accel=kvm’ option:

    {{< imgproc imgPath="2018/01/12-opt.jpg" alt="Qemu Options" max-height="70" >}}

    it works.

2018-01-05 update:

- Removing the 'kvm' option means worse performance.
- VMware has a free product: [VMware Workstation Player](https://www.vmware.com/products/workstation-player/workstation-player-evaluation.html) for Linux and windows.
