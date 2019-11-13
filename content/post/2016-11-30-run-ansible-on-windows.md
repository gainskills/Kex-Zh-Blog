---
layout:     post
title:      "Run Ansible on Windows"
subtitle:   ""
description: "A tip about Ansible"
date:       2016-11-29
tags:
    - Ansible
    - Windows
    - Guide
    - Tip
    - Python
published: true
image:      ""
postWithImg: true
categories:
    - OS
    - DevOps
    - Code
#wechat pay & alipay & Paypal
reward: true
URL: "/2016/11/30/run-ansible-on-windows/"
---
Background:

Here is a topology about the environment for a performance testing, let’s name the servers 1st:

- 1 windows server for License/Workspace server
- 5 windows servers for Network Server
- 5 windows servers for Automation server

{{< imgproc imgPath="2016/11/5-opt.png" alt="Topo" max-height="300" >}}

It really took us a lot of time to deploy the product and collect logs on all of these servers.

My colleague wrote a client-server application and do some of the tasks automatically. The application indeed works for log collection, but for product deployment, as the server end running as a service and fails to launch InstallShield  wizard, it doesn’t support the product installation.

At the same time, I read an article about [Deployment Management Tools comparison between Puppet, Chef, Ansible](http://mp.weixin.qq.com/s/SeGxM87rCiq5jF9ixjGbtw), and decided to try Ansible.

Note:

- Ray Zhao shared with me his experience that how he used Puppet in OpenStack Lab.
- Jin told me LinkedIn is using Ansible.

##### Deploy Ansible

[Ansible’s document](http://docs.ansible.com/ansible/index.html) is very easy to read/understand.

Install Ansible with command (Python is required):

~~~bash
pip install ansible
~~~

For windows management, Pywinrm is required,  but pay attention to pywinrm version, because I met the issue:[https://github.com/ansible/ansible/issues/15973](https://github.com/ansible/ansible/issues/15973) Error Accessing Windows Machine: “ssl: ‘Session’ object has no attribute ‘merge_environment_settings'”

I installed pywinrm by the command:

~~~bash
pip install pywinrm==0.1.1
~~~

~~Note: Currently, Ansible doesn’t support Python3.~~

##### Windows System Prep

I chose win2012R2 to simple windows environment preparation. Just ran  ansible’s [power shell](https://github.com/ansible/ansible/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1) for winRm setup and make sure port : 5986 is open:

{{< imgproc imgPath="2016/11/4-opt.png" alt="Topo" max-height="300" >}}

For the PowerShell security issue:

~~~text
File ConfigureRemotingForAnsible.ps1 cannot be loaded because running scripts is disabled on this system. For more
information, see about_Execution_Policies at http://go.microsoft.com/fwlink/?LinkID=135170.
+ CategoryInfo : SecurityError: (:) [], ParentContainsErrorRecord
Exception
+ FullyQualifiedErrorId : UnauthorizedAccess
~~~

- Start Windows PowerShell with the “Run as Administrator” option.

    [Only members of the Administrators group on the computer can change the execution policy.](http://superuser.com/questions/106360/how-to-enable-execution-of-powershell-scripts)

- [enable running unsigned scripts by entering:](Enable running unsigned scripts by entering:)

    ~~~bash
    set-executionpolicy remotesigned
    ~~~

This will allow running unsigned scripts that you write on your local computer and signed scripts from the Internet.

##### Ansible Inventory

On the linux server, create my hosts file by the command:

~~~bash
vi /etc/ansible/hosts
~~~

Here is a sample to add one server for testing:

~~~yaml
[windows]
10.10.6.12 ansible_user="user_name" ansible_password="password" ansible_port="5986" ansible_connection="winrm"
~~~

configure username/password by group vars by the command:

~~~bash
vi /etc/ansible/group_vars/windows.yml
~~~

Here is the content:

~~~yaml
ansible_user: user_name
ansible_password: password
ansible_port: 5986
ansible_connection: winrm
# The following is necessary for Python 2.7.9+ (or any older Python that has backported SSLContext, eg, Python 2.7.5 on RHEL7) when using default WinRM self-signed certificates:
ansible_winrm_server_cert_validation: ignore
~~~

Note: Encrypting the yml file with _ansible-vault_ is recommended:

~~~bash
ansible-vault edit group_vars/windows.yml
~~~

##### Testing

~~~bash
ansible windows -m win_ping
~~~

#####  Playbook

Create a playbook by the command:

~~~bash
vi /etc/ansible/playbook.yml
~~~

Here is the content

~~~yaml
- name: test raw module
hosts: windows
tasks:
- name: run ipconfig
# query session for RDP session
raw: CMD /C "PSExec.exe \\127.0.0.1 -u user_name -p password -d -i 1 c:\Automation\Install\InstallLatestBuildWith1WS_AllInOneClick.bat"
register: ipconfig
- debug: var=ipconfig
~~~

Without **"PSExec.exe"** in the raw command, ansible has the same behavior as my colleague’s application: InstallShield wizard windows does not pop up when I called it by ‘raw: CMD /C’ even it needs a process to run the command.

Refer to the articles:

- [PowerShell – Using psexec to automate UI tasks on remote machines](http://codingbee.net/tutorials/powershell/powershell-using-psexec-to-automate-ui-tasks-on-remote-machines/)
- [PsExec](https://technet.microsoft.com/en-us/sysinternals/bb897553.aspx) 2.11 // detail about PsExec parameters
- [Query Session](https://technet.microsoft.com/en-us/library/cc785434(v=ws.11).aspx)

    command to figure out the id of a Remote Desktop session which referenced by PsExec parameter: -i

PsExec should be the solution for both ansible and my colleague’s application which execute a command by a background service to call a GUI application.

<hr>

- Comment #1:

    I found that there is an option “Local System account -> Allow service to interact with desktop” in service property:

    {{< imgproc imgPath="2016/11/2-opt.png" alt="Setting" max-height="150" >}}

    It failed to launch windows RM service with this enabled this option:

    {{< imgproc imgPath="2016/11/3-opt.png" alt="Prompt" max-height="150" >}}
