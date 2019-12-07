---
title:      "An incompatible issue of xls file "
subtitle:   ""
description: "A story about the methods I tried to got the issue figured out"
date:       2019-12-02
tags:
    - Python
    - Microsoft Office
    - Excel
    - Hex
    - Tip
categories:
    - Code
published: true
postWithImg: true
image:      ""
postWithImg: true
showtoc: false
URL: "/2019/12/02/pyxlwtdebug/"
#wechat pay & alipay & Paypal
reward: true
---
#### Background

An integration project: exporting a csv file from system A, convert the csv file to xls file, and import the converted file into system B (A 3rd party system).

Environment:

- [Python3.7.5](https://www.python.org/downloads/release/python-375/)
- xls library: [xlwt1.3](https://github.com/python-excel/xlwt/releases)
- Developing on Mac 10.15.1 with [VS Code](/2019/11/15/vscode-as-idle-for-django/), and finally the project will be published to a Docker environment(ritht now, it's [Python:3.7.5-alpine3.10](https://hub.docker.com/_/python/)).

#### Issue

The converted xls file, system B doesn't support it. However, the file can be opened in Microsoft Excel, and then system B supports it after the open operation (did nothing, just open it then close)😫.

#### 1st Try

There are [several libraries](http://www.python-excel.org/) related to xls, such as [pyexcel-xls](https://pypi.org/project/pyexcel-xls/),[xlwings](https://github.com/xlwings/xlwings), [Pandas](https://github.com/pandas-dev/pandas). ([OpenPyXL](https://openpyxl.readthedocs.io/en/stable/), [xlsxwriter](https://github.com/jmcnamara/XlsxWriter) were not considered because the file is a xls file instead of a xlsx file.) I decided to try them one by one:

- ```pyexcel-xls```, ```Pandas```, the issue is still there. Checked their dependencies, all of them mentioned xlwt.

- ```xlwings```, it calls Microsoft Excel and does data operations. I gave it up because this won't work in my Docker environment.

#### 2nd Try - External systems

Depends on the clue: the file can be supported after it was opened in MS Excel, I was thinking to find an alternative way:

- [Microsoft Flow](https://flow.microsoft.com/en-us/)

    MS flow is a powerful tool as a part of O365 suite. My plan was:

    1. Send the xls file to my email

    2. MS flow grabs the file from the email, and insert a row to the xls file, then save the change

    3. MS flow sends the file back to the email

    I had to give it up because MS flow was unable to find the attached file from my email (I have figured the issue out later by creating a new flow. For my next project, I might try [MS UI flows](https://docs.microsoft.com/en-us/power-automate/ui-flows/overview) 1st).


- Web Service

    Per [Hugo-Images management](/2019/01/25/post-img-mgmt-hugo/#before-start). Tried my idea by [Zamzar - Online file conversion](https://www.zamzar.com/),  implemented the function by referring [its doc](https://developers.zamzar.com/docs):

    1. Generated a csv file in my code instead of a xls file

    2. Converted the csv file to a xls file by Zamzar

    Yes, there is "But". I found Zamzar free edition license is based on conversation, uploading/downloading files are two conversations. 100 conversations/1 month didn't meet my expectation, quit again.


#### 3rd - Dig the root cause

Right now, I was aware that I have to sit down and dig the root cause of xlwt.

1. Generated the xls (**File A**) again, made a copy of it (**file B**) and opened file B by Microsoft Excel once.

2. Compared the File A and File B with [Hex Fiend](http://ridiculousfish.com/hexfiend/)

    {{< imgproc imgPath="2019/12/1-opt.png" alt="Comparison" max-height="350" >}}

    There are only 3 differences, not too many, all I need to do is to checking them one by one💪.

3. Open file A and file B by [0xED](https://www.suavetech.com/0xed/0xed.html) to check the difference

    Hex Fiend told you there are 3 differences, but it's difficult to find out what the difference exactly is, 0xED did the trick:

    {{< imgproc imgPath="2019/12/2-opt.png" alt="1st difference" max-height="350" >}}

    Here are the steps I did on xlwt code:

    - xlwt -> Workbook.py -> func: save()

    - xlwt -> Workbook.py -> func: save() -> ```f.write(stream)```

    - xlwt -> Workbook.py -> func: get_biff_data() -> ```before += self.__write_access_rec()```, ```return BIFFRecords.WriteAccessRecord(self.__owner).get()```

    - xlwt -> BIFFRecords.py -> ```class WriteAccessRecord(BiffRecord):```

        Per the difference, I changed the code:

        {{< highlight Python "hl_lines=6">}}
        def __init__(self, owner):
            uowner = owner[0:0x30]
            uowner_len = len(uowner)
            if isinstance(uowner, six.text_type):
                uowner = uowner.encode('ascii')  # probably not ascii, but play it safe until we know more
            self._rec_data = pack('%ds%ds' % (uowner_len, 0x70 - uowner_len), b'\x16\x00' + uowner, b' '*(0x70 - uowner_len)){{< /highlight >}}

        Note: The binary string is '15 00' in the screenshot, but it should be "16 00" when I was working on this, that's why the code and screenshot are inconsistent.

4. Run my code again, __the xls can be support now!!!__ 🎉🎆😂 I felt I'm so lucky because the issue was resolved by fixing the 1st difference.

#### Publish the change to Dock environment

Do ```docker cp``` to copy the modified libraries to docker instance.... Just kidding😂

Here what I did:

1. Fork [xlwt](https://github.com/python-excel/xlwt) code on [Github](https://github.com/gainskills/xlwt) and push my [change](https://github.com/gainskills/xlwt/commit/21a17833d6200da93b45b92300831473345e976b)

    Note: I might create a pull request later after I figured out what I changed.

2. New a pip requirement file: requirement-git.txt with the content:

    ```text
    # xlwt 1.3.0
    https://github.com/gainskills/xlwt/zipball/master
    ```

    Note:
    - ```pip freeze > requirement.txt``` for all libraries.
    - Besides xlwt, I also have flower1.0 in requirement-git.txt
    - ```git+https://github.com/gainskills/xlwt.git``` works for the docker instance which has git installed

3. run ```pip install -r requirement-git.txt``` before ```pip install -r requirement.txt```

##### Reference

- [Compress images with Tinypng API](/2019/01/25/post-img-mgmt-hugo/#before-start)
- [PyMOTW-3 struct — Binary Data Structures](https://pymotw.com/3/struct/)
- [struct — Interpret bytes as packed binary data](https://docs.python.org/3/library/struct.html)
