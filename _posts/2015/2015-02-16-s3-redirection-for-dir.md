---
layout: post
title: Amazon S3 的全資料夾轉址
published: true
date: 2015-02-16 21:30
tags:
categories: []
redirect_from: /posts/2015/02/16/s3-redirection-for-dir
comments: true
---

最近剛把 blog 搬到了 Amazon S3，前面用 CloudFront 擋，速度變快了不少。

不過遇到了一個忘記處理的問題：原本的網站會自動把文章網址從 / 轉到 /posts/，但是我忘記處理了，導致 Google Webmaster Tool 裡面噴一堆 404。

既然是 S3 轉址，我就回去看了之前的[筆記](http://blog.yorkxin.org/posts/2013/04/08/middleman-cdn-1-s3/)，從 Webmaster Tool 把 404 列表下載回來之後，拼湊成轉址表，結果 S3 告訴我最多只能有 50 條規則，行不通了。

不過爬了一下[文件](http://docs.aws.amazon.com/AmazonS3/latest/dev/HowDoIWebsiteConfiguration.html)才發現還有一個轉址規則是  `ReplaceKeyPrefixWith`，簡單來說就是幫你 replace matched path prefix，官方的範例是你要把全站的網址從 `/docs` 搬到 `/documents` 那麼就是這樣設定：

```xml
  <RoutingRules>
    <RoutingRule>
    <Condition>
      <KeyPrefixEquals>docs/</KeyPrefixEquals>
    </Condition>
    <Redirect>
      <ReplaceKeyPrefixWith>documents/</ReplaceKeyPrefixWith>
    </Redirect>
    </RoutingRule>
  </RoutingRules>
```

如此就有 301 轉址了。

但是要注意的是這個轉址是在 S3 設定的，所以如果前面有掛自訂 domain name 的 CDN 例如 CloudFront，那麼就要另外加上 `HostName` 設定才會跑到正確的網址。

所以我的 blog 是這樣設定的：

```xml
<?xml version="1.0"?>
<RoutingRules>
  <RoutingRule>
    <Condition>
      <KeyPrefixEquals>2007/</KeyPrefixEquals>
    </Condition>
    <Redirect>
      <HostName>blog.yorkxin.org</HostName>
      <ReplaceKeyPrefixWith>posts/2007/</ReplaceKeyPrefixWith>
    </Redirect>
  </RoutingRule>
  <RoutingRule>
    <Condition>
      <KeyPrefixEquals>2008/</KeyPrefixEquals>
    </Condition>
    <Redirect>
      <HostName>blog.yorkxin.org</HostName>
      <ReplaceKeyPrefixWith>posts/2008/</ReplaceKeyPrefixWith>
    </Redirect>
  </RoutingRule>
  <RoutingRule>
    <Condition>
      <KeyPrefixEquals>2009/</KeyPrefixEquals>
    </Condition>
    <Redirect>
      <HostName>blog.yorkxin.org</HostName>
      <ReplaceKeyPrefixWith>posts/2009/</ReplaceKeyPrefixWith>
    </Redirect>
  </RoutingRule>
  <RoutingRule>
    <Condition>
      <KeyPrefixEquals>2010/</KeyPrefixEquals>
    </Condition>
    <Redirect>
      <HostName>blog.yorkxin.org</HostName>
      <ReplaceKeyPrefixWith>posts/2010/</ReplaceKeyPrefixWith>
    </Redirect>
  </RoutingRule>
  <RoutingRule>
    <Condition>
      <KeyPrefixEquals>2011/</KeyPrefixEquals>
    </Condition>
    <Redirect>
      <HostName>blog.yorkxin.org</HostName>
      <ReplaceKeyPrefixWith>posts/2011/</ReplaceKeyPrefixWith>
    </Redirect>
  </RoutingRule>
  <RoutingRule>
    <Condition>
      <KeyPrefixEquals>2012/</KeyPrefixEquals>
    </Condition>
    <Redirect>
      <HostName>blog.yorkxin.org</HostName>
      <ReplaceKeyPrefixWith>posts/2012/</ReplaceKeyPrefixWith>
    </Redirect>
  </RoutingRule>
  <RoutingRule>
    <Condition>
      <KeyPrefixEquals>2013/</KeyPrefixEquals>
    </Condition>
    <Redirect>
      <HostName>blog.yorkxin.org</HostName>
      <ReplaceKeyPrefixWith>posts/2013/</ReplaceKeyPrefixWith>
    </Redirect>
  </RoutingRule>
  <RoutingRule>
    <Condition>
      <KeyPrefixEquals>2014/</KeyPrefixEquals>
    </Condition>
    <Redirect>
      <HostName>blog.yorkxin.org</HostName>
      <ReplaceKeyPrefixWith>posts/2014/</ReplaceKeyPrefixWith>
    </Redirect>
  </RoutingRule>
</RoutingRules>
```

btw 我有做一個搬家程式叫做 [hikkoshi](https://github.com/chitsaou/hikkoshi)，可以處理泛 Jekyll 的 blog 搬家，以及 Ghost。如果你也有搬家的需求可以用用看。

---

參考：

- [Configure a Bucket for Website Hosting - Amazon Simple Storage Service](http://docs.aws.amazon.com/AmazonS3/latest/dev/HowDoIWebsiteConfiguration.html)
