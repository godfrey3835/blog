---
layout: post
title: Middleman + CDN 靜態網站實務 (2) 上 CloudFlare CDN
published: true
date: 2013-04-08 21:00
tags:
- middleman
- web development
- CDN
- CloudFlare
categories: []
redirect_from: /posts/2013/04/08/middleman-cdn-2-cloudflare
comments: true

---



上文講到[把 compile 出來的網站整個放到 S3 上面](http://blog.yorkxin.org/2013/04/08/middleman-cdn-1-s3/)，並打開 Website Hosting 。到這裡其實再設 CNAME 就可以上線了，不過我這次還試了上 CDN 。說到 CDN 就會想到 Amazon 他們家的 [CloudFront](http://aws.amazon.com/cloudfront/) ，不過具體實作之後發現不符合需求，後文會提及。

這次用的方案是 [CloudFlare CDN](https://www.cloudflare.com) ，有免費方案，對於我要上線的小網站來說很足夠。以下假設 S3 的 Website Hosting domain name 是 `www.example.com-s3-website-ap-northeast-1.amazonaws.com` 。

**Update**：後來上線之後用 [阿里測](http://alibench.com/) 來檢查從中國的連線速度，才發現到有少部份的 ISP 會連不上（驚），也就是說 CloudFlare CDN 不是最佳解。接下來會再試別的方案，找到更好的解法會再更新的。沒有測試就上線真是太糟糕了啊……。

<!-- more -->

## 讓 CloudFlare 管理全網域

一開始要上 CloudFlare CDN 的時候，其實我遇到 DNS 設定我就卡住了，我想說只是個 CDN 怎麼還需要寫 DNS 記錄？後來 [@wildjcrt 同學](https://twitter.com/wildjcrt) 跟我說[軟體玩家之前有介紹過](http://blog.soft.idv.tw/?p=1110&page=2)，我看了才知道說是要把整個 DNS 交給他管，剛好我也受夠了原本的 HiNet DNS ，就直接換上去吧。

不過 CloudFlare 在自動抓現有 DNS 記錄的時候，其實抓不到 HiNet DNS 的記錄，要手動抄過去。在手動加 DNS 記錄時，會自動把某些子網域的 CloudFlare 功能打開，既然還沒準備好，就先把它們全部關閉（Bypass CloudFlare）。最後在註冊商那邊改成新的 Nameserver 就行了（當然還要等 DNS 記錄傳播出去啦）。

## 設定 S3 Website Hosting 的 CNAME

其實這跟 CloudFlare 沒什麼關係，反正就是在 DNS 新增一筆 CNAME 記錄指到 S3 的 Website Hosting Domain 就對了， bucket name 跟 CNAME 指定的 domain 一樣就行了。例如 `www.example.com` 要指到 S3 ，那麼 bucket name 也就是 `www.example.com` ，然後 CNAME 的 value 是 `www.example.com-s3-website-ap-northeast-1.amazonaws.com`。

## 打開 CloudFlare CDN

確定 `www.example.com` 可以正確打開 S3 裡面的網頁之後，就可以把 `www` 的 CloudFlare CDN 打開了，在 CloudFlare 的 DNS 設定裡面可以打開。

## 從 Root Domain 轉址

意思是說，連 `http://example.com/abc` 自動轉到 `http://www.example.com/abc` 。

這裡就可以利用 CloudFlare 的功能。以下的 Trick 是在 [Configuring CloudFlare DNS for a Heroku App](http://www.higherorderheroku.com/articles/cloudflare-dns-heroku/) 這篇文章裡面提到的。

首先要查出 S3 那個 bucket 的 Website Hosting IP Address，用 `nslookup www.example.com-s3-website-ap-northeast-1.amazonaws.com` 去查，例如 `55.66.77.88` 好了。

接著到 DNS 設定裡面加一個 A Record ，把 Root Domain （輸入 `@`）指到上述這個 IP 。這時候**還不要對它打開 CloudFlare CDN**。

再到 Page Rules ，開一個新的 Rule：

* Pattern: `http://example.com/*`
* Forward To: `http://www.example.com/$1`
* Forward Type: **301 Permanently**

最後回到 DNS Record ，**把 Root Domain 的 CloudFlare CDN 打開**，就行了。

這怎麼做到的呢？我猜是類似「**DNS 綁架**」 XDD 反正可以動。

不過這個 A Record 似乎還是不能砍掉的樣子，不然 CloudFlare 就不能綁架它了。

## 網站更新時要清 CloudFlare 的 Cache

這可以在 CloudFare Settings 裡面有一個 Purge Cache ，戳下去就行了。

但如果使用 middleman-sync 的話，`.html` 也一樣會送出 cache 一年的 header ，這個 header 一樣會從 CDN 傳出去，被 browser 認出來。所以新站上線還是會遇到最近曾經上站、或通過 Proxy 上網的使用者看到舊的網頁。

---

## Amazon CloudFront 不符需求？

我一直說 CloudFront 不符我的需求，這裡來講一下我到底碰什麼壁。

### 不能設 Origin 為 S3 Bucket

這個意思是說， Origin 要設為 S3 的 Website Hosting domain ，而不是 S3 直連到 Bucket。如果直連到 Bucket ：

* 不支援自動打開 `index.html`
* 當找不到檔案的時候，它會直接噴 S3 的 Error ，而不是自己設定的 `404.html`
* 不支援舊網址→新網址的轉址。

不過這樣想想也很合理，因為以上的設定都是在 S3 的 Website Hosting 裡面設定的，理所當然要通過 Website Hosting 的 Domain 才能動。

那既然不能直接用 S3 Bucket 做為 Origin ，就沒有必要用 CloudFront 了啊。

### Distribution / 清 Cache 很慢

嘛，就是很慢啊，改一個設定就要等它 Distribution 大概十幾分鐘，跑 Cache Invalidation Task 又要等十幾分鐘，我急性子懶得等啊。

### Root Domain 轉址很麻煩

如果是用 CloudFront 的話，[它會教你把 DNS 交給 AWS Route 53 代管](http://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html)，然後再開一個空的 bucket 叫做 `example.com` ，設 Redirect All to `http://www.example.com` 。

重點就是這個 Route 53 代管，在裡面它用的是 Alias Record ，這我不知道是不是 Route 53 專屬的 Record ，總之它沒有告訴你實際的 A Record 要指到哪裡去。所以這個 solution 就是綁在 Route 53 上面。

如果用 CloudFlare 的話，就只要綁架 DNS 即可 XDD

### CloudFront 要錢， CloudFlare 不用錢 <del>←重點</del>

CloudFlare 有免費方案，當然有諸多限制，不過對於我要處理的網站已經足夠了，<del>能蹭則蹭就是我的原則</del>。
