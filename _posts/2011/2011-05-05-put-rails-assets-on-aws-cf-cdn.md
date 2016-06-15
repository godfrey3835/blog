---
layout: post
title: "把 Ruby on Rails 的 assets 放到 CloudFront CDN"
published: true
date: 2011-05-05 00:00
tags: []
categories: []
redirect_from: /posts/2011/05/05/put-rails-assets-on-aws-cf-cdn
comments: true

---

為了不要讓 assets  (共用圖片、CSS、JavaScript 等) 下載時擠到網頁主要內容的頻寬，我把 Rails 的 assets放到 <a href="http://aws.amazon.com/cloudfront/" target="_blank">AWS CloudFront</a> 上面，並且設不同的網域名稱，這在 <a href="http://developer.yahoo.com/blogs/ydn/posts/2007/04/high_performanc_1/" target="_blank">Y!Slow 的建議</a>中有提到。

之前的做法是在 deploy 以後 (<a href="http://capify.org/" target="_blank">Capistrano</a> 的 <code>after "deploy:update_code"</code>) 把 <code>public/</code> 給同步到 <a href="http://aws.amazon.com/s3">S3</a> 的某個 bucket，然後在 CloudFront 那邊開一個 distribution 設 origin 到該 bucket。不過缺點是每次 deploy 都要等待它上傳。雖然有 <a href="http://aws.typepad.com/aws/2010/11/amazon-cloudfront-support-for-custom-origins.html" target="_blank">custom origin</a> 可以用，但實作上比較麻煩，所以就一直拖著。

前幾天 AWS Console 多了可以<a href="http://aws.typepad.com/aws/2011/05/improved-cloudfront-support-in-the-aws-management-console.html" target="_blank">從管理頁面指定 CloudFront custom origin</a> 的選項，不過已經存在的 distribution 不能更改 origin，只能在新增 distribution 的時候指定，但總之滑鼠點一點就行了，方便許多。

我把 origin 設為我的 production 主機，這樣子它可以直接去 production 抓檔案。當然 distribution 的 CNAME <code>assets[1-3].domain.com</code> 一定要設的啊，接著測試一下 distribution 給的 domain name 連過去有沒有正確，就可以去 DNS 設定中把原本的 assets CNAME 指到新的 distribution 了。

別忘了 Rails 的 <code>config/environment/production.rb</code> 裡面有個 <code>config.action_controller.asset_host</code> 也要改，具體寫法問 Google （ｒｙ
