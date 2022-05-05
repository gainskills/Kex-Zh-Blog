---
title:      "openwrt DDNS, acme commands"
subtitle:   ""
description: "A note for DDNS, Certificate on Openwrt"
date:       2021-09-15
tags:
    - OPENWRT
    - DDNS
    - Let's Encrypt
    - Certificate
categories:
    - Linux
    - Network
published: true
postWithImg: true
image:      ""
showtoc: false
URL: "/2021/09/15/openwrt-ddns-cert/"
#wechat pay & alipay & Paypal
reward: true
---

I'm using [OpenWrt R21.8.6](https://openwrt.org/releases/21.02/notes-21.02.0) by compile it from [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede).

### 1. Install softwares on Openwrt

- acme
- ddns-scripts (This originally built when compile the firmware)

### 2. DDNS configuration

- DNS System

    Creating a dynamic DNS record on your DNS service provider (Mine is running over [dns.he.net](https://dns.he.net/))

    {{< imgproc imgPath="2021/09/01-opt.jpg" alt="Dynamic DNS A Record - New" max-height="180" >}}

    Generate password for DDNS

    {{< imgproc imgPath="2021/09/02-opt.jpg" alt="Dynamic DNS A Record password - entry" max-height="120" >}}
    {{< imgproc imgPath="2021/09/03-opt.png" alt="Dynamic DNS A Record password - generate" max-height="150" >}}

- Configuration on Openwrt

    Find 'Services' on the top bar, then go to "Dynamic DNS"

    {{< imgproc imgPath="2021/09/04-opt.png" alt="Openwrt DDNS configuration 1" max-height="130" >}}

    Give the record a name and click 'Add' button

    {{< imgproc imgPath="2021/09/05-opt.png" alt="Openwrt DDNS configuration 2" max-height="190" >}}

    Find and switch the DNS service as you're using

    {{< imgproc imgPath="2021/09/06-opt.png" alt="Openwrt DDNS configuration 3" max-height="190" >}}

    Enable the service and enter your dynamic record and password after the UI updated with the provider been switched, click 'Save & Apply' in the corner when the configuration is done

    {{< imgproc imgPath="2021/09/07-opt.png" alt="Openwrt DDNS configuration 4" max-height="220" >}}

    Just in case, check the "Advanced Settings" tab and make sure it is the interface connects to Internet
    
    {{< imgproc imgPath="2021/09/08-opt.png" alt="Openwrt DDNS configuration 5" max-height="130" >}}

    Refresh the page, the process should be running when PID is there in the "Process ID Start / Stop" column

    {{< imgproc imgPath="2021/09/09-opt.png" alt="Openwrt DDNS configuration 5" max-height="80" >}}

    The Process can be started by clicking 'Start' button

    {{< imgproc imgPath="2021/09/10-opt.png" alt="Openwrt DDNS configuration 5" max-height="110" >}}

- Verification

    Check on the DNS system, the record will be updated to the public IP

### 3. Generating Cert by using ACME via DNS API

- Find and download the script for DNS from [acmesh-official/acme.sh](https://github.com/acmesh-official/acme.sh/tree/master/dnsapi)

    For me, I downloaded [dns_he.sh](https://github.com/acmesh-official/acme.sh/blob/master/dnsapi/dns_he.sh)

- Edit the script by adding the username/password

    {{< imgproc imgPath="2021/09/11-opt.png" alt="Openwrt ACME 1" max-height="110" >}}

    **Note: Don't share your credential with others**

- Configuration on Openwrt

    - Install acme service

        {{< highlight shell >}}
root@OpenWrt:~# cd /usr/lib/acme/
root@OpenWrt:/usr/lib/acme# ./acme.sh --install{{</ highlight >}}

        The output when installation is good
        {{< highlight shell >}}
[Fri Sep 17] Installing to /root/.acme.sh
[Fri Sep 17] Installed to /root/.acme.sh/acme.sh
[Fri Sep 17] No profile is found, you will need to go into /root/.acme.sh to use acme.sh
[Fri Sep 17] Installing cron job
[Fri Sep 17] OK{{</ highlight >}}

    - Configuration 

        {{< highlight shell >}}
root@OpenWrt:~# cd /root/.acme.sh
root@OpenWrt:~/.acme.sh# mkdir dnsapi{{</ highlight >}}

    - Upload the file: `dns_he.sh` to the new created folder: `/root/.acme.sh/dnsapi`
    - Certificate generation

        {{< highlight shell >}}
./acme.sh --register-account -m ${your_email} --server letsencrypt --issue --dns dns_he -d ${your_domain_name}{{</ highlight >}}

        The output will be if everything works

        {{< highlight shell >}}
[Fri Sep 17] Using CA: https://acme-v02.api.letsencrypt.org/directory
[Fri Sep 17] Creating domain key
[Fri Sep 17] The domain key is here: /root/.acme.sh/
[Fri Sep 17] Single domain='{__omitted__}'
[Fri Sep 17] Getting domain auth token for each domain
[Fri Sep 17] Getting webroot for domain='{__omitted__}'
[Fri Sep 17] Adding txt value: ___ for domain:  _acme-challenge.{__omitted__}
[Fri Sep 17] Using DNS-01 Hurricane Electric hook
[Fri Sep 17] TXT record added successfully.
[Fri Sep 17] The txt record is added: Success.
[Fri Sep 17] Let's check each DNS record now. Sleep 20 seconds first.
[Fri Sep 17] You can use '--dnssleep' to disable public dns checks.
[Fri Sep 17] See: https://github.com/acmesh-official/acme.sh/wiki/dnscheck
[Fri Sep 17] Checking {__omitted__} for _acme-challenge.{__omitted__}
[Fri Sep 17] Domain {__omitted__} '_acme-challenge.{__omitted__}' success.
[Fri Sep 17] All success, let's return
[Fri Sep 17] Verifying: {__omitted__}
[Fri Sep 17] Success
[Fri Sep 17] Removing DNS records.
[Fri Sep 17] Removing txt: ___ for domain: _acme-challenge.{__omitted__}
[Fri Sep 17] Cleaning up after DNS-01 Hurricane Electric hook
[Fri Sep 17] Record removed successfully.
[Fri Sep 17] Removed: Success
[Fri Sep 17] Verify finished, start to sign.
[Fri Sep 17] Lets finalize the order.
[Fri Sep 17] Le_OrderFinalize='https://acme-v02.api.letsencrypt.org/acme/finalize/163482020/25029386060'
[Fri Sep 17] Downloading cert.
[Fri Sep 17] Le_LinkCert='https://acme-v02.api.letsencrypt.org/acme/cert/03f18ca7f43ee3225f7ff175c2d0ef4cd05a'
[Fri Sep 17] Cert success.
{Certificate key content}
[Fri Sep 17] Your cert is in  /root/.acme.sh/{__omitted__}/{__omitted__}.cer
[Fri Sep 17] Your cert key is in  /root/.acme.sh/{__omitted__}/{__omitted__}.key
[Fri Sep 17] The intermediate CA cert is in  /root/.acme.sh/{__omitted__}/ca.cer
[Fri Sep 17] And the full chain certs is there:  /root/.acme.sh/{__omitted__}/fullchain.cer{{</ highlight >}}

### Reference

- https://openwrt.org/releases/21.02/notes-21.02.0
- https://github.com/coolsnowwolf/lede
- https://dns.he.net/
- https://github.com/acmesh-official/acme.sh
- https://github.com/acmesh-official/acme.sh/wiki/dnsapi
