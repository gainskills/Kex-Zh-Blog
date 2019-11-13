---
title:      "Ansible-Access Network via SSH"
subtitle:   ""
description: "Ansible Beginner Series"
date:       2018-09-04
tags:
    - Ansible
    - Cisco
    - IOS
    - SSH
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
URL: "/2018/09/07/ansible-access-network-via-ssh/"
---
After [Telnet](/2018/09/04/ansible-access-network-via-telnet/), continue to discuss how to access network device via SSH with Ansible.

For SSH access, we should consider 3 methods:

1. Username/password
2. Username/Public-Key without password
3. Username/Public-Key with password

Same EVE lab as the Telnet one: The Cisco IOS Router-192.168.1.99 is for SSH

{{< imgproc imgPath="2018/09/5-opt.png" alt="Topo" max-height="350" >}}

##### Enable SSH on the router

Jump #1 username/password part to public key configuration, I discussed [how to configure public key on IOS router with Putty](/2013/11/08/ios-devices-ssh-key-auth/) before, instead of windows/putty, openssh is useful for generating keys on MAC OS.

Considering Cisco IOS device support RSA key only, I generate keys by  the command:

~~~bash
ssh-keygen -t rsa -b 1024
~~~
{{< imgproc imgPath="2018/09/8-opt.png" alt="SSH key" max-height="300" >}}

Keep passphrase empty is for Case#2.

##### Configuration for SSH access

Because I run all the 3 cases on the same one device, here the points I must care:

- Share SSH Sessions

    The name of the feature of Ansible should be ‘Cache Connections’, refer to the description in the issue: [ansible is caching connections?](https://github.com/ansible/ansible/issues/12006): Ansible itself does not cache connections, but if you ssh is new enough it will be using control master/persist which allows ssh itself to cache connections, you can disable this by overriding ssh args in ansible.cfg or switching to paramiko as a transport. (Here is a [demo](https://www.youtube.com/watch?v=GGYOkwgEGfc&feature=share) about how Putty supports it)

- [Host Key Checking](https://docs.ansible.com/ansible/2.5/user_guide/intro_getting_started.html#host-key-checking)

    From my understanding, it will compare the fingerprint of the host to see whether it’s a known host or not
    For sake of methods testing, I configured secondary IPs (192.168.1.98, 192.168.1.97) and named the IP different names, [disabled Host Key Checking](https://docs.ansible.com/ansible/2.5/user_guide/intro_getting_started.html#host-key-checking).

##### new inventory: inventory_ssh.yml

~~~yaml
---
user:
  hosts:
    user_R:
      ansible_host: "192.168.1.97"
  vars:
    ansible_network_os: "ios"
    ansible_ssh_user: test
    ansible_ssh_pass: test123


pubkeynopass:
  hosts:
    pubkeynopass_R:
      ansible_host: "192.168.1.98"
  vars:
    ansible_network_os: "ios"
    ansible_ssh_user: sshpubkey
    ansible_ssh_private_key_file: '/Users/kz/Documents/SSH/tmp/id_rsa_nokey'


pubkeypass:
  hosts:
    pubkeypass_R:
      ansible_host: "192.168.1.99"
  vars:
    ansible_network_os: "ios"
    ansible_ssh_user: sshpubkeypass
    ansible_ssh_private_key_file: /Users/kz/Documents/SSH/tmp/id_rsa_pass
    ansible_ssh_pass: test123
~~~

Note: For the public key with password case, instead of SSH password,  ‘ansible_ssh_pass’ is for the key’s password.

##### New playbook: pb_first.yml

~~~yaml
---

- name: ssh username/password
  connection: network_cli
  hosts: user
  become_method: enable
  tasks:
    - name: Get config for IOS devices
      ios_facts:
        gather_subset: all

    - name: Display the config
      debug:
        msg: "The hostname is {{ ansible_net_hostname }} and the OS is {{ ansible_net_version }}"


- name: ssh username/keyWithoutPassword
  connection: network_cli
  hosts: pubkeynopass
  become_method: enable
  tasks:
    - name: Get config for IOS devices
      ios_facts:
        gather_subset: all

    - name: Display the config
      debug:
        msg: "The hostname is {{ ansible_net_hostname }} and the OS is {{ ansible_net_version }}"


- name: ssh username/keyWithPassword
  connection: network_cli
  hosts: pubkeypass
  become_method: enable
  tasks:
    - name: Get config for IOS devices
      ios_facts:
        gather_subset: all

    - name: Display the config
      debug:
        msg: "The hostname is {{ ansible_net_hostname }} and the OS is {{ ansible_net_version }}"
~~~

##### Run playbook

Run the playbook by executing the command:

~~~bash
ansible-playbook -i inventory_ssh.yml pb_first.yml
~~~

{{< imgproc imgPath="2018/09/20-opt.png" alt="Run Playbook" max-height="500" >}}

##### How to verify?

From the inventory file, you can see that I use different users for different methods, you can run ‘show users’ command on the IOS router to see if device was accessed by different users:

{{< imgproc imgPath="2018/09/1-opt.png" alt="username password" max-height="80" >}}

{{< imgproc imgPath="2018/09/2-opt.png" alt="public key nopass" max-height="80" >}}

{{< imgproc imgPath="2018/09/3-opt.png" alt="public key with password" max-height="80" >}}

*** End ***

Reference:

- [https://www.ssh.com/ssh/keygen/](https://www.ssh.com/ssh/keygen/)

    How to generate the keys

- [https://medium.com/openinfo/ansible-ssh-private-public-keys-and-agent-setup-19c50b69c8c](https://medium.com/openinfo/ansible-ssh-private-public-keys-and-agent-setup-19c50b69c8c)

    How to run SSH with SSH-add as ansible recommended: Ansible does not expose a channel to allow communication between the user and the ssh process to accept a password manually to decrypt an ssh key when using the ssh connection plugin (which is the default). The use of ssh-agent is highly recommended.

- [https://gist.github.com/yaegashi/9660f147cc8a5dfff339](https://gist.github.com/yaegashi/9660f147cc8a5dfff339)

    A sample reminds me that ansible_ssh_pass should work for the key.

- The output of Ansible cache connections error:

    ~~~bash
    PLAY [ssh username/password] **************************************************************************************************************************
    TASK [Gathering Facts] ********************************************************************************************************************************
    task path: /Users/kz/Documents/C/ansibleprj/pys/pb_first.yml:3
    The full traceback is:
    Traceback (most recent call last):
    File "/Users/kz/Documents/C/ansibleprj/venv/lib/python3.7/site-packages/ansible/plugins/connection/paramiko_ssh.py", line 352, in _connect_uncached
    **sock_kwarg
    File "/Users/kz/Documents/C/ansibleprj/venv/lib/python3.7/site-packages/paramiko/client.py", line 424, in connect
    passphrase,
    File "/Users/kz/Documents/C/ansibleprj/venv/lib/python3.7/site-packages/paramiko/client.py", line 714, in _auth
    raise saved_exception
    File "/Users/kz/Documents/C/ansibleprj/venv/lib/python3.7/site-packages/paramiko/client.py", line 701, in _auth
    self._transport.auth_password(username, password)
    File "/Users/kz/Documents/C/ansibleprj/venv/lib/python3.7/site-packages/paramiko/transport.py", line 1381, in auth_password
    return self.auth_handler.wait_for_response(my_event)
    File "/Users/kz/Documents/C/ansibleprj/venv/lib/python3.7/site-packages/paramiko/auth_handler.py", line 212, in wait_for_response
    raise e
    paramiko.ssh_exception.AuthenticationException: Authentication failed.
    During handling of the above exception, another exception occurred:
    Traceback (most recent call last):
    File "/Users/kz/Documents/C/ansibleprj/venv/bin/ansible-connection", line 105, in start
    self.connection._connect()
    File "/Users/kz/Documents/C/ansibleprj/venv/lib/python3.7/site-packages/ansible/plugins/connection/network_cli.py", line 298, in _connect
    ssh = self.paramiko_conn._connect()
    File "/Users/kz/Documents/C/ansibleprj/venv/lib/python3.7/site-packages/ansible/plugins/connection/paramiko_ssh.py", line 249, in _connect
    self.ssh = SSH_CONNECTION_CACHE[cache_key] = self._connect_uncached()
    File "/Users/kz/Documents/C/ansibleprj/venv/lib/python3.7/site-packages/ansible/plugins/connection/paramiko_ssh.py", line 365, in _connect_uncached
    raise AnsibleConnectionFailure(msg)
    ansible.errors.AnsibleConnectionFailure: Authentication failed.
    fatal: [user_r]: FAILED! => {
    "msg": "Authentication failed."
    }
    ~~~
