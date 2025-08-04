---
title:      "30分钟上手Python网络爬虫"
Lang: "zh"
subtitle:   ""
description: "A tutorial about web scraper"
date:       2018-01-30
tags:
    - Selenium
    - Scraping
    - Translation
    - Webdriver
    - 爬虫
    - Python
    - Web
publishDate: 2018-01-30
image:      ""
categories:
    - Code
#wechat pay & alipay & Paypal
reward: true
URL: "/2018/01/30/30min-python-web-scrapper/"
---
原文链接: [https://hackernoon.com/30-minute-python-web-scraper-39d6d038e5da](https://hackernoon.com/30-minute-python-web-scraper-39d6d038e5da)

此翻译已经获得作者许可。对原文、本文任何形式的转载、引用，必须知会作者

我想用Python和[Selenium](http://www.seleniumhq.org/)做网络爬虫有一会了，但是一直没有实施。几天之前，我决定小试一下。看起来令人望而却步，但实现代码从[Unsplash](https://unsplash.com/)抓取一些漂亮的图片却是相当容易的。

#### 简易图片爬虫的食材

- [Python](https://www.python.org/downloads/)(3.6.3或更新的版本)
- [Pycharm](https://www.jetbrains.com/pycharm/download/#section=windows)(社区版就够了)
- pip install [requests](http://docs.python-requests.org/en/master/user/install/#install) [Pillow](https://pillow.readthedocs.io/en/latest/installation.html#basic-installation) [selenium](http://selenium-python.readthedocs.io/installation.html#downloading-python-bindings-for-selenium)
- [geckodriver](https://github.com/mozilla/geckodriver/releases/latest)
- [Mozlla Firefox](https://www.mozilla.org/en-US/firefox/new/)
- 互联网
- 30分钟(或更少）

*译者注：

1. 我是在MAC OS使用[VS Code](https://code.visualstudio.com/) + [Python extension](https://github.com/Microsoft/vscode-python).MAC OS自带了Python2,一定要在VS Code中将Python解释器关联为你安装的Python3.

2. 与windows不同，geckodriver在MAC OS上没有.exe的后缀

3. 参考[selenium文档](http://selenium-python.readthedocs.io/installation.html)，安装geckodriver，即将下载的geckodriver复制到 /usr/bin 或 /usr/local/bin

#### 简易图片爬虫的食谱

一切安装就绪了？好！在循序渐进深入代码的同时，我会解释每道食材的用途。

首先要做的是绑定 selenium webdriver 和 geckodriver 打开一个为我们工作的浏览器窗口。开始之前，在Pycharm中新建一个工程，下载与你系统对应的最新版本的geckodriver，打开压缩文件并将geckodriver拖拽至你的工程目录中。简单地讲，geckodriver使Selenium获取Firefox控制，所以我们需要它在我们的工程目录中来使用浏览器。

我们要做的下一件事是从Selenium中引入webdriver插入到我们的代码中并连接至我们想连接的URL。所以我们这样做：

<script src="https://gist.github.com/Chalarangelo/2dafc6379d6f893e83740160928abfef.js"></script>

在窗口中打开指定的链接

{{< imgproc imgPath="2018/01/1-opt.png" alt="Run" max-height="400" >}}

很简单，哈？如果你已经正确地做了每件事，你已经过了难的部分，并且你应该看到一个和上面图片相似的浏览器窗口。

接下来，我们应该向下滚动窗口这样在下载前有更多的图片可以被加载。我们还想等几秒钟以防连接速度慢以及图片未能完全加载。因为Unsplash是用React构建的，等5秒好像足够了，所以我们只这样做，使用time包。我们还想使用一些Javascript代码来滚动页面 -- 我们将会用 window.scrollTo() 来实现这个。将这些放到一块，你最终应该得到类似这样的代码：

<script src="https://gist.github.com/Chalarangelo/6f05ffc8171a505ec55a35e413002bed.js"></script>

在测试上述代码后，你应该看到浏览器将页面向下滑动了一点。接下来需要做的事情是从这个网站查找我们想要下载的图片。在研究Ract生成的代码后，我发现我们可以使用一个CSS选择器明确的指向页面上相册的图片。这个页面的特定排版和代码将来可能会变，但在我写作的时候我可以使用 #gridMulti img 选择器获取所有显示在我屏幕上的  元素。

我们可以使用 find_elements_by_css_selector() 获取那些元素的一个列表，但我们想要每个元素的 src 属性。所以，我们可以通过迭代这个列表，并抓取它们：

<script src="https://gist.github.com/Chalarangelo/50818a3f9e3c13aaf52297d41f79f987.js"></script>

现在，真的要开始获取我们找到的图片了。为此，我们将使用 requests 和部分 PIL 库，Image 。我们还将从 io 使用 BytesIO 将图片写至我们将在工程目录中创建的 ./images/ 目录。这样，将这些放到一起，我们需要发送一个HTTP GET request 去获取每个图片的URL，使用 Image 和 BytesIO, 我们会保存从响应中获取的图片。这是实现的一种方式：

<script src="https://gist.github.com/Chalarangelo/ec5c8bed17396e8e55cf3305dbb88f56.js"></script>

译者注：

- MAC OS + VS Code + Python Extension执行脚本时，默认路径是 /Users/user folder
- 请注意创建保存图片的 _images_ 目录，附上我自己使用的脚本:

<script src="https://gist.github.com/gainskills/6d5b1ad35a2f60529a422074a455a8da.js"></script>

只是下载一些免费图片，这些已经足够了。明显地，除非你想原型化一个设计并且你只需要随机的图片，这个小爬虫不够好。所以，我花了时间通过添加一些其它特性来优化它：

- 命令行参数，允许用户指定一个搜索参数，同样还有滚动的数值，能够使页面为下载加载更多的图片
- 可定义的CSS选择器
- 可定义的保存目录，基于搜索查询
- 如果需要，裁剪缩略图的URL获取全高清图片
- 基于URL命名图片
- 过程结束后关闭浏览器窗口

你可以（并且应该）尝试自己根据自己的需要去实现部分特性。这个完整特性的网络爬虫在[这](https://github.com/Chalarangelo/unscrape)。记得分别下载 _geckodriver_ 并将它连接至你的工程，如文章开始中的指导。

**限制，考虑及优化**

整个工程是一个非常简单的概念验证以了解网络爬虫如何完成的，意味着有很多事情可以基于这个小工具优化：

- 不感谢图片的原上传者是个坏主意。Selenium明显有能力实现这个，所以每个图片都有作者的名字。
- Geckodriver 不应该放在项目目录，而应该全局安装并 PATH 系统变更
- 搜索功能能够轻易扩展以包含多个查询，这样下载多个图片的过程可以简化。
- 默认浏览器可以由Firefox换成Chrome或者甚至[PhantomJs](http://phantomjs.org/), 对这类工程会更好。
