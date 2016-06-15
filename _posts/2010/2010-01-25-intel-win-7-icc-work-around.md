---
layout: post
title: Windows 7 套用 ICC 色彩設定檔的問題及 work-around 解
published: true
date: 2010-01-25 00:00
tags: []
categories: []
comments: true

---

入手新螢幕之後，當然要校正色彩讓它看起來更順眼。

我使用 Mac OS X 10.6 內建的色彩校正工具，並把它產生出來的 ICC 設定檔複製到 Windows 7。套用之後，卻發現不論是鎖定螢幕再解鎖、重新開機，都會導致色彩設定被重設。

爬 Google 好久發現不只我有這個問題，而且出問題的都是 Intel GMA 系列顯示晶片（我的 MacBook 是用 GMA950）。我先<a href="http://www.mobile01.com/topicdetail.php?f=256&amp;t=1345013&amp;p=1">照著魔敗01這篇文章來設定</a>，也是無法解決上述問題。有人說是因為電腦裡有除了 Windows 7 以外的程式在設定螢幕色彩，但我沒有用額外的工具程式在設定螢幕色彩，同樣的問題在<a href="http://social.answers.microsoft.com/Forums/zh-TW/w7desktopzhtw/thread/1fd88d44-3bf7-4f53-b45e-82d2f10f3519">台灣微軟的論壇也沒有人po解</a>。

於是找了很久又找到這篇論壇討論文：<a href="http://www.neowin.net/forum/topic/808104-color-calibration-issue-in-windows-7/page__view__findpost__p__591452864?s=9edb3d46a5f64ab8905decff82b26b65">Color calibration issue in Windows 7?  - Neowin Forums</a>。其中有人提及他把某個程式關掉以後就正常了。利用工作管理員砍掉可疑的 process 來實驗以後，發現了是它：

<a href="http://chitsaou.files.wordpress.com/2010/01/intel-utility.png"><img class="size-full wp-image-943" title="Intel-Utility" src="http://chitsaou.files.wordpress.com/2010/01/intel-utility.png" alt="" width="585" height="367" /></a>

開始→執行，輸入msconfig，切換到「啟動」標籤頁，找到「igfxpers.exe」這個執行檔，取消打勾，按確定，重新開機。

測試結果是不論重新開機或解鎖螢幕，都不會蓋掉我所指定的 ICC 。

算是一個 work-around 解吧？
