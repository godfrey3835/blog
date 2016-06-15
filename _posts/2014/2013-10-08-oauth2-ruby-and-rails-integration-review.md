---
layout: post
title: Ruby / Rails 的 OAuth 2 整合方案簡單評比
published: true
date: 2013-10-08 21:00
tags:
- ruby
- rails
- OAuth
- Rack
- Grape
categories: []
comments: true

---
要讓 API 可以用 OAuth 2 的方式來上鎖（認證），必須要準備這些東西：

* 造一個 **Authorization Server** 用來管理 Client 和 Token ，包括核發 Access Token
* 在 Resource Server （即 API） 放一個 **Guard** ，用來限制某些 endpoints 必須帶 OAuth 2 Access Token

因為我要造的 API 是 [Grape](https://github.com/intridea/grape) 搭起來的，掛在 Rails 底下，於是就 survey 了一些方案：

* [Doorkeeper](https://github.com/applicake/doorkeeper)
* [Rack::OAuth2](https://github.com/nov/rack-oauth2)
* [Warden::OAuth2](https://github.com/opperator/warden-oauth2)
* [Grape::Middleware::Auth::OAuth2](https://github.com/intridea/grape/blob/master/lib/grape/middleware/auth/oauth2.rb) （偽）

你可能會問： [OAuth2](https://github.com/intridea/oauth2) 這個 gem 呢？其實他只有實作 Client ，所以不在本文範圍（完）。

<!-- more -->

## Doorkeeper

* 完整的 Authorization Server solution 。
* 簡陋的 Resource Server Guard solution
* 有內建 Client management
* For Ruby on Rails -- 如果你用 Sinatra 就不能用了。

基本上幫你搞定 Authorization Server 的所有需求，但 Resource Server Guard 則是很簡陋，或說根本是隨便寫的，只會幫你丟 401 Unauthorized ，Bearer Token 的要求他幾乎沒實作。具體程式碼在 [lib/doorkeeper/helpers/filter.rb](https://github.com/applicake/doorkeeper/blob/v0.7.3/lib/doorkeeper/helpers/filter.rb) (Tag: v0.7.3) 。有人開 Pull Request 但沒有 merge： [support the spec of 'invalid_token' response by masarakki](https://github.com/applicake/doorkeeper/pull/240) 。

## Rack::OAuth2

* 有 Authorization Server
* 有 Resource Server Guard ，完成度很高
* 沒有內建管理 Client 的方式
* Rack Middleware × 2 ： Authorization Endpoint 和 Token Endpoint
* View 要自己刻
* 沒有綁 Model ，自己刻。

簡單來說只幫你處理掉 Protocol 而已，支持它的 Model 和 View 必須自己處理。

Resource Server Guard 「完成度很高」是相對於 Doorkeeper 而言。

問題點：

* `insufficient_scope` error 沒有帶 `WWW-Authenticate` 和 required scopes。
* 它的 authenticator （就是 use middlware 的時候要丟進去的 block）只會在「有傳 token」的情況下才會 call，沒傳 token 就會跳過，繼續往下一個 Rack stack 跑，所以只能用來「抓 token」。
* 承上，這個 authenticator procedure 要 yield 一個 token object 用來儲存在 Rack env 裡面（raw string 或 model instance 都行），所以它真的就是拿來「抓 token」用的而已。
* 承上，真正驗證 Token 正確與否的程式要寫在 Application layer ，不能寫在 Rack middleware ，否則就會發生「沒傳 token 卻可以 access API」的問題。

## Warden::OAuth2

它會跟 Devise 的 warden 卡在一起，所以我沒有深入研究。

## Grape 的 OAuth 2 authorization

Source Code (master): https://github.com/intridea/grape/blob/master/lib/grape/middleware/auth/oauth2.rb

檢閱日期是 2013/10/07 ，與當下最新版本 v0.6.0 一致。

* 既然是 API Framework 提供的，當然只有 Resource Server Guard
* 但是沒做完
* 而且 **它並不會 mount 這個 middleware** ，所以實際上無法使用（具體見 [這個 Pull Request](https://github.com/intridea/grape/pull/160)）

既然目前的版本無法使用，只能看 code 說故事。它的問題所在：

* 要自己造 Model ，預設是 `AccessToken` ，並且這 class 要實作 `#expired` 和 `#permission_for?`
* `#permission_for?` 就是 scope 驗證，傳進去的參數是整個 Rack `env` （……）。
* 但 `insufficiet_scope` 的 response 並不會提示 required scopes （同 Rack::OAuth2）
* 完全沒有 `error_description`
* Auth-Scheme 同時吃 `Bearer` 和 `OAuth2` ，第二種不是 spec 規定的，顯然不需要

## 我的做法: Doorkeeper + Rack::OAuth2

以上每個 solution 都不完美，就只好自己搭了。

我的做法是這樣：

* Doorkeepr 拿來蓋 Authorization Server ，一鍵搞定
* API 是用 Grape 蓋起來的，所以不用（不能用） Doorkeeper 的 `doorkeeper_for`。
* Guard 改用 Rack::OAuth 2 ，自己寫一個 module 給 Grape 來處理兩邊的整合

之後會寫一篇 Tutorial ……最近幾天內會發表。

**Edit**: 寫完了： [OAuth 2.0 Tutorial: Grape API 整合 Doorkeeper](http://blog.yorkxin.org/posts/2013/10/10/oauth2-tutorial-grape-api-doorkeeper)