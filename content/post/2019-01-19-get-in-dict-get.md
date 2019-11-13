---
layout:     post
title:      "get() in get() method of Pyhon dict"
subtitle:   ""
description: "A tip about get() method of Python dict"
date:       "2019-01-09"
tags:
    - Dictionary
    - Troubleshooting
    - Python
published: true
image:      ""
categories:
    - Code
URL: "/2019/01/19/get-in-dict-get/"
#wechat pay & alipay & Paypal
reward: true
---
Write down the tip for the practice: [The Time in Words](https://www.hackerrank.com/challenges/the-time-in-words/problem).

A dict was created for the time in number format to string format:

~~~python
intToStrDict = {
        1: 'one',
        2: 'two',
        3: 'three',
        4: 'four',
        5: 'five',
        6: 'six',
        7: 'seven',
        8: 'eight',
        9: 'nine',
        10: 'ten',
        11: 'eleven',
        12: 'twelve',
        13: 'thirteen',
        14: 'fourteen',
        15: 'quarter',
        16: 'sixteen',
        17: 'seventeen',
        18: 'eighteen',
        19: 'nineteen',
        20: 'twenty',
        30: 'half',
        40: 'fourty',
        50: 'fifty'
    }
~~~

[get()](https://docs.python.org/3.7/library/stdtypes.html?highlight=dict%20get#dict.get) is a good way get the value of a key from the dict, so I tried following function to convert minute in number format to string format:

~~~python
def minTowords(tempm):
    return intToStrDict.get(tempm, ' '.join([intToStrDict.get( tempm // 10 * 10), intToStrDict.get( tempm % 10 )])
    )
~~~

Unfortunately, it run into following error when the minute number is less than 10:

~~~Python
minTowords(3)

Traceback (most recent call last):
  File "/Users/kz/Documents/C/Pys/test.py", line 538, in <module>
    print(timeInWords(3, 1))
  File "/Users/kz/Documents/C/Pys/test.py", line 533, in timeInWords
    return "%s%s past %s" % (minTowords(m),'' if m in (15, 30) else ' minute' if m ==1 else ' minutes', intToStrDict[h])
  File "/Users/kz/Documents/C/Pys/test.py", line 522, in minTowords
    return intToStrDict.get(tempm, intToStrDict.get( tempm // 10 )+ ' '+intToStrDict.get( tempm % 10 ))
TypeError: unsupported operand type(s) for +: 'NoneType' and 'str'
~~~

It's wired because 3 is defined in the dict already which means the _default_ part : _' '.join([intToStrDict.get( tempm // 10 * 10), intToStrDict.get( tempm % 10 )])_ should not be executed.

For testing purpose, I modified the function to:

~~~python
def minTowords(tempm):
    return intToStrDict.get(tempm, ' '.join([intToStrDict.get( tempm // 10 * 10), ''])
    )
~~~

with same error:

~~~python
minTowords(3)

Traceback (most recent call last):
  File "/Users/kz/Documents/C/Pys/test.py", line 540, in <module>
    minTowords(3)
  File "/Users/kz/Documents/C/Pys/test.py", line 522, in minTowords
    return intToStrDict.get(tempm, ' '.join([intToStrDict.get( tempm // 10 * 10), ''])
TypeError: sequence item 0: expected str instance, NoneType found
~~~

To check if the list operation causes the issue, tried with

~~~python
def minTowords(tempm):
    return intToStrDict.get(tempm, [intToStrDict.get( tempm // 10 * 10)])
~~~

it works. The root cause should be string operation: [join()](https://docs.python.org/3.7/library/stdtypes.html#str.join)

Did another two testings for verification:

- Join string with operator: '+'

    ~~~python
    def minTowords(tempm):
        return intToStrDict.get(tempm, intToStrDict.get( tempm // 10 * 10) + ' ' + intToStrDict.get( tempm % 10 ))
    ~~~

    **Doesn't work**

- Remove Join operation

    ~~~Python
    def minTowords(tempm):
        return intToStrDict.get(tempm, [intToStrDict.get( tempm // 10 * 10), intToStrDict.get( tempm % 10 )])
    ~~~

    **works**

Finally, I made it by following code:

~~~python
def minTowords(tempm):
    if tempm in intToStrDict:
        return intToStrDict[tempm]
    return ' '.join([intToStrDict.get( tempm // 10 * 10), intToStrDict.get( tempm % 10 )])
~~~

Summary:

**Be careful when a function was taken as _default_ parameter of the _[get()](https://docs.python.org/3.7/library/stdtypes.html?highlight=dict%20get#dict.get)_ method.**
