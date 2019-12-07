---
title:      "Ansible-Access Network via Telnet"
subtitle:   ""
description: "Ansible Beginner Series"
date:       2018-09-04
tags:
    - Ansible
    - Cisco
    - IOS
    - Telnet
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
URL: "/2018/09/04/ansible-access-network-via-telnet/"
---
I’m learning [Ansible](https://www.ansible.com/) by reading the official document and some books like [Ansible入门](Ansible入门). Most of the instructions show you how to deploy or maintain the services on Linux, or file operations. But what I do is trying to explore its capability on network device management automation.

The most important thing to practice routers/switches/routing protocol is accessing the device and configure it via CLI when I started to learn network, so I start my ansible tour by accessing the network device from CLI too.

I build a simple lab on EVE for testing: a Cios IOS switch for telnet access, a Cisco IOS router for SSH access.

{{< imgproc imgPath="2018/09/5-opt.png" alt="Topo" max-height="200" >}}

then install Python, ansible on macOS High Sierra (it should be same on Linux, windows), here is the version info:

~~~bash
ansible 2.6.3
config file = None
configured module search path = ['/Users/kz/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
ansible python module location = /Users/kz/Documents/C/ansibleprj/venv/lib/python3.7/site-packages/ansible
executable location = /Users/kz/Documents/C/ansibleprj/venv/bin/ansible
python version = 3.7.0 (v3.7.0:1bf9cc5093, Jun 26 2018, 23:26:24) [Clang 6.0 (clang-600.0.57)]
~~~

Ansible is designed to running over SSH, but there is a module: telnet extends its capbility to access network device via Telnet.

### Part 1

##### 1. Enable Telnet on device

start device: SW on eve, configure IP, enable telnet from line vty, set username/password: test/test123

##### 2. new inventory_telnet.yml

~~~yaml
---

telnet:
hosts:
    sw1:
    ansible_host: "192.168.1.100"
~~~

Note: I use YAML format (ini format should also work) because [Misleading documentation, it shows that you can store vaulted passwords in INI files but it does not work #43897](https://github.com/ansible/ansible/issues/43897)

##### 3. new playbook: pb_telnet.yml

```yaml
---

- name: show version
  hosts: telnet
  gather_facts: false
  connection: local
  tasks:
    - name: telnet sw
      telnet:
        user: test
        password: test123
        login_prompt: "Username: "
        prompts:
          - '[>|#]'
        command:
          - terminal length 0
          - show version
```

The playbook will connect to the device: sw, and run command show version

##### 4.run playbook

Run the task by the command:

~~~bash
ansible-playbook -i inventory_telnet.yml pb_telnet.yml
~~~

##### 5. Debugging

Unfortunately, the task failed to run:

~~~bash
(venv) KZs-MacBook-Pro:pys kz$ ansible-playbook -i inventory_telnet.yml pb_telnet.yml
PLAY [show version] ***********************************************************************************************************************************
TASK [telnet sw] **************************************************************************************************************************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: TypeError: argument should be integer or bytes-like object, not 'AnsibleUnicode'
fatal: [sw1]: FAILED! => {"msg": "Unexpected failure during module execution.", "stdout": ""}
to retry, use: --limit @/Users/kz/Documents/C/ansibleprj/pys/pb_telnet.retry
PLAY RECAP ********************************************************************************************************************************************
sw1 : ok=0 changed=0 unreachable=0 failed=1
~~~

Debugging it by the command:

~~~bash
ansible-playbook -i inventory_telnet.yml pb_telnet.yml -vvv
~~~

get the full stack:

~~~bash
task path: /Users/kz/Documents/C/ansibleprj/pys/pb_telnet.yml:8
The full traceback is:
Traceback (most recent call last):
File "/Users/kz/Documents/C/ansibleprj/venv/lib/python3.7/site-packages/ansible/executor/task_executor.py", line 139, in run
res = self._execute()
File "/Users/kz/Documents/C/ansibleprj/venv/lib/python3.7/site-packages/ansible/executor/task_executor.py", line 577, in _execute
result = self._handler.run(task_vars=variables)
File "/Users/kz/Documents/C/ansibleprj/venv/lib/python3.7/site-packages/ansible/plugins/action/telnet.py", line 69, in run
tn.read_until(login_prompt)
File "/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/telnetlib.py", line 302, in read_until
i = self.cookedq.find(match)
TypeError: argument should be integer or bytes-like object, not 'AnsibleUnicode'
fatal: [sw1]: FAILED! => {
"msg": "Unexpected failure during module execution.",
"stdout": ""
}
to retry, use: --limit @/Users/kz/Documents/C/ansibleprj/pys/pb_telnet.retryPLAY RECAP ********************************************************************************************************************************************
sw1 : ok=0 changed=0 unreachable=0 failed=1
~~~

Searched on Google and find it’s a known issue in current version:Ansible [Cisco IOS – Telnet](Ansible Cisco IOS – Telnet), what I did is copy the latest telnet.py from [telnet action plugin type error #43609](https://github.com/ansible/ansible/pull/43609/files/ac393ff504e08d6c87f868fb647099270c859bfa) to my ansible (Share my path for reference: /Users/kz/Documents/C/ansibleprj/venv/lib/python3.7/site-packages/ansible/plugins/action/telnet.py).

Run the playbook again:

~~~bash
ansible-playbook -i inventory_telnet.yml pb_telnet.yml
~~~

everything works as expected:

~~~bash
PLAY [show version] ***********************************************************************************************************************************
TASK [telnet sw] **************************************************************************************************************************************
changed: [sw1]
PLAY RECAP ********************************************************************************************************************************************
sw1 : ok=1 changed=1 unreachable=0 failed=0
~~~

### Part 2

##### A minor Improvement

I still don’t want to save the password in cleartext as what I did in Part 1 (the password was defined in the playbook).

But I find it will only retrieve the password form playbook and won’t try the credential which was defined in inventory file after I went through telnet.py:

{{< imgproc imgPath="2018/09/21-opt.png" alt="Telnet.py" max-height="400" >}}

so, refer to other modules, I made some change: [ansible-telnet](https://github.com/hanbaobao2005/ansible-telnet/blob/master/telnet.py) so that that [telnet.py](https://github.com/hanbaobao2005/ansible-telnet/blob/master/telnet.py) can retrieve the info from the inventory file. update the inventory with the telnet.py:

~~~yaml
---

telnet:
  hosts:
    sw1:
      ansible_host: "192.168.1.100"
      connection: local
      ansible_ssh_user: test
      ansible_ssh_pass: test123
      ansible_ssh_timeout: 2
      ansible_ssh_port: 23
~~~

then playbook file:

~~~yaml
---

- name: show version
  hosts: telnet
  gather_facts: false
  # connection: local
  tasks:
    - name: CM via telnet
      telnet:
        login_prompt: "Username: "
        prompts:
          - '[>|#]'
        command:
          - terminal length 0
          - show version
~~~

Verify the change by the same cmd:

~~~
ansible-playbook -i inventory_telnet.yml pb_telnet.yml
~~~

##### encrypt the password

password can be encrypted by “ansible-vault” command:

~~~bash
ansible-vault encrypt_string --vault-id test@prompt 'test123' --name 'ansible_ssh_pass'
~~~

I use the password: test123 to encrypt the string.

Update the hashed string to inventory file:

~~~yaml
---

telnet:
hosts:
    sw1:
    ansible_host: "192.168.1.100"
    connection: local
    ansible_ssh_user: test
    ansible_ssh_pass: !vault |
        $ANSIBLE_VAULT;1.2;AES256;test
        63386332356237643731346539336262336231343432313963376438653933323737636535383365
        3562383633646261653739343536386566323462323063320a613638373439363032353137343330
        34306264613932323832373532636230323730626239393564326564303563356666343734633135
        6664373266663238660a363666336661353364393437356433616462346331313537623430393861
        3536
    ansible_ssh_timeout: 2
    ansible_ssh_port: 23
~~~

Verify it by the command:

~~~bash
ansible-playbook -i inventory_telnet.yml --vault-id test@prompt pb_telnet.yml
~~~

{{< imgproc imgPath="2018/09/9-opt.png" alt="result with vault" max-height="400" >}}

### Part 3

Update1 (20180916)

Thanks for [Stefan P’s comment](https://hanbaobao2005.wordpress.com/2018/09/04/ansible-beginner-telnet-access-network/#comment-301) about the command: “show version | include uptime”. Tried it and find that the strings after ‘|’ were cutted:

{{< imgproc imgPath="2018/09/16-opt.png" alt="Pipe" max-height="400" >}}

Read the code

- line 80 of telnet.py:

~~~python
tn.expect(list(map(to_bytes, prompts)))
~~~

- line 652 and 654 of telnet.py:

~~~python
return self._expect_with_poll(list, timeout)
returnself._expect_with_select(list, timeout)
~~~

- line 667 and line 731 of telnet.py:

~~~python
list[i] = re.compile(list[i])
~~~

prompts of playbook actually work as the regular expression match, this is why “|” in [ansible official sample](https://docs.ansible.com/ansible/latest/modules/telnet_module.html) because ‘|’ works for either ‘>’ or ‘ #’. Since [] in Python RE works as a single character match, remove “|” from playbook can work:

~~~yaml
---

- name: show version
  hosts: telnet
  gather_facts: false
  # connection: local
  tasks:
    - name: CM via telnet
      telnet:
        login_prompt: "Username: "
        prompts:
          - '[>#]'
        command:
          - terminal length 0
          - show version | include uptime
          - show version | include Processor board ID
          - exit
~~~

Output:

{{< imgproc imgPath="2018/09/15-opt.png" alt="works" max-height="400" >}}
