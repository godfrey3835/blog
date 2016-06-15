---
layout: post
title: "台灣時區變換的八卦"
published: true
date: 2013-08-26 22:40
tags:
- "歷史"
- "時區"
- "日治時期"
categories: []
redirect_from: /posts/2013/08/26/time-zone-in-taiwan
comments: true

---
[先前有個程式](http://blog.yorkxin.org/2013/08/26/ruby-ambiguous-time/)遇到了古時候台灣時區轉換而導致的 bug ，在那之後，稍微考據了一下台灣的時區過渡過程，發現了一些有趣的事。

不過要先聲明：我沒有研究歷史的專業，不知道怎麼找到最正確的資料，以下除非有列出參考資料，否則都是我自己認為的，可能不正確，歡迎指正。

## 關於時區轉換的歷史事件

### 台灣的官方時區制定於 1896 ，早於中國大陸

首先，大清國直到 1911 年滅亡，都沒有實施現代意義的時區，中國大陸直到中華民國統治的 1918 才打算設置時區，根據維基百科[〈中國時區〉](http://zh.wikipedia.org/wiki/%E4%B8%AD%E5%9C%8B%E6%99%82%E5%8D%80)條目的記載：

> 1912年之前，中國各地並沒有統一的標準時間。在王朝時代，國家的標準曆法由皇庭頒布，稱為「奉正朔」。
>
> 民國7年（1918年），中央觀象台提出將全國劃分為5個標準時區。

所以說，在 1895 年就由大清國割讓給日本的台灣與澎湖，直到 1945 由中華民國接收以前，自然沒有使用到中華民國制定的時區。那麼台灣是什麼時候開始有官方制定的時區？

<!-- more -->

答案是 1896 年的日治初年。在割讓當年的 1895 年底，日本明治天皇頒佈了[敕令 167 號](http://ja.wikisource.org/wiki/%E6%A8%99%E6%BA%96%E6%99%82%E3%83%8B%E9%97%9C%E3%82%B9%E3%83%AB%E4%BB%B6_\(%E5%85%AC%E5%B8%83%E6%99%82\))，從明治 29 年（1896 年）起，將大日本帝國分成兩個時區，一個叫做中央標準時，一個叫西部標準時，前者以 135°E 為基準，即現代的 UTC+9 ，後者以 120°E 為基準，即現代的 UTC+8 。大日本帝國向來使用的時區稱為中央標準時，西部標準時則是在台灣、澎湖、一部份珫球群島使用。這份敕令的內文可以在 Wikisource 的 [〈標準時ニ關スル件 (公布時)〉](http://ja.wikisource.org/wiki/%E6%A8%99%E6%BA%96%E6%99%82%E3%83%8B%E9%97%9C%E3%82%B9%E3%83%AB%E4%BB%B6_\(%E5%85%AC%E5%B8%83%E6%99%82\)) 找到：

> 第一條　 帝國從來ノ標準時ハ自今之ヲ中央標準時ト稱ス
>
> 第二條　 東經百二十度ノ子午線ノ時ヲ以テ臺灣及澎湖列島竝ニ八重山及宮古列島ノ標準時ト定メ之ヲ西部標準時ト稱ス
>
> 第三條　 本令ハ明治二十九年一月一日ヨリ施行ス

這之後的故事，上過《認識台灣：歷史篇》這本課本的應該都有印象，日本人教育台灣人守時的觀念，那張[「時的紀念日」](http://zh.wikipedia.org/wiki/%E6%99%82%E7%9A%84%E7%B4%80%E5%BF%B5%E6%97%A5)海報是我印象最深的圖片。

### 二次大戰期間，改用與日本內地相同的 UTC+9

西部標準時一直用到二次大戰爆發，在昭和 12 年（1937 年，即日本侵華戰爭開始），日本昭和天皇頒佈了[敕令 529 號](http://ja.wikisource.org/wiki/%E6%98%8E%E6%B2%BB%E4%BA%8C%E5%8D%81%E5%85%AB%E5%B9%B4%E5%8B%85%E4%BB%A4%E7%AC%AC%E7%99%BE%E5%85%AD%E5%8D%81%E4%B8%83%E8%99%9F%E6%A8%99%E6%BA%96%E6%99%82%E3%83%8B%E9%97%9C%E3%82%B9%E3%83%AB%E4%BB%B6%E4%B8%AD%E6%94%B9%E6%AD%A3%E3%83%8E%E4%BB%B6)，廢止西部標準時 (UTC+8)，也就是全國改用中央標準時 (UTC+9) ，包括外地（台灣、澎湖、之後佔領的香港）。

戰爭結束之後，顯然這些原本刻意與日本內地同步的時區都必須還原，在維基百科以及我隨便找的資料裡面，都只是及「國民政府接收之後，改用中原標準時間 UTC+8」，但真的是光復當天或光復之後才改時區嗎？日本投降是 8 月 15 日，到 10 月 25 日的接收儀式之間，台灣在名義上還是屬於大日本帝國，又，使用了西部標準時間的還包括琉球群島的一部份，這些地區呢？什麼時候還原的？

我在[臺灣省政府公報網路查詢系統](http://subtpg.tpg.gov.tw/og/q1.asp)使用類似的關鍵字沒有找到切換時區的公文，只有實施夏令時間的公文。有兩種可能：①在光復之前就切換到 UTC+8 ，所以國民政府不需要有任何行政流程，或是②有切換，但不重要，所以沒記載。……怎麼可能咧。

就在我搜尋的過程中，我在國史館的網站找到一份[文獻](http://163.29.208.22:8080/govsaleShowImage/connect_img.php?s=00101738900090036&e=00101738900090037)，根據推友 [@FreeLeaf](https://twitter.com/FreeLeaf) 的[翻譯](https://twitter.com/FreeLeaf/status/355651015292362752)，是台灣總督府專賣局收到的內部公文，要在 9 月 21 日起改回使用西部標準時（更正啟事：先前我寫錯成「專賣局發的公文」，感謝 [@FreeLeaf 再度指正](https://twitter.com/FreeLeaf/status/372228698209931264)）：

[![](http://f.cl.ly/items/1M3f2e1W231N0U0v0J1Q/%E7%B8%BD%E4%BA%A4%E7%AC%AC506%E8%99%9F.jpg)](http://163.29.208.22:8080/govsaleShowImage/connect_img.php?s=00101738900090036&e=00101738900090037)

*出處：[國史館網站](http://163.29.208.22:8080/govsaleShowImage/connect_img.php?s=00101738900090036&e=00101738900090037)*

又在[成功大學的某個校簡史的網頁](http://www.ncku.edu.tw/~ncku70/menu/001/01_01.htm)也提到：

> 1945（昭和20年）
> 
> 8月15日：大詔宣布戰爭結束。
> 
> 9月21日：本日開始，全部改為西部標準時。

這樣可以說是 9 月 21 日當天改時區嗎？但是，更關鍵的官方文件（像是台灣總督府的公文、公告等）我卻沒有找到，也不知道上哪裡找。但我比較傾向相信在 1945 年的時候，並非國民政府接收台灣之後才改時區，而是最晚 9 月 21 日就改了時區。

**Update** (2014/07/03) 終於找到了官方的文件，在[臺灣總督府（官）報資料庫](http://db2.th.gov.tw/db2/view/index.php)找到的[檔案（需註冊）](http://db2.th.gov.tw/db2/view/showDataForm.php?CollectionNo=0072031018a005)、以及其[圖檔（免登入）](http://db2.th.gov.tw/db2/view/viewImg.php?imgcode=0072031018a&num=19&bgn=019&end=019&otherImg=&type=gener)

[![jpeg.jpg](http://user-image.logdown.io/user/2580/blog/2567/post/93429/q2uLpUyGRc6vqKqclQl1_jpeg.jpg)](http://db2.th.gov.tw/db2/view/viewImg.php?imgcode=0072031018a&num=19&bgn=019&end=019&otherImg=&type=gener)

> 告示第三百八十六號
>
> 昭和十二年告示第二百七號（臺灣ノ標準時ニ關スル件）ハ之ヲ廢止シ昭和二十年九月二十一日午前一時ヲ以テ昭和二十年九月二十一日午前零時トス
>
> 昭和二十年九月十九日　臺灣總督　安藤　利吉
>
> <q>收錄於《臺灣總督府官報》昭和二十年九月十九日　第千十八號</q>

簡單來說，就是廢止昭和 12 年總督府的告示第 207 號，而其為公告實施敕令 529 號，廢止西部標準時，那麼負負得正，就是回歸到西部標準時了。感謝 [@rail02000](https://twitter.com/rail02000) 協助翻譯。

*（2014/07/03 更新結束）*

至於琉球群島西部是否也曾經改回 UTC+8 ，後來又再改成現在的 UTC+9 ，我很是好奇，但就沒再研究了……。

這裡稍微岔一下題。一開始提到，會研究這個是因為之前遇到一個神秘的程式 bug ，這個世界上有一個資料庫叫做 [TZ Database](http://www.iana.org/time-zones) ，這是幾乎是所有電腦作業系統都會內建一份的時區資料庫，其中當然有記載台灣的時區，比較特別的是，我今天看到的版本 2013d ，香港的時區資料，有記載香港日佔時期使用 UTC+9 時區的史實，但台灣的卻沒有。以下取自 ftp://ftp.iana.org/tz/data/asia ：

    # Zone  NAME            GMTOFF  RULES   FORMAT  [UNTIL]
    Zone    Asia/Hong_Kong  7:36:42 -       LMT     1904 Oct 30
                            8:00    HK      HK%sT   1941 Dec 25
                            9:00    -       JST     1945 Sep 15
                            8:00    HK      HK%sT
    
    Zone    Asia/Taipei     8:06:00 -       LMT     1896 # or Taibei or T'ai-pei
                            8:00    Taiwan  C%sT

不過事實上，這份資料庫是公共維護的，並不是所有的資料來源都具有權威性，維護者建議，如果你知道更詳細的，可以告訴他們。在我挖到二戰期間台灣用 UTC+9 的史實之後，我寄信給維護者，不過過了一個多月，還沒有回信……。

## 關於台灣實施夏日節約時間 (DST) 的八卦

**Update** 2014/07/11 考據了所有關於日光節約時間的公文，整理在〈[台灣日光節約時間之考據](http://blog.yorkxin.org/posts/2014/07/11/dst-in-taiwan-study)〉這篇新文章。

根據[中央氣象局的網頁](http://www.cwb.gov.tw/V7/knowledge/astronomy/cdata/summert.htm)，中華民國的夏日時間制從民國 34 年到 68 年，斷斷續續實施了好幾次。但其中民國 34 年的那一次沒有在台灣實施。為什麼呢？很明顯嘛， 1945 年實施的日期是 5 月 1 日到 9 月 30 日，台灣光復是 10 月 25 日，怎麼可能實施呢？

但這個簡單的邏輯謬誤，卻被許多網頁複製貼上，稱其「台灣的日光節約時間」，卻沒有仔細考據。

在考據日光節約時間的時候，又挖到[臺灣省政府的公報](http://subtpg.tpg.gov.tw/og/image2.asp?f=0360310AKZ431)，其中一份公文指出，民國 36 年的夏令時間，結束日期從原本的 9 月 30 日延長到 10 月 31 日，也就是說氣象局的網頁上所說的 34 年 到 40 年間，實施日期到 9 月 30 止，在 36 年這一年要再更正。原文抄錄如下，在下圖的右下角：

> 臺灣省政府代電　參陸申？府人甲字第六○○二一號　中華民國卅六年九月十五日（不另行文）
>  
> 事由：奉電爲本年夏令時間延長至十月三十一日午夜二十四時止等因電？？
> 
> 本府所屬各機關學校：頃奉行政院卅六人字第三五一一七號代電開：「奉國府調
令，本年夏令時間定自四月十五日零時起，至九月二十日午夜二十四時止，前經
由寄通飭遵照在案。茲為勵行節約消費起見，再將是項夏令時間延長，其通用期
間至本年十月三十一日午夜二十四時爲止。等因；除分電外，仰卽遵照，幷飭爲
遵照。」等因；奉此，自應遵辦，合行電希遵照，並轉飭屬遵照。臺灣省政府
卅六申（刪）府人甲

[![](http://cl.ly/image/0E0x0m0z3C0a/image2.gif)](http://subtpg.tpg.gov.tw/og/image2.asp?f=0360310AKZ431)

這些 bug 我已經寄信去告知中央氣象局網站了，他們給我的回信內容是，肯定它是 bug ，會再研究，但為免誤導，先把原本的網頁下架。我現在已經看不到[原本那個網頁](http://www.cwb.gov.tw/V7/astronomy/cdata/summert.htm)了，但 Google 又可以找到[另一個存在錯誤的網頁](http://www.cwb.gov.tw/V7/knowledge/astronomy/cdata/summert.htm)……。

## 番外篇：關於香港日佔時期實施夏日節約時間（？）的八卦

研究以上這些東西難免會去找到香港的資料，最具權威的當然應該要是香港天文台，不過[香港天文台介紹夏令時間的網頁](http://www.hko.gov.hk/gts/time/Summertimec.htm)竟然是這樣寫的：

- 1941: 4 月 1 日至 9 月 30 日
- 1942: 全年
- 1943: 全年
- 1944: 全年
- 1945: 全年
- 1946: 4 月 20 日至 12 月 1 日	

**全年**！！這不明擺著有問題的嘛！！夏季都不夏季了啊！！不可以把因為香港被日本佔領所以改時區成 UTC+9 稱做夏令時間啊！！！

哪位香港網友看到的麻煩去函指正一下吧……即使是恥辱的歷史，也要正視啊（正色）。

這個 bug 也有人在 TZ Database 裡面提到：

> From Lee Yiu Chung (2009-10-24):
> I found there are some mistakes for the...DST rule for Hong Kong. [According] to the DST record from Hong Kong Observatory [...], there are some missing and incorrect rules. [...]
>
> From Arthur David Olson (2009-10-28):
> Here are the dates given at http://www.hko.gov.hk/gts/time/Summertime.htm as of 2009-10-28:
>
> Year        Period
> 1941        1 Apr to 30 Sep
> 1942        Whole year
> 1943        Whole year
> 1944        Whole year
> 1945        Whole year
> 1946        20 Apr to 1 Dec
> [...]
>
> The Japanese occupation of Hong Kong began on 1941-12-25.
> The Japanese surrender of Hong Kong was signed 1945-09-15.

---

## 參考資料

* [國家標準時間 - 維基百科，自由的百科全書](http://zh.wikipedia.org/wiki/%E5%9C%8B%E5%AE%B6%E6%A8%99%E6%BA%96%E6%99%82%E9%96%93)
* [Japan Standard Time - Wikipedia, the free encyclopedia](http://en.wikipedia.org/wiki/Time_in_Japan)
* [標準時ニ關スル件 (公布時) - Wikisource](http://ja.wikisource.org/wiki/%E6%A8%99%E6%BA%96%E6%99%82%E3%83%8B%E9%97%9C%E3%82%B9%E3%83%AB%E4%BB%B6_\(%E5%85%AC%E5%B8%83%E6%99%82\))
* [明治二十八年勅令第百六十七號標準時ニ關スル件中改正ノ件 - Wikisource](http://ja.wikisource.org/wiki/%E6%98%8E%E6%B2%BB%E4%BA%8C%E5%8D%81%E5%85%AB%E5%B9%B4%E5%8B%85%E4%BB%A4%E7%AC%AC%E7%99%BE%E5%85%AD%E5%8D%81%E4%B8%83%E8%99%9F%E6%A8%99%E6%BA%96%E6%99%82%E3%83%8B%E9%97%9C%E3%82%B9%E3%83%AB%E4%BB%B6%E4%B8%AD%E6%94%B9%E6%AD%A3%E3%83%8E%E4%BB%B6)
* [台灣總督府專賣局的公文（國史館）](http://163.29.208.22:8080/govsaleShowImage/connect_img.php?s=00101738900090036&e=00101738900090037)
* [世紀回眸（成功大學網站）](http://www.ncku.edu.tw/~ncku70/menu/001/01_01.htm)
* [臺灣省政府公報 民國 36 年秋](http://subtpg.tpg.gov.tw/og/image2.asp?f=0360310AKZ431)
* [臺灣省政府公報網路查詢系統](http://subtpg.tpg.gov.tw/og/q1.asp)
* [臺灣ノ標準時ニ關スル件](http://db2.th.gov.tw/db2/view/showDataForm.php?CollectionNo=0072031018a005) （需登入）、[其圖檔](http://db2.th.gov.tw/db2/view/viewImg.php?imgcode=0072031018a&num=19&bgn=019&end=019&otherImg=&type=gener)（免登入）
* [臺灣總督府府官報資料庫](http://db2.th.gov.tw/db2/view/)（需登入）
* <del>[中央氣象局的網頁](http://www.cwb.gov.tw/V7/knowledge/astronomy/cdata/summert.htm)</del> 已下架

## 延伸閱讀

* 程式設計界的前輩良葛格所寫的時間與日期基本知識[【Joda-Time 與 JSR310 】（2）時間的 ABC by caterpillar | CodeData](http://www.codedata.com.tw/java/jodatime-jsr310-2-time-abc/)