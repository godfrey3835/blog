---
layout: post
title: "[亂來] 智慧晶片讀卡機 EZ100PU"
published: true
date: 2009-02-13 00:00
tags: []
categories: []
comments: true

---

<span style="color:#999999;">揭露：這篇我真的沒有拿錢打廣告。</span>

<span style="color:#ff0000;">警告：<span style="text-decoration:underline;"><strong>本文是標準的外行看熱鬧</strong></span>，您在本文<span style="text-decoration:underline;">無法</span>取得任何關於智慧型晶片卡 (Smart Card) 或與PC/SC 規範相關的技術知識。</span>

為了使用某些網站上的 IC 晶片服務 (e.g. <a href="http://www.icash.com.tw/checkpoint.asp">iCash 餘額查詢</a>、<a href="https://webatm.post.gov.tw/">郵局網路 ATM</a>、<a href="http://moica.nat.gov.tw/html/index.htm">內政部自然人憑證</a>，以及其他)，我決定去買一台簡單的智慧卡讀卡機。

當然，「Windows Only」這件事已經沒甚麼好驚訝了，這年頭政府的網站都嘛 Windows IE Only，沒甚麼好稀奇；早就寄生了一個 Windows XP 在 OS X 裡面了 (ㄎㄎ)

我買的是這一台：<a href="http://www.casauto.com.tw/in-products-03.aspx?id=P_00000001&amp;cid=C_00000001&amp;pname=EZ100系列&amp;cname=PC%2fSC外接型晶片卡讀卡機">EZ100PU</a>。就我所知台灣師範大學也是用這台（為甚麼我知道？因為我看過啊 = = ）。

<!--more-->

插上去然後安裝 Windows 的驅動程式就行了。如果你發現不能使用，說什麼「服務未啟動」或「找不到讀卡機」之類的，試試到「控制台」→「系統管理工具」→「服務」，找一個 Smart Card 的服務，把它設定為「自動」，並按一下「啟動」。

包裝裡除了本來就該有的讀卡機之外，還有 SIM 卡的轉卡（讓你可以插 SIM 卡上去），雖然有轉卡，但你會發現內附光碟的安裝程式提示你「只有 EZ100 Mini 才能使用 SIM 讀寫程式」...。沒關係，其實官網已經有新版可以抓了，<a href="http://www.casauto.com.tw/in-download-02.aspx?wcid=C_00000003&amp;id=P_00000001&amp;cid=C_00000001">來這裡下載</a>「電話簿編輯程式」...。

---

<a href="http://www.casauto.com.tw/in-download-02.aspx?wcid=C_00000003&amp;id=P_00000001&amp;cid=C_00000001">官網提供的工具下載</a>其實蠻多元的 (沒有照順序)：
<ol>
	<li><strong>電話簿編輯程式</strong> (2008102717204657952.exe)<br />
- 就是 SIM 卡編輯程式，可以讓你編輯 SIM 卡的 PIN1 、通訊錄和簡訊（兩者包括匯入匯出） 。不過別忘了「<span style="text-decoration:underline;">只有儲存在 SIM 裡面的資料才能讀取</span>」</li>
	<li><strong>電子錢包讀取程式</strong> (2008102717204630195.exe)<br />
- 這個就很厲害，等等說明</li>
	<li><strong>健保卡讀卡程式</strong> (2008102717204628957.exe)<br />
- 這個實際上不能用，不用理它。其實讀健保卡可以用 2. 那支程式</li>
	<li><strong>安裝檢測程式</strong> (2008102717204653343.exe)<br />
- 隨附光碟裡面就有了</li>
	<li><strong>IC 卡工具程式</strong> (2008102717204670555.exe)<br />
- 這個是工程師在用的，一般來說不會用到。</li>
</ol>
以上全都是 WinRAR 自解壓縮檔，當然你也可以用 WinRAR 解壓縮。除了 IC 卡工具程式是安裝程式之外，其他全都是可以獨立執行的。

---

來介紹一下<span style="color:#ff0000;"><strong>電子錢包讀取程式</strong></span>...這個很厲害

解壓縮開來是一個名叫「ICC Utility v1.2」的資料夾，執行裡面的「IC_Card_Utility.exe」就行了。

它的功能如下↓
<p style="text-align:center;"><a title="Flickr 上 chitsaou 的 IC Card Utility - EZ100PU et al." href="http://www.flickr.com/photos/chitsaou/3276744018/"><img class="aligncenter" src="http://farm4.static.flickr.com/3386/3276744018_bae3f94a61.jpg" alt="IC Card Utility - EZ100PU et al." width="500" height="326" /></a>

<ol>
	<li>iCash / iCash <span style="text-decoration:line-through;">波™</span> Wave  餘額查詢 (這個到<a href="http://www.icash.com.tw/checkpoint.asp"> iCash 官網</a>可以查到很多資訊)</li>
	<li>健保卡查詢，包括<span style="text-decoration:underline;">就醫剩餘次數</span>（我不知道是甚麼意思）</li>
	<li>電子收費 ETC，這個我（當然）沒有卡，所以沒得試</li>
	<li>中油便捷卡（同上）</li>
	<li><a href="http://www.mastercard.com/tw/personal/zh/findacard/prepaid_card.html">MasterCard Cash</a> → 這個我有</li>
</ol>
為甚麼說我有  MasterCard Cash 呢？當然我年紀這麼小（未滿 20）是不可能去申請那個甚麼神奇的卡，我擁有的是這個↓
<p style="text-align:center;"><a title="Flickr 上 chitsaou 的 TaiwanMoney 卡實物近照" href="http://www.flickr.com/photos/chitsaou/393570440/"><img class="aligncenter" src="http://farm1.static.flickr.com/180/393570440_3d2a606668.jpg" alt="TaiwanMoney 卡實物近照" width="500" height="375" /></a>
這叫 TaiwanMoney 卡。反正是在南部<del datetime="00">國</del>七縣市通行的 RFID 非接觸式交通票證，在高雄捷運一卡通上市之前，這玩意兒可是稱霸南台灣的，我到現在還是拿它搭<a href="http://ebus.tncg.gov.tw">台南市公車</a>，因為有優惠<span style="text-decoration:line-through;"> + 不想拿零錢</span>（2 小時內轉乘半價，可累計，甚至台南刷完兩小時內到高雄刷公車也有半價...），不過拿來搭高捷可是相當崩潰，除了感應慢之外，還得要走一個奇怪的公務門，而且優惠條件還跟一卡通不一樣...…。這張卡的細節可以去<a href="http://www.taiwanmoney.com.tw/">官網</a>看。

反正這張卡說穿了也是 MasterCard Cash-compatible 的（它右下角不就寫了），所以直接插進去，然後按一下程式的「MCASH卡」標籤，再按「讀取」，<strong>欸還真的可以耶</strong>！
<p style="text-align:center;"><a title="Flickr 上 chitsaou 的 EZ100PU reads TaiwanMoney" href="http://www.flickr.com/photos/chitsaou/3275949591/"><img class="aligncenter" src="http://farm4.static.flickr.com/3489/3275949591_86be6ae445.jpg" alt="EZ100PU reads TaiwanMoney" width="500" height="324" /></a>
所以你不用再跑去玉山銀行 或國泰世華銀行 或高雄客運 或興南客運查詢餘額了...。

<span style="text-decoration:line-through;">我比較好奇的是，為甚麼 MasterCard Cash 的網站上沒有查詢的功能...</span>

update: <a href="http://www.esunbank.com.tw/credit/MCC_index.aspx">玉山銀行可以查詢</a>，剛剛在 PTT 捷運板某人分享的。可是...你不覺得查詢出來的記錄很奇怪嗎？（裡面那個 iFrame 是 SSL 安全加密連線的）
<p style="text-align:center;"><a title="Flickr 上 chitsaou 的 玉山銀行 MasterCard Cash (TaiwanMoney) 查詢" href="http://www.flickr.com/photos/chitsaou/3276490145/"><img class="aligncenter" src="http://farm4.static.flickr.com/3528/3276490145_e339af7458.jpg" alt="玉山銀行 MasterCard Cash (TaiwanMoney) 查詢" width="407" height="500" /></a>
除此之外，還有更神奇的。為什麼健保 IC 卡要查詢個人資料和就醫記錄（健保局網站），<strong>竟然要用自然人憑證勒</strong>！？我還沒有自然人憑證，所以就沒試了。

---

<a href="https://webatm.post.gov.tw/">郵局的網路 ATM</a> 你有晶片金融卡的話可以直接用，可以查詢存簿餘額、未補摺細目、未補摺次數（原來未補摺細目超過某種數量，就會把你的金融卡停掉）和轉帳；當然不能提款...…。至於跨行轉帳的手續費多少，其實我還沒查明，不過應該會比實體 ATM 機器還要低...？

神奇的是，郵局的網路 ATM 輸入密碼的地方，除了要用滑鼠點之外，它的<strong><span style="color:#ff6600;">按鍵位置竟然還會洗牌</span></strong> XD 我是不知道這樣比較安全的意思是在哪裡啦？
<p style="text-align:center;"><a title="Flickr 上 chitsaou 的 �華郵政 WebATM 鍵盤洗牌" href="http://www.flickr.com/photos/chitsaou/3275974671/"><img class="aligncenter" src="http://farm4.static.flickr.com/3312/3275974671_5d9dd3b79d.jpg" alt="�華郵政 WebATM 鍵盤洗牌" width="500" height="421" /></a>
---

最強的是

這隻讀卡機
<p style="text-align:center;"><span style="color:#339966;"><strong>竟然有 Mac 版驅動程式！</strong></span>
<p style="text-align:center;"><span style="color:#0000ff;"><strong>竟然有 Mac 版驅動程式！！</strong></span>

<div>
<p style="text-align:center;"><span style="color:#ff0000;"><strong>竟然有 Mac 版驅動程式！！！</strong></span>
我真的不是在唬人，<a href="http://www.casauto.com.tw/in-download-02.aspx?wcid=C_00000006&amp;id=P_00000001&amp;cid=C_00000001">官方網站就有得抓了</a>，抓下來之後是一個 gz 檔，你的 Safari  應該會自動解壓縮，然後出現一個名叫「2008122218204253343」的二進位檔，這時候請把它改名為「<code>xxx.tar</code>」，再按兩下（或 <code>tar xf xxx.tar</code> ）把它解開來...你就得到它了
<p style="text-align:center;"><a title="Flickr 上 chitsaou 的 EZ100PU Mac OS X Universal Driver" href="http://www.flickr.com/photos/chitsaou/3276808754/"><img class="aligncenter" src="http://farm4.static.flickr.com/3312/3276808754_e89bc3d82c.jpg" alt="EZ100PU Mac OS X Universal Driver" width="500" height="311" /></a>
按兩下「<code>ezusb_setup</code>」就可以安裝了，這是一個 Mac OS X 10.4 的 pkg ，不過 10.5 也可以用。</div>

接著要怎麼使用呢？

其實也沒甚麼好玩的...事實上它只提供了一個測試程式，使用方法是直接在終端機裡執行它，但在這之前要先以 <code>root</code> 權限啟動 <code>pcscd</code> 這支程式：
<blockquote><code>sudo pcscd</code></blockquote>
接著讀卡機應該會閃紅燈。

使用測試程式的方法很簡單，在你解壓縮的路徑底下執行：
<blockquote><code>./mifdtest/mifdtest</code></blockquote>
會出現以下畫面：
<p style="text-align:center;"><a title="Flickr 上 chitsaou 的 EZ100PU Mac OS X Test Utility Loaded" href="http://www.flickr.com/photos/chitsaou/3276826282/"><img class="aligncenter" src="http://farm4.static.flickr.com/3463/3276826282_baf96b00ef.jpg" alt="EZ100PU Mac OS X Test Utility Loaded" width="500" height="170" /></a>
然後會進行一系列測試（其實也三個），例如插拔偵測測試，照著它的指示，插拔卡片。如果執行測試程式前就已經先插上卡，那不會顯示「<code>&lt;&lt; Please insert card</code>」那一行：
<p style="text-align:center;"><a title="Flickr 上 chitsaou 的 EZ100PU Mac OS X Test Utility Part A" href="http://www.flickr.com/photos/chitsaou/3276007297/"><img class="aligncenter" src="http://farm4.static.flickr.com/3315/3276007297_495d32066f.jpg" alt="EZ100PU Mac OS X Test Utility Part A" width="500" height="234" /></a>
接著是連線測試和... Transmit 測試？
<p style="text-align:center;"><a title="Flickr 上 chitsaou 的 EZ100PU Mac OS X Test Utility Part B and C" href="http://www.flickr.com/photos/chitsaou/3276826944/"><img class="aligncenter" src="http://farm4.static.flickr.com/3489/3276826944_beb76b2aea.jpg" alt="EZ100PU Mac OS X Test Utility Part B and C" width="500" height="285" /></a>
以上測試是插 iCash 的。我插 TaiwanMoney  就不會進入第三步。

要關掉 daemon 的話就是
<blockquote><code>sudo killall pcscd</code></blockquote>
除了 <code>mifdtest</code> 之外，安裝到系統的還有 <code>pcsctest</code> 和 <code>pcsctool</code>，以及剛剛講過的 <code>pcscd</code> 這隻 daemon。實際執行之後老實說我不知道 <code>pcsctest</code> 和 <code>pcsctool</code> 是在幹嘛的，我對 Smart Card 其實也不懂。

我想這個 Mac OS X 驅動程式，只是工程師拿來測試的... XD

官網也有提供 Linux 版的驅動 (2008 年 11 月 26 日)，而且下載回來竟然有 mifdtest 的原始碼 (C 語言) ......不知道有沒有勇者要玩玩看？

---

最後來講一個有趣的東西

官方網站上提供了<a href="http://www.casauto.com.tw/in-download-02.aspx?wcid=C_00000004&amp;id=P_00000001&amp;cid=C_00000001">SDK 下載</a> (Software Development Kit，簡單來說就是可以給你寫程式控制這台讀卡機的東西），下載回來裡面除了有 Windows 的 API (VC++、Borland C++，包括一個已編譯好的 DLL)，還有 Linux 的 API (也有一個已編譯好的 .so 檔)，兩者皆包含範例程式以及函式庫標頭檔  (include/*.h)，以及兩本厚厚的 API Document (PDF)。

上網查了一下，我現在知道這種晶片卡的規格叫作「<a href="http://en.wikipedia.org/wiki/PC/SC">PC/SC</a>」，它在 Windows 2000 以後已經成為系統內建服務，而 Open-source 的 implementation 叫作 <a href="http://pcsclite.alioth.debian.org/">PC/SC Lite</a>，根據維基百科的說法，支援 Linux 及 Mac OS X。

這隻 EZ100PU 官網上發佈的 SDK 裡，Linux 版本也是以 PC/SC Lite 寫出來的，Mac OS X 的驅動程式，根據 pcsctest 這支程式的描述（寫道 "<a href="http://pcsclite.alioth.debian.org/pcsc-lite/">MUSCLE PC/SC Lite</a> Test Program"），也是 PC/SC Lite 的成品。

所以說到底，根本沒有什麼「只有 Windows 可以用智慧晶片卡」的理論，而是「寫應用程式的只會寫 Windows 的版本」

換句話說，這是<span style="color:#ff0000;">政府單位、銀行機關聘用的程式設計師功力不足的問題</span>。

試想，API 都擺在那裡給你用了，為甚麼沒有任何一個單位肯撥出人力來寫 Linux 、 Mac OS X 版本的應用程式呢？

通常你打客服去幹譙，得到的答案都是「我們以多數人為主」、「Mac 和 Linux 我們不支援，請使用 Windows 與 IE」 blahblah。

我對 Linux / OS X  硬體層的程式設計不懂，但我不認為，當有人餵給你 API 的時候，擁有足夠能力的人會寫不出來。

所以更深一層說，這是主管單位的心態問題：<span style="color:#ff0000;">不想多花人力（$）在其他作業系統上，所以乾脆裝作沒看到</span>，省時省力又可以打太極。

---

當然這年頭在台灣，你在非 Windows 的環境就只能認命一點，有些東西（包括政府或學校提供的服務）並不是如你想像的那麼美好，即使你根本就知道它可以很美好（例如一個 IE-only 的校務網頁，或是一個 <a href="http://course.ntnu.edu.tw/course">Windows-only 的選課系統</a>…）

---

話說回來，我其實很期待這家廠商會搞出一個 Mac OS X 的解決方案... 不管是提供一個 API 讓程式設計師可以寫出 Linux / OS X 版本的應用程式（Java 是一個可能性？），或是針對自家產品做更進一步的演化（把你們家的 ICC Utility 搬到 OS X 如何？）。我想既然他們做了 Linux 和 OS X 的驅動程式，就表示它們至少有在實驗這些東西。

不過，又不是只有他們提供 Linux / OS X 的驅動程式啊... (一時不知道還有哪些廠商)

<strong>update 2009/12/25</strong>: 沒想到<a href="https://netbank.esunbank.com.tw/webatm/Q&amp;A_017.htm">玉山銀行竟然開發了 Mac OS X 專用的 WebATM Plug-in</a> ！<strong>非常 GOOD JOB!</strong>!!!!


