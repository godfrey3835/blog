---
layout: post
title: "用 Fixtures 丟測試資料給 sphinx ，建索引很久怎麼辦？"
published: true
date: 2011-07-27 00:00
tags: []
categories: []
redirect_from: /posts/2011/07/27/sphinx-testdata-with-rails-fixtures
comments: true

---

答：fixture instance 的 <strong>id 自己打！</strong>

Ruby on Rails 內建的 <a href="http://api.rubyonrails.org/classes/Fixtures.html" target="_blank">Fixtures</a> 可以讓我們寫 Model 測資時把資料跟程式分開（中間好處略過千萬字）。要測試 sphinx 的搜尋當然也可以用它。

今天搞了兩三個小時，為什麼這麼久呢？是因為我每次建索引都很久，不明其道理。然後求了 Google 大神才發現有這個事：<strong>Fixtures 自動產生的 id 會讓 sphinx 在建索引時很慢</strong>（<a href="http://groups.google.com/group/thinking-sphinx/browse_thread/thread/9dd0d309676edbdd" target="_blank">來源</a>）！原來在 ThinkingSphinx 的 common issues 裡面也有提到<a href="http://freelancing-god.github.com/ts/en/common_issues.html#slow_indexing" target="_blank">這件事</a>，他的解答是你自己把他跳的距離增加，我是想說乾脆自己打 id 嘛。

不過，會發生這種事的原因，其實都是因為我一開始懶得打 id （掩面）

---

最近在玩 ThinkingSphinx ，頗有心得，過陣子玩熟了點再來發文。
