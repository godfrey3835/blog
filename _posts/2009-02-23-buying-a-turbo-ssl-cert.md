---
layout: post
title: "[筆記] SSL 憑證購買記"
published: true
date: 2009-02-23 00:00
tags: []
categories: []
comments: true

---

由於某些因素，我這次學會了怎麼購買 SSL 憑證。

你沒看錯，不是自己簽發，是<span style="font-size:2em;">購買憑證！購！買！憑！證！</span>

一開始以為憑證申購很麻煩又要花一大筆錢，但後來發現原來有 Turbo SSL Certificate 這種東西。簡單來說就是只要通過 Domain Control Validation (證明你具有控制該網域的權限，指的是向網域代理商購買的根網域，不是子網域)，那你就可以拿到一個「不會被瀏覽器叫」的憑證了。

不需要甚麼奇怪的管道，知名的網域名稱代理商<span style="text-decoration:line-through;">去你爸的</span> Go Daddy 就有賣了，<a href="http://www.godaddy.com/gdshop/ssl/ssl.asp?ci=9039">DM 在這裡</a>，左邊的「Standard SSL」就是了。

<!--more-->

---

先從 SSL 憑證說起好了

SSL 憑證在簽發的時候需要有一個根憑證，這個根憑證如果已經內建在作業系統或瀏覽器裡面，那就不會出現以下的畫面：

<a title="Flickr 上 chitsaou 的 error-ssl-cert-untrusted.png" href="http://www.flickr.com/photos/chitsaou/3303571910/"><img src="http://farm4.static.flickr.com/3582/3303571910_16d1625d64.jpg" alt="error-ssl-cert-untrusted.png" width="500" height="354" /></a>

---

當然，你自己簽發的 SSL 憑證一定都沒有那種內建在電腦裡的；我的意思是，自己簽的憑證一定會出現以上的畫面。當然你也可以<a href="http://webmail.ntnu.edu.tw/wmail/faq/iecert.htm">教使用者如何把根憑證加入他的電腦裡</a>，不過這種步驟對於一個跟電腦不熟的人，一定是一大挑戰。

(偷偷表一下師大計中ㄎㄎ)

現在如果你想花錢消災的話，除了購買貴桑桑的 Verisign 憑證之外 (台灣有代理，請 Google 一下「 Verisign 台灣」)，其實你還有別的選擇，那就是買一個 Turbo SSL Certificate。

貴桑桑的憑證到底差在哪裡呢？

你可以看一下國內知名網站的憑證，例如<a href="http://www.thsrc.com.tw/irs.html">台灣高鐵線上訂票系統</a>（或各大銀行）

<a title="Flickr 上 chitsaou 的 THSRC SSL Certificate" href="http://www.flickr.com/photos/chitsaou/3303580808/"><img src="http://farm4.static.flickr.com/3310/3303580808_71e7938124_o.png" alt="THSRC SSL Certificate" width="498" height="596" /></a>

你可以看到它裡面記載了很仔細的公司名稱資訊。

至於 Turbo 版的呢，給個例子，像是國內著名線上報名系統 <a href="https://registrano.com/">Registrano</a>：

<a title="Flickr 上 chitsaou 的 Registrano SSL Cert" href="http://www.flickr.com/photos/chitsaou/3303584806/"><img src="http://farm4.static.flickr.com/3483/3303584806_de050118a2_o.png" alt="Registrano SSL Cert" width="498" height="524" /></a>

差異在於裡面只有寫網域名稱。

但是，兩支憑證都是從大廠商的 SSL 根憑證簽發出來的，所以在大部份的現代主流瀏覽器都不會出現「憑證錯誤」的問題。

如果你的網站只想要讓這個「憑證錯誤」的訊息消失的話，那 Turbo SSL Cert 就是你要的。

Go Daddy 的 Standard SSL Certificate 報價是一年 29.99 美金，折合新臺幣約一千出頭，怎麼算都比花一萬多塊錢買個 VeriSign 的 Certificate 還便宜吧？

(老實說我也是看了 Registrano 的憑證才知道有這種東西)

---

首先當然是去 Go Daddy 的網站透過線上付款的方式購買 Standard SSL 這個產品。

刷卡完成後，大概要等五分鐘，你才會在<a href="https://mya.godaddy.com/">你的帳號頁</a>裡面看到有 SSL Certificate 這個產品。

進去之後就<a href="https://products.secureserver.net/products/howtoapplyturbo.htm">照著這個網頁的流程去走</a>，如果你要放的伺服器不是 Go Daddy 的 hosting，記得要選「Third-party Server」

在簽發 SSL 憑證之前有幾件事你要注意：
<ol>
	<li><span style="color:#ff0000;">請確定 Whois 記錄<span style="text-decoration:underline;">沒有設成 Private </span>，而且<span style="text-decoration:underline;">聯絡信箱</span>你可以存取</span>。Go Daddy 的域名認證是會<span style="color:#ff0000;">寄信到 Whois 的 Administrative Contact Email</span>，你一定要確定在你的 Whois 記錄裡面，這個欄位的 email 是你收得到的，不然你拿不到認證信。要查 Whois 記錄可以<a href="http://whois.domaintools.com/">在這裡查</a>。</li>
	<li><span style="color:#ff0000;">請準備好你的地址的英文翻譯</span>，在送出 CSR 的時候會用到。但是這些資料不會顯示在簽發給你的憑證裡面。</li>
	<li>在你的伺服器或電腦裡產生 CSR 檔案的時候，<span style="color:#ff0000;">Passphrase 一定要記住</span>，你可以打密碼，也可以隨便找一段文字來貼上，<span style="color:#ff0000;">但這一個字串一定要記住</span>，因為網頁伺服器在開啟憑證的時候會需要你輸入這個字串。</li>
	<li>產生 CSR 檔案的時候，<span style="color:#ff0000;">Common Name (CN) 一定要填寫你想簽署的網域名稱</span>。例如今天我要簽署這個 SSL  憑證給 secure.yorkxin.org，那我就要填 secure.yorkxin.org，絕對不要寫 Apache OpenSSL 程式叫你填的「My name」 -_-</li>
	<li>產生 CSR 過程中所使用的 <span style="color:#ff0000;">.</span><span style="color:#ff0000;">key 檔案不要丟掉</span>！</li>
</ol>
Apache 2.x 要製作 CSR 檔案的方法如下：（其實在申請 SSL 的頁面裡面就有說明了）
<blockquote><code>openssl genrsa -des3 -out ca.key 1024</code>
<code>openssl req  -new -key ca.key -out ca.csr</code></blockquote>
在上述的第二步，你需要輸入一堆資料，我之前寫的<a href="http://chitsaou.wordpress.com/2009/01/17/rails-ssl/">這篇文章</a>裡面有<a href="http://www.flickr.com/photos/chitsaou/3201032583/">一張圖</a>，參考著用。

---

整理步驟大概如下：
<ol>
	<li>刷卡買 Turbo SSL Certificate</li>
	<li>進入帳號頁面的 SSL Certificate 產品頁面，找找看哪裡有可以 Manage Certificates 的連結，按進去</li>
	<li>按下 Request Certificate 之類的連結</li>
	<li>填寫申請人資料，Email 欄位要填寫的是「收取憑證的 Email」</li>
	<li>產生一個 CSR 檔案，然後把檔案的內容貼到要你輸入 CSR 的欄位 (通常是最頭和最尾兩行有很多個等號 = ，然後中間一堆看起來是亂碼的東西。</li>
	<li>送出之後可能會確認資料，再用肉眼確認一次</li>
	<li>接著就等著收 Whois 記錄裡面 Administrative Email 的認證信，或是請網管協助。</li>
	<li>按一下認證信裡面的連結，完成 Domain Access Verification</li>
	<li>然後到你在申請人資料裡填寫的 email 裡面，會有一封信說網域認證已經過了，要你點擊連結，你就點吧。然後你要選擇這個憑證要放在哪一種伺服器裡面，有 Apache 2.x 可以選，或著你要用大硬的 IIS 就選 IIS。</li>
	<li>最後就可以拿到你的 SSL 憑證了。 Go Daddy 是寄到你的 email 裡面，一個 zip 檔案</li>
</ol>
這個 Zip 檔案解開來有兩個檔案 (例如我申請的是 secure.yorkxin.org)：
<ul>
	<li>secure.yorkxin.org.crt</li>
	<li>gd_bundle.crt</li>
</ul>
第一個是你的伺服器 SSL 憑證

第二個是中繼憑證 (Intermediate Certificate)

---

Apache 2 要設定 SSL 的方法如下：

先把你之前自己生出來的 ca.key 、廠商給你的 domain.com.crt (檔名依你的網域而有所不同) 、和 gd_bundle.crt 複製到主機上

在你的 ssl.conf 裡面（我是放在 Virtual Host 的設定裡面）寫這樣：
<blockquote><code>SSLCertificateFile /path/to/domain.com.crt</code>
<code>SSLCertificateKeyFile /path/to/ca.key</code>
<code>SSLCertificateChainFile /path/to/gd_bundle.crt</code></blockquote>
然後重新啟動 Apache (<code>/etc/init.d/apache2 restart</code> 或其他類似指令)，會<span style="color:#ff0000;">要你輸入當初產生 ca.key 的時候使用的 Passphrase</span> （所以才叫你不要忘記啊 XD），打上去就可以啟動了。...如果忘了的話...ㄎㄎ

---

心得：憑證這麼便宜為什麼一堆單位都偷懶自己簽發呢？而且買 Wildcard 的憑證還有優惠ㄟ！

Update:

心得 2 ：<span style="color:#ff6600;"><strong>具備 SSL  的網站也不是一定就可信的</strong></span>，你看投資 1000 台票就有這種東西了...
