---
layout: post
title: Octopress 搬家記 (1) -- Wordpress.com 舊文轉移
published: true
date: 2011-11-26 22:44
tags:
- Octopress
- wordpress
categories: []
comments: true

---

有一些文章我想要從 Wordpress.com 搬到 Octopress 。

## 1. 下載匯入 Wordpress.com Export XML 到 Octopress 的程式

我把匯入的程式放在 Octopress 根目錄的 `_import/` 這個目錄裡面。

Jekyll 原本有提供 [匯入 Wordpress.com 的 XML Export 程式](https://github.com/mojombo/jekyll/blob/master/lib/jekyll/migrators/wordpressdotcom.rb)，產生的文章格式會是 HTML 。但我不甚滿意，所以改寫了一番，程式在這裡：

<https://gist.github.com/1394128>

<!--more-->

它的特色：

- **正確處理 YAML 的 UTF-8 輸出** ，改用 Ruby 1.9.2 內建的 [Psych](https://github.com/tenderlove/psych) ，這問題就解決了；你可以 Google `ruby yaml utf-8` 就知道我在說什麼了。不過也因此必須使用 Ruby 1.9.2。
- **自動產生 ``** ，因為 Wordpress.com 用一個空行來代表換段。這借用了 [Ruby on Rails](http://rubyonrails.org/) 的 `simple_format` ([原程式](https://github.com/rails/rails/blob/master/actionpack/lib/action_view/helpers/text_helper.rb#L229)) 來產生。
- **自動產生 `<br>`** ，因為 Wordpress.com 用一個 `\n` 來代表段內換行。我改寫了 `simple_format` 的演算法。
- **更正非 ASCII 的 Permalink Title** ，因為 Wordpress.com 實際上已經幫你做過 URL Encode 了，如果再把 encode 過的當做檔案名稱（也就是網址的 `:title`），會變成雙重 encode ，很醜。
- 如果原文禁止 comments ，也一併寫進 YAML Front Matter

此外還會做：

- **匯入 category 以及 tag** ，我實在不懂為什麼原本的程式只匯入 tag ？這樣就不能造 category page 了。
- **丟掉 meta data**，我寫文的時候還需要寫 meta 嗎 XDD
- **把匯入的資料夾放在 `source/_posts`** ，這個只是因為 Octopress 和 Jekyll 的差異。

但不能處理：

- 把 `[sourcecode]` 的 block 轉成 `<pre>`
- 把 HTML 轉成 Markdown

有空再把改好的回送給 Jekyll ……。

然後它需要用 [hpricot](http://rubygems.org/hpricot) 解讀 XML ，所以就 `gem install hpricot` 裝一下。

## 2. 下載 Wordpress 備份檔

從 Wordpress.com 的後台 → Tools → Export 下載 Wordpress 的匯出檔（是個 XML）。

檔案放在 Octopress 的根目錄，並且命名為 `wordpress.xml` （匯入程式用的預設檔名）。

## 3. 轉檔囉

打這條指令：

    ruby -r "./_import/wordpressdotcom.rb" -e "Jekyll::WordpressDotCom.process"

它會跟你說轉了多少文。

如果實際打開 `source/_posts/` 這個目錄，會發現它原封不動地把 HTML 放進來了。

有一些文章如果不想拿到新站的話，直接把檔案刪掉就行了。

## 4. 收尾

別忘了把匯入的文章給 commit 進 repository 。

* * *

其實我丟掉了不少舊文，以前那些中二文就丟掉吧 XDD