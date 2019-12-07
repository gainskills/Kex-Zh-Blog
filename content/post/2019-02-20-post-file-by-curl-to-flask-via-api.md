---
title:      "Post a file to Flask by Curl via API"
subtitle:   ""
description: "A practice about API"
date:       2019-02-20
tags:
    - Curl
    - Flask
    - API
    - Post
    - Tinypng
    - Tip
    - Python
    - Web
published: true
image:      ""
categories:
    - Code
#wechat pay & alipay & Paypal
reward: true
URL: "/2019/02/20/post-file-by-curl-to-flask-via-api/"
---
[Curl](https://curl.haxx.se/docs/manpage.html) is widely used in command lines or scripts to transfer data.<br>
Different ways to use curl to post a file to a web server with samples (from both client side and server: [Python-Flask](http://flask.pocoo.org/) side) will be discussed because it took me a while on server side to receiving the data from client.<br>
I would like to adding samples of [Python-requests](http://docs.python-requests.org/en/master/), [Postman](https://www.getpostman.com/) later.

- ##### Started with

    - macOS Mojave
    - Python 3.7.2
    - Flask 1.0.2
    - Flask-RESTful 0.3.7
    - curl 7.54.0 (x86_64-apple-darwin18.0)

    The Flask code:
        {{< highlight Python >}}
# Py file name: simple.py
from flask import Flask, request
from flask_restful import Api, Resource, reqparse
import werkzeug

app = Flask(__name__)
api = Api(app)

class kzwebfile(Resource):

    def post(self, filename):
        pass

api.add_resource(kzwebfile, '/<string:filename>')

if __name__ == "__main__":
    app.run()
{{< /highlight >}}

    Run it:
    {{< highlight bash "hl_lines=1" >}}
(flask) $ python3 simple.py
* Serving Flask app "simple" (lazy loading)
* Environment: production
WARNING: Do not use the development server in a production environment.
Use a production WSGI server instead.
* Debug mode: off
* Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
{{< /highlight >}}

- ### 1st try

    Refer to Tinypng [Developer API](https://tinypng.com/developers)(I used this method in [image optimization](/2019/01/25/post-img-mgmt-hugo/#before-start) for Hugo posts), the file can be uploaded to server in this way:
    {{< highlight bash >}}
curl --data-binary @test.png http://127.0.0.1:5000/test{{< /highlight >}}

    Searched on StackOverflow, here is a [post]((https://stackoverflow.com/a/16664376/2701959)) about [All attributes](http://flask.pocoo.org/docs/1.0/api/#flask.Request) on the request was summarized by the author of Flask. <br>
    I tried to check the attributions with following code, but I found ```request.stream```, ```request.data``` and ```request.files``` affect each other (the content of ```stream``` become empty) when I adjusting the order of ```print``` syntaxes.
    {{< highlight Python "hl_lines=3-6" >}}
    def post(self, filename):
        print("---stream---\r\n", request.stream.read()) # without read(), it returns <werkzeug.wsgi.LimitedStream object at > all the time
        print("---data---\r\n", request.data)
        print("---args---\r\n", request.args)
        print("---files---\r\n", request.files)
        print("---form---\r\n", request.form)
        # print("---values---\r\n", request.values) # comment this because it just combined args and form.{{< /highlight >}}

     Output:
    {{< highlight bash "hl_lines=2 4 6 8 10" >}}
---stream---
 b'\x00....<omitted>...'
---data---
 b''
---args---
ImmutableMultiDict([])
---files---
ImmutableMultiDict([])
---form---
ImmutableMultiDict([('\x00\x00\x01....<omitted>...', '')]){{< /highlight >}}

    Output after ```print``` syntaxes were adjusted:
    {{< highlight bash "hl_lines=2 4 6 8 10" >}}
---data---
 b''
---args---
ImmutableMultiDict([])
---files---
ImmutableMultiDict([])
---form---
ImmutableMultiDict([('\x00\x00\x01....<omitted>...', '')])
---stream---
 b''{{< /highlight >}}

    _Note: The attribute: ```request.stream``` was mentioned in [another answer](https://stackoverflow.com/a/38311116/2701959)._

- ### ```request.form```

    Before further steps, I realized [```request.form```](http://flask.pocoo.org/docs/1.0/api/#flask.Request.form) receive the data. Checked the ```request.headers``` about the content-type:
    {{< highlight Python "hl_lines=1" >}}
    def post(self, filename):
        print("---headers---\r\n",request.headers){{< /highlight >}}

    {{< highlight bash "hl_lines=6" >}}
---headers---
Host: 127.0.0.1:5000
User-Agent: curl/7.54.0
Accept: */*
Content-Length: 1150
Content-Type: application/x-www-form-urlencoded
Expect: 100-continue{{< /highlight >}}

    The content type is ```application/x-www-form-urlencoded``` which was mentioned in [Curl document](https://ec.haxx.se/http-post.html) as well:

    > POSTing with curl's -d option will make it include a default header that looks like Content-Type: ```application/x-www-form-urlencoded```

    Checked ```request.form```: ```ImmutableMultiDict``` with ```request.form.[to_dict()](https://tedboy.github.io/flask/generated/generated/werkzeug.ImmutableMultiDict.html)```, the key of it is the content of file, the value of it is empty.

    By comparing with coverting the ```ImmutableMultiDict``` to list and retrieve the data via index, the option: <strong>```data-urlencode```</strong> would be a better choice
    {{< highlight bash >}}
curl --data-urlencode image@test.png http://127.0.0.1:5000/test{{< /highlight >}}

    {{< highlight bash >}}
ImmutableMultiDict([('image', '\x00 ...<omitted>...\x00')]){{< /highlight >}}

- ### Checked the POST data again

    Went through Flask official document, and found [```get_data()```](http://flask.pocoo.org/docs/1.0/api/#flask.Request.get_data) is available for incoming data.

    Updated the code to:
    {{< highlight Python >}}
    def post(self, filename):
        print("---headers---\r\n", request.headers)
        print("---get_data---\r\n", request.get_data()){{< /highlight >}}

    Checked this with content type: ```Content-Type: application/json```:
    {{< highlight bash >}}
curl --data @test.png -H 'Content-Type: application/json' http://127.0.0.1:5000/test{{< /highlight >}}

    The data can be received:
    {{< highlight Bash >}}
---get_data---
 b'\x00\x00 ....<omitted>... \x00'{{< /highlight >}}

    Following content types were tested as well:

    - ```Content-Type: image/png```
    - ```Content-Type: application/octet-stream```
    - ```Content-Type: multipart/form-data```
    - ```Content-Type: text/csv``` (with a csv file)

    _Note: In my testing, ```request.stream``` woks as ```get_data()```,differnt to the [official document](http://flask.pocoo.org/docs/1.0/api/#flask.Request.stream):_

    >If the incoming form data was not encoded with a known mimetype the data is stored unmodified in this stream for consumption. **Most of the time it is a better idea to use ```data``` which will give you that data as a string**. The stream only returns the data once.

- ### Option: -F

    Refer the [sample](https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1444738726), test it with:
    {{< highlight bash >}}
curl -F media=@test.png http://127.0.0.1:5000/test{{< /highlight >}}

    the output:
    {{< highlight bash "hl_lines=7 10" >}}
---headers---
 Host: 127.0.0.1:5000
User-Agent: curl/7.54.0
Accept: */*
Content-Length: 1351
Expect: 100-continue
Content-Type: multipart/form-data; boundary=------------------------80bc4d7df251bbac

---get_data---
 b'--------------------------80bc4d7df251bbac\r\nContent-Disposition: form-data; name="media"; filename="test.png"\r\nContent-Type: application/octet-stream\r\n\r\n\x00\x00\x01\x00....<omitted>... \x00\r\n--------------------------80bc4d7df251bbac--\r\n'{{< /highlight >}}

    [<strong>```files```</strong>](http://flask.pocoo.org/docs/1.0/api/#flask.Request.files) should be the option instead of dealing with the ```boundary``` with the ```get_data()```:

    {{< highlight Python >}}
    def post(self, filename):
        print("---headers---\r\n", request.headers)
        print("---files---\r\n", request.files()){{< /highlight >}}

    {{< highlight bash "hl_lines=10" >}}
---headers---
 Host: 127.0.0.1:5000
User-Agent: curl/7.54.0
Accept: */*
Content-Length: 1351
Expect: 100-continue
Content-Type: multipart/form-data; boundary=------------------------c446447e71e96358

---files---
 ImmutableMultiDict([('media', <FileStorage: 'test.png' ('application/octet-stream')>)]){{< /highlight >}}

- ### Request Parsing
    [flask-restful](https://flask-restful.readthedocs.io/en/latest/) provides a module: [Request Parsing](https://flask-restful.readthedocs.io/en/latest/reqparse.html#basic-arguments) to provide simple and uniform access to the variable on ```flask.request``` object.

    - command:
        {{< highlight bash >}}
curl --data-urlencode image@test.png http://127.0.0.1:5000/test{{< /highlight >}}

        can be supported with:
    {{< highlight bash >}}
parser = reqparse.RequestParser()
parser.add_argument('image', required=True, help="image filed is required",  location='form')

class kzwebfile(Resource):

    def post(self, filename):
        args = parser.parse_args()
        print(args['image']){{< /highlight >}}

    - command:
        {{< highlight bash >}}
curl -F media=@test.png http://127.0.0.1:5000/test{{< /highlight >}}

        can be supported with:
        {{< highlight bash >}}
parser = reqparse.RequestParser()
parser.add_argument('media', type=werkzeug.datastructures.FileStorage, required=True, help="media field is required",  location='files')

class kzwebfile(Resource):

    def post(self, filename):
        args = parser.parse_args()
        print(args['media']){{< /highlight >}}

    Check more from this [document](https://flask-restful.readthedocs.io/en/latest/reqparse.html#argument-locations).
