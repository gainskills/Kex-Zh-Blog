---
layout:     post
title:      "Hugo-Customization"
subtitle:   ""
description: "Hugo tutorials"
date:       "2019-02-06"
lastmod:    "2019-03-09"
tags:
    - Hugo
    - Blog
    - Tip
    - SEO
    - Html
    - Web
published: true
image:      ""
postWithImg: true
categories:
    - Code
showtoc: false
URL: "/2019/02/06/hugo-customization/"
#wechat pay & alipay & Paypal
reward: true
---
A list about how I customize Hugo and why I did the change, the post will be updated continuously.

### 1. [fractions](https://gohugo.io/getting-started/configuration/)

Network Engineer should care about this, because it shows wrong _IP/mask_ format with default value:
{{< imgproc imgPath="2019/02/01-opt.png" alt="fractions with default value" max-height="140" >}}
Disable it in config.toml:
{{< highlight toml>}}
[blackfriday]
    fractions = false{{< /highlight >}}

### 2. hrefTargetBlank

This default value of the option is ```false``` which means external links(The wording was corrected to "absolute" from 'external' on Hugo official doc).
I prefer to change the value to ```true```.

### 3. [baseurl and canonifyURLs](https://gohugo.io/content-management/urls/)

_canonifyURLs_ option should be to ```true``` for [SEO purpose](https://web.dev/discoverable/tell-search-engine-canonical-url), _baseurl_ should be configured at the same time. For my case (config.toml):
{{< highlight toml>}}
baseurl = "https://blog.gainskills.top"
canonifyURLs = true{{< /highlight >}}

Then, add following content to [Hugo template](https://discourse.gohugo.io/t/how-to-replace-the-href-value-of-the-link-rel-canonical/484):
{{< highlight html>}}
<link rel="canonical" href="{{ .Permalink }}">{{< /highlight >}}

The site might be failed to load on local machine after the change because it failed to bind to the domain. The [resolution](https://github.com/indigotree/atlas/issues/38) is: add ```--baseURL``` when running Hugo locally.
{{< highlight toml>}}
./hugo_osx/hugo server --baseURL http://127.0.0.1{{< /highlight >}}

### 4. ```.Pages``` or ```.Site.RegularPages```

Since ```.Pages``` contains the urls of tag/category page, I prefer to use ```.Site.RegularPages``` for sitemap/robots.txt.

### 5. structured-data

Following [Google Docs](https://developers.google.com/search/docs/data-types/article) for structured-data.

#### Tools

- [web.dev](https://web.dev/measure)
- [structured-data](https://search.google.com/structured-data/testing-tool#)

### 6. [Asset minimization](https://gohugo.io/hugo-pipes/minification/)

Update @ Mar-09-2019

With this feature, the resource will be minified for better performance

1. Location of the static resource

    Moving the static resource to the folder: assets. You can check the [theme repository](https://github.com/gainskills/hugo-theme-cleanwhite/tree/36842390d0f9212650868779208b0fa211be927f) as an example.

2. The way to call the resource

    ```resources.Get``` will be used instead of linking the resource directly. Here is the [sample](https://github.com/gainskills/hugo-theme-cleanwhite/blob/36842390d0f9212650868779208b0fa211be927f/layouts/partials/head.html):

    {{< highlight html>}}
<!-- Custom CSS -->
{{ $huxcss := resources.Get "css/hux-blog.css" }}
{{ $huxstyle := $huxcss | resources.Minify }}
<!-- JavaScript -->
{{ $jqueryjs := resources.Get "js/jquery.js" }}
{{ $jqueryscript := $jqueryjs | resources.Minify }}
<script src="{{ $jqueryscript.Permalink }}"></script>{{</ highlight >}}
