---
title:      "Configuring SSH public key authentication on Cisco IOS Device"
subtitle:   ""
description: "A guide about public key generation, and Cisco IOS device configuration"
date:       2013-11-08
tags:
    - Public Key
    - Tip
    - SSH
    - Security
    - Cisco
    - IOS
    - Putty
    - SecureCRT
publishDate: 2013-11-08
image:      ""
postWithImg: true
categories:
    - Network
Lang: "zh"
URL: "/2013/11/08/ios-devices-ssh-key-auth/"
#wechat pay & alipay & Paypal
reward: true
---
SSH public Key types:

- RSA key use with SSH1 and SSH2 protocol
- DSA key use with SSH2 protocol<br><br>Note: DSA is weak than RSA

The Key pairs:

- Public key: SSH.com使用的RFC 4716指定的公钥格式，而OpenSSH使用了另外的格式
- Private Key: SSH v1私钥只有一种标准格式，但SSH v2私钥格式很多，OpenSSH、ssh.com、puty、winscp格式不同且不兼容

#### Generate the Key

1. SecureCRT
    {{< imgproc imgPath="2013/11/12-opt.png" alt="SecureCRT-PublicKey-1" max-height="100" >}}
    {{< imgproc imgPath="2013/11/13-opt.png" alt="SecureCRT-PublicKey-2" max-height="270" >}}
    {{< imgproc imgPath="2013/11/14-opt.png" alt="SecureCRT-PublicKey-3" max-height="270" >}}
    密钥类型有两种: DSA、RSA. Secure CRT提示多种服务器不支持RSA, Cisco IOS supports RSA only.
    {{< imgproc imgPath="2013/11/15-opt.png" alt="SecureCRT-PublicKey-4" max-height="270" >}}
    通行短语为对私钥加密的密码，注释为提示输入密码时的提示，两项均为可为空
    {{< imgproc imgPath="2013/11/16-opt.png" alt="SecureCRT-PublicKey-5" max-height="270" >}}
    {{< imgproc imgPath="2013/11/17-opt.png" alt="SecureCRT-PublicKey-6" max-height="270" >}}
    {{< imgproc imgPath="2013/11/18-opt.png" alt="SecureCRT-PublicKey-7" max-height="270" >}}
    为了更好的兼容性和适用性，OpenSSH format is prefered，Choose the location to save the key files：
    {{< imgproc imgPath="2013/11/19-opt.png" alt="SecureCRT-PublicKey-8" max-height="270" >}}
    点击’Finish’后会弹出对话框：
    {{< imgproc imgPath="2013/11/20-opt.png" alt="SecureCRT-PublicKey-9" max-height="150" >}}
    如果选择’Yes’,会影响’快速连接’中的公钥指向保存的文件:
    {{< imgproc imgPath="2013/11/21-opt.png" alt="SecureCRT-PublicKey-10" max-height="290" >}}

2. Putty
    {{< imgproc imgPath="2013/11/22-opt.png" alt="Putty-PublicKey-1" max-height="290" >}}
    {{< imgproc imgPath="2013/11/23-opt.png" alt="Putty-PublicKey-2" max-height="200" >}}
    {{< imgproc imgPath="2013/11/24-opt.png" alt="Putty-PublicKey-3" max-height="290" >}}
    key passphrase: 输入对密钥加密的密码

    key comment: 提示输入密码时的提示

    _Note：默认生成的是PuTTY’s native format (*.PPK), 通过Conversions菜单保存为ssh.com或openssh格式的private key_

#### Configure Cisco IOS Device
1. Enable SSH

    ~~~bash
    ip domain-name publickey.com  #配置domain name
    crypto key generate rsa  #通过配置生成SSH key
    line vty 0 4  #设置vty的login mode
    transport input ssh  #Cisco与3com的认证方式差异，3com可以设置telnet或ssh用户，而Cisco是基于session的
   ~~~

2. IOS 15, SSH使用Public-Key ([similar with 12.4T](http: #www.cisco.com/en/US/docs/ios-xml/ios/sec_usr_ssh/configuration/12-4t/sec-usr-ssh-12-4t-book.pdf))

    {{< highlight bash "linenos=table,hl_lines=12" >}}
    ip domain-name publickey.com
    ip ssh version 2
    crypto key generate rsa label ssh module 1024
    ip ssh rsa keypair-name ssh
    line vty 0 4
    transport input ssh
    exit

    ip ssh pubkey-chain
    username kzhang  #配置使用证书的登陆的用户名
    key-string  #回车后，是类似banner的配置方式，直到输入exit才结束key配置
    xxxxxx
    exit  #通过exit退出public key设置
    {{< /highlight >}}

**Notes About line12**<br>
- Key不能被误时会有提示: ```%SSH: Failed to decode the Key Value’ ```.<br>
- CRT：直接将整个文本内容复制过来即可，PuTTY:只copy文本的一部分

{{< imgproc imgPath="2013/11/25-opt.png" alt="Putty-PublicKey-text" max-height="140" >}}

#### Verification
1. 'show ip ssh'

    {{< highlight bash "linenos=table,hl_lines=2" >}}
    R2#show ip ssh
    SSH Enabled – version 2.0
    Authentication timeout: 120 secs; Authentication retries: 3
    Minimum expected Diffie Hellman key size : 1024 bits
    IOS Keys in SECSH format(ssh-rsa, base64 encoded):
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQCkhc93+j/D2RdJFhRn9NWkfoW+LE8WvERSX9wnygVp
    bVMxjlov+PP6Fe4OlppueLtRtdrAVIwROeyE4hxf/bCMf8efUylIqMGx4aI64m+V/l2rbFKEECdDXUHU
    LI/cNkdwu12h1C0fw4asGuhq4RQkjH53AgVgdQvk3yi37Rf4fQ==
    {{< /highlight >}}

2. SecureCRT

    以SSH的’快速连接’为例：
    {{< imgproc imgPath="2013/11/26-opt.png" alt="SecureCRT" max-height="250" >}}

    1. 设置username
    2. 设置’公钥’项为高优先级
    3. 点击’属性’配置登陆的公钥
    4. 点击’使用会话公钥设置’
    5. 点击 … 指定私钥文件,CRT支持openssh格式，不支持ssh.com格式
    6. 点击连接

3. Putty

    Session页面指定device IP:
    {{< imgproc imgPath="2013/11/27-opt.png" alt="Putty-Setting1" max-height="150" >}}
    Connection -> SSH -> Auth项指定私钥
    {{< imgproc imgPath="2013/11/28-opt.png" alt="Putty-Seeting2" max-height="150" >}}
    Note: PuTTY只支持ppk格式，不支持openssh和ssh.com格式

#### Others
- IOS 15.0，使用putty登录时出现Error```Server refused our key```，在设备执行 ```Debug ip ssh detail```, 有error: ```invalid old access type configured – 0x01 ```

    Resolution:
    ~~~bash
    configure terminal
    line vty 0 4
    login local
    exit
    ~~~
