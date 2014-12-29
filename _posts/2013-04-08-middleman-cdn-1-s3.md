---
layout: post
title: Middleman + CDN 靜態網站實務 (1) 丟到 Amazon S3
published: true
date: 2013-04-08 20:00
tags:
- middleman
- web development
- amazon s3
- CDN
- s3
categories: []
comments: true

---


最近幫親戚的網站搬家，之前<del>偷懶</del>放在 Google Sites ，變成要改什麼都只能被 Google Sites 限制住，所以幫他做一個。

由於只是要展示產品，而沒有任何動態程式，所以當然全站就做成靜態網站了，這次用的方案是 [Middleman](http://middlemanapp.com) ，也當做練習製作靜態網站。上線的話，由於主要的客群是在中國大陸，所以得盡可能讓 HTTP Server 在線路上靠近中國大陸。

總的來說，這個網站在線上需要符合以下需求：

* 在中國大陸連線速度要快。
* 要能做到舊轉址自動轉到新網址。

說到連線速度快，那就會想到 CDN 了，那麼 CDN 就需要設 Origin 。

<!-- more -->

關於 Origin Server ，我考慮了幾個方案：

* **Heroku + Rack Static Site** - 在美國，雖然用 CDN 擋就行，但根據部署 blog 的經驗，覺得很麻煩，而且 S3 還可以設定 Redirection Rules ，用 Heroku 只能手刻，所以出局。
* **Linode + HTTP Server** - 在東京有設點，但我沒買 VPS ，要為這個買 VPS 代價太高。
* **Amazon S3 + Website Hosting** - 在東京有設點，可以設 Redirection Rules，符合我的需求。

所以就選了 S3 。然後前面再用一個 CDN 擋：

* **Amazon CloudFront** - 實際操作之後才發現不符需求。
* **CloudFlare CDN** - 實際操作之後發現比 CloudFront 好，而且可以做 Root Domain 到 `www` 的轉址。

實際操作之後選的是 S3 + CloudFlare CDN 。

CDN 的部份[第二篇](http://blog.yorkxin.org/2013/04/08/middleman-cdn-2-cloudflare/)會寫，這篇先說明部署到 Amazon S3 的一些小撇步。

**Update**：後來上線之後用 [阿里測](http://alibench.com/) 來檢查從中國的連線速度，才發現到有少部份的 ISP 會連不上（驚），也就是說 CloudFlare CDN 不是最佳解。接下來會再試別的方案，找到更好的解法會再更新的。沒有測試就上線真是太糟糕了啊……。

## Middleman Build 的設定

在開始部署之前，要先確定 Middleman Build 出來的東西是我要的。我做了以下設定：

```ruby config.rb
configure :build do
  activate :asset_hash
  activate :gzip
  activate :minify_css, :ignore => [/^_/]
  activate :minify_javascript
end
```

`asset_hash` - 同 Rails 的 Assets Pipeline ，自動對 CSS 、 JavaScript 、 Image 的檔名加上 hash ，這樣子就可以在 Proxy 裡面 cache 住，換新版本也不怕前端沒清 cache。

`gzip` - 順便對 CSS 、 JavaScript 打包一個 `.gz` 的版本，可以用在 nginx 也可以在之後上傳 S3 時使用。

`minify_css` - 就 Minify … 我要說的是那個 `:ignore` ，我把除了網頁裡面引用到的 `site.css` 以外的檔案都改成 `_` 開頭，這樣子最終 build 出來的檔案就只會有 `site.css` ：

    $ tree source/css
    source/css
    ├── _bootstrap-variables.scss
    ├── _sass
    │   ├── bootstrap.css.scss
    │   ├── layout.css.scss
    │   └── site.css.scss
    └── site.css.scss

`minify_javascript` - 就 Minify … 我要說的是我的 JavaScript 檔案，有預先 Minify 過的，檔名都會有個 `.min` ，這樣子它會自動略過，只打 hash。然後這個網站沒有額外的 JavaScript ，所以我也不加 `:ignore` 了。

    $ tree source/js
    source/js
    └── vendor
        └── html5shiv.min.js

說到那個 ignore 選項，我不是很習慣這種負向表列的方式，我比較習慣 Rails 的 Asset Pipeline 用正向表列來列出有哪些是要 compile 的。

## 開 S3 Bucket

這個 S3 Bucket 是 Middleman Build 出來的靜態網頁要上傳的目的地，除了開 Bucket 還要有一些額外的設定：

1. 在 Tokyo 開 Bucket ， Bucket 名稱要跟網站的網域名稱一致，例如 `www.example.com`
- 打開 Website Hosting ，把 Index Document 設成 `index.html` ，把 Error Document 設成 `404.html`
- 開放每個人都可以 Get Object ，不然 HTTP Not Found 的 status code 會是 `403` 而不是 `404` 。
- 去 IAM Console 開一個 deployer ，把 bucket 的所有權限開給他。

關於 3 和 4 是要寫在 Bucket Policy 裡面，這是 JSON Format ，很難手寫，但 Amazon AWS 有做一個產生器 [AWS Policy Generator](http://awspolicygen.s3.amazonaws.com/policygen.html)。

### 開 Deployer

在寫 Policy 之前要先開 Deployer ，有些資料得抄下來，步驟是這樣：

1. 去 AWS IAM Console。
2. 開一個 User 叫做 `website-deployer`，然後抄下它的 **Access Key 和 Secret Key** ，之後從 Middleman 上傳會用到。
3. 到 "Summary" 的分頁，抄下他的 **User ARN** ，等下製作 Bucket Policy 會用到。格式是像 `arn:aws:iam::123456789012:user/website-deployer` 這樣子。

### 製作 S3 Bucket Policy

承前文所述，要寫的 Policy 有兩條：

1. 開放每個人都可以 Get Object。
2. Deployer 可以對 Bucket 做任何事。

要準備的資料：

1. **Bucket ARN**，格式像這樣，注意中間的逗號 `,` 是區分兩個不同的 ARN，其中 `www.example.com` 就是 S3 的 bucket name：`arn:aws:s3:::www.example.com,arn:aws:s3:::www.example.com/*`
2. **Deployer 的 User ARN**，格式像這樣：`arn:aws:iam::123456789012:user/website-deployer`

現在可以去 [AWS Policy Generator](http://awspolicygen.s3.amazonaws.com/policygen.html) 這樣填寫：

1. Type of Policy: **S3 Bucket Policy**
* 加入「開放每個人都可以 Get Object」的 Policy :
    * Effect: **Allow**
    * Principal: `*`
    * Actions: **GetObject**
    * ARN: ***填 Bucket ARN***
* 加入「Deployer 可以對 Bucket 做任何事」的 Policy:
    * Effect: **Allow**
    * Principal: ***填 Deployer 的 User ARN***
    * Actions: **All Actions**
    * ARN: ***填 Bucket ARN***

然後按「**Generate**」，就會生出一長串的 JSON 格式的 Bucket Policy ，把它貼到 Bucket 的 Policy 設定裡面（在 Permission 裡面）。

## Middleman-Sync：上傳到 S3 的工具

有個工具叫 [middleman-sync](https://github.com/karlfreeman/middleman-sync) ，把 S3 Bucket 的資訊和 Access Token 給他之後，就可以幫你上傳到 S3 Bucket。

設定方式如下，在 `config.rb` 裡面寫：

```ruby config.rb
# Activate sync extension
activate :sync do |sync|
  sync.fog_provider = 'AWS'
  sync.fog_directory = 'www.example.com'
  sync.fog_region = 'ap-northeast-1'
  sync.aws_access_key_id = '填寫 Deployer 的 Access Key ID'
  sync.aws_secret_access_key = '填寫 Deployer 的 Secret Access Key'
  sync.existing_remote_files = 'keep' # 寫 'delete' 的話會自動刪掉舊版檔案
  sync.gzip_compression = true # 自動改用 gzip 過的檔案
end
```

上傳之後它會自動幫你把**所有**檔案加上 **Cache-Control** 和 **Expires** 的 header ，期限都是設成一年之後。

特別注意 `gzip_compression` 這個選項，前文提及，在 build 時有打開 gzip 的選項，所以有產生 `.gz` 的檔案，那麼它會自動改上傳 `.gz` 的檔案，並且把上傳之後的檔名設成沒有 `.gz` 結尾的，再設好 `Content-Encoding: gzip` 的 HTTP header。

說到 gzip ，其實 CloudFlare CDN 可以自動幫你自動 minify + gzip，但我這次的做法是從 S3 出去的就有 minify + gzip 過，CDN 只是擋在前面做為一個 Proxy 而已，不讓它改任何檔案內容。

### 已知問題

* `.html` 一樣會被加上 cache headers ，如果你網站的使用者會頻繁上來看的話，瀏覽器會 cache 住舊版，新站上線的時候，就沒辦法保證瀏覽器一定下載新的版本。這是因為 middleman-sync 用的 backend 是 [asset_sync](https://github.com/rumblelabs/asset_sync) ，原本就是針對 CSS / JavaScripts / 圖片來最佳化的。
* 如果 S3 上面已經有相同內容檔案，middleman-sync 還是會重新上傳，也就是說每次都是全站上傳。這樣子不只多耗時間還浪費錢。

## 實際上傳到 S3

以上設好之後就可以上傳了：

    $ middleman build
    $ middleman sync

沒問題的話，你可以在 Bucket 裡面找到 Website Hosting 的網址，打開那個網址看看有沒正常運作，要檢查的項目：

1. 首頁，不加 `index.html` 是否能存取。
2. 子頁，如果是資料夾裡面有個 `index.html` ，是否能不打 `index.html` 就能存取
3. 隨便打網址，是否能看到 `404.html` 的內容，而且回傳的 Status Code 要是 `404` 。沒設好的話會變成 `403` 。
4. HTTP 的 header 是否有設好，注意 `Cache-Control`、 `Expires` 、 `Content-Encoding` 。

## 舊站到新站的轉址

S3 的 Website Hosting 支援設定轉址規則，將規則寫在 Redirection Rules 裡面就行了。不過這個規則卻是 XML 格式的<del>，也就是很難手寫的意思</del>，官方文件可以參考 [Configure a Bucket for Website Hosting](http://docs.aws.amazon.com/AmazonS3/latest/dev/HowDoIWebsiteConfiguration.html#configure-bucket-as-website-routing-rule-syntax)
。

我隨便搜尋一下沒有找到產生器，只好自己做了。產生器的程式碼和使用方式我公開在這裡（拋棄版權）： [gist.github.com/chitsaou/5319661](https://gist.github.com/chitsaou/5319661)

**Update:** 有人照我的 script [做了一個網站](http://quiet-cove-8872.herokuapp.com/)，你只要照格式貼上，就可以自動產生 XML 檔了，不需要搞 Ruby！

要注意因為 Redirection Rules 是用 Prefix 來 match 的，而且是 First-In-First-Out ，所以比較長的 path （資料夾比較深）要寫在前面，比較短的 path （資料夾比較淺）要寫在後面，也就是 Depth-First。例如：

```xml
<RoutingRules>
  <RoutingRule>
    <Condition>
      <KeyPrefixEquals>products/iphone/specs.html</KeyPrefixEquals>
    </Condition>
    <Redirect>
      <ReplaceKeyWith>iphone/specs.html</ReplaceKeyWith>
    </Redirect>
  </RoutingRule>
  <RoutingRule>
    <Condition>
      <KeyPrefixEquals>products/iphone/</KeyPrefixEquals>
    </Condition>
    <Redirect>
      <ReplaceKeyWith>iphone/index.html</ReplaceKeyWith>
    </Redirect>
  </RoutingRule>
</RoutingRules>
```

---

這樣子網站就已經開在 S3 上面了。[下一篇再講 CDN 的部份](http://blog.yorkxin.org/2013/04/08/middleman-cdn-2-cloudflare/)。

p.s. 設定檔又是 JSON 又是 XML ， Amazon 你就不能搞個比較簡單的設定介面嗎…