---
layout: post
title: "大量轉換 iTunes 歌曲名稱的繁簡體中文的 AppleScript"
published: true
date: 2008-12-30 00:00
tags: []
categories: []
redirect_from: /posts/2008/12/30/scpt-to-convert-zh-hans-and-hant-for-itunes
comments: true

---

是否曾經煩惱看不習慣 iTunes 裡顯示的曲目名稱是你看不懂的中文字體呢？例如你購買了一張大陸歌手的專輯，但 iTunes 抓到的曲目名稱是你所不習慣的簡體中文。Windows 有 <a href="http://alf-li.pcdiscuss.com/c_convertz.html">ConvertZ</a> 可以做到這件事，但 Mac OS X 可不能執行 ConvertZ 啊。

雖然我們知道在 Mac OS X 的「服務」功能表裡面，有「<a href="http://docs.info.apple.com/article.html?path=Mac/10.5/yh/8951.html">中文字轉換程式</a>」，可以把中文在簡體和繁體之間轉換，但僅適用於可以反白選擇的文字範圍，就算你在 iTunes 裡選擇曲目，再執行 iTunes 功能表 → 服務 → 中文字轉換程式 → 轉換所選的簡體中文文字，但你會發現，IT DOES NOT WORK AT ALL!

一首一首改？你有更好的工具。

---

<!--more-->
<h2>必備的工具及條件</h2>
<ul>
	<li>終端機軟體。<br />
可以使用內建的終端機 (位在 應用程式 → 系統工具 → 終端機)，或使用開放原始碼的 <a href="http://iterm.sf.net">iTerm</a>。</li>
	<li><a href="http://macports.org">MacPorts</a> 套件管理系統。<br />
可以在<a href="http://www.macports.org/install.php">這裡</a>下載安裝，選擇 dmg 格式；在安裝之前，你要先安裝 <a href="http://developer.apple.com/tools/xcode/">Xcode</a>。</li>
	<li>你的帳號要有<span style="color:#ff0000;">系統管理員</span>的權限。</li>
	<li>要轉換的歌曲名稱<span style="color:#ff0000;">必須是 UTF-8 編碼</span>
也就是你在 iTunes 看到的曲目名稱不可以是亂碼。你可以使用 <a href="http://www.sinomac.com/ID3Mod/">ID3MOD2</a> 來進行編碼更正。</li>
</ul>
下文所提及的「指令」都是在終端機軟體裡面操作的。
<h2>安裝 zh-autoconvert (libhz)</h2>
首先請下載並安裝 zh-autoconvert (libhz)，這是一套可以在 BIG5 和 GB2312 編碼之間轉換的程式，轉換的同時還會自動轉換繁體和簡體。MacPorts 並沒有這套程式，<a href="http://code.google.com/p/libhz/">官方網站</a>上提供的 Tarball (<code>.tar.gz</code>) 解開來直接 <code>make</code> 編譯卻會發生編譯錯誤，所以只好抓 SCM 上面的原始碼回來編譯。不過 libhz 使用的 SCM 是 <a href="http://git.or.cz/">git</a>，所以在抓回原始碼之前，要先透過 MacPorts 安裝 git：
<blockquote><code>sudo port install git-core</code></blockquote>
安裝的時間隨電腦硬體能力而異 (因為 MacPorts 安裝的軟體是要從頭開始編譯的)。

裝完了就可以透過 git 來取得 libhz 的原始碼：
<blockquote><code>git clone git://gitorious.org/libhz/mainline.git</code></blockquote>
接著你應該會在目前路徑裡看到一個名為 mainline 的資料夾，切換進去：
<blockquote><code>cd mainline</code></blockquote>
然後打入以下指令來編譯並安裝 libhz：
<blockquote><code>./autogen.sh<br />
./configure<br />
make<br />
sudo make install</code>
# [然後輸入你的密碼]</blockquote>
這樣 libhz 就裝好了。可以把 mainline 資料夾砍掉。

---
<h2>下載我寫的 AppleScript</h2>
請在這裡下載我<span style="text-decoration:line-through;">爆肝</span>寫出來的 AppleScript ：
<blockquote><a href="http://dl.getdropbox.com/u/159570/iTunes%20Song%20Name%20Converter%20between%20Chiese%20Varients.zip">iTunes Song Name Converter between Chinese <span style="text-decoration:line-through;">Varients</span> Variants.zip</a></blockquote>

授權： <a href="http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt">GNU GPL v2.0</a>

版權沒有，歡迎亂改 (不過改出來的東西也得是 GPL 相容的授權)
下載回來之後解壓縮開來，是一個 AppleScript 檔案，按兩下檔案，會開啟工序指令編寫程式。此時建議先按一下工序指令編寫程式視窗最下面的「Event 記錄」，切換到 Log 檢視，等下如果執行階段發生錯誤可以看。

<a title="Flickr 上 chitsaou 的 iTunes 轉換�文�曲名稱繁簡體的 AppleScript" href="http://www.flickr.com/photos/chitsaou/3150682628/"><img src="http://farm4.static.flickr.com/3260/3150682628_dda6bb360a.jpg" alt="iTunes 轉換�文�曲名稱繁簡體的 AppleScript" width="500" height="362" /></a>

---
<h2>操作方法</h2>
首先在 iTunes 裡選擇你要轉換歌曲名稱的曲目。同時不可以選擇繁體字和簡體字，我不知道會發生什麼事XD

<a title="Flickr 上 chitsaou 的 iTunes 轉換�文�曲名稱繁簡體的 AppleScript" href="http://www.flickr.com/photos/chitsaou/3149850735/"><img src="http://farm4.static.flickr.com/3125/3149850735_fa91459dff_o.jpg" alt="iTunes 轉換�文�曲名稱繁簡體的 AppleScript" width="593" height="354" /></a>

然後回到工序指令編寫程式，按下工具列上的「執行」鈕 (綠色 Play 圓鈕)，會詢問你轉換的方向：

<a title="Flickr 上 chitsaou 的 iTunes 轉換�文�曲名稱繁簡體的 AppleScript" href="http://www.flickr.com/photos/chitsaou/3149850671/"><img src="http://farm4.static.flickr.com/3195/3149850671_9208b3d15b.jpg" alt="iTunes 轉換�文�曲名稱繁簡體的 AppleScript" width="500" height="160" /></a>

選擇你要的方向，就可以進行轉換了。轉換過程出現的訊息與錯誤會出現在下方窗格的 Event 記錄裡面：

<a title="Flickr 上 chitsaou 的 iTunes 轉換�文�曲名稱繁簡體的 AppleScript" href="http://www.flickr.com/photos/chitsaou/3149850623/"><img src="http://farm4.static.flickr.com/3252/3149850623_bae54d5363.jpg" alt="iTunes 轉換�文�曲名稱繁簡體的 AppleScript" width="500" height="362" /></a>

接著再回到 iTunes ，看看成果吧

<a title="Flickr 上 chitsaou 的 iTunes 轉換�文�曲名稱繁簡體的 AppleScript" href="http://www.flickr.com/photos/chitsaou/3150682390/"><img src="http://farm4.static.flickr.com/3291/3150682390_db77f2bd27_o.jpg" alt="iTunes 轉換�文�曲名稱繁簡體的 AppleScript" width="628" height="378" /></a>

---
<h2>已知問題</h2>
眼尖的你應該會發現，有少數一些曲目轉換出來的字會有問題。我想這可以是 BIG5 傳說中的<a href="http://zh.wikipedia.org/wiki/%E5%A4%A7%E4%BA%94%E7%A2%BC#.E8.A1.9D.E7.A2.BC.E5.95.8F.E9.A1.8C">許功蓋問題</a>，遇到這種情況只能手動打字了。至於範例裡的「泵叉」，是因為我在做這個示範的時候，先把繁體 (「掙扎」) 轉換成簡體，就出錯了。

另外，因為轉換的過程是直接 call Shell Script，所以如果曲目名稱裡面有雙引號 (")，則執行過程會發生錯誤而停止。這個時候也只能針對出錯的曲目名稱手動打字。我知道這裡可以用 Escape Character 的方式來解決，不過我目前試不出來 XD

---
<h2>技術細節</h2>
其實我是在尋找如何透過 AppleScript 呼叫 Safari 執行 JavaScript 的時候，意外發現 AppleScript 可以執行 Shell Script，又剛好前幾天 PTT 的 Mac 板有人提問說怎麼做歌曲名稱的繁簡轉換 (<code>#19LxF9jS</code>)，這會兒就讓我想到可以直接把轉換的程序丟給 Shell Script 做。

問題就在於，哪來的繁簡轉換程式？既然系統服務功能表裡面的中文字轉換程式是無法使用的，那就勢必要丟給第三方程式來做。上網搜尋了好久，終於讓我找到<a href="http://www.linux-wiki.cn/index.php/%E7%AE%80%E7%B9%81%E8%BD%AC%E6%8D%A2">這篇文章</a>裡面提到 iconv 的轉換秘技：
<blockquote><a class="new" title="Iconv (尚未撰写)" href="http://www.linux-wiki.cn/index.php?title=Iconv&amp;action=edit&amp;redlink=1">iconv</a>是用来转换编码的小工具。现在的iconv在执行编码从gb2312到big5的转化时，实现了简繁转换。</blockquote>
我試了一下，發現 Mac OS X 內建的 iconv 並不支援這項秘技 (而 Ubuntu Linux 的 iconv 是有支援的)，因此只好試試看 zh-autoconvert (libhz)。又因為 zh-autoconvert 在 Mac OS X 沒有 Binary Package 也沒有被收進 MacPorts ，又費了好一番工夫才搞到原始碼，編譯出來，的確可以進行繁簡轉換。

最後就是 AppleScript 怎麼寫的問題了。我從沒寫過 AppleScript，不過實際在網路上<span style="text-decoration:line-through;">抄</span>參考範例的時候，發現 AppleScript 真的很像英文...。所以就這樣搞了一個晚上...XD

---
<h2>應該要有的改進</h2>
事實上，透過轉換編碼的方式來轉換繁簡體，根本是偷吃步的招數。最佳解應該是有一個只接受 UTF-8 輸入輸出的程式，這個程式有一張繁簡對照表，透過這個表來轉換，也不用擔心什麼許功蓋的問題。當然我們知道在服務功能表裡面就有這個小程式，不過它的使用困難已經在前文提及了。<a href="http://openvanilla.org">OpenVanilla</a> 的打簡出繁/打繁出簡不知道能不能用啊？

我的期望是，它應該是一個具備 GUI  的程式，有一個拖曳區，從 iTunes 或 Finder 拖曳歌曲進來 (這意味著需要轉換的曲目不一定要在同一個 Playlist 或顯示範圍) ，然後選擇要轉換的方向，它就會把曲目名稱、專輯名稱、演唱者和檔名都幫你轉好了。不過我不會 Cocoa Programming，這對我來說還是太難了一點。希望有人可以做出完整解就是了ˊˋ

update: <a href="http://uranusjr.twbbs.org/2009/02/itunes-song-name-conversion-between-traditional-and-simplified-chinese/">另請參考 uranusjr 所寫的 GUI 版本</a>

---
<h2><span style="text-decoration:line-through;">抄來的</span>參考程式碼</h2>
本程式的完成仰賴以下範例：
<ul>
	<li><a href="http://www.linux-wiki.cn/index.php/%E7%AE%80%E7%B9%81%E8%BD%AC%E6%8D%A2">简繁转换 - Linux Wiki</a></li>
	<li><a href="http://bbs.macscripter.net/viewtopic.php?id=18736">Applescript Forums | MacScripter / Check if file exists</a></li>
	<li><a href="http://homepage.mac.com/corrp/macsupt/applescript/index.html#User_Input_in_AppleScript">Working With AppleScript</a></li>
	<li><a href="http://dougscripts.com/itunes/itinfo/info02.php">Doug's AppleScripts for iTunes ♫ AppleScript Basics</a></li>
</ul>
