---
layout: post
title: "網樂通 + Mac: 把 Mac 電腦的 Internet 透過 Ethernet 共享給網樂通機上盒"
published: true
date: 2011-05-07 00:00
tags: []
categories: []
comments: true

---

最近流行 VOD，<a href="http://www.nexttv.com.tw/" target="_blank">壹電視</a>也走在其他媒體業者的前面，率先推出<a href="https://www.nextvod.com.tw/" target="_blank">壹網樂</a>隨選視訊服務，但需要搭配網樂通機上盒。之前趁著機上盒免費申請（需運費）的期間去申請了一台機上盒，過了大概一個月左右終於寄來了，但直到現在才真正插上電源線，因為我的螢幕只有一台 orz 我還要用電腦。

在我的環境裡，第一個問題就是要怎麼讓機上盒上網，因為我宿舍的網路是自己架 Private AP ，讓 MacBook 透過 WiFi 連到學校的宿網，因為網路孔離電腦太遠我懶得牽線（欸）。所以這部網樂通機上盒也會遇到同樣的問題，即使它有乙太網路孔，AP 上面也有乙太網路孔，我還是沒有足夠長的線可以牽過去。這時候， Mac OS X 內建的 Internet 共享就可以派上用場了。

首先當然是去系統偏好設定→共享，把 Internet 共享打開，在打勾之前，先在右邊選擇共享連線來源為「AirPort」，而下方的「對使用以下傳輸埠的電腦」選擇「乙太網路」，接著回到左邊，把「Internet 共享」打勾，它會出現警告，按「啟動」就對了。

<a href="http://chitsaou.files.wordpress.com/2011/05/nextvod-lan-sharing-internet-sharing.png"><img class="alignnone size-full wp-image-1300" title="打開 Internet 共享，從 AirPort 到 Ethernet" src="http://chitsaou.files.wordpress.com/2011/05/nextvod-lan-sharing-internet-sharing.png" alt="" width="640" height="536" /></a>

然後就可以看電視了。

<span style="font-size:2em;color:red;font-weight:bold;">才怪！！</span>代誌當然不是像我這個憨人所想得這麼簡單！

網樂通機上盒一直不能連線到網際網路，所以只好試這招：自己設定 IP。

<!--more-->

首先打開你的「終端機」應用程式，懶得找的話可以在 Mac OS X 右上角的 Spotlight 輸入 Terminal 按下 Enter 便能啟動。接著輸入指令：

<blockquote><code>ifconfig</code></blockquote>

你會看到像下面這個畫面：

<a href="http://chitsaou.files.wordpress.com/2011/05/nextvod-lan-sharing-ifconfig.png"><img class="alignnone size-full wp-image-1301" title="執行 ifconfig 來找出你的乙太網路共享到哪裡去了" src="http://chitsaou.files.wordpress.com/2011/05/nextvod-lan-sharing-ifconfig.png" alt="" width="640" height="480" /></a>

首先你要找到開頭為 <code>en0</code> 的那一行，它下面有個 <code>inet 192.168.2.1</code> 的字樣，可能不同，但應該長得像 <code>192.168.x.x</code> 或 <code>10.x.x.x</code> 。接著你隨便選一個 2 ~ 253 的數字，我選 2，然後把原本 <code>192.168.2.1</code> 最後一個數字換掉，這樣就會得到 <code>192.168.2.2</code> 這個 IP。

接下來，進入網樂通的網路設定，選擇「乙太網路」→「手動設定 IP」，填入如下的資訊：
<ul>
	<li>IP 地址：<code>192.168.2.2</code></li>
	<li>子網路遮罩：<code>255.255.255.0</code></li>
	<li>通訊閘：<code>192.168.2.1</code> （就是剛剛 <code>inet</code> 字樣後面跟的 IP）</li>
	<li>網域名稱服務器一：<code>8.8.8.8</code> （這是 Google 的 DNS）</li>
</ul>
要注意的是，如果 <code>ifconfig</code> 出來的結果中， <code>inet 192.168.2.1</code> 那一行後面寫的 <code>netmask</code> 不是 <code>0xffffff00</code> ，則「子網路遮罩」這個欄位要填的東西會不太一樣，詳情請洽<a href="http://linux.vbird.org/problem/linux/problem_2.php">鳥哥</a>。

然後按下「連接網路」。
<a href="http://chitsaou.files.wordpress.com/2011/05/nextvod-mac-lan-sharing-settings.jpg"><img class="alignnone size-full wp-image-1299" title="在網樂通機上盒的設定" src="http://chitsaou.files.wordpress.com/2011/05/nextvod-mac-lan-sharing-settings.jpg" alt="" width="640" height="359" /></a>

網樂通連上網際網路以後，會檢查軟體更新，並且自動安裝新軟體。重新開機後，就看到了許多隨選視訊可以點，有的要付款，有的免費，要小心一點（？）。

然後就可以看電視了。

<span style="font-size:2em;color:red;font-weight:bold;">才怪！！</span>代誌當然不是像我這個憨人所想得這麼簡單！

雖然已經連上網際網路，但不能看電視，任何節目選擇以後都會在 1 分鐘內跳回原本的目錄，為什麼呢？根據剛才去電客服中心詢問的結果是，網樂通有使用到 P2P 的技術。

師大擋 P2P，所以看不到。

<span style="font-size:2em;color:olive;font-weight:bold;">◢▆▅▄▃崩╰(〒皿〒)╯潰▃▄▅▇◣</span>

有沒有擋 P2P 擋到合法用戶的八卦！！

所以我一個節目也沒有看，就把它收回盒子裡面了（默

等以後搬出去住再看吧 orz
