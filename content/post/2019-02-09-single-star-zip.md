---
title:      "Python operator:single star(*)"
subtitle:   ""
description: "A summary after reading a block of pseudo code"
date:       2019-02-09
lastmod:    2019-08-25
tags:
    - zip
    - singlestar
    - operator
    - Python
categories:
    - Code
published: true
postWithImg: true
image:      ""
postWithImg: true
showtoc: false
URL: "/2019/02/09/single-star-zip/"
#wechat pay & alipay & Paypal
reward: true
---

- <h3>with Zip</h3>

    Read a block of pseudo Python code like
    {{< highlight Python >}}
comA = zip(lsA, lsB)
comB = zip(*comA){{< /highlight >}}

    then made a try to see how * works:
    {{< highlight Python "linenos=table,hl_lines=4 5 8" >}}
a = [1, 2, 3]
b = [4, 5, 6]
c = zip(a,b)
for j in c:
    print(j)
d = zip(*c)
for i in d:
    print(i){{< /highlight >}}

    and the output:
    {{< highlight Python >}}
(1, 4)
(2, 5)
(3, 6){{< /highlight >}}

    There is nothing was outputted by line8: ```print(i)```, but it works after removing line4-5:

    {{< highlight Python "hl_lines=8" >}}
a = [1, 2, 3]
b = [4, 5, 6]
c = zip(a,b)
d = zip(*c)
for i in d:
    print(i){{< /highlight >}}

    with the output:

    {{< highlight Python >}}
1, 2, 3)
(4, 5, 6){{< /highlight >}}

    Just as it was mentioned in the [Python doc](https://docs.python.org/3/library/functions.html#zip):

    > zip() in conjunction with the <strong>* operator can be used to unzip a list</strong>

    But I'm still wondering why the first try failed, submitted a question on Stackoverflow: [Why “for” affects another zip object?](https://stackoverflow.com/questions/54592039/why-for-affects-another-zip-object) after my debugging, and got the answer shortly: [zip variable empty after first use](https://stackoverflow.com/questions/17777219/zip-variable-empty-after-first-use?answertab=active#tab-top):

    > In [Python2.x](https://docs.python.org/2/library/functions.html#zip), zip returned a list of tuples

    > In [Python3](https://docs.python.org/3/library/functions.html#zip), a lot of the builtin functions now return iterators rather than lists ([map](https://docs.python.org/3/library/functions.html#map), zip, [filter](https://docs.python.org/3/library/functions.html#filter))

- <h3> List comprehensions: the type of elements is list</h3>

    <small>Updated @ 25/Aug/2019</small>

    {{< highlight Python >}}
a = [[1,2], [3,4], [5, 6, 7]]
c  = [ [*i, sum(i)] for i in a]
print(c){{< /highlight >}}

    Output:

    {{< highlight Python >}}
[[1, 2, 3], [3, 4, 7], [5, 6, 7, 18]]{{< /highlight >}}
