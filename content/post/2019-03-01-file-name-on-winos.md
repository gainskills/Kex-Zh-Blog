---
title:      "File name on windows"
subtitle:   ""
description: "Two errors I met caused by file name"
date:       2019-03-01
tags:
    - Windows
    - Troubleshooting
    - Tip
publishDate: 2019-03-01
image:      ""
categories:
    - OS
    - Code
#wechat pay & alipay & Paypal
reward: true
URL: "/2019/03/01/file-name-on-winos/"
---
### Error 1

Run a bat (ping.bat) to ping multiple IPs like this:
{{< highlight bat >}}
set testipa=x.x.x.x
echo Checking ping %testipa% (15 times), please don't close current window
echo ping %testipa% (15 times)  >> test.log
ping %testipa% -w 500 -n 15 >> test.log{{</ highlight >}}

But got the following error:
{{< highlight bat >}}
Checking ping x.x.x.x (15 times), please don't close current window
The process cannot access the file because it is being used by another process.
The process cannot access the file because it is being used by another process.{{</ highlight >}}

Checked it again and again, test.log is **not** being used by any other process.<br>
It suddenly works when I rename it to '**ping-old.bat**' for testing.

<strong>Conclusion</strong><br>
Don't using built-in tools' name as user executable files' name.

### Error 2

Once upon a Time, a customer reported an issue: some of the devices lost after they relaunched the software.<br>
And the device was found after comparing the data, and the hostname of the device is 'com1'.

Searched on [Microsoft](https://docs.microsoft.com/en-us/windows/desktop/fileio/naming-a-file) and found:

> Do not use the following reserved names for the name of a file:

>CON, PRN, AUX, NUL, COM1, COM2, COM3, COM4, COM5, COM6, COM7, COM8, COM9, LPT1, LPT2, LPT3, LPT4, LPT5, LPT6, LPT7, LPT8, and LPT9. Also avoid these names followed immediately by an extension; for example, NUL.txt is not recommended. For more information, see [Namespaces](https://docs.microsoft.com/en-us/windows/desktop/fileio/naming-a-file#win32-file-namespaces).

It failed to load the device because the software tries to parse the file, after all, it's not there.

<strong>Conclusion</strong><br>
A mechanism is required if the software save data to file by outer conditions.
