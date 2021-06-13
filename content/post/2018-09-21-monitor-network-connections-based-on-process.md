---
title:      "Monitor network connections based on Process"
subtitle:   ""
description: "A note for packets capturing"
date:       2018-09-21
tags:
    - Tip
    - windows
published: true
image:      ""
postWithImg: true
categories:
    - Network
    - OS
#wechat pay & alipay & Paypal
reward: true
URL: "/2018/09/21/monitor-network-connections-based-on-process/"
---
[Wireshark](https://www.wireshark.org/) is widely used in packets capturing with flexible filters, but for some particular cases, end users care about the network sessions which established by a specific application.

I will show how to check the sessions of ‘Microsoft OneNote’.

### Windows

Microsoft provides its own product for packets capturing: [Microsoft Network Monitor](https://www.microsoft.com/en-us/download/4865).

Lunch ‘Microsoft Network Monitor’ before you run OneNote:

{{< imgproc imgPath="2018/09/12-opt.png" alt="nm-1" max-height="300" >}}

You will see the processes from the left panel, All related network sessions will shown in the ‘frame summary’ window once OneNote lunched:

{{< imgproc imgPath="2018/09/13-opt.png" alt="nm-2" max-height="200" >}}

### Linux/MAC OS

I prefer ‘lsof’ to capture the network by application with the advantages:

- run continuously
- the result can be filtered by application name, process id

For the prospect of my case, the thing I concerned from the beginning is the limitation of the app name because lsof only supports up to 15 strings with -c options, otherwise,  you will get an error:

~~~bash
KZs-MacBook-Pro:SSH kz$ lsof -c "Microsoft OneNote"
lsof:"-c Microsoft\x20OneNote" length (17) > what system provides (15)
lsof 4.89
latest revision: ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/
latest FAQ: ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/FAQ
latest man page: ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_man
usage: [-?abhlnNoOPRtUvV] [+|-c c] [+|-d s] [+D D] [+|-f[cgG]]
[-F [f]] [-g [s]] [-i [i]] [+|-L [l]] [+|-M] [-o [o]] [-p s]
[+|-r [t]] [-s [p:s]] [-S [t]] [-T [t]] [-u s] [+|-w] [-x [fl]] [--] [names]
Use the ``-h'' option to get more help information.
~~~

Thanks to lsof’s regular expression feature which made it possible to filter Microsoft One Note’s network sessions.

Before you lunch OneNote, run following command for the capturing:

~~~bash
lsof -c /Microsoft\ One/ -r 1 | awk '$5 ~ /^IP/ {print}
~~~

- -c /Microsoft\ One/ is how lsof supports regular expression:

    If c begins and ends with a slash (‘/’), the characters between the slashes are interpreted as a regular expression.

- -r 1 means the losf will run in repeat mode
- awk command will filter all IP connections because -c and -i options are conflicting with each other

here is a sample:

{{< imgproc imgPath="2018/09/10-opt.png" alt="lsof" max-height="140" >}}
