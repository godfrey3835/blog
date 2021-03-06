---
layout: post
title: "台灣日光節約時間之考據"
published: true
date: 2014-07-11 17:06
tags:
- "台灣"
- "時區"
- "時間"
- "日治時代"
- "日光節約時間"
categories: []
redirect_from: /posts/2014/07/11/dst-in-taiwan-study
comments: true

---
去年（2013）我寫過一篇文章是〈[台灣時區變換的八卦](http://blog.yorkxin.org/posts/2013/08/26/time-zone-in-taiwan/)〉，當時寄信去 IANA TZ Database 的 mailing list 提 patch，一年後終於改了，原因是我給的 link 裡面有 non-ASCII 文字（非英文數字的文字），為了這個，所以 Time Zone Database 必須修改成 UTF-8-compatible 的格式（可以容納非英文數字的文字），所以才拖到現在。

因為最近收到回信，所以我又去研究了一下台灣的時區，這次重點是放在日光節約時間。

<!--more-->

簡單來說，中央氣象局網站上大家[常引用的](http://www.cwb.gov.tw/V7/knowledge/astronomy/cdata/summert.htm)，以下的這個日光節約時間的資訊，不是完全正確的。

| 年代 | 名稱 | 起訖日期 |
|-----|------|--------|
| 民國34年至40年（西元1945-1951年） | 夏令時間 |   5月1日至9月30日 **← 這是錯的** |
| 民國41年（西元1952年） | 日光節約時間 |   3月1日至10月31日 |
| 民國42年至43年（西元1953-1954年） | 日光節約時間 |   4月1日至10月31日 |
| 民國44年至45年（西元1955-1956年） | 日光節約時間 |   4月1日至9月30日 |
| 民國46年至48年（西元1957-1959年） | 夏令時間 |   4月1日至9月30日 |
| 民國49年至50年（西元1960-1961年） | 夏令時間 |   6月1日至9月30日 |
| 民國51年至62年（西元1962-1973年） | 　 |   停止夏令時間 |
| 民國63年至64年（西元1974-1975年） | 日光節約時間 |   4月1日至9月30日 |
| 民國65年至67年（西元1976-1978年） | 　 |   停止日光節約時 |
| 民國68年（西元1979年） | 日光節約時間 |   7月1日至9月30日 |
| 民國69年起（西元1980年） | 　 |   停止日光節約時 |

我去翻了[臺灣省政府網際網路公報查詢系統][taiwan-province-gazette]、[政府公報資訊網][ncl-gazette]，搜尋「夏令時」、「日光節約」、「夏季時」的公告，終於把每一年的日光節約時間的實施給湊出來了。

基本上都對，只有民國 34 到 36 年是錯的。

民國 34 年台灣光復，但 34 年實施是 5/1 至 9/30，台灣光復是 10/25，怎麼想都不可能由中華民國政府實施日光節約時間。不過其實有找到[當年的電文][1945a]。此外也找到了[台灣總督府的告示][1945b]，要在 1945 年 9 月 21 日改回西部標準時（UTC+8）。

民國 35 年實際上是從 5/15 到 9/30，[有公文可證][1946a]，甚至還有[日譯文][1946b]。

民國 36 年實際上是從 4/15 到 10/31，而且原本打算[實施到 9/30][1947a]，在 9/15 又[決定延到 10/31][1947b]。這在之前的文章寫過了。

每一年的公文整理如下。我發現到網路上很多人直接 copy 氣象局的網站，畢竟是權威機關所以相信也是理所當然的，也不能怪大家不去求證。我已經去信請氣象局更改網頁了，希望可以早日修正才是。

Update: 下表我已經整理至 [Wikipedia: 夏令時間](https://zh.wikipedia.org/wiki/%E5%A4%8F%E4%BB%A4%E6%99%82%E9%96%93) 條目了，所以你如果看到類似的表格，不用懷疑，是我做的，不是我抄他，也不是他抄我。

| 民國 | 西元 | 始日 | 終日  | 回標準時 | 公告文件 | 註 |
|-----|------|------|-------|------|---|----|
| 34  | 1945 | 5/1  | 9/30 | 10/1 | [國民政府訓令][1945a] | 未在台灣實施 |
| 35  | 1946 | 5/15 | 9/30 | 10/1 | [長官公署代電][1946a]、[日譯][1946b] | |
| 36  | 1947 | 4/15 | 10/31 | 11/1 | [長官公署代電][1947a]、[延長][1947b] | 9 月 15 日公佈延長 |
| 37  | 1948 | 5/1  | 9/30  | 10/1 | [省府代電][1948] | |
| 38  | 1949 | 5/1  | 9/30  | 10/1 | [省府代電(1)][1949a]、[(2)][1949b] | |
| 39  | 1950 | 5/1  | 9/30  | 10/1 | [省府代電][1950] | |
| 40  | 1951 | 5/1  | 9/30  | 10/1 | [省府代電][1951] | |
| 41  | 1952 | 3/1  | 10/31 | 11/1 | [省府代電][1952] | 改稱日光節約時間 |
| 42  | 1953 | 4/1  | 10/31 | 11/1 | [省府令][1953] | |
| 43  | 1954 | 4/1  | 10/31 | 11/1 | [省府令][1954] | |
| 44  | 1955 | 4/1  | 9/30  | 10/1 | [省府令][1955] | |
| 45  | 1956 | 4/1  | 9/30  | 10/1 | [省府令][1956] | |
| 46  | 1957 | 4/1  | 9/30  | 10/1 | [省府令][1957] | 改稱夏令時間 |
| 47  | 1958 | 4/1  | 9/30  | 10/1 | [省府令][1958] | |
| 48  | 1959 | 4/1  | 9/30  | 10/1 | [省府令][1959] | |
| 49  | 1960 | 6/1  | 9/30  | 10/1 | [省府令][1960] | |
| 50  | 1961 | 6/1  | 9/30  | 10/1 | [省府令][1961] | |
| 51  | 1962 | -    | -     | -    | [省府令：不實施][1962] | 未實施 |
| 52  | 1963 | -    | -     | -    | | 未實施 |
| 53  | 1964 | -    | -     | -    | | 未實施 |
| 54  | 1965 | -    | -     | -    | | 未實施 |
| 55  | 1966 | -    | -     | -    | | 未實施 |
| 56  | 1967 | -    | -     | -    | | 未實施 |
| 57  | 1968 | -    | -     | -    | | 未實施 |
| 58  | 1969 | -    | -     | -    | | 未實施 |
| 59  | 1970 | -    | -     | -    | | 未實施 |
| 60  | 1971 | -    | -     | -    | | 未實施 |
| 61  | 1972 | -    | -     | -    | | 未實施 |
| 62  | 1973 | -    | -     | -    | | 未實施 |
| 63  | 1974 | 4/1  | 9/30  | 10/1 | [省府函][1974] | 稱為節約能源 |
| 64  | 1975 | 4/1  | 9/30  | 10/1 | [省府函][1975] | |
| 65  | 1976 | -    | -     | -    | [省府函：不實施][1976] | 未實施 |
| 66  | 1977 | -    | -     | -    | | 未實施 |
| 67  | 1978 | -    | -     | -    | | 未實施 |
| 68  | 1979 | 7/1  | 9/30  | 10/1 | [省府函][1979] | 稱為節約能源 |
| 69  | 1980 | -    | -     | -    | [省府函：不實施][1980] | 此後再也沒實施 |

---

## 引用文獻

以下原始文獻都可以在[政府公報資訊網][ncl-gazette]、[臺灣省政府網際網路公報查詢系統][taiwan-province-gazette]、[臺灣總督府（官）報資料庫][taiwan-soutokuhu-gazette]找到。我把它們全部搬到 Wikisource 了。

* 1945a: [國防最高委員會規定全國各地自三十四年五月一日起至九月三十日止將時間提前一小時令仰遵照並飭屬遵照由 (民國34年國民政府訓令)][1945a]
* 1945b: [臺灣ノ標準時ニ關スル件 (昭和二十年台湾総督府告示第三百八十六号)][1945b]
* 1946a: [電知實行夏季時間 (民國35年臺灣省行政長官公署代電)][1946a]
* 1946b: [夏季時間ヲ實行スルニ付承知相成度 (1946年台湾省行政長官公署代電)][1946b]
* 1947a: [電行政長官公署所屬各機關為奉令自卅六年四月十五日起實行夏令時間 (民國36年臺灣省行政長官公署代電)][1947a]
* 1947b: [電府屬各機關學校為本年夏令時間奉令延長至卅六年十月卅一日午夜廿四時止 (民國36年臺灣省政府代電)][1947b]
* 1948: [電府屬各機關學校為奉層令規定卅七年夏令時間自卅年五月一日零時起至九月卅日午夜廿四時止 (民國37年臺灣省政府代電)][1948]
* 1949a: [電省屬各機關學校為奉行政院電知本年夏令時間仍照成例鐘點撥早一小時 (民國38年臺灣省政府代電)][1949a]
* 1949b: [電省屬各機關學校為本年夏令時間自五月一日零時起至九月卅日午後廿四時止 (民國38年臺灣省政府代電)][1949b]
* 1950: [電省屬各機關學校為奉行政院令自五月一日零時起施行夏令時間 (民國39年臺灣省政府代電)][1950]
* 1951: [電省屬各機關學校為奉行政院令自五月一日零時起施行夏令時間 (民國40年臺灣省政府代電)][1951]
* 1952: [電本省所屬各機關學校為三月一日零時起全國實行日光節約時間 (民國41年臺灣省政府代電)][1952]
* 1953: [令省各機關學校為奉行政院令以四十二年度日光節約時間自四月一日零時起開始實行 (民國42年臺灣省政府令)][1953]
* 1954: [令各機關學校為奉行政院令知本年度日光節約時間 (民國43年臺灣省政府令)][1954]
* 1955: [令省屬各機關學校為奉行政院令知改訂本年度日光節約時間 (民國44年臺灣省政府令)][1955]
* 1956: [令省屬各機關學校為層奉總統令本年日光節約時間仍自四月一日零時起至九月卅日午夜廿四時止一案，令希遵照 (民國45年臺灣省政府令)][1956]
* 1957: [令省屬各級機關學校為奉行政院令知實施夏令時間一案，轉希遵照 (民國46年臺灣省政府令)][1957]
* 1958: [令省屬各級機關學校為四十七年度夏令時間自四月一日零時起實施 (民國47年臺灣省政府令)][1958]
* 1959: [令省屬各機關學校為奉令自四月一日實行夏令時間，轉希遵照 (民國48年臺灣省政府令)][1959]
* 1960: [令省屬各級機關學校、各縣市政府（局）為抄發本府暨所屬各級機關全年各月份辦公時間表及四十九年夏令時間起止日期，希遵照 (民國49年臺灣省政府令)][1960]
* 1961: [令省屬各級機關學校為五十年夏令時間自六月一日零時起至九月三十日午夜二十四時止，希遵照 (民國50年臺灣省政府令)][1961]
* 1962: [行政院令五十一年夏令時間毋須循例辦理及各機關辦公時間仍照原規定辦理案 (民國51年臺灣省政府令)][1962]
* 1974: [行政院函為節約用電實施「日光節約時間」自四月一日零時起至九月三十日二十四時止 (民國63年臺灣省政府函)][1974]
* 1975: [行政院函為節約用電實施「日光節約時間」自六十四年四月一日零時起至九月三十日二十四時止 (民國64年臺灣省政府函)][1975]
* 1976: [夏令「日光節約時間」自本年起停止實施 (民國65年臺灣省政府函)][1976]
* 1979: [函轉行政院規定節約能源實施「日光節約時間」 (民國68年臺灣省政府函)][1979]
* 1980: [函知六十九年停止實施「日光節約時間」及重新規定省屬各機關辦公時間 (民國69年臺灣省政府函)][1980]

[1945a]:https://zh.wikisource.org/wiki/%E5%9C%8B%E9%98%B2%E6%9C%80%E9%AB%98%E5%A7%94%E5%93%A1%E6%9C%83%E8%A6%8F%E5%AE%9A%E5%85%A8%E5%9C%8B%E5%90%84%E5%9C%B0%E8%87%AA%E4%B8%89%E5%8D%81%E5%9B%9B%E5%B9%B4%E4%BA%94%E6%9C%88%E4%B8%80%E6%97%A5%E8%B5%B7%E8%87%B3%E4%B9%9D%E6%9C%88%E4%B8%89%E5%8D%81%E6%97%A5%E6%AD%A2%E5%B0%87%E6%99%82%E9%96%93%E6%8F%90%E5%89%8D%E4%B8%80%E5%B0%8F%E6%99%82%E4%BB%A4%E4%BB%B0%E9%81%B5%E7%85%A7%E5%B9%B6%E9%A3%AD%E5%B1%AC%E9%81%B5%E7%85%A7%E7%94%B1_%28%E6%B0%91%E5%9C%8B34%E5%B9%B4%E5%9C%8B%E6%B0%91%E6%94%BF%E5%BA%9C%E8%A8%93%E4%BB%A4%29
[1945b]:https://ja.wikisource.org/wiki/%E8%87%BA%E7%81%A3%E3%83%8E%E6%A8%99%E6%BA%96%E6%99%82%E3%83%8B%E9%97%9C%E3%82%B9%E3%83%AB%E4%BB%B6_%28%E6%98%AD%E5%92%8C%E4%BA%8C%E5%8D%81%E5%B9%B4%E5%8F%B0%E6%B9%BE%E7%B7%8F%E7%9D%A3%E5%BA%9C%E5%91%8A%E7%A4%BA%E7%AC%AC%E4%B8%89%E7%99%BE%E5%85%AB%E5%8D%81%E5%85%AD%E5%8F%B7%29
[1946a]:https://zh.wikisource.org/wiki/%E9%9B%BB%E7%9F%A5%E5%AF%A6%E8%A1%8C%E5%A4%8F%E5%AD%A3%E6%99%82%E9%96%93_%28%E6%B0%91%E5%9C%8B35%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E8%A1%8C%E6%94%BF%E9%95%B7%E5%AE%98%E5%85%AC%E7%BD%B2%E4%BB%A3%E9%9B%BB%29
[1946b]:https://ja.wikisource.org/wiki/%E5%A4%8F%E5%AD%A3%E6%99%82%E9%96%93%E3%83%B2%E5%AF%A6%E8%A1%8C%E3%82%B9%E3%83%AB%E3%83%8B%E4%BB%98%E6%89%BF%E7%9F%A5%E7%9B%B8%E6%88%90%E5%BA%A6_%281946%E5%B9%B4%E5%8F%B0%E6%B9%BE%E7%9C%81%E8%A1%8C%E6%94%BF%E9%95%B7%E5%AE%98%E5%85%AC%E7%BD%B2%E4%BB%A3%E9%9B%BB%29
[1947a]:https://zh.wikisource.org/wiki/%E9%9B%BB%E8%A1%8C%E6%94%BF%E9%95%B7%E5%AE%98%E5%85%AC%E7%BD%B2%E6%89%80%E5%B1%AC%E5%90%84%E6%A9%9F%E9%97%9C%E7%82%BA%E5%A5%89%E4%BB%A4%E8%87%AA%E5%8D%85%E5%85%AD%E5%B9%B4%E5%9B%9B%E6%9C%88%E5%8D%81%E4%BA%94%E6%97%A5%E8%B5%B7%E5%AF%A6%E8%A1%8C%E5%A4%8F%E4%BB%A4%E6%99%82%E9%96%93_%28%E6%B0%91%E5%9C%8B36%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E8%A1%8C%E6%94%BF%E9%95%B7%E5%AE%98%E5%85%AC%E7%BD%B2%E4%BB%A3%E9%9B%BB%29
[1947b]:https://zh.wikisource.org/wiki/%E9%9B%BB%E5%BA%9C%E5%B1%AC%E5%90%84%E6%A9%9F%E9%97%9C%E5%AD%B8%E6%A0%A1%E7%82%BA%E6%9C%AC%E5%B9%B4%E5%A4%8F%E4%BB%A4%E6%99%82%E9%96%93%E5%A5%89%E4%BB%A4%E5%BB%B6%E9%95%B7%E8%87%B3%E5%8D%85%E5%85%AD%E5%B9%B4%E5%8D%81%E6%9C%88%E5%8D%85%E4%B8%80%E6%97%A5%E5%8D%88%E5%A4%9C%E5%BB%BF%E5%9B%9B%E6%99%82%E6%AD%A2_%28%E6%B0%91%E5%9C%8B36%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E4%BB%A3%E9%9B%BB%29
[1948]:https://zh.wikisource.org/wiki/%E9%9B%BB%E5%BA%9C%E5%B1%AC%E5%90%84%E6%A9%9F%E9%97%9C%E5%AD%B8%E6%A0%A1%E7%82%BA%E5%A5%89%E5%B1%A4%E4%BB%A4%E8%A6%8F%E5%AE%9A%E5%8D%85%E4%B8%83%E5%B9%B4%E5%A4%8F%E4%BB%A4%E6%99%82%E9%96%93%E8%87%AA%E5%8D%85%E5%B9%B4%E4%BA%94%E6%9C%88%E4%B8%80%E6%97%A5%E9%9B%B6%E6%99%82%E8%B5%B7%E8%87%B3%E4%B9%9D%E6%9C%88%E5%8D%85%E6%97%A5%E5%8D%88%E5%A4%9C%E5%BB%BF%E5%9B%9B%E6%99%82%E6%AD%A2_%28%E6%B0%91%E5%9C%8B37%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E4%BB%A3%E9%9B%BB%29
[1949a]:https://zh.wikisource.org/wiki/%E9%9B%BB%E7%9C%81%E5%B1%AC%E5%90%84%E6%A9%9F%E9%97%9C%E5%AD%B8%E6%A0%A1%E7%82%BA%E5%A5%89%E8%A1%8C%E6%94%BF%E9%99%A2%E9%9B%BB%E7%9F%A5%E6%9C%AC%E5%B9%B4%E5%A4%8F%E4%BB%A4%E6%99%82%E9%96%93%E4%BB%8D%E7%85%A7%E6%88%90%E4%BE%8B%E9%90%98%E9%BB%9E%E6%92%A5%E6%97%A9%E4%B8%80%E5%B0%8F%E6%99%82_%28%E6%B0%91%E5%9C%8B38%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E4%BB%A3%E9%9B%BB%29
[1949b]:https://zh.wikisource.org/wiki/%E9%9B%BB%E7%9C%81%E5%B1%AC%E5%90%84%E6%A9%9F%E9%97%9C%E5%AD%B8%E6%A0%A1%E7%82%BA%E6%9C%AC%E5%B9%B4%E5%A4%8F%E4%BB%A4%E6%99%82%E9%96%93%E8%87%AA%E4%BA%94%E6%9C%88%E4%B8%80%E6%97%A5%E9%9B%B6%E6%99%82%E8%B5%B7%E8%87%B3%E4%B9%9D%E6%9C%88%E5%8D%85%E6%97%A5%E5%8D%88%E5%BE%8C%E5%BB%BF%E5%9B%9B%E6%99%82%E6%AD%A2_%28%E6%B0%91%E5%9C%8B38%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E4%BB%A3%E9%9B%BB%29
[1950]:https://zh.wikisource.org/wiki/%E9%9B%BB%E7%9C%81%E5%B1%AC%E5%90%84%E6%A9%9F%E9%97%9C%E5%AD%B8%E6%A0%A1%E7%82%BA%E5%A5%89%E8%A1%8C%E6%94%BF%E9%99%A2%E4%BB%A4%E8%87%AA%E4%BA%94%E6%9C%88%E4%B8%80%E6%97%A5%E9%9B%B6%E6%99%82%E8%B5%B7%E6%96%BD%E8%A1%8C%E5%A4%8F%E4%BB%A4%E6%99%82%E9%96%93_%28%E6%B0%91%E5%9C%8B39%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E4%BB%A3%E9%9B%BB%29
[1951]:https://zh.wikisource.org/wiki/%E9%9B%BB%E7%9C%81%E5%B1%AC%E5%90%84%E6%A9%9F%E9%97%9C%E5%AD%B8%E6%A0%A1%E7%82%BA%E5%A5%89%E8%A1%8C%E6%94%BF%E9%99%A2%E4%BB%A4%E8%87%AA%E4%BA%94%E6%9C%88%E4%B8%80%E6%97%A5%E9%9B%B6%E6%99%82%E8%B5%B7%E6%96%BD%E8%A1%8C%E5%A4%8F%E4%BB%A4%E6%99%82%E9%96%93_%28%E6%B0%91%E5%9C%8B40%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E4%BB%A3%E9%9B%BB%29
[1952]:https://zh.wikisource.org/wiki/%E9%9B%BB%E6%9C%AC%E7%9C%81%E6%89%80%E5%B1%AC%E5%90%84%E6%A9%9F%E9%97%9C%E5%AD%B8%E6%A0%A1%E7%82%BA%E4%B8%89%E6%9C%88%E4%B8%80%E6%97%A5%E9%9B%B6%E6%99%82%E8%B5%B7%E5%85%A8%E5%9C%8B%E5%AF%A6%E8%A1%8C%E6%97%A5%E5%85%89%E7%AF%80%E7%B4%84%E6%99%82%E9%96%93_%28%E6%B0%91%E5%9C%8B41%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E4%BB%A3%E9%9B%BB%29
[1953]:https://zh.wikisource.org/wiki/%E4%BB%A4%E7%9C%81%E5%90%84%E6%A9%9F%E9%97%9C%E5%AD%B8%E6%A0%A1%E7%82%BA%E5%A5%89%E8%A1%8C%E6%94%BF%E9%99%A2%E4%BB%A4%E4%BB%A5%E5%9B%9B%E5%8D%81%E4%BA%8C%E5%B9%B4%E5%BA%A6%E6%97%A5%E5%85%89%E7%AF%80%E7%B4%84%E6%99%82%E9%96%93%E8%87%AA%E5%9B%9B%E6%9C%88%E4%B8%80%E6%97%A5%E9%9B%B6%E6%99%82%E8%B5%B7%E9%96%8B%E5%A7%8B%E5%AF%A6%E8%A1%8C_%28%E6%B0%91%E5%9C%8B42%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E4%BB%A4%29
[1954]:https://zh.wikisource.org/wiki/%E4%BB%A4%E5%90%84%E6%A9%9F%E9%97%9C%E5%AD%B8%E6%A0%A1%E7%82%BA%E5%A5%89%E8%A1%8C%E6%94%BF%E9%99%A2%E4%BB%A4%E7%9F%A5%E6%9C%AC%E5%B9%B4%E5%BA%A6%E6%97%A5%E5%85%89%E7%AF%80%E7%B4%84%E6%99%82%E9%96%93_%28%E6%B0%91%E5%9C%8B43%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E4%BB%A4%29
[1955]:https://zh.wikisource.org/wiki/%E4%BB%A4%E7%9C%81%E5%B1%AC%E5%90%84%E6%A9%9F%E9%97%9C%E5%AD%B8%E6%A0%A1%E7%82%BA%E5%A5%89%E8%A1%8C%E6%94%BF%E9%99%A2%E4%BB%A4%E7%9F%A5%E6%94%B9%E8%A8%82%E6%9C%AC%E5%B9%B4%E5%BA%A6%E6%97%A5%E5%85%89%E7%AF%80%E7%B4%84%E6%99%82%E9%96%93_%28%E6%B0%91%E5%9C%8B44%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E4%BB%A4%29
[1956]:https://zh.wikisource.org/wiki/%E4%BB%A4%E7%9C%81%E5%B1%AC%E5%90%84%E6%A9%9F%E9%97%9C%E5%AD%B8%E6%A0%A1%E7%82%BA%E5%B1%A4%E5%A5%89%E7%B8%BD%E7%B5%B1%E4%BB%A4%E6%9C%AC%E5%B9%B4%E6%97%A5%E5%85%89%E7%AF%80%E7%B4%84%E6%99%82%E9%96%93%E4%BB%8D%E8%87%AA%E5%9B%9B%E6%9C%88%E4%B8%80%E6%97%A5%E9%9B%B6%E6%99%82%E8%B5%B7%E8%87%B3%E4%B9%9D%E6%9C%88%E5%8D%85%E6%97%A5%E5%8D%88%E5%A4%9C%E5%BB%BF%E5%9B%9B%E6%99%82%E6%AD%A2%E4%B8%80%E6%A1%88%EF%BC%8C%E4%BB%A4%E5%B8%8C%E9%81%B5%E7%85%A7_%28%E6%B0%91%E5%9C%8B45%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E4%BB%A4%29
[1957]:https://zh.wikisource.org/wiki/%E4%BB%A4%E7%9C%81%E5%B1%AC%E5%90%84%E7%B4%9A%E6%A9%9F%E9%97%9C%E5%AD%B8%E6%A0%A1%E7%82%BA%E5%A5%89%E8%A1%8C%E6%94%BF%E9%99%A2%E4%BB%A4%E7%9F%A5%E5%AF%A6%E6%96%BD%E5%A4%8F%E4%BB%A4%E6%99%82%E9%96%93%E4%B8%80%E6%A1%88%EF%BC%8C%E8%BD%89%E5%B8%8C%E9%81%B5%E7%85%A7_%28%E6%B0%91%E5%9C%8B46%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E4%BB%A4%29
[1958]:https://zh.wikisource.org/wiki/%E4%BB%A4%E7%9C%81%E5%B1%AC%E5%90%84%E7%B4%9A%E6%A9%9F%E9%97%9C%E5%AD%B8%E6%A0%A1%E7%82%BA%E5%9B%9B%E5%8D%81%E4%B8%83%E5%B9%B4%E5%BA%A6%E5%A4%8F%E4%BB%A4%E6%99%82%E9%96%93%E8%87%AA%E5%9B%9B%E6%9C%88%E4%B8%80%E6%97%A5%E9%9B%B6%E6%99%82%E8%B5%B7%E5%AF%A6%E6%96%BD_%28%E6%B0%91%E5%9C%8B47%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E4%BB%A4%29
[1959]:https://zh.wikisource.org/wiki/%E4%BB%A4%E7%9C%81%E5%B1%AC%E5%90%84%E6%A9%9F%E9%97%9C%E5%AD%B8%E6%A0%A1%E7%82%BA%E5%A5%89%E4%BB%A4%E8%87%AA%E5%9B%9B%E6%9C%88%E4%B8%80%E6%97%A5%E5%AF%A6%E8%A1%8C%E5%A4%8F%E4%BB%A4%E6%99%82%E9%96%93%EF%BC%8C%E8%BD%89%E5%B8%8C%E9%81%B5%E7%85%A7_%28%E6%B0%91%E5%9C%8B48%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E4%BB%A4%29
[1960]:https://zh.wikisource.org/wiki/%E4%BB%A4%E7%9C%81%E5%B1%AC%E5%90%84%E7%B4%9A%E6%A9%9F%E9%97%9C%E5%AD%B8%E6%A0%A1%E3%80%81%E5%90%84%E7%B8%A3%E5%B8%82%E6%94%BF%E5%BA%9C%EF%BC%88%E5%B1%80%EF%BC%89%E7%82%BA%E6%8A%84%E7%99%BC%E6%9C%AC%E5%BA%9C%E6%9A%A8%E6%89%80%E5%B1%AC%E5%90%84%E7%B4%9A%E6%A9%9F%E9%97%9C%E5%85%A8%E5%B9%B4%E5%90%84%E6%9C%88%E4%BB%BD%E8%BE%A6%E5%85%AC%E6%99%82%E9%96%93%E8%A1%A8%E5%8F%8A%E5%9B%9B%E5%8D%81%E4%B9%9D%E5%B9%B4%E5%A4%8F%E4%BB%A4%E6%99%82%E9%96%93%E8%B5%B7%E6%AD%A2%E6%97%A5%E6%9C%9F%EF%BC%8C%E5%B8%8C%E9%81%B5%E7%85%A7_%28%E6%B0%91%E5%9C%8B49%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E4%BB%A4%29
[1961]:https://zh.wikisource.org/wiki/%E4%BB%A4%E7%9C%81%E5%B1%AC%E5%90%84%E7%B4%9A%E6%A9%9F%E9%97%9C%E5%AD%B8%E6%A0%A1%E7%82%BA%E4%BA%94%E5%8D%81%E5%B9%B4%E5%A4%8F%E4%BB%A4%E6%99%82%E9%96%93%E8%87%AA%E5%85%AD%E6%9C%88%E4%B8%80%E6%97%A5%E9%9B%B6%E6%99%82%E8%B5%B7%E8%87%B3%E4%B9%9D%E6%9C%88%E4%B8%89%E5%8D%81%E6%97%A5%E5%8D%88%E5%A4%9C%E4%BA%8C%E5%8D%81%E5%9B%9B%E6%99%82%E6%AD%A2%EF%BC%8C%E5%B8%8C%E9%81%B5%E7%85%A7_%28%E6%B0%91%E5%9C%8B50%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E4%BB%A4%29
[1962]:https://zh.wikisource.org/wiki/%E8%A1%8C%E6%94%BF%E9%99%A2%E4%BB%A4%E4%BA%94%E5%8D%81%E4%B8%80%E5%B9%B4%E5%A4%8F%E4%BB%A4%E6%99%82%E9%96%93%E6%AF%8B%E9%A0%88%E5%BE%AA%E4%BE%8B%E8%BE%A6%E7%90%86%E5%8F%8A%E5%90%84%E6%A9%9F%E9%97%9C%E8%BE%A6%E5%85%AC%E6%99%82%E9%96%93%E4%BB%8D%E7%85%A7%E5%8E%9F%E8%A6%8F%E5%AE%9A%E8%BE%A6%E7%90%86%E6%A1%88_%28%E6%B0%91%E5%9C%8B51%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E4%BB%A4%29
[1974]:https://zh.wikisource.org/wiki/%E8%A1%8C%E6%94%BF%E9%99%A2%E5%87%BD%E7%82%BA%E7%AF%80%E7%B4%84%E7%94%A8%E9%9B%BB%E5%AF%A6%E6%96%BD%E3%80%8C%E6%97%A5%E5%85%89%E7%AF%80%E7%B4%84%E6%99%82%E9%96%93%E3%80%8D%E8%87%AA%E5%9B%9B%E6%9C%88%E4%B8%80%E6%97%A5%E9%9B%B6%E6%99%82%E8%B5%B7%E8%87%B3%E4%B9%9D%E6%9C%88%E4%B8%89%E5%8D%81%E6%97%A5%E4%BA%8C%E5%8D%81%E5%9B%9B%E6%99%82%E6%AD%A2_%28%E6%B0%91%E5%9C%8B63%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E5%87%BD%29
[1975]:https://zh.wikisource.org/wiki/%E8%A1%8C%E6%94%BF%E9%99%A2%E5%87%BD%E7%82%BA%E7%AF%80%E7%B4%84%E7%94%A8%E9%9B%BB%E5%AF%A6%E6%96%BD%E3%80%8C%E6%97%A5%E5%85%89%E7%AF%80%E7%B4%84%E6%99%82%E9%96%93%E3%80%8D%E8%87%AA%E5%85%AD%E5%8D%81%E5%9B%9B%E5%B9%B4%E5%9B%9B%E6%9C%88%E4%B8%80%E6%97%A5%E9%9B%B6%E6%99%82%E8%B5%B7%E8%87%B3%E4%B9%9D%E6%9C%88%E4%B8%89%E5%8D%81%E6%97%A5%E4%BA%8C%E5%8D%81%E5%9B%9B%E6%99%82%E6%AD%A2_%28%E6%B0%91%E5%9C%8B64%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E5%87%BD%29
[1976]:https://zh.wikisource.org/wiki/%E5%A4%8F%E4%BB%A4%E3%80%8C%E6%97%A5%E5%85%89%E7%AF%80%E7%B4%84%E6%99%82%E9%96%93%E3%80%8D%E8%87%AA%E6%9C%AC%E5%B9%B4%E8%B5%B7%E5%81%9C%E6%AD%A2%E5%AF%A6%E6%96%BD_%28%E6%B0%91%E5%9C%8B65%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E5%87%BD%29
[1979]:https://zh.wikisource.org/wiki/%E5%87%BD%E8%BD%89%E8%A1%8C%E6%94%BF%E9%99%A2%E8%A6%8F%E5%AE%9A%E7%AF%80%E7%B4%84%E8%83%BD%E6%BA%90%E5%AF%A6%E6%96%BD%E3%80%8C%E6%97%A5%E5%85%89%E7%AF%80%E7%B4%84%E6%99%82%E9%96%93%E3%80%8D_%28%E6%B0%91%E5%9C%8B68%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E5%87%BD%29
[1980]:https://zh.wikisource.org/wiki/%E5%87%BD%E7%9F%A5%E5%85%AD%E5%8D%81%E4%B9%9D%E5%B9%B4%E5%81%9C%E6%AD%A2%E5%AF%A6%E6%96%BD%E3%80%8C%E6%97%A5%E5%85%89%E7%AF%80%E7%B4%84%E6%99%82%E9%96%93%E3%80%8D%E5%8F%8A%E9%87%8D%E6%96%B0%E8%A6%8F%E5%AE%9A%E7%9C%81%E5%B1%AC%E5%90%84%E6%A9%9F%E9%97%9C%E8%BE%A6%E5%85%AC%E6%99%82%E9%96%93_%28%E6%B0%91%E5%9C%8B69%E5%B9%B4%E8%87%BA%E7%81%A3%E7%9C%81%E6%94%BF%E5%BA%9C%E5%87%BD%29

[taiwan-province-gazette]:http://subtpg.tpg.gov.tw/og/q1.asp
[ncl-gazette]:http://gaz.ncl.edu.tw/
[taiwan-soutokuhu-gazette]:http://db2.th.gov.tw/db2/view/