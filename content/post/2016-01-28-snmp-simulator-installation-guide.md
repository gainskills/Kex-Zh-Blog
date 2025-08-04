---
title:      "SNMP simulator installation guide"
subtitle:   ""
description: "An awesome tool"
date:       2013-11-13
tags:
    - Tip
    - Linux
    - SNMP
    - Simulator
    - Windows
    - Python
publishDate: 2013-11-13
image:      ""
postWithImg: true
categories:
    - Network
URL: "/2016/01/28/snmp-simulator-installation-guide/"
#wechat pay & alipay & Paypal
reward: true
---
**About SNMP Simulator**

The the SNMP Simulator software is intended for testing SNMP Managers against a large number of SNMP Agents that represent a potentially very large network populated with different kinds of SNMP-capable devices.

Refers to its [project page](https://github.com/etingof/snmpsim) for more info.

Why?

With SNMP simulator you can simulate a device by the output of SNMPwalk without considering MIB files.

This article is about how to install SNMP Simulator.

1. Install Python

    Download/execute Python installation files from the [official website](https://www.python.org/downloads/).

    Installation option:

    {{< imgproc imgPath="2016/07/1-opt.png" alt="Installation setting" max-height="300" >}}

2. Install PyCrypto

    SNMP simulator depends on the packages:

    - PyASN1
    - PySNMP
    - PyCrypto
    - pysmi
    - ply

    It always fails when installing PyCrypto by pip with error:

    ~~~python
    running build_ext
    warning: GMP or MPIR library not found; Not building Crypto.PublicKey._fastmath.
    building 'Crypto.Random.OSRNG.winrandom' extension
    error: Unable to find vcvarsall.bat
    ----------------------------------------
    Command d:\program files (x86)\python3.5\python.exe; -u -c import setuptools,tokenize;__file__='D:\\temp\\OSTEMP\\pip-build-9o27ywdt\\pycrypto\\setup.py';exec(compile(getattr(tokenize, 'open', open)(__file__).read().replace('\r\n', '\n'), __file__, 'exec')) install --record D:\temp\OSTEMP\pip-3h_5j6n8-record\install-record.txt --single-version-externally-managed --compile failed with error code 1 in D:\temp\OSTEMP\pip-build-9o27ywdt\pycrypto\
    ~~~

    Refer to [stackoverflow](http://stackoverflow.com/questions/32800336/pycrypto-on-python-3-5), I would like to install a build distribution from 3rd party.

    - For Python 2.6, 2.7, 3.2, 3.3, 3.4

        Visit the [link](http://www.voidspace.org.uk/python/pycrypto-2.6.1/) to select/download Pycrypto installation file, execute the file to finish PyCrypto setup

        E.g.:

        - For Python3.4 32bit,  choose pycrypto-2.6.1.win32-py3.4.exe

        - For Python3.4 64 bit, choose pycrypto-2.6.1.win-amd64-py3.4.exe

    - For Python3.5

        Install PyCrypto by pip command

        - 64-bit

            ~~~bash
            pip install --use-wheel --no-index --find-links=https://github.com/sfbahr/PyCrypto-Wheels/raw/master/pycrypto-2.6.1-cp35-none-win_amd64.whl pycrypto
            ~~~

        - 32bit

            ~~~bash
            pip install --use-wheel --no-index --find-links=https://github.com/sfbahr/PyCrypto-Wheels/raw/master/pycrypto-2.6.1-cp35-none-win32.whl pycrypto
            ~~~

3. Install SNMPsim:

    - Python3.5 and newer versions

        Install SNMP Simulator by pip command:

        ~~~bash
        pip install snmpsim
        ~~~

    - Previous versions:

        Refer to [SNMPsim pypi page](https://pypi.python.org/pypi/snmpsim/), copy egg file’s hyperlink to install it by easy_install tool

        ~~~bash
        easy_install.exe egg_file_hyperlink
        ~~~

4. Run it:

    {{< imgproc imgPath="2016/07/2-opt.png" alt="Installation Done" max-height="300" >}}

**Note:**

- If Python is not in your OS path environment, enter to pip folder by command:

    ~~~bash
    cd $python installation folder$/scripts
    ~~~

    when the installation was done, snmpsimd.py also in the folder: _python installation folder_/scripts

- Pycrypto installation issue

    On Linux, you may meet an issue:

    ~~~bash
    warning: GMP or MPIR library not found; Not building Crypto.PublicKey._fastmath.
    src/MD2.c:31:20: fatal error: Python.h: No such file or directory
    compilation terminated.
    ~~~

    Solution:

    Install Python-dev by apt-get command

    ~~~bash
    sudo apt-get install python-dev
    ~~~

- Newer version is strongly recommended

    Checked the [changelog](http://snmplabs.com/snmpsim/changelog.html) from its official website.
