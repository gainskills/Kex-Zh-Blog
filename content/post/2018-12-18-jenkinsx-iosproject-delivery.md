---
title:      "Jenkins/Xcode plugin for iOS project delivery"
subtitle:   ""
description: "A sample about an iOS project"
date:       2018-12-18
tags:
    - Jenkins
    - Xcode
    - Troubleshooting
publishDate: 2018-12-18
image:      ""
postWithImg: true
categories:
    - DevOps
    - Code
#wechat pay & alipay & Paypal
reward: true
URL: "/2018/12/18/jenkinsx-iosproject-delivery/"
---
Most of this blog is discuss the errors and how I resolve the errors when I try iOS project Continuous Delivery with Jenkins. The brief steps are:

1. Install Jenkins
2. Install Xcode plugin on Jenkins
3. New a ‘Freestyle project’ on Jenkins
4. Jenkins project configuration

    - ‘Source Code Management’ on Jenkins
    - ‘Build’ setting on Jenkins
5. Jenkins Project -> ‘Build Now’

Errors:

+ CodeSign error: Code signing is required for product type ‘Application’ in SDK ‘iOS x.x’

    I have stuck on this error for days and got it resolved by checking following configuration:

    1. For XCode, Check if the account you logged on Xcode has been bound Certificate and Provisioning profiles on [Apple Developer](https://idmsa.apple.com/IDMSWebAuth/signin?appIdKey=891bd3417a7776362562d2197f89480a8547b108fd934911bcbea0110d07f757&path=%2Faccount%2F&rv=1). The option ‘Automatically manage signing’ was enabled on my project and it doesn’t cause any issue (XCode version: 10.1)
    2. For Fastlane, if the account was verified as #1, there won’t be any issue.
    3. For Jenkins,  I prefer to enable ‘Import developer profile’ option before run build with [Xcode Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Xcode+Plugin). Actually, the steps about how to upload the profile to Jenkins has been described in details on [XCode Plugin page](https://wiki.jenkins.io/display/JENKINS/Xcode+Plugin#XcodePlugin-Signing):

        > This plugin builds on top of Credentials Plugin to allow you to store your Apple Developer Profile (*.developerprofile) file. This file contains a code signing private key, corresponding developer/distribution certificates, and mobile provisioning profiles. You can create this file from your XCode. To upload the developer profile into Jenkins, go to “Manage Credentials” in the system configuration page, and select “Apple Developer Profile” from the “Add” button.  To use this profile for signing, add “Import developer profile” as a build step before you run Xcode, and select the developer profile to import into the build machine. This build step will install the developer profile into the slave’s keychain.

        Screenshots about Apple Developer Profile Export:

        {{< imgproc imgPath="2018/12/3-opt.png" alt="XCode-Export Apple Developer Profile-1" max-height="80" >}}

        {{< imgproc imgPath="2018/12/4-opt.png" alt="XCode-Export Apple Developer Profile-2" max-height="400" >}}

        {{< imgproc imgPath="2018/12/5-opt.png" alt="XCode-Export Apple Developer Profile-3" max-height="250" >}}

        Screenshot about Apple Developer Profile Import:

        {{< imgproc imgPath="2018/12/2-opt.png" alt="XCode-Export Jenkins-Import Apple Developer Profile-1" max-height="200" >}}

        {{< imgproc imgPath="2018/12/6-opt.png" alt="XCode-Export Jenkins-Import Apple Developer Profile-2" max-height="100" >}}

        {{< imgproc imgPath="2018/12/7-opt.png" alt="XCode-Export Jenkins-Import Apple Developer Profile-3" max-height="100" >}}

    4. For Jenkins/Xcode plugin, make sure the ‘Scheme’ or the ‘Target’ was defined properly.

        Two schedules were defined in my project: one for real devices and another for the simulator.

        {{< imgproc imgPath="2018/12/8-opt.png" alt="Jenkins/Xcode plugin-Scheme" max-height="300" >}}

        Scheme names also can be found by the command: ‘xcodebuild -list’

        {{< imgproc imgPath="2018/12/9-opt.png" alt="xcodebuild -list" max-height="260" >}}

+ Target ‘xxx’ (project ‘xxx’) has copy command from file_location1 to file_location2

Refer to the question on StackOverflow, the issue can be resolved by changing Build System to ‘Legacy Build System’

{{< imgproc imgPath="2018/12/10-opt.png" alt="xcode build system" max-height="260" >}}

{{< imgproc imgPath="2018/12/11-opt.png" alt="build option of xcode plugin" max-height="260" >}}

Note: I prefer “Jenkins Credential” than “[Keychains and Provisioning Profiles Plugin](https://wiki.jenkins.io/display/JENKINS/Keychains+and+Provisioning+Profiles+Plugin)” because the comment: ‘This plugin exposes the keychain passwords in the Compare Environment section.’ from [Henry Yei](https://wiki.jenkins.io/display/~hyei).
