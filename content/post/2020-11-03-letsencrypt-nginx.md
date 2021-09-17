---
title:      "Certbot with Docker Compose"
subtitle:   ""
description: "A guide for SSL cert management via Docker Compose"
date:       2020-11-03
tags:
    - Docker
    - Let's Encrypt
    - Certificate
categories:
    - DevOps
published: false
postWithImg: true
image:      ""
showtoc: false
URL: "/2020/11/03/letsencrypt-nginx/"
#wechat pay & alipay & Paypal
reward: true
---

### Why this ariticle?
This article describes how I used certbot as the SSL certification. Thanks for [Let's Encrypt](https://letsencrypt.org/docs/) and [certbot](https://certbot.eff.org/), it provides a trusted certificate at zero cost.

### Why HTTPs?
> HTTPS (Hypertext Transfer Protocol Secure) is the update to HTTP that uses the SSL/TLS protocol to provide security for connections between web browsers and web servers. Using HTTPS normally requires a certificate from a certificate authority, such as Let’s Encrypt, and will also require installing that certificate onto a web server. Certbot can help perform both of these steps automatically in many cases. HTTPS is an Internet standard.


### How it works
{{< imgproc imgPath="2020/11/01-opt.png" alt="ACME" max-height="500" >}}

More details are introduce on [nginx-proxy/acme-companion](https://github.com/nginx-proxy/acme-companion)

### Steps
1. Plan for folder structure

    ```
    .
    +-- certbot
    |   +-- conf
    |   |   +-- archive
    |   |   |   +-- domain-name
    |   |   |   |   +-- certificate.crt
    |   |   |   |   +-- chain1.pem
    |   |   |   |   +-- fullchain1.pem
    |   |   |   |   +-- privkey1.pem
    |   +-- log
    |   +-- www
    +-- certs
    |   +-- certificate.crt
    |   +-- private.key
    +-- dockfiles
    |   +-- docker-compose.ssl.yml
    |   +-- docker-compose.yml
    +-- nginx
    |   +-- nginx_ssl.conf
    |   +-- nginx_nossl.conf
    +-- Folder for frontend
    |   +-- ...
    +-- Folder for backed
    |   +-- ...
    ```

    Folders: certbot, certs, nginx are mapped per condition

2. Dockerlize the web app, web gateway (NGINX or Apache). I use NGINX in my sample.

### References:
- [Packetriot](https://packetriot.com/tutorials)
- [acme-companion](https://github.com/nginx-proxy/acme-companion)
- Similar projects
    - [letsencrypt-nginx-proxy-companion](https://hub.docker.com/r/jrcs/letsencrypt-nginx-proxy-companion)
    - [Caddy](https://caddyserver.com/)
