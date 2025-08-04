---
title:      "OverflowError: signed char is greater than maximum"
subtitle:   ""
description: "A note about String in Python"
date:       2017-06-06
tags:
    - Troubleshooting
    - Python
publishDate: 2017-06-06
postWithImg: true
image:      ""
categories:
    - Code
#wechat pay & alipay & Paypal
reward: true
URL: "/2017/06/06/overflowerror-signed-char-is-greater-than-maximum/"
---
Here the pseudo code about the flow:

~~~python
from array import array
c = array('b')
with open(file, mode = 'rb') as f:
    for character in f:
        res = func(character)
        c.append(res)
~~~

It runs into the error:

~~~python
OverflowError: signed char is greater than maximum
~~~

with a special character 'À' which its binary value is 192:

{{< imgproc imgPath="2017/06/1-opt.png" alt="Character" max-height="20" >}}

My way to resolve this error is to update the type code of the array from 'b' (signed char) to 'B' (unsigned char).

~~~python
from array import array
c = array('B')
~~~

**Reason:** Data from the file will not in the range: from -127 to -1.
