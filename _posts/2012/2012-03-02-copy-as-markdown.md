---
layout: post
title: Copy as Markdown -- 輕鬆複製 Markdown 救手指
published: true
date: 2012-03-02 02:52
tags:
- Markdown
- chrome
categories: []
redirect_from: /posts/2012/03/02/copy-as-markdown
comments: true

---


如果你跟我一樣是 Markdown 的愛用者（就像 Blog 也用 Markdown 寫），你或許常常在引用資料的時候一直要按 `Ctrl+C`、`Ctrl+V` 的快速鍵。遇到圖片還得用滑鼠按「複製圖片網址」。有時我會覺得我手指快斷了。

[**Copy as Markdown**](https://chrome.google.com/webstore/detail/fkeaekngjflipcockcnpobkpbbfbhmdn) 是我做的 Chrome Extension ，專門做這些事：

1. 把目前的分頁標題及網址複製成 Markdown
2. 按右鍵把超連結複製成 Markdown
   * 如果你是在圖片上按右鍵，則複製出來的會是連結包圖片 `[![](img url)](link url)`
3. 按右鍵把圖片複製成 Markdown
4. 把目前視窗的所有分頁及網址複製成 Markdown 的列表（！）

一按就完成，手指可以空出來做更多事，我是說寫稿。

## 載點

[Chrome 網路商城由此去](https://chrome.google.com/webstore/detail/fkeaekngjflipcockcnpobkpbbfbhmdn) 、[原始碼由此去](https://github.com/chitsaou/copy-as-markdown) (MIT)。

## 截圖

大概像這樣（其實下圖的 markdown code 我也是直接用這個 extension 複製的… 超懶人 XD）：

![](/images/2012/2012-03-02-copy-as-markdown/Screen Shot 2012-03-02 at 01.40.37.png)

## Known Issues

已知問題有幾個：

1. **在 Windows 的 Chorme，複製連結的時候，不會複製連結文字**。這個原因是 Mac OS X 會自動在按右鍵的時候就選取文字，但 Windows 版本不會。這是我上架之後才發現的 bug ，沒用 Windows 測試真的不行 orz
2. **複製圖片的時候，抓不到 `alt` 屬性**；這個我還在找答案，很顯然直接從 Chrome 的 Context Menu [OnClickData 物件](http://code.google.com/chrome/extensions/contextMenus.html#type-OnClickData) 是抓不到的。這個問題要是解決了， 1 或許也就解決了。

<!-- more -->

## 以下心得文

這是我最近這兩天開始做的，但其實已經想很久了。壓倒我的最後一根稻草，是最近在學 Code Academy 的 [JavaScript 課程](http://www.codecademy.com/languages/javascript)，總覺得終於有條理地學了 JavaScript ，那就把以前因為沒技術所以寫不出來的東西寫一寫吧。

第一次做 Chrome Extension ，當然第一個是參考[官方文件](http://code.google.com/chrome/extensions/docs.html)。不過官方文件似乎只列出了基本的 API ，使用範例也很少，就老是叫你翻 Sample 。

別的不說，光是複製到剪貼簿，就是上 StackOverflow 找到[答案](http://stackoverflow.com/questions/3436102/copy-to-clipboard-in-chrome-extension)的（非常怪的招數），這個功能我以為會是 Chrome API 要提供的… Orz

功能大致寫完了以後，要上架時又碰到阻礙。

首先是 Chrome Web Store 要求上架時要有 1280x800 **或** 640x400 解析度的螢幕截圖。

1. 我想說 Chrome Web Store 的圖片這麼小，我隨便切個小圖就行了。
2. 第一次放，**不滿 640x400** ，叫我再傳一次。
3. 第二次放，我切 643x404 ，上傳後跟我說「尺寸不符」，所以是一定要**完全一致**才行…
4. 第三次放，我切得剛好 640x400 ，上傳後卻跟我說**「請上傳 1280x800 的解析度」**，<strike>泥馬</strike>玩我啊！！不接受小解析度就把說明文字砍掉啊 -_-
5. 第四次放，就只好先用別的工具把 Chrome 縮到 1280x800 ，抓圖，然後用 Preview.app 小心切…
6. 而且上架之後才發現他**還是縮到 640x400** 了，那你叫人家放大圖放身體健康的？

此外還要放一張宣傳圖，是 440x280 ，為了這個只好再切一次。不過這好像是要放在 Web Store 的 index ，哪天這個 app 被擠到上面就需要了<strike>（會有這一天嗎？）</strike>。

最後要付 US$5.00 的一次性註冊費，這麼便宜當然不介意了。不過我竟然看到這個畫面：

[![](/images/2012/2012-03-02-copy-as-markdown/Screen Shot 2012-03-02 at 01.48.09.png)](http://cl.ly/1E1r120E2d300W2b0r3C)

五樓你評評理啊！當然我在姓名之間加入一個空格就通過了 Orz

不過這次還真的學到了怎麼做 Chrome Extension ，以前還想說要學怎麼做 Firefox Extension ，但最近兩年已經沒在用 Firefox 了...。
