---
title:      "AWS S3 Bucket Creation"
subtitle:   ""
description: "boto3 error for beginner"
date:       2018-12-27
tags:
    - AWS
    - Troubleshooting
    - Python
published: true
image:      ""
categories:
    - DevOps
#wechat pay & alipay & Paypal
reward: true
URL: "/2018/12/27/aws-s3-bucket-creation/"
---
Try to create a bucket with the Python library: boto3

~~~Python
from boto3.session import Session
session=Session(aws_access_key_id='key1', aws_secret_access_key='key2')
s3 = session.resource('s3')
s3.create_bucket(Bucket='kz-testbucket')
~~~

but failed to run the script with errors:

1. botocore.exceptions.ClientError: An error occurred (IllegalLocationConstraintException) when calling the CreateBucket operation: The unspecified location constraint is incompatible for the region specific endpoint this request was sent to.

2. botocore.errorfactory.BucketAlreadyExists: An error occurred (BucketAlreadyExists) when calling the CreateBucket operation: The requested bucket name is not available. The bucket namespace is shared by all users of the system. Please select a different name and try again.

It’s weird because the bucket can be created by following code:

~~~Python
!/usr/bin/python3
import boto3
s3 = boto3.resource('s3')
s3.create_bucket(Bucket='kz-bucketname')
~~~

Searched on the Internet and found the solution – Bucket name should conform with DNS requirements (Should in FQDN format):

- Should not contain uppercase characters
- Should not contain underscores (_)
- Should be between 3 and 63 characters long
- Should not end with a dash
- Cannot contain two, adjacent periods
- Cannot contain dashes next to periods (e.g., “my-.bucket.com” and “my.-bucket” are invalid)

It works after I changed the bucket name to ‘ke.testbucket’.
Related links:

1. [s3.create_bucket() fails if the region is set to ‘ap-northeast-2’#781](https://github.com/boto/boto3/issues/781)
2. [Strange behavior when trying to create an S3 bucket in us-east-1 #125](https://github.com/boto/boto3/issues/125)
3. [The specified bucket is not valid errors?](https://forums.aws.amazon.com/message.jspa?messageID=315883)
