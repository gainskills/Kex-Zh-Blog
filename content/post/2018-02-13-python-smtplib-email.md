---
title:      "Python SMTPlib/Email"
subtitle:   ""
description: "A sample of Python SMTPlib"
date:       2018-02-13
tags:
    - Email
    - Troubleshooting
    - Python
published: true
image:      ""
postWithImg: true
categories:
    - Code
#wechat pay & alipay & Paypal
reward: true
URL: "/2018/02/13/python-smtplib-email/"
---
I followed the [instruction](http://www.runoob.com/python3/python3-smtp.html) which is written in Chinese to learn how to send emails by Python, here some tips from my practice:

1. Name of the attachment is shown as ‘ATT00002’

    The name of the attachment in the receiver mailbox is shown in the format ‘ATT0000X‘ with the code:

    ~~~Python
    att1["Content-Disposition"] = 'attachment; filename="runoob.txt"'
    ~~~

    {{< imgproc imgPath="2018/02/4-opt.png" alt="Issue" max-height="300" >}}

    The issue can be fixed by using .addheader() function:

    ~~~Python
    att1.add_header('Content-Disposition', 'attachment', filename="1.cpp")
    ~~~

Here is my code:

<script src="https://gist.github.com/gainskills/3a97788c9fe9248b1e9e5d73ff7987b6.js"></script>
