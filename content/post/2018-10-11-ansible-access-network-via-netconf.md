---
title:      "Ansible-Access Network via Netconf"
subtitle:   ""
description: "Ansible Beginner Series"
date:       2018-10-11
tags:
    - Ansible
    - Cisco
    - Python
published: true
image:      ""
postWithImg: true
categories:
    - Code
    - DevOps
    - Network
#wechat pay & alipay & Paypal
reward: true
URL: "/2018/10/11/ansible-access-network-netconf/"
---
Continue to try ansible with the device which was configure in [netconf feature on Cisco IOS/IOSXE](/2018/10/07/netconf-feature-on-cisco-ios-iosxe/).

Ansible Inventory:

~~~yaml
---
netconf:
hosts:
    netconfIos:
    ansible_host: "172.16.254.100"
    ansible_network_os: "ios"
    ansible_ssh_port: 22
    netconfJunos:
    ansible_host: "172.16.254.9"
    ansible_network_os: "junos"
    ansible_ssh_port: 830
vars:
    ansible_connection: "netconf"
    ansible_ssh_user: test
    ansible_ssh_pass: test123
~~~

***Note:***

1. ansible_connnection should be ‘netconf’
2. Be careful on the netconf port, it should be 22 if you enable netconf over SSH (the default port is 830)

PlayBook:

~~~yaml
- name: IOS
hosts: netconfIos
gather_facts: false
tasks:
    - name: Get config for IOS devices
    netconf_get:
        source: running
    register: iosnetconf

    - name: Display output
    debug:
        msg: "{{ iosnetconf.stdout }}"
~~~

***Note:***

1. I tried module: ios_facts with the error:

    ~~~bash
    fatal: [netconfIos]: FAILED! => {“changed” : false, “msg”: “Connection type netconf is not valid for this module”}.
    ~~~

    This is why I choose [netconf_get](https://docs.ansible.com/ansible/latest/modules/netconf_get_module.html).

    BTW: I tried the module: junos_facts on Juniper device, works.

2. With return values of [netconf_get](https://docs.ansible.com/ansible/latest/modules/netconf_get_module.html#return-values) module and Register variables of Ansible, you can verify the output of netconf request.

Run PlayBook

~~~bash
ansible-playbook -i inventory_netconf.yml pb_netconf.yml
~~~

{{< imgproc imgPath="2018/10/2-opt.png" alt="netconf" max-height="280" >}}
