---
layout: post
title: Octopress 搬家記 (3) -- 未搬遷文章轉至舊站
published: true
date: 2011-11-26 23:34
tags:
- Octopress
- Sinatra
categories: []
comments: true

---


雖然我搬了很多文章過來新站，但還是有不少文章沒有搬的。有一些是我還在觀察要不要轉，如果看的人很多可能就會搬過來。

不過這都不是重點，總之我實作了，在要噴 404 Not Found 的時候，轉址去舊站。

## 改寫 Sinatra 的 Not Found 程式

因為 Octopress 是採用 [Sinatra](http://sinatrarb.com) 這個 Rack Middleware ，所以可以直接利用所有 Sinatra 支援的功能，包括用 [`redirect` 轉址](http://www.sinatrarb.com/intro.html#Browser%20Redirect)。

當然，因為需要執行 rack 的程式碼，所以我的 blog 是放在 Heroku 的。

在 `config.ru` 這個檔案裡面，有實作如果檔案找不到的時候，會輸出 `404.html` （[見此](https://github.com/imathis/octopress/blob/master/config.ru#L13)），我要的是轉去舊站，所以這樣改：

```ruby
# config.ru
not_found do
  redirect to("http://chitsaou.wordpress.com#{request.path}"), 307
end
```

這樣子，只要找不到檔案，就會轉址去 `http://chitsaou.wordpress.com` ；到那邊再找不到，就不干我的事了。

這裡我用了 `307` ，也就是 Temporary Redirect ，讓認得 [HTTP 狀態碼](http://en.wikipedia.org/wiki/List_of_HTTP_status_codes#3xx_Redirection) 的程式，不要視這個為永久轉移，因為我可能以後會砍掉那篇、或移到新站。如果你需要永久轉址的話，請使用  `301`。