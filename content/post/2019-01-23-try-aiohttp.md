---
layout:     post
title:      "aiohttp/aiodns-Resolving using custom nameservers"
subtitle:   ""
description: "Try aiohttp/aiodns"
date:       "2019-01-23"
tags:
    - Aiohttp
    - Asynchronous
    - Troubleshooting
    - Python
    - Web
published: true
image:      ""
categories:
    - Code
URL: "/2019/01/23/try-aiohttp/"
#wechat pay & alipay & Paypal
reward: true
---
[aiohttp](https://github.com/aio-libs/aiohttp) is an Asynchronous HTTP client/server framework for asyncio and Python

I tried it because the features:

- [Tuning the DNS cache](https://aiohttp.readthedocs.io/en/stable/client_advanced.html#tuning-the-dns-cache)
- [Resolving using custom nameservers](https://aiohttp.readthedocs.io/en/stable/client_advanced.html#resolving-using-custom-nameservers)

With this, verifying the CDN's POPs with different ISPs' DNS on single a point should be possible.

Since the code on the officical document is simple:

>~~~python
from aiohttp.resolver import AsyncResolver

resolver = AsyncResolver(nameservers=["8.8.8.8", "8.8.4.4"])
conn = aiohttp.TCPConnector(resolver=resolver)
~~~

I tried it with following code:

~~~python
import aiohttp
import asyncio
from aiohttp.resolver import AsyncResolver

resolver = AsyncResolver(nameservers=["114.114.114.114"])

async def dnstesting():
    async with aiohttp.ClientSession(connector=aiohttp.TCPConnector(verify_ssl=False, use_dns_cache=False, resolver=resolver)) as session:
        r = await session.get("http://google.com")
        print(r.text)

asyncio.run(dnstesting())
~~~

Run with following error:

~~~python
/aiohttp-1.py:38: DeprecationWarning: The object should be created from async function
  resolver = AsyncResolver(nameservers=["114.114.114.114"])
/aiohttp-1.py:41: DeprecationWarning: verify_ssl is deprecated, use ssl=False instead
  async with aiohttp.ClientSession(connector=aiohttp.TCPConnector(verify_ssl=False, use_dns_cache=False, resolver=resolver)) assession:
Traceback (most recent call last):
  File "/aiohttp-1.py", line 51, in <module>
    asyncio.run(dnstesting())
  File "/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/asyncio/runners.py", line 43, in run
    return loop.run_until_complete(main)
  File "/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/asyncio/base_events.py", line 584, in run_until_complete
    return future.result()
  File "/aiohttp-1.py", line 42, in dnstesting
    r = await session.get("http://google.com")
  File "/pyvenvs/aiohttp/venv/lib/python3.7/site-packages/aiohttp/client.py", line 476, in _request
    timeout=real_timeout
  File "/pyvenvs/aiohttp/venv/lib/python3.7/site-packages/aiohttp/connector.py", line 522, in connect
    proto = await self._create_connection(req, traces, timeout)
  File "/pyvenvs/aiohttp/venv/lib/python3.7/site-packages/aiohttp/connector.py", line 854, in _create_connection
    req, traces, timeout)
  File "/pyvenvs/aiohttp/venv/lib/python3.7/site-packages/aiohttp/connector.py", line 955, in _create_d/aiohttp-1.py:38: DeprecationWarning: The object should be created from async function
  resolver = AsyncResolver(nameservers=["114.114.114.114"])
/aiohttp-1.py:41: DeprecationWarning: verify_ssl is deprecated, use ssl=False instead
  async with aiohttp.ClientSession(connector=aiohttp.TCPConnector(verify_ssl=False, use_dns_cache=False, resolver=resolver)) assession:
Traceback (most recent call last):
  File "/aiohttp-1.py", line 51, in <module>
    asyncio.run(dnstesting())
  File "/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/asyncio/runners.py", line 43, in run
    return loop.run_until_complete(main)
  File "/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/asyncio/base_events.py", line 584, in run_until_complete
    return future.result()
  File "/aiohttp-1.py", line 42, in dnstesting
    r = await session.get("http://google.com")
  File "/pyvenvs/aiohttp/venv/lib/python3.7/site-packages/aiohttp/client.py", line 476, in _request
    timeout=real_timeout
  File "/pyvenvs/aiohttp/venv/lib/python3.7/site-packages/aiohttp/connector.py", line 522, in connect
    proto = await self._create_connection(req, traces, timeout)
  File "/pyvenvs/aiohttp/venv/lib/python3.7/site-packages/aiohttp/connector.py", line 854, in _create_connection
    req, traces, timeout)
  File "/pyvenvs/aiohttp/venv/lib/python3.7/site-packages/aiohttp/connector.py", line 955, in _create_direct_connection
    traces=traces), loop=self._loop)
  File "/pyvenvs/aiohttp/venv/lib/python3.7/site-packages/aiohttp/connector.py", line 788, in _resolve_host
    host, port, family=self._family))
  File "/pyvenvs/aiohttp/venv/lib/python3.7/site-packages/aiohttp/resolver.py", line 64, in resolve
    resp = await self._resolver.gethostbyname(host, family)
RuntimeError: Task <Task pending coro=<TCPConnector._resolve_host() running at /pyvenvs/aiohttp/venv/lib/python3.7/site-packages/aiohttp/connector.py:788> cb=[shield.<locals>._done_callback() at /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/asyncio/tasks.py:776]> got Future <Future pending> attached to a different loop
python3(38437,0x107b185c0) malloc: *** error for object 0x9000000000000000: pointer being freed was not allocated
python3(38437,0x107b185c0) malloc: *** set a breakpoint in malloc_error_break to debug
Abort trap: 6irect_connection
    traces=traces), loop=self._loop)
  File "/pyvenvs/aiohttp/venv/lib/python3.7/site-packages/aiohttp/connector.py", line 788, in _resolve_host
    host, port, family=self._family))
  File "/pyvenvs/aiohttp/venv/lib/python3.7/site-packages/aiohttp/resolver.py", line 64, in resolve
    resp = await self._resolver.gethostbyname(host, family)
RuntimeError: Task <Task pending coro=<TCPConnector._resolve_host() running at /pyvenvs/aiohttp/venv/lib/python3.7/site-packages/aiohttp/connector.py:788> cb=[shield.<locals>._done_callback() at /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/asyncio/tasks.py:776]> got Future <Future pending> attached to a different loop
python3(38437,0x107b185c0) malloc: *** error for object 0x9000000000000000: pointer being freed was not allocated
python3(38437,0x107b185c0) malloc: *** set a breakpoint in malloc_error_break to debug
Abort trap: 6
~~~

Did something debugging without any clue, with [Saghul](https://github.com/saghul) and [asvetlov](https://github.com/asvetlov)'s help on the issue [#3573](https://github.com/aio-libs/aiohttp/issues/3573), it works finally with: *Moving the resolver definition from outside of the function to inside*.

~~~python
import asyncio
import aiohttp
from aiohttp.resolver import AsyncResolver

async def dnstesting():
    resolver = AsyncResolver(nameservers=["114.114.114.114"])

    async with aiohttp.ClientSession(connector=aiohttp.TCPConnector(verify_ssl=False, use_dns_cache=False, resolver=resolver)) as session:
        r = await session.get("http://google.com")
        print(r.text)

asyncio.run(dnstesting())
~~~
