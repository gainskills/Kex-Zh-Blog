---
title:      "VSCode as an IDLE for Django"
subtitle:   ""
description: "VSCode Guide for beginner"
date:       2019-11-15
tags:
    - Django
    - Web
    - Python
categories:
    - Code
published: true
postWithImg: true
image:      ""
postWithImg: true
showtoc: false
URL: "/2019/11/15/vscode-as-idle-for-django/"
#wechat pay & alipay & Paypal
reward: true
---
I documented two articles about the IDLE for Python development before:

- [A tutorial about setup Sublime Text with Anaconda and multiple Python versions](/2016/06/07/python-sublimetext-anaconda/)
- [MS VS Code for Python debug](https://www.slideshare.net/69444091/vs-code-debug?ref=https://www.slideshare.net/69444091/slideshelf)

This is another one to using MS VSCode as Django IDLE (OS: Mac OX, the steps are referenceable on Linux, Windows).

##### 1. Download installation files and Install MS VScode, Python

- [MS VSCode](https://code.visualstudio.com/download)

- [Python](https://www.python.org/downloads/)

> On Mac OS, I recommend [homebrew](https://brew.sh/) for Python Installation because third party libraries' dependency will be processed smoothly.
>
> Install <code>homebrew</code>:
>
> ```shell
> /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
> ```
> Install <code>Python3</code>:
>
> ```shell
> brew install python@3
> ```

##### 2. Install [virtualenv](https://virtualenv.pypa.io/en/latest/), Django

- Run the command in terminal to install virtualenv

    ```shell
    pip3 install virtualenv
    ```

- homebrew

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

- Active virtual environment and Install Django in VSCode

    - Select or create a folder for Django project

        ```shell
        mkdir django_test
        ```

    - Create a sub folder for Python virtual environment

        ```shell
        cd django_test
        mkdir venv
        virtualenv venv
        ```

        **Note**: For the case it prompts you <code>command not found: virtualenv</code>, please check the [#2 -> homebrew](/2019/11/15/vscode-as-idle-for-django/#2-install-virtualenv-https-virtualenv-pypa-io-en-latest-django) part, you could using <code>/Users/admin/Library/Python/3.7/bin/virtualenv</code> instead, or adding <code>/Users/admin/Library/Python/3.7/bin/</code> to <code>PATH</code>.

    - Active virtual environment in VSCode

        {{< imgproc imgPath="2019/11/01-open-1-opt.png" alt="Open folder-1" max-height="120" >}}

        {{< imgproc imgPath="2019/11/01-open-2-opt.png" alt="Open folder-2" max-height="300" >}}

        {{< imgproc imgPath="2019/11/01-ve-1-opt.png" alt="Active virtual Environment" max-height="380" >}}

        {{< imgproc imgPath="2019/11/01-ve-2-opt.png" alt="Select VE depends the path" max-height="260" >}}

    - Active terminal in VSCode, install Django

        {{< imgproc imgPath="2019/11/01-terminal-1-opt.png" alt="Active terminal" max-height="250" >}}

        **Note**: The hot key to active the terminal on Mac OS is <code>Control + `</code>

        {{< imgproc imgPath="2019/11/01-terminal-2-opt.png" alt="VSCode active VE automatically" max-height="120" >}}

        Execute following command in the terminal to install Django:
        ```shell
        pip3 install django
        ```

##### 3. Run Django

Congratulations! you can work on your django project within VSCode right now.

With MS VScode task feature, some regular task could be executed easily, let's say Django runserver command.

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
                "command": "/Users/kezh/Documents/project/django_test/venv/bin/python3 /Users/kezh/Documents/project/django_test/testprj/manage.py runserver 0.0.0.0:8000"
            }
        ]
    }
    ```

    The command is consist of:

    <code>
    "<i>path_of_venv_python_bin</i> <i>path_of_Django_manage.py</i> runserver <i>host_addr</i>:<i>port</i>"</code>

- Run task

    {{< imgproc imgPath="2019/11/01-task-1-opt.png" alt="Run Task 1" max-height="80" >}}

    {{< imgproc imgPath="2019/11/01-runtask-1-opt.png" alt="Run Task 2" max-height="60" >}}

    {{< imgproc imgPath="2019/11/01-runtask-2-opt.png" alt="Run Task 3" max-height="60" >}}

    {{< imgproc imgPath="2019/11/01-runtask-3-opt.png" alt="Run Task 4" max-height="130" >}}

    {{< imgproc imgPath="2019/11/01-runtask-4-opt.png" alt="Run Task 5" max-height="200" >}}
