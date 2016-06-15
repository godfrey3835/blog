---
layout: post
title: 關於 HTTP Authentication 的 "realm"
published: true
date: 2013-10-02 11:12
tags: []
categories: []
redirect_from: /posts/2013/10/02/realm-in-http-authentication
comments: true

---
最近在學 OAuth 2.0，在讀 spec 的時候，發現 Bearer Token 的 auth-param 有 `realm` 和 `scope` 。我一開始搞混，後來去查了 HTTP Basic Auth 裡面也有 `realm` ，在瀏覽器上面出現的效果就是像下圖箭頭指的地方：

![](http://cl.ly/image/043j211v223m/http-basic-auth-realm.png)

且就算 realm 不同，瀏覽器都會試同樣一組帳號密碼，我試過[用 Sinatra 做一個微 App](https://github.com/chitsaou/http-basic-auth-demo) ，分別有以下的 routes：

| Path | Realm | Username | Password |
|------|-------|----------|----------|
| /a1  | Protected A | abc | a1 |
| /a2  | Protected A | abc | a2 |
| /b   | Protected B | abc | b  |

這樣子的話：

1. 先登入 a1 ，再去 b （不同的 realm）則瀏覽器會用 a2 用過的密碼試著去登入 b。
- 先登入 a1 ，再登入 a2 ，再去 a1 （同樣的 realm）則瀏覽器會用 a2 用過的密碼試著去登入 a1。

我在 Safari, Chrome, Firefox 都試出一樣的行為。從結果來看應該是不能從 `realm` 去劃分區域，並且預期瀏覽器會認 `realm` 來決定要用哪一組帳號密碼，甚至瀏覽器會把上一次用的  `realm` 記起來，忘掉之前用過的，再遇到同一個 host 裡面需要 authenticate 的場合，就用新的帳密。所以作用域是 per-host 嗎？

如果說 OAuth 2 的 `realm` 跟 HTTP Basic Auth 的 `realm` 一樣，那是否表示 `realm` 是給人類看的，而不是給程式看的呢？我不確定。求科普。[在 StackOverflow 上面有人說](http://stackoverflow.com/a/12701105/664245)「Realm 一樣的，就會用同一組帳密」，但從結果來看不是這樣。
