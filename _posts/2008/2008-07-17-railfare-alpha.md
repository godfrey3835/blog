---
layout: post
title: "[作品] RailFare 台灣鐵道服務票價查詢機 (只有捷運且只有 IE 不能開)"
published: true
date: 2008-07-17 00:00
tags: []
categories: []
redirect_from: /posts/2008/07/17/railfare-alpha
comments: true

---

網址在這裡：<a href="http://fare.yorkxin.org/" target="_blank">http://fare.yorkxin.org</a> 。

前一陣子在 PTT MRT 板上發表的 (茶)

目前只提供台北捷運和高雄捷運的票價地圖查詢，並且 (只有) Internet Explorer 無法使用，並且 Internet Explorer 6 無法顯示圖形。

Internet Explorer 現僅支援 7.x 版，因為 6 版以下不支援 PNG 透明背景，8 (Beta) 版在繪製表格有問題。

<a title="Flickr 上 chitsaou 的 RailFare" href="http://www.flickr.com/photos/chitsaou/2675875493/" target="_blank"><img src="http://farm4.static.flickr.com/3065/2675875493_2069f42e80.jpg" alt="RailFare" width="500" height="345" /></a>

<!--more-->

最初的想法是這樣來的：
<ol>
	<li>我的宿舍在師大公館校區</li>
	<li>可是剛好在公館站和萬隆站的中間 = =</li>
	<li>我比較喜歡去萬隆站搭車</li>
	<li>可是有時候公館、萬隆就差 5 塊錢</li>
	<li>要去按<a href="http://www.trtc.com.tw/c/index_search1024.asp" target="_blank">台北捷運公司的查詢</a>又很難按 (而且用 Safari 看會爛掉)</li>
	<li>又不能兩個站都去看單程票售票機的票價表</li>
	<li>那何不把票價地圖直接顯示出來？</li>
</ol>
所以就有了這個程式。

—

起先是想用 <a href="http://code.google.com/appengine" target="_blank">Google App Engine</a> 做，把每個區間的票價都放進 Datastore，但發現光是匯入資料就是件很難的事。後來想想，票價這種東西是幾年才會改一次的，就算放進資料庫，也很少在寫入。所以乾脆寫了一支小程式把票價梯形圖輸出成 JSON 檔案，再寫個 <a href="http://jquery.com/" target="_blank">jQuery</a> 的前端來讀。

不過我不知道是哪裡寫錯了，其他瀏覽器都可以用，就<strong>只有 </strong><a href="http://www.microsoft.com/taiwan/ie/" target="_blank"><strong>Microsoft Internet Explorer</strong></a><strong> 不能用</strong>…。所以 Windows 用戶就先用 <a href="http://moztw.org/" target="_blank">Firefox</a> 或 <a href="http://www.apple.com.tw/safari" target="_blank">Safari</a> 或 <a href="http://opera.com/" target="_blank">Opera</a> 吧 (趁機推廣？)

一開始想說如果要做就全部做，北捷、高捷、台鐵、高鐵全部做進來，但後來發現台鐵和高鐵的票價實在太複雜，用我目前的方法做不出來 XD 所以台鐵、高鐵就無限期延後啦。而且最恐怖的是台鐵不提供各區間的票價梯形圖，只有<a href="http://service.tra.gov.tw/tw/ticketprice/trapezoid.aspx" target="_blank">大站的</a>(也難怪，站那麼多)，所以要怎麼獲得票價表呢？(把<a href="http://service.tra.gov.tw/tw/ticketprice/index.aspx" target="_blank">它</a>ㄎㄎ掉？)

至於梯形票價圖表，台北捷運的來自<a href="http://www.trtc.com.tw/img/C/B46/Cprice950518.pdf" target="_blank">這裡</a>，高雄捷運的，高捷公司並沒有提供，是 PTT MRT 板的 <a href="http://www.wretch.cc/blog/fcbih350" target="_blank">fcbih350 網友</a>自行製作的<a href="http://fcbih0610.myweb.hinet.net/kmrtmoney.htm" target="_blank">票價表</a> (MRT 板 <code>#18MewnWr</code>)，在這裡也感謝 fcbih350 網友同意我在我的程式中使用他所製作的票價表。不過高捷未完工的車站我並沒有在地圖上顯示票價，想說既然還不能進去搭車，那寫上票價也沒意思 XDrz

—

其他技術細節和未來的計畫都寫在<a href="http://www.yorkxin.org/work:nanshijiao" target="_blank">這裡</a>，不知道有沒有人想來寫手機版 (J2ME, iPhone) 的 XD

—

我好像都寫一些很奇怪的程式齁…
