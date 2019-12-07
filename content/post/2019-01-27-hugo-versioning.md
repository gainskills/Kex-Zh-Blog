---
layout:     post
title:      "Hugo-Versioning"
subtitle:   ""
description: "Hugo tutorials"
date:       "2019-01-27"
tags:
    - Hugo
    - Blog
    - Git
    - Tip
    - Web
published: true
image:      ""
# postWithImg: true
categories:
    - Code
# showtoc: true
URL: "/2019/01/27/hugo-versioning/"
#wechat pay & alipay & Paypal
reward: true
---
Hugo provides the detail [instructions](https://gohugo.io/hosting-and-deployment/) about how to deploy it on different environment.

At first, I followed [Deployment of Project Pages from /docs folder on master branch](https://gohugo.io/hosting-and-deployment/hosting-on-github/#deployment-of-project-pages-from-docs-folder-on-master-branch), and put all files in one repository.

I continue to check [Deployment of Project Pages From Your gh-pages branch](https://gohugo.io/hosting-and-deployment/hosting-on-github/#deployment-of-project-pages-from-your-gh-pages-branch) after I did some customization on [hugo-theme-cleanwhite](https://themes.gohugo.io/hugo-theme-cleanwhite/) and want to publish the change to the [forked branch](https://github.com/gainskills/hugo-theme-cleanwhite).

Instead of the follow Hugo guide, I did some try myself. I searched "change a subfolder to another repository and found the article: [Moving Files from one Git Repository to Another, Preserving History](http://gbayer.com/development/moving-files-from-one-git-repository-to-another-preserving-history/) but its case is:

- Move directory 1 from Git repository A to Git repository B
- repository A as a branch in repository B

Searched and read the following links:

- [Splitting a sub folder out into a new repository](https://help.github.com/articles/splitting-a-subfolder-out-into-a-new-repository/)
- [Working with submodules](https://github.blog/2016-02-01-working-with-submodules/)

#### Create Repositories on GitHub

- [gainskills.github.io](https://github.com/gainskills/gainskills.github.io)

    This repository is for Hugo published files, the prefix of the repository should be the same as my name in github, read more about the repository setup: [pages.github](https://pages.github.com/),[GitHub User or Organization Pages
](https://gohugo.io/hosting-and-deployment/hosting-on-github/#github-user-or-organization-pages)
- [gainskills/hugo-theme-cleanwhite](https://github.com/gainskills/hugo-theme-cleanwhite)

    This repository is for the customized theme (It's a forked repository)
    <br>
    **Note:**

    The existing repository: [Kex-Zh-Blog](https://github.com/gainskills/Kex-Zh-Blog), is for markdown files (post), and post images.

#### Setup [gainskills.github.io](https://github.com/gainskills/gainskills.github.io)

Refer to [Quick start: Setting up a custom domain](https://help.github.com/articles/quick-start-setting-up-a-custom-domain/)

1. Custom Domain

    For my case, I configured "blog.gainskills.top" as *Custom domain* in [gainskills.github.io](https://github.com/gainskills/gainskills.github.io).

2. DNS system

    Created a CNAME record: *blog.gainskills.top* to _gainskills.github.io_ on the DNS system.

    Compared the free version of [cloudflare](https://cloudflare.com), [Namecheap](https://www.namecheap.com/domains/freedns/), and [ns.he.net/](https://dns.he.net/), I would say [ns.he.net/](https://dns.he.net/) is a better choice as a DNS Hosting Provider.

#### Push local files to new Repositories

- Disable _publishDir_ option in config.toml
- Update _baseurl_ in config.toml
    The value can be kept, but for my case, I migrated my blog from "www.gainskills.top" to "blog.gainskills.top".
- run Hugo to generate published files.
- Check _public_ folder and make sure the files were generated
- Push files

    - In the root folder of the Hugo project, run the following commands to push local files to [gainskills.github.io](https://github.com/gainskills/gainskills.github.io)

        ~~~bash
        mkdir pubic
        git clone --no-checkout https://github.com/gainskills/gainskills.github.io.git  temp
        mv temp/.git public
        rm -r -f temp
        cd public
        git add .
        git commit -m "Initial commit"
        ~~~
    - Login to github and confirmed that all files were pushed.

        Verified [https://blog.gainskills.top](https://blog.gainskills.top) as well, it works.

    - Do the same thing on folder _theme/hugo-theme-cleanwhite_ with the url: https://github.com/gainskills/hugo-theme-cleanwhite.git

#### Git Submodules

In the root folder of Hugo project, run the command:
~~~bash
git rm -r public
git submodule add https://github.com/gainskills/gainskills.github.io.git public/
git add .
git commit -m "add submodule"
git push --force
~~~

Do the same thing on folder _theme/hugo-theme-cleanwhite_ with the url: https://github.com/gainskills/hugo-theme-cleanwhite.git

For _git rm_, the data can be removed from history by the following: [Removing sensitive data from a repository](https://help.github.com/articles/removing-sensitive-data-from-a-repository/)

#### Deployment script

Update Hugo deployment script for all repositories:
{{< highlight bash >}}
#!/bin/bash

#remove old files
rm -r -f ./public/*
find . -name '.DS_Store' -type f -delete

# Build the project, if using a theme, replace with `hugo -t <YOURTHEME>
./hugo_0.53_osx/hugo -t Hugo-theme-cleanwhite --quiet --cleanDestinationDir --minify --gc

#add CNAME back
echo "blog.gainskills.top" >> ./public/CNAME

#add License
cp LICENSE public/LICENSE

if [ "$1" != "testing" ]
then
    echo -e "\033[0;32mDeploying updates to Algolia...\033[0m"
    npm run algolia

    # git push --recurse-submodules=on-demand

    echo -e "\033[0;32mpush changes on submoudle: theme...\033[0m"
    cd themes/hugo-theme-cleanwhite
    git add .
    git commit -m "$1"
    git push

    echo -e "\033[0;32mpush changes on submoudle: public...\033[0m"
    cd ../../public
    git add .
    git commit -m "$1"
    git push

    echo -e "\033[0;32mAdd changes to current repo....\033[0m"
    cd ..
    git add .
    git commit -m "$1"
    git push
fi
{{< /highlight >}}

#### Clean up

Since I moved my blog from 'www.gainskill.top' to 'blog.gainskills.top', I redirected the traffic to a new domain by the following [Redirects on GitHub Pages](https://help.github.com/articles/redirects-on-github-pages/).

Removed all files in the folder: docs (Keep CNAME file there), and new files: _config.yml and index.html

- The content of _config.yml
{{< highlight yaml >}}
plugins:
- jekyll-redirect-from {{< /highlight >}}

- The content of index.html
{{< highlight yaml >}}
---
title: Kexian Zhang's Blog
redirect_from:
- /sitemap.xml
- /index.xml
- /2019/01/23/try-aiohttp/
- /2019/01/19/get-in-dict-get/
- /top/about/
- /2019/01/01/hello-world/
- /2018/12/27/aws-s3-bucket-creation/
- /2018/12/26/jenkins-xcode-plugin-parameterized-project/
- /2018/12/27/python-trick-double-stars/
- /2018/02/09/run-asa9.1-on-eve/
- /2018/12/19/ipsec-over-paloalto-fw-static-nat/
- /2018/12/18/jenkinsx-iosproject-delivery/
- /2018/12/17/wireshark-vnc-integrate-eve-ngunlonosx/
- /2018/10/11/ansible-access-network-netconf/
- /2018/10/07/netconf-feature-on-cisco-ios-iosxe/
- /2018/09/21/monitor-network-connections-based-on-process/
- /2018/09/07/ansible-access-network-via-ssh/
- /2018/09/04/ansible-access-network-via-telnet/
- /2018/07/20/mininet-importerror-customclass/
- /2018/04/16/flask-flask-wtf-flask-bootstrap-select2-jinja2-i
- /2018/02/13/python-smtplib-email/
- /2018/01/25/run-paloalto-vm-on-eve-unl-virtualbox-osx/
- /2017/09/22/tc-how-it-works-on-different-ips/
- /2017/06/06/overflowerror-signed-char-is-greater-than-maximu
- /2017/03/24/cisco-ipsinline-vlan-pair-mode/
- /2017/01/08/run-nx-osv-9000-on-eve-unl/
- /2016/11/29/adding-realtek-8139-driver-to-esxi6/
- /2016/11/30/run-ansible-on-windows/
- /2016/07/21/loop-a-dict-to-update-key/
- /2016/01/08/vsphere6-vcenter6-installation/
- /2013/12/20/dynagen-dynamips-error-netio_desc-create-udp-una
- /2016/01/28/snmp-simulator-installation-guide/
- /2013/11/13/trouble-shooting-cisco-router-dhcp-no-option125/
- /2013/11/05/make-error-usrbinld-cannot-find-luuid/
- /search/placeholder/
redirect_to:
- "https://blog.gainskills.top"{{< /highlight >}}

##### Links:

- [Git push master fatal: You are not currently on a branch](https://stackoverflow.com/questions/30471557/git-push-master-fatal-you-are-not-currently-on-a-branch)
