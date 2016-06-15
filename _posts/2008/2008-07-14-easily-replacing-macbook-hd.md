---
layout: post
title: "[筆記] 簡單到炸飛的 MacBook 換硬碟"
published: true
date: 2008-07-14 00:00
tags: []
categories: []
comments: true

---

<a title="Flickr 上 chitsaou 的 新買的 Hitachi 硬碟~~" href="http://www.flickr.com/photos/chitsaou/2664133727/" target="_blank"><img src="http://farm4.static.flickr.com/3206/2664133727_7aea16ef75_m.jpg" alt="新買的 Hitachi 硬碟~~" width="180" height="240" align="right" /></a>最近因為 MacBook 的硬碟滿了，加上很怕<span style="text-decoration:line-through;">去年那次的 Seagate 硬碟爆炸事件再度發生</span>，所以昨天去光華商場買了一顆內附 Hitachi 160G 硬碟的隨身硬碟，準備把裡面的硬碟和原本的 MacBook 硬碟互換。

<span style="color:#ff0000;">更新</span>：結果在同年 11 月 28 日，<strong><span style="text-decoration:underline;">這顆硬碟竟然也壞軌了</span></strong>，裡面的資料也就死光光。因此<span style="text-decoration:underline;">本人在此不推薦 H 牌硬碟</span>...

所以問題在於，怎麼把資料移轉過去；但其實最大的問題也就是這個而已。

其實照著MacUKnow 的<a href="http://www.macuknow.com/node/160" target="_blank">這篇經典文章</a>做就 ok 了，甚至<a href="http://manuals.info.apple.com/en/MacBook_13inch_HardDrive_DIY.pdf" target="_blank">蘋果會社也教你怎麼自己換硬碟.pdf</a>。不過同時我也遇到一些問題，順便寫個心得。

—

<!--more-->

第一點是關於工具。MacBook 拆換硬碟的時候需要一個特別的工具：<strong>T8 六角星型螺絲起子</strong>。在官方版的說明文件是寫「Philips #1 screwdriver」，這是拿來拆卸<a href="http://flickr.com/photos/chitsaou/2664959582/" target="_blank">硬碟架</a>的。這道具可以在一般的電子材料行或五金行買到，但我去光華商場買不到 (其實是有，但竟然喊價 280)，我是去電子材料行才買到<strong>一支 45 元</strong>的起子。

<a title="Flickr 上 chitsaou 的 螺絲釘和起�合照" href="http://www.flickr.com/photos/chitsaou/2664134657/" target="_blank"><img src="http://farm4.static.flickr.com/3024/2664134657_dbd0dfb3ba.jpg" alt="螺絲釘和起�合照" width="500" height="375" /></a>

第二點關於備份。MacUKnow 的教學文章是寫用 <a href="http://www.bombich.com/software/ccc.html" target="_blank">Carbon Copy Cloner</a> 「比較快」，但也沒快到哪裡去，我光複製 70G 的資料就費掉 3 小時之久，也許跟傳輸速度比較有關。這套軟體是免費的，它好像還有定期備份的功能。

第三點很重要，<strong>接地</strong>。這是我沒注意到的，但官方的教學文件上有寫。不用再去找什麼地方摸接地了，<strong>MacBook 電池座有一塊金屬板就是給你摸接地的</strong>…。拿出電池後，摸一下那塊金屬板吧。

<a title="Flickr 上 chitsaou 的 拆開 MacBook 電池囉~" href="http://www.flickr.com/photos/chitsaou/2664134079/" target="_blank"><img src="http://farm4.static.flickr.com/3250/2664134079_277654c425.jpg" alt="拆開 MacBook 電池囉~" width="500" height="375" /></a>

—

<a title="Flickr 上 chitsaou 的 桌面上的新硬碟~" href="http://www.flickr.com/photos/chitsaou/2664135025/" target="_blank"><img src="http://farm4.static.flickr.com/3163/2664135025_b2fdcc8f3c_o.png" alt="桌面上的新硬碟~" width="201" height="200" align="right" /></a>其他的沒什麼好注意。

不過我在把新硬碟安裝到 MacBook 上之前有先用 USB 開機試試看，總之是在開機的時候按下 ⌥ (Option) 就可以選擇要用哪個卷宗開機了。在一切貌似完好之後，再實際裝到 MacBook 上面。

安裝完之後出現一個問題，就是按下開機鈕，連噹一聲都沒有。本來以為是外接盒的廠牌太雜導致格式化出問題(不能開機)，但不知道怎麼想到跟預設的開機卷宗有關，因為原本是用 Seagate 那顆硬碟裡面的卷宗開機，現在那個卷宗不見了，所以一開機 Macintosh 就找不到卷宗，就停在那邊，只有燈亮。因此這時候<strong>關閉電源再開機，同時按下 ⌥ (Option)</strong>，這樣就看到新硬碟啦。

開機之後，隨即到系統偏好設定.app 修改「啟動磁碟」，選擇「新硬碟 上的 Mac OS X, 10.4.11」，按一下「重新開機」，這個問題應該就可以解決了。

最後遇到一個小問題，是 iTunes 的資料夾 (~/Music/iTunes) 的 owner 被設成 system，所以我的 iTunes 不能啟動。不過既然是權限的問題就更簡單了，直接在 ~/Music/iTunes 資料夾上面按滑鼠輔助鍵，按一下「取得簡介」，下方的「擁有者與權限」改一下就好啦~~。

另外，我怕在複製的過程中會因為時差而資料不完整，所以在複製資料的過程中，我是把網路整個切斷的，而且也不進行其他工作。

—

所以大略整理一下步驟，細節請參考 <a href="http://www.macuknow.com/node/160" target="_blank">MacUKnow 的說明</a>。
<ol>
	<li>關掉網路連線，包括移除乙太網路線和關掉 AirPort</li>
	<li>把新的硬碟格式化</li>
	<li>使用 Carbon Copy Cloner 把原本硬碟的資料複製到新硬碟</li>
	<li>重新開機，按 Option 鍵選擇外接硬碟卷宗開機測試</li>
	<li>確認無誤，關機</li>
	<li>拆掉電池</li>
	<li>摸一下電池座的金屬板以接地</li>
	<li>拆開記憶體擋板，整塊擋板拿開</li>
	<li><a href="http://flickr.com/photos/chitsaou/2664959372/" target="_blank">拉出硬碟</a>，記得要輕輕的喔。</li>
	<li>把舊的硬碟從硬碟架上拆下來，把<a href="http://flickr.com/photos/chitsaou/2664959962/" target="_blank">新的硬碟鎖上去</a></li>
	<li><a href="http://flickr.com/photos/chitsaou/2664134935/" target="_blank">插回硬碟</a>，記得要輕輕的喔。</li>
	<li>開機時按住 Option 鍵，選擇卷宗</li>
	<li>進入「系統偏好設定」的「啟動磁碟」，選取作業系統所在的卷宗，按一下「重新開機」</li>
	<li>everything should work well :p</li>
</ol>
—

btw 為什麼我覺得這顆新的硬碟比較快，開機變快，開程式也變快了，我明明就買同樣轉速的…是錯覺嗎 = =

<a title="Flickr 上 chitsaou 的 系統描述.app 裡面的新硬碟" href="http://www.flickr.com/photos/chitsaou/2664969200/" target="_blank"><img src="http://farm4.static.flickr.com/3144/2664969200_5ebf20e2a3.jpg" alt="系統描述.app 裡面的新硬碟" width="500" height="338" /></a>
