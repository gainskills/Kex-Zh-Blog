---
title:      "Loop a dict to update the keys"
subtitle:   ""
description: "Dictionary of Python"
date:       2016-07-21
tags:
    - Tip
    - Dictionary
    - Python
published: true
image:      ""
categories:
    - Code
#wechat pay & alipay & Paypal
reward: true
URL: "/2016/07/21/loop-a-dict-to-update-key/"
---
Source dict:

~~~python
{'keyA': '', 'keyB': ''}
~~~

Expected dict:

~~~python
{‘keyA/'keyA' :’’, keyA/keyB’ : ‘’}
~~~

**Code1:**

~~~python
keyPrefix = 'keyA'
for key, value in Dict.items():
    newkey = '/'.join([keyPrefix, key])
    Dict[newkey] = Dict.pop(key)
~~~

**Code2:**

~~~python
keyPrefix = 'keyA'
for key, value in Dict.keys():
    newkey = '/'.join([keyPrefix, key])
    Dict[newkey] = Dict.pop(key)
~~~

Result of code1/code2 is:

~~~python
{'keyA/keyA/keyB' : '', 'keyA/keyA/keyA': ''}
~~~

It doesn't work as expected, and I found the case only exists when **prefix is same to a key of the dict** which means code1/code2 works well when the keyPrefix is neither ‘keyA’ nor ‘beyB’.

My way to resolve this unexpected result:

~~~python
Dict = {'/'.join([keyPrefix, key]): value for key, value in Dict.items()}
~~~

For complex case:

~~~python
keyPrefix = 'keyA'
for key in list(Dict.keys()):
    newkey = '/'.join([keyPrefix, key])
    Dict[newkey] = Dict.pop(key)
~~~
