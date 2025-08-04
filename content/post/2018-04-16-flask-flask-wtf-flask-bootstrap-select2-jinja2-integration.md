---
title:      "Flask, Flask-WTF, Flask-Bootstrap, Select2, jinja2 integration"
subtitle:   ""
description: "A sample of Flask"
date:       2018-04-16
tags:
    - Python-Flask
    - Select2
    - JavaScript
    - Troubleshooting
    - Python
    - Web
publishDate: 2018-04-16
image:      ""
postWithImg: true
categories:
    - Code
#wechat pay & alipay & Paypal
reward: true
URL: "/2018/04/16/flask-flask-wtf-flask-bootstrap-select2-jinja2-integration/"
---
I intend to acquire the Python skill on web after years' work on data processing, so I started with [Flask](http://flask.pocoo.org/) by the following Miguel [Grinberg's instruction](https://blog.miguelgrinberg.com/author/Miguel%20Grinberg): [The Flask Mega](https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-i-hello-world), you can learn how to integrate bootstrap with your project from it.

After that, you can learn how to integrate select2 with your project by reading [Flask Web开发:用Select2实现类似知乎的标签系统](https://blog.csdn.net/zheng_integer/article/details/59507942) as a guide.

Here is a [demo of select2](https://select2.github.io/select2-bootstrap-theme/):

{{< imgproc imgPath="2018/04/1-opt.png" alt="run mininet" max-height="200" >}}

Packages:

- Jinja2 2.10
- WTForms 2.1
- WTForms-Components 0.10.3
- WTForms-SQLAlchemy 0.1SQLAlchemy 1.2.6
- Flask 0.12.2
- Flask-Bootstrap 3.3.7.1
- Flask-Migrate 2.1.1
- Flask-SQLAlchemy 2.3.2
- Flask-WTF 0.14.2

#### 1. TypeError: $(...).select2 is not a function

I met this error at the start of integration, and found my answer from stackoverflow (See my code in Q2 part):

> This error raises if your js files where you have bounded the select2 with a select box is loading before select2 js files. Please make sure files should be in this order like:
> - Jquery
> - select2 js
> - your js

I found that jquery was loaded twice from developer Tools even if I have linked it in the header, this has been mentioned in [Flask Bootstrap official guide](https://pythonhosted.org/Flask-Bootstrap/faq.html#why-is-bootstrap-javascript-not-loading):

>An easy-to-miss quirk are the block names: While there is a block named body, it usually is not the one you want to replace, use content instead. Currently, javascript is loaded at the end of the tag by default).

#### 2. Flask renders the header of HTML twice

The resolution for Q1 and Q2 is more like a trick about how to use Flask Bootstrap blocks.

Here is my code:

- base.html

    ~~~jinja2
    {% extends 'bootstrap/base.html' %}
    {% block styles %}
        <link href="{{ url_for('.static', filename='css/bootstrap.min.css') }}" rel="stylesheet">
    {% endblock %}
    {% block title %}
        Python Flask, Flask-WTF, Flask-Bootstrap, Select2, jinja2 integration
    {% endblock %}
    {% block scripts %}
        <script src="{{ url_for('.static', filename='js/jquery.min.js') }}"></script>
    {% endblock %}
    {% block content %}
    {% endblock %}
    ~~~

- extend.html

    ~~~jinja2
    {% extends "base.html" %}
    {% import 'bootstrap/wtf.html' as wtf %}
    {% block styles %}
        {{ super() }}
        <link href="{{ url_for('.static', filename='css/select2.css') }}" rel="stylesheet">
        <link href="{{ url_for('.static', filename='css/select2-bootstrap.css') }}" rel="stylesheet">
    {% endblock %}
    {% block scripts %}
        {{ super() }}
        <script src="{{ url_for('.static', filename='js/select2.js') }}"></script>
        <script type="text/javascript">
            $('select').select2({
                theme: 'bootstrap',
                language: 'zh-CN',
                allowClear: true,
            });
        </script>
    {% endblock %}}
    {% block content %}
    <div class="container">
        <form action="" method="post">
            <div class="col-md-2">
                {{ wtf.form_field(form.ctgy, class='form-control') }}
            </div>
    </form>
    </div>
    {% endblock %}
    ~~~

#### 3. Flask-WTF and wtforms_sqlalchemy

I met the following error when I try to organize _select_'s data from DB query result

~~~python
cls, key = identity_key(instance=obj)
~~~

~~~python
ValueError: too many values to unpack (expected 2)
~~~

Here is the [patch](https://github.com/kvesteri/wtforms-alchemy/pull/128/commits/4b20d130ca1480bd8697bf8ca80720d80150174f?diff=split) about the issue.
