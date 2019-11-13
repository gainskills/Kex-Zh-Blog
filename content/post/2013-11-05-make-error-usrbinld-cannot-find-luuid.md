---
title:      "make error :/usr/bin/ld: cannot find -luuid"
subtitle:   ""
description: "A compile error"
date:       2013-11-05
tags: 
    - Troubleshooting
    - Linux
    - Compile
    - Make
    - CentOS
published: true 
image:      ""
categories:
    - OS
URL: "/2013/11/05/make-error-usrbinld-cannot-find-luuid/"
#wechat pay & alipay & Paypal
reward: true
---
I met a make error in CentOS 6:

~~~bash
# make

......

/usr/bin/ld: cannot find -luuid
 ld returned 1 exit status
make: *** Error 1
~~~

The way to fix this error is to install lib : uuid-devel

~~~bash
yum -y install libuuid-devel
~~~
