---
layout: post
title: "[教學] 如何使用 Windows 正版嘸蝦米製作超強版嘸蝦米 CIN 檔 (用於 GCIN 、OpenVanilla 或 Yahoo! 輸入法)"
published: true
date: 2009-01-11 00:00
tags: []
categories: []
comments: true

---
**Update** 2014/02: 推薦改用鼠鬚管，請參考我新寫的〈[在鼠鬚管 (Squirrel) 使用嘸蝦米](http://blog.yorkxin.org/posts/2013/12/10/use-boshiamy-in-squirrel)〉。

看到這篇的標題，一定要先來個 Q&amp;A：

<h2>問：<a href="http://boshiamy.com">嘸蝦米</a>都有官方版的 <a href="http://www.boshiamy.com/download.html#mactrial">Mac Version </a>也有官方版的 <a href="http://www.boshiamy.com/member_download.php">gcin/scim 表格</a>，這篇是在教啥？</h2>
答：

官方版完全與 Windows 版相同，包括「<strong>選字框內同時只能出現一種 Variant 的漢字</strong>」這件事，如下圖 (以下是嘸蝦米 for Mac X1 版的抓圖)：

<a title="Flickr 上 chitsaou 的 demo-boshiamy-kanzi-variants.png" href="http://www.flickr.com/photos/chitsaou/3185737301/"><img src="http://farm4.static.flickr.com/3370/3185737301_d9064a083a.jpg" alt="demo-boshiamy-kanzi-variants.png" width="500" height="264" /></a>

如果你想做到下圖這件事，那這篇文章就是你要的：

<a title="Flickr 上 chitsaou 的 boshiamy-hyper.png" href="http://www.flickr.com/photos/chitsaou/3187039030/"><img src="http://farm4.static.flickr.com/3375/3187039030_8365069629_o.png" alt="boshiamy-hyper.png" width="261" height="96" /></a>

當然前提是，這幾個字的嘸蝦米字根要一樣。
<h2>問：何謂「超強」？</h2>
答：嘸蝦米標準版漢字 + <a href="http://zh.wikipedia.org/wiki/%E4%B8%AD%E6%97%A5%E9%9F%93%E7%B5%B1%E4%B8%80%E8%A1%A8%E6%84%8F%E6%96%87%E5%AD%97#.E6.93.B4.E5.B1.95A.E5.8D.80">Unicode Ext-A/Ext-B 擴展區漢字</a> (一部份)
<h2><span style="font-weight:normal;">問：這</span>是盜版嗎？</h2>
答：我不知道，但你不能跟我要表格檔。你要有<strong>嘸蝦米 Windows 標準版</strong>才能這樣搞。
<h2>問：還有什麼要注意的？</h2>
答：

在同一個選字框裡出現所有漢字寫法的候選字，這在某方面是優點，也是缺點。

基本上<strong>除了繁體中文之外</strong>，它的選字模式是不符合嘸蝦米正常使用規則的；全部都塞在一起怎麼會跟分開來放一樣？

<span style="color:#ff0000;"><strong>建議初學者不要用</strong></span>。

另外，本文生產出的 CIN 檔，並<span style="color:#ff0000;">無法輸入</span>所有存在 liu.box 裡的 Unicode CJK Extension 漢字。具體原因我不清楚。

---

如果以上都沒問題的話，那正式來咯。

<!--more-->

你需要的東西：
<h2>嘸蝦米輸入法標準版 for Microsoft Windows</h2>
請向<a href="http://www.boshiamy.com">行易有限公司</a>購買。
<h2><span style="font-weight:normal;">一</span>個 Unix-like 的環境</h2>
不管是 Mac OS X 、FreeBSD、Linux 、還是你要在 Windows 裡弄一個 <a href="http://www.cygwin.com/">cygwin</a> 都行。
<h2>所以你還要有基本的 Unix-like 命令列指令操作概念。</h2>
不過，既然你都找到這篇文章，我假設你已經有這些基本概念了。
<h2><span style="font-weight:normal;">最</span>後你必須要有支援 Unicode Ext-A/Ext-B 漢字的字型</h2>
不然你加了那些擴充區的漢字，打得出來看不到有什麼用 = =

不過基本上 Ext-A 在大部份的 Unicode 字型都有了，問題大多出在 Ext-B

你有以下這些管道可以取得：
<ol>
	<li>自 Windows Vista 或 Windows 7 取得新版的新細明體 ExtB，但這是不合法的。</li>
	<li>在 Windows XP 安裝新細明體更新套件 (官方載點不見了，有<a href="http://blog.chweng.idv.tw/archives/221">低調宅點</a>) ，然後複製到你的作業系統。當然這也是不合法的。</li>
	<li><a href="http://sourceforge.net/project/showfiles.php?group_id=153105&amp;package_id=172061">下載自由授權的 HAN NOM 漢字字型</a>。請選擇 hannomH.zip，它可以直接安裝在 Mac OS X (字體簿) 或 Xwindow。號稱收集了 Ext-A 和 Ext-B 的字型，雖然看起來有點怪，但將就點用也不是不行。<a href="http://www.opendesktop.org.tw/modules/newbb/viewtopic.php?post_id=1083">細節請看這裡</a>。</li>
</ol>
---
<h2>操作方式</h2>
基本上，是從<a href="http://cle.linux.org.tw/trac/wiki/GcinInstallBoshiamy">這篇 GCIN 官方網站上的說明</a>延伸而來的。我的需求是在 <a href="http://tw.download.yahoo.com/keykey/">Yahoo! 奇摩輸入法</a>安裝超強嘸蝦米表格檔，而不是在 Linux 的 GCIN 使用；不過，產生出來的東西拿到 GCIN 也能用就是了。
<h2>首先你要取得 Windows 版的表格檔</h2>
很簡單，如果你已經在 Windows 安裝了嘸蝦米，它就在 C:\Windows\System32\ 裡面的以下四個檔案：

<a title="Flickr 上 chitsaou 的 find-boshiamy-windows-tabs.png" href="http://www.flickr.com/photos/chitsaou/3186607314/"><img src="http://farm4.static.flickr.com/3438/3186607314_62ee0eb370_o.png" alt="find-boshiamy-windows-tabs.png" width="624" height="465" /></a>

問：如果我沒有 Windows 呢？

答：那表示您高人一等，請直接閱讀上述<a href="http://cle.linux.org.tw/trac/wiki/GcinInstallBoshiamy">這篇 GCIN 官方網站上的說明</a>，以 WINE 的方式模擬安裝嘸蝦米。反正搞到這四個檔案就行了。
<h2>拿到哪裡呢？</h2>
請一併複製到同一個資料夾，並<a href="http://cle.linux.org.tw/trac/attachment/wiki/GcinInstallBoshiamy/uni2txt.exe?format=raw">下載 GCIN 同好會提供的 uni2txt.exe</a> ，也放到同一個資料夾，像這樣：

<a title="Flickr 上 chitsaou 的 tabs-and-converter.png" href="http://www.flickr.com/photos/chitsaou/3185798621/"><img src="http://farm4.static.flickr.com/3298/3185798621_ecd124c21b_o.png" alt="tabs-and-converter.png" width="542" height="420" /></a>

然後開啟命令提示字元，cd 到你所放的資料夾，接著連續執行以下四則指令：

<pre>uni2txt.exe liu-uni.tab liu-uni.txt
uni2txt.exe liu-uni2.tab liu-uni2.txt
uni2txt.exe liu-uni3.tab liu-uni3.txt
uni2txt.exe liu-uni4.tab liu-uni4.txt</pre>

如下圖：

<a title="Flickr 上 chitsaou 的 convert-tab-to-text-process.png" href="http://www.flickr.com/photos/chitsaou/3185798567/"><img src="http://farm4.static.flickr.com/3301/3185798567_25eb46d2af_o.png" alt="convert-tab-to-text-process.png" width="685" height="631" /></a>

接著你應該會多得到四個檔案：

<a title="Flickr 上 chitsaou 的 tabs-and-texts-after-convertion.png" href="http://www.flickr.com/photos/chitsaou/3186639478/"><img src="http://farm4.static.flickr.com/3322/3186639478_ecfd1e321c_o.png" alt="tabs-and-texts-after-convertion.png" width="543" height="423" /></a>

這裡我們需要做一點額外的工作，這是 GCIN 同好會網站上該篇原文所未提及的。

不知道是不是 7.0 的格式有變，總之這樣轉出來的 txt 檔案，前面會有一大段是垃圾內容，特色是前面都多了一個空格，例如這樣：

<a title="Flickr 上 chitsaou 的 liu-uni-errors.png" href="http://www.flickr.com/photos/chitsaou/3186116943/"><img src="http://farm4.static.flickr.com/3093/3186116943_6024dce8e1_o.png" alt="liu-uni-errors.png" width="366" height="396" /></a>

把這些部份刪掉，空行也要刪掉。像這樣：

<a title="Flickr 上 chitsaou 的 liu-uni2-errors.png" href="http://www.flickr.com/photos/chitsaou/3186117023/"><img src="http://farm4.static.flickr.com/3387/3186117023_e2e7f6c756_o.png" alt="liu-uni2-errors.png" width="365" height="395" /></a>

<code>liu-uni.txt</code>, <code>liu-uni2.txt</code>, <code>liu-uni3.txt</code> 各有 1 行錯誤。而<span style="color:#ff0000;"> </span><code><span style="color:#ff0000;">liu-uni4.txt</span></code><span style="color:#ff0000;"> 則有很多行錯誤</span>，捲軸往下拉，找到 <code><span style="color:#ff0000;">a 対 *+</span></code><span style="color:#ff0000;"> </span>這一行 (會有很明顯的「斷層」，有錯誤的行前面會多一個空格)：

<a title="Flickr 上 chitsaou 的 liu-uni4-errors.png" href="http://www.flickr.com/photos/chitsaou/3186958934/"><img src="http://farm4.static.flickr.com/3461/3186958934_34b79b17fd_o.png" alt="liu-uni4-errors.png" width="364" height="395" /></a>

把空格開頭的行統統刪掉，像這樣：

<a title="Flickr 上 chitsaou 的 liu-uni4-correct.png" href="http://www.flickr.com/photos/chitsaou/3186958902/"><img src="http://farm4.static.flickr.com/3497/3186958902_a2332fcaf2_o.png" alt="liu-uni4-correct.png" width="366" height="395" /></a>

就可以了，記得存檔。

問：如果我沒有 Windows 呢？

答：那表示您高人一等，請直接閱讀上述<a href="http://cle.linux.org.tw/trac/wiki/GcinInstallBoshiamy">這篇 GCIN 官方網站上的說明</a>，以 WINE 的方式模擬執行這支程式。反正搞出這四個檔案就行了。

---
<h2>接下來要轉成 CIN 囉</h2>
把這四個檔案移動 (複製-貼上) 到你的 Unix-like 環境裡。以下以 Mac OS X 為範例：

<a title="Flickr 上 chitsaou 的 texts-and-converter.png" href="http://www.flickr.com/photos/chitsaou/3186190583/"><img src="http://farm4.static.flickr.com/3264/3186190583_dbac202bd8.jpg" alt="texts-and-converter.png" width="500" height="469" /></a>

先下載以下五個檔案，與 liu-uni*.txt 放在同一個目錄：

<ol>
	<li><a href="http://cle.linux.org.tw/trac/attachment/wiki/GcinInstallBoshiamy/uni2txt.sh?format=raw"><code>uni2txt.sh</code></a></li>
	<li><a href="http://cle.linux.org.tw/trac/attachment/wiki/GcinInstallBoshiamy/liu-uni.vrsf?format=raw"><code>liu-uni.tab</code> 的 <code>vrsf</code> 選字</a></li>
	<li><a href="http://cle.linux.org.tw/trac/attachment/wiki/GcinInstallBoshiamy/liu-uni2.vrsf?format=raw"><code>liu-uni2.tab</code> 的 <code>vrsf</code> 選字</a></li>
	<li><a href="http://cle.linux.org.tw/trac/attachment/wiki/GcinInstallBoshiamy/liu-uni3.vrsf?format=raw"><code>liu-uni3.tab</code> 的 <code>vrsf</code> 選字</a></li>
	<li><a href="http://cle.linux.org.tw/trac/attachment/wiki/GcinInstallBoshiamy/liu-uni4.vrsf?format=raw"><code>liu-uni4.tab</code> 的 <code>vrsf</code> 選字</a></li>
</ol>

但先別急著執行，要修改一下。使用文字編輯器開啟 <code>uni2txt.sh</code> ，然後把下面這四行<span style="color:#ff0000;">註解掉</span> (在行首加 #) (內行的應該知道這四行在幹嘛)

<pre># wine ./uni2txt.exe liu-uni.tab liu-uni.txt
# wine ./uni2txt.exe liu-uni2.tab liu-uni2.txt
# wine ./uni2txt.exe liu-uni3.tab liu-uni3.txt
# wine ./uni2txt.exe liu-uni4.tab liu-uni4.txt
</pre>

接著當然是執行啊！

<pre>sh uni2txt.sh</pre>

可能會出現以下四行錯誤，但是不用理它

<pre>uni2txt.sh: line 18: gcin2tab: command not found
uni2txt.sh: line 29: gcin2tab: command not found
uni2txt.sh: line 40: gcin2tab: command not found
uni2txt.sh: line 51: gcin2tab: command not found
</pre>

你會看到多了 8 個檔案：

<a title="Flickr 上 chitsaou 的 texts-and-cins-after-convertion.png" href="http://www.flickr.com/photos/chitsaou/3187031308/"><img src="http://farm4.static.flickr.com/3387/3187031308_81e4c5059d.jpg" alt="texts-and-cins-after-convertion.png" width="500" height="469" /></a>
 
<h2>把 Ext-A/Ext-B 的漢字加進來</h2>
嘸蝦米 7.0 標準版好像也不能輸入 Ext-A 和 Ext-B (其實我沒有全部試過)，所以要做以下的補完。

請<a href="http://liu.twbbs.org/liuzmd1/liu.box/">到這裡下載</a> Extension A/B 加字加詞檔的 liu.box 檔案，也放到同一個資料夾裡面。然後以文字編輯器開啟：

<a title="Flickr 上 chitsaou 的 liu-box-original.png" href="http://www.flickr.com/photos/chitsaou/3185894329/"><img src="http://farm4.static.flickr.com/3338/3185894329_8fec33bb6e.jpg" alt="liu-box-original.png" width="500" height="494" /></a>

刪掉最前面的檔頭，並把分號 <span style="color:#ff0000;"><code>;</code></span> 取代為<span style="color:#ff0000;">空的字串</span>，讓它看起來長得像這樣：

<a title="Flickr 上 chitsaou 的 liu-box-after-process.png" href="http://www.flickr.com/photos/chitsaou/3186735382/"><img src="http://farm4.static.flickr.com/3518/3186735382_5a6bec8c8e.jpg" alt="liu-box-after-process.png" width="500" height="346" /></a>

然後利用你的文字編輯器的功能，儲存成 <span style="color:#ff0000;"><strong>編碼為 UTF-8</strong></span>、而且<span style="color:#ff0000;"><strong>換行是 Unix (LF)</strong></span> 的檔案 (重要!!) (下圖是 <a href="http://www.barebones.com/products/TextWrangler/">TextWrangler</a> 的 Save As 對話方塊中，按下 Options 會出現的對話方塊，可以直接指定輸出的換行格式和編碼)

<a title="Flickr 上 chitsaou 的 liu-box-save-utf8-and-lf.png" href="http://www.flickr.com/photos/chitsaou/3186776732/"><img src="http://farm4.static.flickr.com/3500/3186776732_5a8f5b4a48_o.png" alt="liu-box-save-utf8-and-lf.png" width="452" height="222" /></a>

以下假設你把新的檔案儲存成 <code><span style="color:#339966;">liu-utf8.box</span></code><span style="color:#339966;"> </span>這個檔案。

問：我開起來亂碼

答：社群版的 liu.box 編碼是 UTF-16 Little-Endian，自己想辦法吧 ^.&lt; (Windows 記事本可以開)。Mac OS X 直接用 <a href="http://www.barebones.com/products/TextWrangler/">TextWrangler</a> 就可以正確辯識了。

<h2>最後重頭戲來啦! 合成超強表格檔!!</h2>

我們可以從 GCIN 同好會提供的<a href="http://cle.linux.org.tw/trac/wiki/GcinInstallBoshiamy">嘸蝦米字根表+補破網教學</a>，悟出如何合成出完整嘸蝦米 + Unicode Ext-A/Ext-B 的 CIN 表格檔的咒語，如下：

<pre>cat noseeing.cin liu-uni2.unix liu-uni3.unix liu-uni4.unix liu-utf8.box | perl -nle '(print,$hash{$_}=1) unless defined $hash{$_}' &gt; boshiamy-hyper.cin</pre>

是的，這樣你就得到<span style="color:#ff0000;"><strong> boshiamy-hyper.cin</strong></span> 這個檔案了。

---
<h2>生完了超強版 CIN 檔，怎麼裝？</h2>
Linux 我不知道，我現在用的 Mac OS X 只有裝 Yahoo! 奇摩輸入法和嘸蝦米 for Mac X1 (試用版，正式版我買了還沒寄到 XD)，所以以下是 Yahoo! 奇摩輸入法的安裝方法；其他的輸入法框架應該也有類似的方法可以安裝：

首先，把 <code>boshiamy-hyper.cin</code> 複製到 <code>~/Library/Application Support/Yahoo! KeyKey/DataTables/Generic</code>

然後，登出 Mac OS X，再登入。

接著你可以在 Yahoo! 奇摩輸入法的偏好設定裡看到「liu」這個選項：

<a title="Flickr 上 chitsaou 的 liu-in-yahoo-keykey.png" href="http://www.flickr.com/photos/chitsaou/3187039092/"><img src="http://farm4.static.flickr.com/3489/3187039092_fee925ed84.jpg" alt="liu-in-yahoo-keykey.png" width="454" height="500" /></a>

先打勾起來。然後在 Generic 分頁設定如下，比較接近在 Windows 使用嘸蝦米的習慣：

<a title="Flickr 上 chitsaou 的 liu-settings-in-yahoo-keykey.png" href="http://www.flickr.com/photos/chitsaou/3186198433/"><img src="http://farm4.static.flickr.com/3522/3186198433_27db1a4065_o.png" alt="liu-settings-in-yahoo-keykey.png" width="489" height="448" /></a>

這樣就完成了。

---

問：有些 Unicode CJK Extension 的漢字我打不出來

答：我也打不出來，明明在字根表裡面卻打不出來 = =
