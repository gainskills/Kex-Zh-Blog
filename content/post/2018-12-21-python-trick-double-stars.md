---
title:      "Python operator: double start(**)"
subtitle:   ""
description: "Try the Operator: **"
date:       2018-12-21
tags:
    - Tip
    - operator
    - Python
published: true
image:      ""
categories:
    - Code
#wechat pay & alipay & Paypal
reward: true
URL: "/2018/12/27/python-trick-double-stars/"
---
Here is the data:

~~~python
testdata = {
    'a' : 1,
    'b': 2
}
~~~

There are two ways to pass the data to a function

1. Passing the data to the function
    ~~~python
    def loop(data):
        for key, value in data.items():
            print(key, value)

    loop(testdata)
    ~~~

1. Passing the data with operator: **
    ~~~ Python
    def loopStar(**kwargs):
        for key, value in kwargs.items():
            print(key, value)

    loopStar(**testdata)
    ~~~
