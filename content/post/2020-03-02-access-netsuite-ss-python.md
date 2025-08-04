---
title:      "Accessing NetSuite SavedSearch via python"
subtitle:   ""
description: ""
date:       2020-03-02
tags:
    - Oracle
    - NetSuite
    - Python
published: 2090-01-01
image:      ""
categories:
    - Code
URL: "/2020/03/02/access-netsuite-ss-python/"
#wechat pay & alipay & Paypal
reward: true
---
Related Python library: [netsuite](https://github.com/jjorissen52/netsuite)

### SuiteScript + Python (NetSuite Restlet)

### Pure Python - AdvancedSearch

### Pure Python - Basic Search


Note for troubleshooting:
- Take care of the web service role's permissions. Resolved an issue: one script got much fewer items than UI by assigning read permission on 'List -> Credit Note'.
- The column won't be there if the record of saved search doesn't have the property. I stuck on an issue: Unable to find 'locationquantityonhand' from an Inventory Item search, figured it out until I sorted the result.
