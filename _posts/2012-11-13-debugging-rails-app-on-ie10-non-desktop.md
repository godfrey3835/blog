---
layout: post
title: "在 IE10 Metro UI 連線到 Rails App (Development) 的方法"
published: true
date: 2012-11-13 22:27
tags:
- rails
- windows
- IE
categories: []
comments: true

---


***TL;DR***：「無法顯示此網頁」？把網址加入「**信任的網站**」就好了。下文詳解。

Windows 8 上市之際，地球上又出現了一個新的瀏覽器，叫做 Internet Explorer 10 。事實上 IE10 實作了許多 HTML5 / CSS3 的規格，幾乎可以跟現代瀏覽器相提並論了（雖然缺乏 rapid release 會讓 IE10 逐步走向落後，就像 IE9 一樣）。

然而與一般瀏覽器不同的是，對於 Rails Developer 來說，我們通常是用 OS X 或 Linux ，那 IE 是跑在虛擬機器或別的電腦裡面。我用 OS X 搭配 [Pow](http://pow.cx) 這套無腦掛載 Rack app 的程式，所以通常是把 Windows 的網路設為 NAT 連到 Host OS ，然後在 Windows 的 `C:\Windows\System32\drivers\etc\hosts` 裡面寫死 IP 設定，如 `192.168.2.2 railsapp.dev`。這樣子就可以透過 `http://railsapp.dev` 連到 development environment 的 Rails app。

## 區域網路連線在 Metro IE10 遭到禁止

那 IE10 有什麼不同的呢？因為 IE10 在 Windows 8 同時有 Metro UI 和桌面版，如果用 Metro UI 的 IE10 打開 `http://railsapp.dev` 要測網站的話，就會出現「無法顯示此網頁」：

[![](http://cl.ly/image/3A2c460x2q2W/metro-ie10-connection-failed.png)](http://cl.ly/image/3A2c460x2q2W)

這個原因是：

1. IE10 在 Metro UI 會強制打開「加強的受保護模式」。
2. 在「加強的受保護模式」，網路連線會受阻，它會拒絕連到 `127.0.0.1` 和 [Private Network](http://en.wikipedia.org/wiki/Private_network) 的 IP 區段（如 `192.168.0.0/16` 、 `10.0.0.0/8` ，俗稱區網）。
3. Windows 8 做為委身（？）於 Virutal Machine 裡面的 Guest OS ，要連線到 OS X 的 Pow ，就要連到 `192.168.2.2` 這個 IP （前文指定的 Host OS IP）
4. 但因為是區網 IP ，所以被 IE 的「加強的受保護模式」給禁止連線。

因為是 IP 被擋，所以就算用 [xip.io](http://xip.io) 解到區網 IP 也不能解決。而且它是擋 Private Network ，所以我猜想如果是連線到同一區網內的別台電腦，也會遇到同樣的問題（我沒實際試過）。

同樣的問題，應該也會在其他 Web App 的開發環境遇到，如 Python 、 PHP 、 Node.js 等，只要 http server 不是開在 Windows 本機，情況就跟上面描述的類似。

<!--more-->

## 在桌面版重現問題

Metro UI 的 IE10 並沒有附 F12 開發者工具，要 debug 就有點難。不過還好「加強的受保護模式」可以在桌面版的 IE10 打開，就在「網際網路選項→進階→安全性→☑啟用加強的受保護模式」：

[![](http://cl.ly/image/0z0z1I2t3q2H/enable-epm-on-desktop-ie10.png)](http://cl.ly/image/0z0z1I2t3q2H)

重新打開 IE10 桌面版，你就能重現「無法連線」的問題了。最棒（？）的是，可以在 F12 開發者工具裡面看到錯誤訊息：

[![](http://cl.ly/image/1j1w0J022u2m/err-msg-on-ie10-epm-blocking-private-network-conneciton.png)](http://cl.ly/image/1j1w0J022u2m)

## 解法：「信任的網站」

那怎麼解決呢？只要把 `http://railsapp.dev` 加入「信任的網站」就行了，在「網際網路選項→安全性」，點選「信任的網站」，按下「網站…」就能新增之。不過可惜沒辦法直接指定 `http://*.dev` 的頂級網域：

[![](http://cl.ly/image/3X1D0I2z2O3H/add-to-trusted-zone.png)](http://cl.ly/image/3X1D0I2z2O3H)

這樣就可以了。

不過這個方法是我用 Pow 的時候所試出來的，我不確定用 `rails s` 生出來的 server (`http://localhost:3000`) 或別的 development server 能不能也這樣搞，請你試試看然後下面留言跟我說（欸）。<s>但 Pow 真的很好用喔不用嗎？</s>

## 參考資料：

* [Debugging in IE10 on Windows 8 - IEInternals - Site Home - MSDN Blogs](http://blogs.msdn.com/b/ieinternals/archive/2012/09/05/debugging-local-websites-using-not-metro-immersive-modern-full-screen-internet-explorer-10-desktop-f12.aspx)
* [Enhanced Protected Mode - IEBlog - Site Home - MSDN Blogs](http://blogs.msdn.com/b/ie/archive/2012/03/14/enhanced-protected-mode.aspx)
    *  中譯：[增强的保护模式 - IEBlog 简体中文 - Site Home - MSDN Blogs](http://blogs.msdn.com/b/ie_cn/archive/2012/03/14/enhanced-protected-mode.aspx)
* [Understanding Enhanced Protected Mode - IEInternals - Site Home - MSDN Blogs](http://blogs.msdn.com/b/ieinternals/archive/2012/03/23/understanding-ie10-enhanced-protected-mode-network-security-addons-cookies-metro-desktop.aspx)

---

註：雖然 "[Metro UI](http://en.wikipedia.org/wiki/Metro_\(design_language\))" 這個名稱， Microsoft 已經因為商標問題而停止使用，但我找不到它的替代名稱，我看到的官方文件裡還有 Modern UI 、 non-Desktop 、 [IEPKaM](http://blogs.msdn.com/b/ieinternals/archive/2012/09/26/windows-8-internet-explorer-10-activex-control-changes-and-restrictions.aspx) （指 IE10） 、 Windows Store app look and feel 、 touch-optmized ，沒有統一標準，我想要描述它也不知道該用什麼正確的名字，所以姑且用那個已死的 "Metro UI" 了。
