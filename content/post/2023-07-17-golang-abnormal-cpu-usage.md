---
title:      "Golang abnormal CPU usage"
subtitle:   ""
description: "A note about Golang `time.sleep`/`duration`"
date:       2023-07-17
tags:
    - Golang
categories:
    - Code
published: true
postWithImg: true
image:      ""
showtoc: false
URL: "/2023/07/17//"
#wechat pay & alipay & Paypal
reward: true
---
Plan: Sleep 2.5 hours in a `for` loop

Implementation:

```golang
package test

import (
    "context"
    "time"
)

const connChkInterval = 2.5 * time.Hour.Hours()

func  testFunc(ctx context.Context) {
_Loop:
    for {
        select {
        case <-ctx.Done():
            break _Loop
        default:
            //	code of default branch
        }
        time.Sleep(connChkInterval)
    }
}
```

Issue: 

1. CPU usage goes high with the code
2. Did analysis with golang profile, and saw `runtime/internal/syscall.Syscall` is the root cause
3. The CPU usage never went to so high ever even though I run SQLite and the Golang App on the same server

Troubleshooting:

Did search on google, and most of posts are not helpful to me. So I decided to go to the hard way: revert my changes line by line

Light:

The cpu usage went back to normal after I revert my change on `connChkInterval`

```golang
package test

import (
    "context"
    "time"
)

const connChkInterval = 3 * time.Hour.Hours()

func  testFunc(ctx context.Context) {
_Loop:
    for {
        select {
        case <-ctx.Done():
            break _Loop
        default:
            //	code of default branch
        }
        time.Sleep(connChkInterval)
    }
}
```