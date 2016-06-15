---
layout: post
title: "如何移轉 SIM 卡的資料 (通訊錄、簡訊)"
published: true
date: 2009-09-08 00:00
tags: []
categories: []
redirect_from: /posts/2009/09/08/transfer-addressbook-and-messages-in-sim-card
comments: true

---

最近剛去中華電信辦理 2G 轉換 3G ，所以拿到一張新的 SIM 卡。

然而舊 SIM 卡裡面還有一些資料是需要丟到新卡裡面的，像是儲存在 SIM 卡裡面的通訊錄，以及簡訊。雖然這年頭很多人都把通訊錄放在手機的記憶體裡面，鮮少有人還存在 SIM 卡中的。

在做這項操作之前，你必須要擁有一台讀卡機，可以參考<a href="http://blog.yorkxin.org/2009/02/13/pcsc-ez100pu-reader/">我之前的文章</a>。

如果你的手機可以從 SIM 卡把通訊錄和簡訊移動到手機，那可以考慮直接用手機移轉。

---
<!--more-->

首先，你要找到讀卡機的 SIM 卡電話簿編輯工具。我使用的 EZ100PU 官方提供<a href="http://www.casauto.com.tw/in-download-02.aspx?wcid=C_00000003&amp;id=P_00000001&amp;cid=C_00000001">程式下載</a>，但我不清楚是否能應用在別的機種。

載完之後，把 SIM 卡透過轉卡插到讀卡機裡面：

<a title="Flickr 上 chitsaou 的 SIM Data Transfer 1" href="http://www.flickr.com/photos/chitsaou/3897179520/"><img src="http://farm3.static.flickr.com/2649/3897179520_8d462e700d.jpg" alt="SIM Data Transfer 1" width="500" height="280" /></a>

接著把電話簿編輯工具打開來。按一下「讀取」

<a href="http://www.flickr.com/photos/chitsaou/3896490241/" title="Flickr 上 chitsaou 的 SIM Editor 1.png"><img src="http://farm4.static.flickr.com/3430/3896490241_fb9af67b4a.jpg" width="500" height="392" alt="SIM Editor 1.png" /></a>

會問你 SIM 卡的密碼，就輸入吧：

<a title="Flickr 上 chitsaou 的 SIM Editor 2.png" href="http://www.flickr.com/photos/chitsaou/3896490347/"><img src="http://farm4.static.flickr.com/3481/3896490347_33594a5806_o.png" alt="SIM Editor 2.png" width="279" height="198" /></a>

接著會把你的電話簿讀進來，問你要不要丟到編輯區（不會刪掉 SIM 卡裡面原有的），按一下「是」

<a title="Flickr 上 chitsaou 的 SIM Editor 3.png" href="http://www.flickr.com/photos/chitsaou/3897270176/"><img src="http://farm3.static.flickr.com/2612/3897270176_763a37e75b.jpg" alt="SIM Editor 3.png" width="500" height="388" /></a>

然後切換到「簡訊」分頁，一樣按「讀取」，然後也要輸入密碼。

<a title="Flickr 上 chitsaou 的 SIM Editor 4.png" href="http://www.flickr.com/photos/chitsaou/3896490641/"><img src="http://farm4.static.flickr.com/3536/3896490641_8c4043853a_o.png" alt="SIM Editor 4.png" width="262" height="199" /></a>

這樣會把儲存在 SIM 卡裡面的簡訊讀進來。

<a title="Flickr 上 chitsaou 的 SIM Editor 5.png" href="http://www.flickr.com/photos/chitsaou/3897270390/"><img src="http://farm3.static.flickr.com/2645/3897270390_e768832959.jpg" alt="SIM Editor 5.png" width="500" height="188" /></a>

這時候有一件重要的事要做：

<strong>按一下左上角的「關閉」，然後把 SIM 卡從讀卡機抽出來</strong>

接下來，插入新的 SIM 卡。如果你的卡還沒從電信公司給你的卡片上拔下來，應該可以直接插入讀卡機

<a title="Flickr 上 chitsaou 的 SIM Data Transfer 2" href="http://www.flickr.com/photos/chitsaou/3897178516/"><img src="http://farm4.static.flickr.com/3481/3897178516_a85761ffd4.jpg" alt="SIM Data Transfer 2" width="500" height="280" /></a>

然後可以做一件不一定要做的事，就是把電話簿做重新整理。你可以透過程式的功能進行新增、編輯或刪除，甚至移動它的上下位置。（雖然有些手機會直接用姓名排序）

我只要保留其中 7 個號碼，就刪掉其他的了：

<a title="Flickr 上 chitsaou 的 SIM Editor 6.png" href="http://www.flickr.com/photos/chitsaou/3896490891/"><img src="http://farm3.static.flickr.com/2484/3896490891_65d87e1a21_o.png" alt="SIM Editor 6.png" width="491" height="315" /></a>

整理完成再按左上角的「啟動」

接著當然是寫入新卡囉。

按一下「寫入卡片」，會要求你輸入新的 SIM 卡的密碼。

<a title="Flickr 上 chitsaou 的 SIM Editor 7.png" href="http://www.flickr.com/photos/chitsaou/3896490993/"><img src="http://farm4.static.flickr.com/3433/3896490993_05a4b4c1fb_o.png" alt="SIM Editor 7.png" width="287" height="323" /></a>

這個時候，會跳出一個訊息告訴你，卡片裡面的通訊錄會完全被蓋掉（程式以為還是原本那張卡）。按一下「確定」

<a title="Flickr 上 chitsaou 的 SIM Editor 8.png" href="http://www.flickr.com/photos/chitsaou/3896491163/"><img src="http://farm3.static.flickr.com/2610/3896491163_b7ec06c3b2_o.png" alt="SIM Editor 8.png" width="222" height="160" /></a>

切換到簡訊的頁面，一樣按一下「寫入卡片」，輸入密碼，按下「確定」就行了。

<a title="Flickr 上 chitsaou 的 SIM Editor 9.png" href="http://www.flickr.com/photos/chitsaou/3897270888/"><img src="http://farm4.static.flickr.com/3454/3897270888_31ca9c8e6a_o.png" alt="SIM Editor 9.png" width="240" height="324" /></a>
