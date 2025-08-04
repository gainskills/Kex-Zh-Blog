---
title:      "Python多版本, Sublime Text, Anaconda指北"
Lang: "zh"
subtitle:   ""
description: "A tutorial about setup Sublime Text with Anaconda and multiple Python versions"
date:       2016-06-07
tags:
    - Sublime Text
    - Anaconda
    - Tip
    - Python
categories:
    - Code
publishDate: 2016-06-07
postWithImg: true
image:      ""
postWithImg: true
showtoc: false
URL: "/2016/06/07/python-sublimetext-anaconda/"
#wechat pay & alipay & Paypal
reward: true
---
#### 介绍
- [Sublime text](https://www.sublimetext.com/)是一款很好用的文本编辑器，更是一款先进的代码编辑器，支持通过插件进行功能扩展。在使用过UltraEditor, Notepad++, vim等等编辑器后，感觉sublime text最好用 (Update @ 2019-02-07: 目前由Sublimetext转移至[MS VSCode](https://code.visualstudio.com/))。

    Sublime text是一款收费软件，但只是会弹出提示购买的窗口，功能未做任何限制，在经济能力允许时请一定要购买License。

    Sublime text有两个版本[sublime text2](https://www.sublimetext.com/2)停止维护和[sumblime text3](https://www.sublimetext.com/3)，它们支持Linux(32/64 bit)、windows(32/64 bit)，OS X64 bit only)多操作系统,更是提供了免安装的版本（赞赞赞！）
- [Anaconda](http://damnwidget.github.io/anaconda/)是Sublime Text的一款插件，它对于Sublime text的Python IDLE如虎添翼

    推荐特性：代码格式化、引用错误检查、Go To definition。

#### 安装

Anaconda提供了详细的[安装教程](http://damnwidget.github.io/anaconda/#using-anaconda-installation)，简单的罗列如下。

1. 安装Python

    我安装了Python3.1和Python3.5，未将其添加至系统path

    注：Anaconda使用Python3.1时会出现IDLE挂死的情况；通过Sublime text + Anaconda能够灵活的设置Python版本，所以个人未不在系统Path变量中设置Python路径（稍后提供相关的配置信息）

2. 安装Sublime text

    [下载安装](https://www.sublimetext.com/3)。喜欢尝试新事物，所以使用新版本

3. Sublime Text安装package control

    Sublime Text的插件安装、更新是通过package control进行，简洁、高效！
    [package controller installation instruction](https://packagecontrol.io/installation)

4. 安装Anaconda

    Sublime Text快捷键Ctrl+Shift+P (Tools -> Command Palette) 启用command Palette

    {{< imgproc imgPath="2016/06/1-opt.jpg" alt="Command Palette" max-height="90" >}}

    回车后输入anaconda

    {{< imgproc imgPath="2016/06/2-opt.jpg" alt="anaconda" max-height="90" >}}

    回车，Anaconda的安装就完成了

#### 配置

Anaconda也提供了相应的[配置教程](http://damnwidget.github.io/anaconda/#using-anaconda-per-project-config)，我将自己的使用情况罗列如下：

1. 设置默认的Python解析器

    针对Python3.1+Anaconda会导致sublime text挂死，又未在系统path变量设置Python路径；我在Anaconda手工指定了Python解释器使其使用Python3.5并创建Build System

    Why创建Build System?

    Sublime text内置的Python Build System是直接调用Python.exe，当系统Path变量内未设置Python路径时，此功能会因调用Python.exe失败而不可用

2. 配置文件内容：

    {{< imgproc imgPath="2016/06/7-opt.jpg" alt="configuration" max-height="250" >}}

    {{< highlight text "hl_lines=2 8" >}}
{
    “python_interpreter”: “D:/Program Files (x86)/python3.5/python”,
    “build_systems”:
    [
        {
            “name”: “Python3.5×64”,
            “selector”: “source.python”,
            “shell_cmd”: “\”D:\\Program Files (x86)\\python3.5\\python\” -u \”$file\””
        }
    ]
}{{< /highlight >}}
    配置后，Anaconda就可以正常工作了。接下来介绍如何配置build system实现多版本Python的调用.

2. 创建Project并配置Python

    Anaconda可以project为单位指定Python版（可以与virtualenv配合使用）。以我为例 ，工作项目使用Python3.1，自己平时则使用Python3.5。

    - 通过Project菜单创建两个Projects

        {{< imgproc imgPath="2016/06/3-opt.jpg" alt="New Project" max-height="260" >}}

    - 通过Project -> Open Project或Open Recent，打开Python3.1的Project
    - Project -> Edit Project 配置Python

        {{< highlight text "hl_lines=7" >}}
{
    “build_systems”:
    [
        {
            “name”: “Python31”,
            “selector”: “source.python”,
            “shell_cmd”: “\”D:\\Program Files (x86)\\python3.1\\python\” -u \”$file\””
        }
    ],
}{{< /highlight >}}

    - 此Project的Build System:
        {{< imgproc imgPath="2016/06/4-opt.jpg" alt="Build System-3.1" max-height="140" >}}

    - 通过Project -> Open Project或Open Recent，打开Python3.5的Project
    - Project -> Edit Project配置Python
        {{< highlight text "hl_lines=7" >}}
{
    “build_systems”:
    [
        {
            “name”: “Python3.5×64”,
            “selector”: “source.python”,
            “shell_cmd”: “\”D:\\Program Files (x86)\\python3.5\\python\” -u \”$file\””
        }
    ],
}{{< /highlight >}}

    - 此Project的Build System:
        {{< imgproc imgPath="2016/06/5-opt.jpg" alt="Build System-3.5" max-height="140" >}}

    接下来，按照自己的需求使用不同的Project就可以愉快的使用不同版本的Python了。
