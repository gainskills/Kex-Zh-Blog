---
layout:     post
title:      "Hugo-Images management"
subtitle:   ""
description: "Hugo tutorials"
date:       "2019-01-25"
lastmod:    "2019-03-09"
tags:
    - Hugo
    - Blog
    - Html
    - Tip
    - Lazy load
    - Tinypng
    - Web
categories:
    - Code
published: true
image:      ""
postWithImg: true
categories:
# showtoc: true
URL: "/2019/01/25/post-img-mgmt-hugo/"
#wechat pay & alipay & Paypal
reward: true
---
I introduced [why](2019/01/01/hello-world/) I migrate my blog to github and Hugo here. Most of articles have been moved to here in 30 days. Next, I just want to talk about something about [posts' images management](/2019/01/25/post-img-mgmt-hugo/), [versioning](/2019/01/27/hugo-versioning/), [theme customization/something about SEO](/2019/02/07/hugo-customization/).

### Before start

All images will be compressed before I upload them for post. There are many tools could do this, such as [tinypng](https://tinypng.com/), [UPNG](http://upng.photopea.com/). My choice is Tinypng because it supports variety formats and its [API](https://tinypng.com/developers/reference#{tpath(%22/developers%22)}).

{{< imgproc imgPath="2019/01/01-opt.png" alt="img compression (20M to 5.1M)" max-height="400" >}}

Tinypng's APIs can be called by [Python-Requests](http://docs.python-requests.org/en/master/) in this way:
{{< highlight python>}}
import os
from os import path
import requests
from requests.auth import HTTPBasicAuth

def picopt(root_path, apikey):
    for f in os.listdir(root_path):
        fullurl = os.sep.join([root_path, f])
        if path.isdir(fullurl):
            picopt(fullurl, apikey)
        else:
            if fullurl.endswith(('.DS_Store', '-opt.png', '-opt.jpg', '-opt.jpeg')):
                print('ignore ' + fullurl)
                continue
            print('processing ' + fullurl)

            with open(fullurl, 'rb') as imgf:
                content = imgf.read()
            res = requests.post(
                auth=HTTPBasicAuth("api:%s" %(apikey), ''), url='https://api.tinify.com/shrink', data=content)
            print(res.json())
            optimgurl = res.json()['output']['url']
            # print(optimgurl)
            res = requests.get(
                auth=HTTPBasicAuth("api:%s" %(apikey), ''), url=optimgurl)

            filename, filetypestr = fullurl.rsplit('.', 1)
            optfullurl = '-opt.'.join([filename, filetypestr])
            with open(optfullurl, 'wb') as fd:
                for chunk in res.iter_content(chunk_size=128):
                    fd.write(chunk)
                print('optimized img file: ' + fullurl)

if __name__ == "__main__":
    devkey = ''
    postimgsfolder = ''
    picopt(postimgsfolder, devkey)
{{< /highlight >}}

### Manage the image in post with markdown

Refer to this [Guide](https://learn.netlify.com/en/cont/markdown/#images), it's the most easiest way:

1. Save the image file to folder _static/img_
2. Link image in post file with the markdown:

    - For image without link:

        ~~~markdown
        ![Minion](/img/home-psb-bg.jpeg "alt wording")
        ~~~

    - For image with link:

        ~~~markdown
        [![Minion](/img/home-psb-bg.jpeg "alt wording")](/img/home-psb-bg.jpeg)
        ~~~

    Yes, it's _/img/_ in the link which was mentioned in [here](https://gohugo.io/content-management/static-files/):

    > This union filesystem will be served from your site root. So a file <SITE PROJECT>/static/me.png will be accessible as <MY_BASEURL>/me.png

    Load images from the post folder is possible in [Hugo future version](https://gohugo.io/content-management/organization/#page-bundles).

From my understanding, as the [guide](https://learn.netlify.com/en/cont/markdown/#resizing-image) described, extra work should be needed for images resize with HTTP parameters, I didn't dig deeper on this.

### Manage the image in post with html code

- For image without link:

    ~~~html
    <img src="/img/home-psb-bg.jpeg" alt="alt wording" style="height:200px;">
    ~~~

- For images with link:

    ~~~html
    <a href="/img/home-psb-bg.jpeg">
    <img src="/img/home-psb-bg.jpeg" alt="alt wording" style="height:200px;">
    </a>
    ~~~

### Manage the image with shortcode

Hugo provides a [figure](https://gohugo.io/content-management/shortcodes/#figure) shortcode with sample:

~~~
{{</* figure src="/media/spf13.jpg" title="Steve Francia" */>}}
~~~
_Note: <br>A [sample](https://raw.githubusercontent.com/gainskills/Kex-Zh-Blog/master/content/post/2019-01-25-post-img-mgmt-hugo.md) about show shortcode on Hugo post._

The thing is [Shortcode](https://gohugo.io/content-management/shortcodes/) and [Image Processing](https://gohugo.io/content-management/image-processing/) module enable Hugo to create responsive images:

1. Customize the behavior and style to view the image
2. Resize and crop the image to proper size and quality for different view

Make a long story short, shared my customization as an example

1. Image defination with shortcode in the [markdown](https://github.com/gainskills/Kex-Zh-Blog/blob/master/content/post/2018-12-18-jenkinsx-iosproject-delivery.md) file:
~~~markdown
...
postWithImg: true
...
{{</* imgproc imgPath="2018/12/5-opt.png" alt="XCode-Export Apple Developer Profile-3" max-height="250"  */>}}
~~~

2. Post images related settings in [site configuration file](https://github.com/gainskills/Kex-Zh-Blog/blob/master/config.toml):

    ~~~toml
    ...
    [params]
    postimgfoler = "/img/postimgs" #full url: assertsDir + /img/postimgs
    ...
    ~~~

3. [_layout/shortcodes/_](https://github.com/gainskills/hugo-theme-cleanwhite/blob/master/layouts/shortcodes/imgproc.html)
{{< highlight html "linenos=table" >}}
{{ $img := resources.Get (printf "%s/%s" ( .Site.Params.postimgfoler ) (.Get "imgPath")) }}

{{ $imgpath := (printf "%s/%s/%s" ( "assets" ) (.Site.Params.postimgfoler ) (.Get "imgPath")) }}

{{ $pagehgt := (printf "x%s q20" (.Get "max-height")) }}
{{ .Scratch.Set "image" ($img.Resize $pagehgt) }}
{{ $pageimage := .Scratch.Get "image" }}

{{ $imgData :=  imageConfig $imgpath }}
{{ $fanhgt := string ( $imgData.Height ) }}
{{ if gt  $imgData.Height  550 }}
{{ $fanhgt = "550" }}
{{ end }}

{{ $fanhgt := (printf "x%s q20" ($fanhgt)) }}
{{ .Scratch.Set "image" ($img.Resize $fanhgt) }}
{{ $fanimage := .Scratch.Get "image" }}

<div align="center">
    <figure style="padding: 0.8rem; margin: 2rem 0; border: thin #c0c0c0 solid; border-radius: 10px; width: {{$pageimage.Width}}px; max-width: 88%">
    <a href="{{ $fanimage.RelPermalink }}" data-fancybox data-caption={{ .Get "alt" }} >
        <img src="{{ $pageimage.RelPermalink }}" class="img-responsive" alt={{ .Get "alt" }} style="display: block;margin: 0.5rem;"/>
    </a>
    <figcaption class="text-capitalize">
        <small>{{ .Get "alt" }}</small>
    </figcaption>
    </figure>
</div>
{{< /highlight >}}
    * Line1: Different to markdown and html part, the images were saved to _/assets/_ folder so that _resources.Get_ function could load the image file by path. The _printf_ function joins two parameters to one string for _resources.Get_ function.
    * Line 3: Initial the full url of the image for _imageConfig_ function (Line 9)
    * Line 5-7: Generate an image from original image by the max-height value which was defined in the markdown file, quality to 20
    * Line 9-10: Get the hight info of the original image file with [_imageConfig_](https://gohugo.io/functions/imageconfig/)
    * Line 11-17: Check the height of the original image file, and generate a new file with quality value: 20. The height of new image will be 550px if the value of the origin is larger than 550px.
    * Line 21-23: Call [fancybox](https://codepen.io/fancyapps/pen/EeqJPG?editors=1000) and bootstrap for image (Refer to [_layouts/partials/head.html_](https://github.com/gainskills/hugo-theme-cleanwhite/blob/e94268ebf3418d9d51d0cbee6fc0efd7af718b2a/layouts/partials/head.html) for jQuery and fancybox files)

    **Note:**

    - For the post with multiple images, failure might happens because [Hugo timeout mechanism](https://gohugo.io/getting-started/configuration/). Changing _timeout_ in global configuration (config.toml) could be the resolution:

        ~~~toml
        timeout = 30000
        ~~~

    - The short code is also an example of [Hugo - Creating a resource from a string](https://gohugo.io/hugo-pipes/resource-from-string/)

4. A [live demo]((/2018/12/26/jenkins-xcode-plugin-parameterized-project/)).

### Lazy load images

Update @ Mar-09-2019

This part was refer to [Lazy load images with zero Javascript](https://medium.com/@filipvitas/lazy-load-images-with-zero-javascript-2c5bcb691274)

1. Add the class <code>img-lazyload</code> in Hugo shortcode for lazy load
    {{< highlight html >}}
        <img data-src="{{ $pageimage.RelPermalink }}" class="img-responsive img-lazyload" alt={{ .Get "alt" }} style="height: {{$pageimage.Height}}px;"/>{{</ highlight >}}

2. JS code

    Added following code in [footer.html](https://github.com/gainskills/hugo-theme-cleanwhite/blob/master/layouts/partials/footer.html)
    {{< highlight javascript >}}
{{ if .Params.postWithImg }}
<script>
    let lazyImages = [...document.querySelectorAll('.img-lazyload')]
    let inAdvance = 20

    function lazyLoad() {
        lazyImages.forEach(image => {
            if ((image.offsetTop < window.innerHeight + window.pageYOffset + inAdvance) && ! image.classList.contains('img-lazyload-loaded') ) {
                image.src = image.dataset.src
                image.onload = () => {
                    image.classList.add('img-lazyload-loaded');
                    image.style.height="";
                }
            }
        })
        // if all loaded removeEventListener
    }
    lazyLoad()
    window.addEventListener('scroll', _.throttle(lazyLoad, 8))
    window.addEventListener('resize', _.throttle(lazyLoad, 8))
</script>
{{end}}{{</ highlight >}}

3. Link <code>lodash</code>

    Add the link in [head.html](https://github.com/gainskills/hugo-theme-cleanwhite/blob/master/layouts/partials/head.html), otherwise it will run into the error: [<code>ReferenceError: _ is not defined</code>](https://stackoverflow.com/questions/13556010/referenceerror-is-not-defined)

    {{< highlight html >}}
    <!-- JS/CSS for postimg -->
    {{ if .Params.postWithImg }}
    <link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/fancybox/3.5.6/jquery.fancybox.min.css">
    <script src="//cdnjs.cloudflare.com/ajax/libs/fancybox/3.5.6/jquery.fancybox.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/lodash.js/0.10.0/lodash.min.js"></script>
    {{end}}{{</ highlight >}}

4. Demo

    <video controls preload="none" loop width="640" height="360" src="/img/postimgs/2019/03/loadlazyimgs.mov">
    Your browser does not support the video tag. Try Chrome</video>

<hr>
**To Do:** With shortcodes and img process module, I'd like to try and process the post images like this: [Responsive images | MDN](https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images).
