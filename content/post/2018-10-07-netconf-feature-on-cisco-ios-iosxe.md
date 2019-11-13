---
title:      "Netconf feature on Cisco IOS/IOSXE"
subtitle:   ""
description: "Ansible Beginner Series"
date:       2018-10-07
tags:
    - Ansible
    - Cisco
    - IOS
    - Cisco XE
    - NetConf
    - Troubleshooting
    - Python
published: true
image:      ""
postWithImg: true
categories:
    - DevOps
    - Code
    - Network
#wechat pay & alipay & Paypal
reward: true
URL: "/2018/10/07/netconf-feature-on-cisco-ios-iosxe/"
---
I tried to see how ansible works with the netconf feature on Cisco and Juniper in past days: [Juniper’s official document](https://www.juniper.net/documentation/en_US/junos/topics/topic-map/netconf-ssh-connection.html) is clear and easy to follow. but for Cisco, I followed [NETCONF over SSHv2](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/cns/configuration/xe-3s/cns-xe-3s-book/netconf-sshv2.pdf), unfortunately, I was stuck on it for 6 days.

**OS Version**

- Cisco IOS XE Software, Version 16.04.01
- Cisco IOS Software, Linux Software (I86BI_LINUXL2-IPBASEK9-M), Experimental Version 15.2(20170809:194209) [dstivers-aug9_]

**NetConf Requests**

Tried many requests, all failed:

1. The hello (works) request:

    ~~~xml
    <?xml version=”1.0″ encoding=”UTF-8″?>
    <hello>
    <capabilities>
    <capability>
    urn:ietf:params:xml:ns:netconf:base:1.0
    </capability>
    </capabilities>
    </hello>]]>]]>
    ~~~

2. The request with nf: which was mentioned in (Cisco community)[https://community.cisco.com/t5/network-management/netconf-get-config-error-wrong-document-namespaces-not-specified/td-p/3298323]:

    ~~~xml
    <?xml version=”1.0″ encoding=”UTF-8″?>
    <hello xmlns=”urn:ietf:params:xml:ns:netconf:base:1.0″>
    <capabilities>
    <capability>urn:ietf:params:netconf:base:1.0</capability>
    </capabilities>
    </hello>]]>]]>
    <?xml version=”1.0″ encoding=”UTF-8″?>
    <nf:rpc xmlns:nf=”urn:ietf:params:xml:ns:netconf:base:1.0″ message-id=”1″>
    <nf:get-configtype=”subtree”>
    <nf:source>
    <nf:running/>
    </nf:source>
    <nf:filter>
    <nf:config-format-text-block/>
    </nf:filter>
    </nf:get-config>
    </nf:rpc>]]>]]>
    ~~~

    ~~~xml
    <?xml version=”1.0″ encoding=”UTF-8″?>
    <hello xmlns=”urn:ietf:params:xml:ns:netconf:base:1.0″>
    <capabilities>
    <capability>urn:ietf:params:netconf:base:1.0</capability>
    </capabilities>
    </hello>]]>]]>
    <?xml version=”1.0″ encoding=”UTF-8″?>
    <rpc xmlns:nf=”urn:ietf:params:xml:ns:netconf:base:1.0″ message-id=”101″>
    <get-config>
    <source>
    <running/>
    </source>
    </get-config>
    </rpc>]]>]]>
    ~~~

    ~~~xml
    <?xml version=”1.0″ encoding=”UTF-8″?>
    <hello xmlns=”urn:ietf:params:xml:ns:netconf:base:1.0″>
    <capabilities>
    <capability>urn:ietf:params:netconf:base:1.0</capability>
    </capabilities>
    </hello>]]>]]>
    <?xml version=”1.0″ encoding=”UTF-8″?>
    <rpc xmlns=”urn:ietf:params:xml:ns:netconf:base:1.0″ message-id=”101″>
    <get-config>
    <source>
    <running/>
    </source>
    <filter>
    <config-format-text-block/>
    </filter>
    </get-config>
    </rpc>
    ]]>]]>
    ~~~

    ~~~xml
    <?xml version=”1.0″?>
    <nc:rpc message-id=”1″ xmlns:nc=”urn:ietf:params:xml:ns:netconf:base:1.0″ xmlns=”http://www.cisco.com/nxos:1.0:nfcli”&gt;
    <nc:get>
    <nc:filtertype=”subtree”>
    <show>
    <xml>
    <server>
    <status/>
    </server>
    </xml>
    </show>
    </nc:filter>
    </nc:get>
    </nc:rpc>]]>]]>
    ~~~

**How I test the requests**

1. Send the request after enter the netconf subsystem by the command:

    ~~~bash
    ssh test@device_ip -s netconf
    ~~~

2. The tool: (netconf_client)[https://github.com/nnakamot/netconf_client] (which was mentioned in the Cisco Community).
    I have made some changes so that the tool can run with Python3, here is the link.

***Error Message***

~~~xml
<?xml version=”1.0″ encoding=”UTF-8″?><rpc-reply message-id=”1″ xmlns=”urn:ietf:params:xml:ns:netconf:base:1.0″><rpc-error><error-type>protocol</error-type><error-tag>operation-failed</error-tag><error-severity>error</error-severity></rpc-error></rpc-reply>]]>]]>
~~~

**Solution**

Refer to [NETCONF/YANG を使って、Ciscoルータからコンフィグ設定を取得する(IOS-XE)](https://qiita.com/eiuemura/items/55c5520dba35e7e31b47)

Configure the username password with privilege 15 on devices:

~~~bash
username test privilege 15 password 0 test123
~~~

{{< imgproc imgPath="2018/10/4-opt.png" alt="netconf" max-height="400" >}}
