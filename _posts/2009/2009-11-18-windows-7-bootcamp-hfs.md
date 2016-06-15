---
layout: post
title: Windows 7 在 Mac 電腦的問題 (Windows 更新、Windows Installer)
published: true
date: 2009-11-18 00:00
tags: []
categories: []
redirect_from: /posts/2009/11/18/windows-7-bootcamp-hfs
comments: true

---

最近在我的 MacBook 裝了 Windows 7 （學校的授權）。

前一陣子發現一個問題是 Windows 更新和任何以 Windows Installer 包裝起來的安裝程式都會爛掉。

試了好久才發現是 BootCamp 掛載 HFS+ 磁區的問題。

Windows Update 會完全無法使用（連檢查更新的畫面都是一片白，程式沒有回應），而 Windows Installer 則是安裝過程整個沉默，或是直接告訴你安裝失敗。

trace 了安裝程式的 log 才知道，它會去找最大可用磁碟分割區當暫存區。一般來說用 Mac 電腦裝 Windows ，你給 Windows 的磁區都不會太大，所以安裝程式會自動找到 HFS+ 的磁區，好死不死它又是唯讀，所以...嗯<span style="text-decoration:line-through;">（小鄭老師調</span>。

為甚麼這麼肯定是 HFS+ 呢？是因為我把 Mac OS X 磁區和 Time Machine 磁區兩個都 unmount 之後，問題就解決了。 = =

修改方法及完成後的畫面如下圖：（反正就是把那個掛載點移除就好了，小心<span style="text-decoration:underline;">不要選錯</span>…）

圖中的「磁碟 1」是 Time Machine 的，你可以乾脆把那條線拔掉，或是在磁碟 1 的圖示上按右鍵選「離線」，也能達到類似的效果。

<a href="http://chitsaou.files.wordpress.com/2009/11/e89ea2e5b995e68a93e59c96-2009-11-18-20-59-47.png"><img class="aligncenter size-full wp-image-692" title="Windows 7 移除 HFS+ 掛載點" src="http://chitsaou.files.wordpress.com/2009/11/e89ea2e5b995e68a93e59c96-2009-11-18-20-59-47.png" alt="" width="700" height="483" /></a>

p.s. 基本上蘋果電腦<a href="http://support.apple.com/kb/HT3920?viewlocale=zh_TW">還沒正式支援在 BootCamp 安裝 Windows 7 </a>，所以上面這個問題，很有可能在未來的 BootCamp Patch 會修正。

p.s. 2 Windows 7 真的很好用啊又很快，我這台 MacBook 13.3" (Mid 2007, 沒有獨立顯卡) 跑 Windows 7 比 XP 還順 = =

p.s. 3 因為 Windows Media Center 可以接收來自電視諧調器 (TV Tuner) 的 H.264 封裝影音訊號，所以我現在可以看到<a href="http://hihd.pts.org.tw">公共電視的 HiHD</a> 了~~耶~~
