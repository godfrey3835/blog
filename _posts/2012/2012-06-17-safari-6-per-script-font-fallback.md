---
layout: post
title: Safari 6 也依語言選字體，英文變醜了！
published: true
date: 2012-06-17 15:38
tags:
- Safari
- font
- webkit
- web development
categories: []
redirect_from: /posts/2012/06/17/safari-6-per-script-font-fallback
comments: true

---


沒錯，這個跟 [Chrome 19 的 <strike>bug</strike> 功能](http://blog.yorkxin.org/2012/05/03/chrome-18-chinese-font-fail-and-solution/)是一樣的， Safari 6 (Developer Preview) 也使用 html tag 的 `lang` attribute 來判斷要用哪一套字體來 fallback （[參考這裡](http://www.zhihu.com/question/20291055/answer/14646065)）。以繁體中文的 `zh-TW` 為例，它會 fallback 到 Heiti TC （黑體-繁），不只漢字，連英文、數字都套用。這不是一個很好的現象。

為什麼這樣不好呢？我同意 [@lianghai 所說的](https://twitter.com/lianghai/status/214373518094254080)，根據語言選擇字體很好，像是繁體中文、簡體中文、日文都可以看到正確的筆劃。但是它選擇的中文字體（Heiti TC、Heiti SC）的英文、數字很醜，而瀏覽器又沒有針對英文、數字另外選擇字體，於是就看到了不舒服的字體組合。對我來說，以前看慣了 Helvetica 和 Arial 這些為西文特別設計的字體，現在卻看到另一種設計不良的字體，我會抓狂。

要親眼看效果的可以去 ADC [下載 Safari 6 Developer Preview](https://developer.apple.com/devcenter/safari/index.action) ，要先（免費）註冊成 Safari Developer（但它常常當掉，所以如果你拿它來日常使用，試完記得解除安裝）。

不過既然 Chrome 可以「關掉這個功能」，Safari 行不行呢？我看了 Extension API 沒找到有關 `font` 的 API ，不過我找到一個 hack 可以關掉 per-script font fallback：

**Update:** 我把以下的 hack 包成 [Safari Extension](https://github.com/chitsaou/no-per-script-font) 來一鍵關閉這個「功能」。

<!-- more -->

##  關掉 Per-Script Font Fallback

我找到的方法是透過設定自訂樣式表來「關閉」 per-script font fallback，不確定在未來的正式版，還能不能用這招：

1. 把下面的 `font-fix.css` 下載到你的電腦裡面。[（原 gist）](https://gist.github.com/2925009)
2. 在 Safari 6 打開偏好設定→進階→樣式表，瀏覽到 `font-fix.css` 這個檔案。
3. 不用重開 Safari 就能看到效果了。

<script src="https://gist.github.com/2925009.js?file=font-fix.css"></script>

## 修改後的效果

至少你會看到像樣一點的英文和數字了。因為我把系統字體改成 Hiragino Sans GB ，所以你看到的中文字會跟我看到的不太一樣。嗯總之英文和數字變回 Helvetica 了。

[![](/images/2012/2012-06-17-safari-6-per-script-font-fallback/Safari 6 Font Fix.png)](http://cl.ly/1O0p011L062C190E2z2V)
