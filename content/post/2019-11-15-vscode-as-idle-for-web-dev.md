---
title:      "VSCode as an IDLE for Django"
subtitle:   ""
description: "VSCode Guide for beginner"
date:       2019-11-15
tags:
    - Django
    - Web
    - Python
    - MS VSCode
categories:
    - Code
publishDate: 2019-11-15
postWithImg: true
image:      ""
postWithImg: true
showtoc: false
URL: "/2019/11/15/vscode-as-idle-for-Django/"
#wechat pay & alipay & Paypal
reward: true
---
This blog is about using MS VSCode as Django IDLE (OS: Mac OX, the steps are referenceable on Linux, Windows).

##### 1. Download installation files and install MS VScode, Python from following links:

- [MS VSCode](https://code.visualstudio.com/download)

- [Python3](https://www.python.org/downloads/)

> **Optional:** On Mac OS, I recommend [homebrew](https://brew.sh/) for Python Installation because third party libraries' dependency will be processed smoothly.
>
> Install ```homebrew```:
>
> ```shell
> /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
> ```
> Install ```Python3```:
>
> ```shell
> brew install python@3
> ```

##### 2. Python Extension

Launch VSCode and install the Extension: [Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)

{{< imgproc imgPath="2019/11/01-lunchvs-opt.png" alt="Launch VS" max-height="150" >}}

{{< imgproc imgPath="2019/11/01-ext-opt.png" alt="Install Extension" max-height="280" >}}

**Note**: Pay attention to the prompt of 'Install' button because restart MS VScode might be required

##### 3. "Hello World"

- Select or create a folder for the Django project

    E.g.: using '~/Documents/Django_test' as the project folder
    {{< imgproc imgPath="2019/11/01-open-1-opt.png" alt="Open folder-1" max-height="140" >}}
    {{< imgproc imgPath="2019/11/01-open-2-opt.png" alt="Open folder: Document" max-height="220" >}}
    {{< imgproc imgPath="2019/11/01-open-3-opt.png" alt="New Folder-1" max-height="400" >}}
    {{< imgproc imgPath="2019/11/01-open-4-opt.png" alt="New Folder-2" max-height="120" >}}

- MS Code, Python verification

    New 'test.py' in the folder: 'Document/Django_test'

    {{< imgproc imgPath="2019/11/01-open-5-opt.png" alt="New File-1" max-height="160" >}}
    {{< imgproc imgPath="2019/11/01-open-6-opt.png" alt="New File-2" max-height="100" >}}

    The file will be loaded in the editor area, enter ```print("Hello world!")```:
    {{< imgproc imgPath="2019/11/01-open-7-opt.png" alt="New File-3" max-height="140" >}}

    Python2.x was installed on Mac by default, hence select Python Interpreter might be required before run the file:

    {{< imgproc imgPath="2019/11/01-open-8-opt.png" alt="Interpreter" max-height="280" >}}

    **Note:** The info here might be different from yours because of OS, Python version differences.

    {{< imgproc imgPath="2019/11/01-open-9-opt.png" alt="Run Py file-1" max-height="320" >}}

    A terminal toolbar will pop up and the Py file will be executed:
    {{< imgproc imgPath="2019/11/01-open-10-opt.png" alt="Run Py file-2" max-height="180" >}}

    Since verification is done here, delete test.py file
    {{< imgproc imgPath="2019/11/01-open-11-opt.png" alt="Delete file" max-height="260" >}}

##### 4. Install [virtualenv](https://virtualenv.pypa.io/en/latest/), Django

- Create a folder: "venv" inside the project folder for the Python virtual environment

    {{< imgproc imgPath="2019/11/01-ve-1-opt.png" alt="New Folder-1" max-height="180" >}}
    {{< imgproc imgPath="2019/11/01-ve-2-opt.png" alt="New Folder-2" max-height="100" >}}

    Find "Terminal" from menu:
    {{< imgproc imgPath="2019/11/01-ve-3-opt.png" alt="Active Terminal" max-height="180" >}}

    **Note**: The hotkey to active the terminal on Mac OS is ```Control + ` ```

    In the pop terminal window, execute the commands:
    ```shell
    pip3 install virtualenv
    cd Django_test
    virtualenv venv
    ```

    Sample for last two commands:
    {{< imgproc imgPath="2019/11/01-ve-3-1-opt.png" alt="run commands in terminal" max-height="120" >}}

    **Note**:
    - For **homebrew**, you might meet the permission issue, it can be resolved by executing command:  ```pip3  install virtualenv --user```. Here is the example:

        {{< highlight bash "linenos=table,hl_lines=1 6 12 16-17" >}}
% pip3  install virtualenv
Collecting virtualenv
Downloading https://files.pythonhosted.org/packages/c5/97/00dd42a0fc41e9016b23f07ec7f657f636cb672fad9cf72b80f8f65c6a46/>virtualenv-16.7.7-py2.py3-none-any.whl (3.4MB)
    100% |████████████████████████████████| 3.4MB 5.2MB/s
Installing collected packages: virtualenv
Could not install packages due to an EnvironmentError: [Errno 13] Permission denied: '/Library/>Python/3.7'
Consider using the `--user` option or check the permissions.>

You are using pip version 19.0.3, however version 19.3.1 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.>

% pip3  install virtualenv --user
Collecting virtualenv
Using cached https://files.pythonhosted.org/packages/c5/97/00dd42a0fc41e9016b23f07ec7f657f636cb672fad9cf72b80f8f65c6a46/>virtualenv-16.7.7-py2.py3-none-any.whl
Installing collected packages: virtualenv
The script virtualenv is installed in '/Users/admin/Library/Python/3.7/bin' which is not on PATH.
Consider adding this directory to PATH or, if you prefer to suppress this warning, use >--no-warn-script-location.
Successfully installed virtualenv-16.7.7
You are using pip version 19.0.3, however version 19.3.1 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.>

% pip3 install --upgrade pip --user
Collecting pip
Using cached https://files.pythonhosted.org/packages/00/b6/>9cfa56b4081ad13874b0c6f96af8ce16cfbc1cb06bedf8e9164ce5551ec1/pip-19.3.1-py2.py3-none-any.whl
Installing collected packages: pip
Successfully installed pip-19.3.1{{</ highlight >}}
        **Note**: Please task care of the highlight content, especially line: 16-17.
    - Please check the homebrew output highlight lines if you got the error: ```command not found: virtualenv```, , you could using ```/Users/admin/Library/Python/3.7/bin/virtualenv``` instead, or adding ```/Users/admin/Library/Python/3.7/bin/``` to ```PATH```.

- Active virtual environment in VSCode

    {{< imgproc imgPath="2019/11/01-ve-4-opt.png" alt="Active virtual Environment" max-height="380" >}}

    {{< imgproc imgPath="2019/11/01-ve-5-opt.png" alt="Select VE depends the path" max-height="260" >}}

- Install Django

    {{< imgproc imgPath="2019/11/01-terminal-1-opt.png" alt="Active terminal" max-height="250" >}}

    {{< imgproc imgPath="2019/11/01-terminal-2-opt.png" alt="VS Code active VE automatically" max-height="120" >}}

    Execute the following command in the terminal to install Django:
    ```shell
    pip3 install Django
    ```

##### 5. Run Django

With MS VScode task feature, regular tasks could be executed easily, let's say `Django runserver` command.

- Configure task

    {{< imgproc imgPath="2019/11/01-task-1-opt.png" alt="New Task 1" max-height="80" >}}

    {{< imgproc imgPath="2019/11/01-task-2-opt.png" alt="New Task 2" max-height="150" >}}

    {{< imgproc imgPath="2019/11/01-task-3-opt.png" alt="New Task 3" max-height="80" >}}

    {{< imgproc imgPath="2019/11/01-task-4-opt.png" alt="New Task 4" max-height="150" >}}

    A new window will pop up, edit the file and save it. Here is a sample about tasks.json:

    ```json
    {
        // See https://go.microsoft.com/fwlink/?LinkId=733558
        // for the documentation about the tasks.json format
        "version": "2.0.0",
        "tasks": [
            {
                "label": "Run Django",
                "type": "shell",
                "command": "/Users/kezh/Documents/Django_test/venv/bin/python3 /Users/kezh/Documents/Django_test/testprj/manage.py runserver 0.0.0.0:8000"
            }
        ]
    }
    ```

    The command is consist of:

    ```path_of_venv_python_bin path_of_Django_manage.py runserver host_addr:port```

- Run task

    {{< imgproc imgPath="2019/11/01-task-1-opt.png" alt="Run Task 1" max-height="80" >}}

    {{< imgproc imgPath="2019/11/01-runtask-1-opt.png" alt="Run Task 2" max-height="60" >}}

    {{< imgproc imgPath="2019/11/01-runtask-2-opt.png" alt="Run Task 3" max-height="60" >}}

    {{< imgproc imgPath="2019/11/01-runtask-3-opt.png" alt="Run Task 4" max-height="130" >}}

    {{< imgproc imgPath="2019/11/01-runtask-4-opt.png" alt="Run Task 5" max-height="200" >}}

##### Reference

- [A tutorial about setup Sublime Text with Anaconda and multiple Python versions](/2016/06/07/python-sublimetext-anaconda/)
- [MS VS Code for Python debug](/2016/11/10/vscode-for-python-debug/)
