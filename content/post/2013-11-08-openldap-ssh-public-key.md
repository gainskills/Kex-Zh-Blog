---
title:      "Open LDAP and SSH Public key"
subtitle:   ""
description: "A guide to setup public key authentication on CentOS with Open LDAP"
date:       2013-11-08
tags:
    - Linux
    - Public Key
    - LDAP
    - Tip
    - SSH
    - Security
    - CentOS
publishDate: 2013-11-08
image:      ""
postWithImg: true
categories:
    - OS
    - Network
URL: "/2013/11/08/openldap-ssh-public-key/"
#wechat pay & alipay & Paypal
reward: true
---
The article is about how I setup Open LDAP on CentOS6 for SSH public key authentication.

#### 1.Download and install CentOS6.2

[CentOS-6.xx-i366-minimal.iso](http://ftp.riken.jp/Linux/centos/6/isos/i386/CentOS-6.10-i386-minimal.iso)

#### 2. CentOS configuration

- Network: IP address, DNS, and restart network service

    ~~~bash
    vi /etc/resolv.conf/DNS
    vi /etc/sysconfig/network-scripts/ifcfg-eth0/NIC IP
    vi /etc/networks//Route
    /etc/init.d/network restart
    ~~~

- configure host file

    ~~~bash
    vi /etc/hosts
    ~~~

    Modify 127.0.0.1 item to FQDN format because openldap get _dc_ from the item automatically.

    ~~~text
    127.0.0.1   ldap.kzblog.com
    ~~~

- Stop security services

    ~~~bash
    setenforce permissive
    getenforce
    service iptables stop
    ~~~

    _Note: This only for the testing environment._

- Update software repository, install LDAP/ssh-lpk Clients

    ~~~bash
    yum -y update
    yum install openldap-servers openldap-clients -y
    yum install openssh-ldap nss-pam-ldapd
    ~~~

#### 3. LDAP Configuration

- Generate the LDAP admin password

    ~~~bash
    slappasswd -s mysecret
    {SSHA}cFJqdWOeG4b1p3bJFGSds5QKGw8faPd7       //copy string as password by following steps
    ~~~
    Note: _mysecret_  is the manage password, you will use the password for administrative commands. Displayed after the command is the corresponding hash, use the hash in further steps.

- TLS settings

    ~~~bash
    sed -i ‘s/dc=my-domain,dc=com/dc=kzblog,dc=com/g’ /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}bdb.ldif
    ~~~

- add password and TLS settings to the file

    ~~~bash
    cat <> /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}bdb.ldif
    olcRootPW: {SSHA}cFJqdWOeG4b1p3bJFGSds5QKGw8faPd7
    olcTLSCertificateFile: /etc/pki/tls/certs/slapdcert.pem
    olcTLSCertificateKeyFile: /etc/pki/tls/certs/slapdkey.pem
    EOF
    ~~~

- Initialize the password for the user: “cn=admin,cn=config”

    ~~~bash
    cat <> /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{0\}config.ldif
    olcRootPW: {SSHA}cFJqdWOeG4b1p3bJFGSds5QKGw8faPd7
    EOF
    ~~~

- Monitor configuration

    ~~~bash
    sed -i ‘s/cn=manager,dc=my-domain,dc=com/cn=Manager,dc=kzblog,dc=com/g’ /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{1\}monitor.ldif
    ~~~

- DB config

    ~~~bash
    cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
    chown -R ldap:ldap /var/lib/ldap/
    ~~~

- Generate SSL keys

    ~~~bash
    openssl req -new -x509 -nodes -out /etc/pki/tls/certs/slapdcert.pem -keyout /etc/pki/tls/certs/slapdkey.pem -days 365
    chown -Rf root.ldap /etc/pki/tls/certs/slapdcert.pem
    chown -Rf root.ldap /etc/pki/tls/certs/slapdkey.pem
    ~~~

- Schemas: Add _openssh-lpk_ schema

    ~~~bash
    cat < /etc/openldap/slapd.d/cn=config/cn=schema/cn={21}openssh-lpk.ldif
    dn: cn={21}openssh-lpk
    objectClass: olcSchemaConfig
    cn: {21}openssh-lpk
    olcAttributeTypes: {0}( 1.3.6.1.4.1.24552.500.1.1.1.13 NAME ‘sshPublicKey’ DES
    C ‘MANDATORY: OpenSSH Public key’ EQUALITY octetStringMatch SYNTAX 1.3.6.1.4.
    1.1466.115.121.1.40 )
    olcObjectClasses: {0}( 1.3.6.1.4.1.24552.500.1.1.2.0 NAME ‘ldapPublicKey’ DESC
    ‘MANDATORY: OpenSSH LPK objectclass’ SUP top AUXILIARY MAY ( sshPublicKey $
    uid ) )
    structuralObjectClass: olcSchemaConfig
    entryUUID: 135574f4-bda0-102f-9362-0b01757f31d8
    creatorsName: cn=config
    createTimestamp: 20110126135819Z
    entryCSN: 20110126135819.712350Z#000000#000#000000
    modifiersName: cn=config
    modifyTimestamp: 20110126135819Z
    EOF
    ~~~

- Initialize base.ldif

    e.g. : create base.ldif with following content by command: _vi base.ldif_ :

    ~~~text
    dn: dc=kzblog,dc=com
    dc: kzblog
    objectClass: top
    objectClass: domain
    ~~~


- Start the services and add the entries:

    ~~~bash
    service slapd start
    chkconfig slapd on
    ldapadd -x -W -D “cn=Manager,dc=kzblog,dc=com” -f base.ldif
    ldapadd -x -W -D “cn=Manager,dc=kzblog,dc=com” -f newsudoers.ldif
    ~~~

- Try searching to verify

    ~~~bash
    ldapsearch -x -b “dc=kzblog,dc=com”
    ldapsearch -H “ldap://127.0.0.1.com” -x -b “dc=kzblog,dc=com”
    ~~~


- LDAP server configuration

    ~~~bash
    authconfig –disablenis –enablemkhomedir –enableshadow –enablelocauthorize –enableldap –ldapserver=ldap://127.0.0.1 –enablemd5 –ldapbasedn=dc=kzblog,dc=com –updateall
    ~~~

    **Or**, you can use a curses-based application for the configuration.
    Enable necessary options based on the above command
    ~~~bash
    authconfig-tui
    ~~~
    Note: _–enablemkhomedir_ is not available in authconfig-tui

- Allow SSH public-key login

    ~~~bash
    cat < /etc/ssh/ldap.conf
    uri ldap://127.0.0.1/
    base dc=kzblog,dc=com
    ssl no
    EOF
    ~~~

    ~~~bash
    cat <> /etc/ssh/sshd_config
    AuthorizedKeysCommand /usr/libexec/openssh/ssh-ldap-wrapper
    AuthorizedKeysCommandRunAs nobody
    EOF
    ~~~

- Tell the system to lookup sudoers info from ldap or files respectively

    ~~~bash
    echo ‘sudoers: ldap files’ >> /etc/nsswitch.conf
    cat <> /etc/nslcd.conf
    ou=sudoers,dc=kzblog,dc=com
    sudoers_base ou=sudoers,dc=kzblog,dc=com
    EOF
    ~~~

- Restart sshd

    ~~~bash
    service sshd restart
    ~~~

#### 4. LAM

**LAM**: ldap account manager, an excellent web-based LDAP manage tool

- Install [epel](https://fedoraproject.org/wiki/EPEL) and start Apache

    ~~~bash
    wget http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-5.noarch.rpm
    rpm -ivh epel-release-6-5.noarch.rpm
    service httpd start
    ~~~
    Note: # Click [this link](http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-5.noarch.rpm) to search a newer version when wget run failed

- LAM installation

    [LAM](http://www.ldap-account-manager.org/) is an alternative tool of phpldapadmin. You can download [rpm](http://prdownloads.sourceforge.net/lam/ldap-account-manager-6.6-0.fedora.1.noarch.rpm?download) for CentOS/fedora and install it.

    Navigate http://_IP_/lam/ after the installation:

    {{< imgproc imgPath="2013/11/02-opt.png" alt="LAM" max-height="50" >}}

- Edit server profiles for LAM and LDAP connection

    {{< imgproc imgPath="2013/11/03-opt.png" alt="LAM Server Setting" max-height="250" >}}

- Enter LAM default password: lam, and click ‘Ok’

    {{< imgproc imgPath="2013/11/04-opt.png" alt="LAM Password" max-height="120" >}}

- update server address, Tree suffix, List of valid users

    {{< imgproc imgPath="2013/11/05-opt.png" alt="General Setting" max-height="350" >}}

- Modify LDAP suffix of Users and Groups, remove ‘Samba 3’ items from Users and Groups

    Remove Hosts, Samba domain option by red ‘x’
    {{< imgproc imgPath="2013/11/06-opt.png" alt="Account Types" max-height="350" >}}

- Add ‘SSH Public Key’ to Users from Available module to extent LAM capability to manage SSH public key

    {{< imgproc imgPath="2013/11/07-opt.png" alt="Modules" max-height="350" >}}

- Go back to login page after you click ‘Save’ button; Login by LDAP root password: _mysecret_

    {{< imgproc imgPath="2013/11/08-opt.png" alt="Login again" max-height="200" >}}

- Create Groups

    {{< imgproc imgPath="2013/11/09-opt.png" alt="Add Group" max-height="150" >}}

- Create users

    {{< imgproc imgPath="2013/11/10-opt.png" alt="Add User" max-height="200" >}}

- Public key setting in User

    {{< imgproc imgPath="2013/11/11-opt.png" alt="Public Key" max-height="100" >}}

    A sample of PuTTYGen generated key format:

    ~~~text
    —- BEGIN SSH2 PUBLIC KEY —-
    Comment: “rsa-key-20121022”
    AAAAB3NzaC1yc2EAAAABJQAAAIEAhGF6GIuMY8FJ1+CNApnSY1N2YSlkYz72Yvwu
    a6N1nFpBklz1+dsIMg4rcTLcF34M/tW5Yz+NUDAw2AEbxQ32FPgw7sAOIXktkYOH
    tr7mmimiTjkoSCrJh1kqalPSpi8rglT/Bp67Ql2SZwvUFfMzHISryR0EZC4rXP/u
    vObrJe8=
    —- END SSH2 PUBLIC KEY —-
    ~~~

    Edit it and change the text to:

    ~~~text
    ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAhGF6GIuMY8FJ1+CNApnSY1N2YSlkYz72Yvwua6N1nFpBklz1+dsIMg4rcTLcF34M/tW5Yz+NUDAw2AEbxQ32FPgw7sAOIXktkYOHtr7mmimiTjkoSCrJh1kqalPSpi8rglT/Bp67Ql2SZwvUFfMzHISryR0EZC4rXP/uvObrJe8=
    ~~~

##### 5. Debugging

- On CentOS:
    ~~~bash
    more  /var/log/secure
    find . –name slapd
    path/slapd –V –d debuglevel
    ~~~

- On ubuntu:
    ~~~
    more /var/log/auth.log
    ~~~

- LDAP settings

    ~~~
    setenforce permissive
    getenforce
    service iptables stop
    /etc/init.d/slapd start
    authconfig –disablenis –enablemkhomedir –enableshadow –enablelocauthorize –enableldap –ldapserver=ldap://127.0.0.1 –enablemd5 –ldapbasedn=dc=kzblog,dc=com –updateall
    service httpd start
    ~~~

    Note: Firewall setting only for testing environment

##### Others

- Issue: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=432662

    For error msg:

    ~~~bash
    $ sudo slapindex
    WARNING!
    Runnig as root!
    There’s a fair chance slapd will fail to start.
    Check file permissions!
    ~~~

    Start it with '_sudo –u openldap slapindex_'


- ##### Related links:

    - [Centralize the administration of Linux accounts/Centralize the administration of sudo access](http://blog.johnalvero.com/2012/03/ldap-server-installation-for-openssh.html)
    - [Security option](http://sios-oss.blogspot.jp/2011/12/rhel61-openldap-slapdconf-ssh.html)
    - [SSH Public Key - No supported authentication methods available (server sent public key)](http://askubuntu.com/questions/204400/ssh-public-key-no-supported-authentication-methods-available-server-sent-publ)
    - [OpenLDAP Server Setup in Ubuntu 12.04 LTS](http://ubuntuforums.org/showthread.php?t=1975429)
    - [ssh and ldap](https://marc.xn--wckerlin-0za.ch/computer/blog/ssh_and_ldap#configuration)
    - [SSH Public Keys from LDAP](http://jpmens.net/2006/03/02/ssh-public-keys-from-ldap/)
