---
layout: post
title: "如何修改 NeoOffice 使用者介面 (UI) 的字型"
published: true
date: 2008-10-13 00:00
tags: []
categories: []
redirect_from: /posts/2008/10/13/hacking-neooffice-ui-font
comments: true

---

<a href="http://neooffice.org/" target="_blank">NeoOffice</a>，一套修改自 <a href="http://openoffice.org/" target="_blank">OpenOffice</a> 的辦公室套裝軟體，Mac OS X 的使用者一定對這套軟體耳熟能詳，在 <a href="http://www.microsoft.com/mac/products/Office2008/default.mspx" target="_blank">Microsoft Office</a> 過度昂貴以及 OpenOffice 3 Aqua 版本<span>過度廢柴</span>容易當掉的今天，以自由軟體發行的 NeoOffice 提供了一個雖然不算最棒，但至少勘用的解決方案。

而同時它也有繁體中文語系，<a href="http://www.neooffice.org/neojava/en/langpackdownload.php" target="_blank">在這裡下載</a>安裝封包檔案 (其他語系的也有)，並在 NeoOffice 的 Preferences -&gt; Language Settings -&gt; Languages 裡面把語系換成 Chinese (Traditional)，重新啟動 NeoOffice 就行了。

<a title="Flickr 上 chitsaou 的 NeoOffice-Preferences-Language.png" href="http://www.flickr.com/photos/chitsaou/2937093411/" target="_blank"><img src="http://farm4.static.flickr.com/3272/2937093411_18261805e5.jpg" alt="NeoOffice-Preferences-Language.png" width="500" height="261" /></a>

不過，當我們重新啟動程式之後，映入眼簾的，除了熟悉的中文之外，還有熟悉的…新細明體…

<a title="Flickr 上 chitsaou 的 NeoOffice-zh_TW-Ugly-UI-Font.png" href="http://www.flickr.com/photos/chitsaou/2937944920/" target="_blank"><img src="http://farm4.static.flickr.com/3172/2937944920_5bfc422830.jpg" alt="NeoOffice-zh_TW-Ugly-UI-Font.png" width="500" height="387" /></a>

當然前提是你有把新細明體 (或稱 PMingLiU) 安裝到 Mac OS X 裡面；不過就算沒有裝，看到的大概也是其他的宋體或明體字 (serif)。

而這並不符合我們在 Mac OS X 的習慣。

簡單來說就是看起來很吃力 = =

如何修改呢？

<!--more-->

—

首先，就如同你修改其他程式<span>或遊戲</span>一樣，修改之前先把 NeoOffice 程式關掉。

進入 <code>~/Library/Preferences/NeoOffice-2.2/user/registry/cache</code> 這個路徑，把<code>org.openoffice.VCL.dat</code> 這個檔案刪掉。

<a title="Flickr 上 chitsaou 的 NeoOffice-Delete-Cached-Font-Settings.png" href="http://www.flickr.com/photos/chitsaou/2937093259/" target="_blank"><img src="http://farm4.static.flickr.com/3024/2937093259_34cddab9d1.jpg" alt="NeoOffice-Delete-Cached-Font-Settings.png" width="500" height="290" /></a>

接著進入 <code>/Applications/NeoOffice.app/Contents/share/registry/data/org/openoffice</code>，使用文字編輯器開啟 <code>VCL.xcu</code> 這個檔案。本例使用 <a href="http://www.barebones.com/products/textwrangler/" target="_blank">TextWrangler</a> (免費軟體)。

<a title="Flickr 上 chitsaou 的 NeoOffice-Default-Font-Settings.png" href="http://www.flickr.com/photos/chitsaou/2937944548/" target="_blank"><img src="http://farm4.static.flickr.com/3002/2937944548_3467fa3db4.jpg" alt="NeoOffice-Default-Font-Settings.png" width="500" height="278" /></a>

然後就開始修改啦。

請透過搜尋的功能 (通常是按下 <em>Command + F</em>)，搜尋 <code>zh-hk</code> 這個字串，然後不要急著往下拉，我們要修改的是它上面的上面的上面那坨<strong>寫著新細明體、方正明體等等一堆</strong>的那一行。(因為 <code>zh-hk</code> 的前一個 sibling element 的語言是 <code>zh-tw</code>)

<a title="Flickr 上 chitsaou 的 NeoOffice-Modify-Default-Font-Setting-for-zh_TW-1.png" href="http://www.flickr.com/photos/chitsaou/2937944664/" target="_blank"><img src="http://farm4.static.flickr.com/3067/2937944664_211ce7012a.jpg" alt="NeoOffice-Modify-Default-Font-Setting-for-zh_TW-1.png" width="500" height="335" /></a>

到這裡你應該大概知道怎麼做了 :p

直覺看來當然是在 <strong>方正明體 </strong>這幾個字前面加入想要用的字型啦~ 例如 Mac OS X 應該是以 <strong>Lucida Grande</strong> 為全系統的 UI 通用字型。不過當然你也可以用別的，例如微軟正黑體之類 (當然前提是你有安裝)。記得字型名稱之間要以 <code>;</code> (分號) 隔開喔。

<a title="Flickr 上 chitsaou 的 NeoOffice-Modify-Default-Font-for-zh_TW-2.png" href="http://www.flickr.com/photos/chitsaou/2937093371/" target="_blank"><img src="http://farm4.static.flickr.com/3166/2937093371_5eff26144b.jpg" alt="NeoOffice-Modify-Default-Font-for-zh_TW-2.png" width="500" height="335" /></a>

然後就存檔啦。不過因為 <code>VLC.xcu</code> 這個檔案的 owner 是 <code>system</code>，所以你在存檔的時候會問你密碼；當然如果你在開檔的時候用終端機，並且在指令前面先加 <code>sudo</code> ，應該就沒這個問題了。

<a title="Flickr 上 chitsaou 的 NeoOffice-Sudo-Modify-Settings.png" href="http://www.flickr.com/photos/chitsaou/2937944828/" target="_blank"><img src="http://farm4.static.flickr.com/3178/2937944828_693de99147.jpg" alt="NeoOffice-Sudo-Modify-Settings.png" width="500" height="336" /></a>

修改完成之後啟動 NeoOffice (它會再抓一次預設值，然後存進我們第一個砍掉的 Cache 檔)，是不是字體變漂亮了呢？

<a title="Flickr 上 chitsaou 的 NeoOffice-zh_TW-Beautiful-UI-Font.png" href="http://www.flickr.com/photos/chitsaou/2937093519/" target="_blank"><img src="http://farm4.static.flickr.com/3271/2937093519_41c9c062c6.jpg" alt="NeoOffice-zh_TW-Beautiful-UI-Font.png" width="500" height="388" /></a>

—

不過，因為它抓字型的方式是以「從頭開始抓，看哪個存在系統裡面，就以那個字型做為使用者界面的字型」，至於字型裡沒有的字元 (例如 Lucida Grande 裡面理所當然沒有東亞文字)，就交由 Mac OS X 去做字型的 Fall-back；因此在某些情況下，可能顯示出來的字很醜或不符你眼睛的標準，這時候就從頭做起 (關程式、砍 Cache 檔、修改預設值、存檔、開程式)，直到你試出你覺得好看的界面啦…XD

至於為甚麼不直接改 Cache 檔 (<code>org.openoffice.VCL.dat</code>) 呢？那是因為這個檔案是二進位檔…與其拿十六進位編輯器來改這個檔案，不如砍掉這個檔案讓 NeoOffice 誤以為字型沒有初始化，然後再去抓預設值回來存…XD

同理，如果你想修改其他語系的 UI 字型，就搜尋相對應語系縮寫的 element 裡面的 <code>UI_SANS</code> 這一條字型設定就行囉。 例如中国用简体中文是 <code>zh-cn</code>、香港中文是 <code>zh-hk</code>、新加坡中文是 <code>zh-sg</code>、日本語是 <code>ja</code>、한국어 (韓國語) 是 <code>kr</code>，預設的 English 是 <code>en</code>。

—

嗯…我不知道 NeoOffice 更新的時候會不會又要重新動一次手術…XD 應該不用啦 (?)
