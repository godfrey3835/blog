---
layout: post
title: "在鼠鬚管 (Squirrel) 使用嘸蝦米"
published: true
date: 2013-12-10 19:06
tags:
- mac
- "輸入法"
- "嘸蝦米"
- Squirrel
categories: []
redirect_from: /posts/2013/12/10/use-boshiamy-in-squirrel
comments: true

---
使用嘸蝦米，證明

![Screen Shot 2013-12-05 at 00.45.57.png](http://user-image.logdown.io/user/2580/blog/2567/post/165576/YoH4WwNDRN6dE5No4yU4_Screen%20Shot%202013-12-05%20at%2000.45.57.png)

## What?

鼠鬚管 Squirrel 是 Mac 上面以一個叫做「[中州韻 RIME](https://code.google.com/p/rimeime/)」為核心的輸入法，通常拿來當做漢語拼音輸入，而且拼音的對照表是用繁體編出來的，要打簡體的時候再轉成簡體，所以原生就支援繁體拼音，對於我這種需要繁體拼音的人來說非常方便。更多關於這套輸入法的介紹，可以參考[〈推薦一個神級輸入法——Rime〉](https://www.byvoid.com/blog/recommend-rime)這篇文章。

注意到我稱中州韻為「核心」，Squirrel 實際上是 RIME 的 Front-End ，所以這次做出來的 RIME 輸入法設定檔，理論上可以用在他的 Windows 和 Linux 版 Front-End。Windows 的叫做小狼毫。不過我平常沒在用 Windows ，所以我沒用過。聽說目前還不支援 Windows 8 ……。

<!--more-->

## Why?

1. 官方版的[嘸蝦米 for Mac](http://boshiamy.com/product_mac.shtml) 輸入框常常亂跳，很礙眼。
* 做為一個 Geek 想要試試看。
* RIME 有漢語拼音，比起注音我更習慣漢語拼音，我要可以隨時切換到拼音。
* 鼠鬚管可以自訂的選項比較多，像是顏色、字體都可以自己改。
* Yahoo! 奇摩輸入法不維護了，可是 RIME 系列現在還是 active development ，當然要選這一邊站。

大約五年前我寫過一篇[〈如何使用 Windows 正版嘸蝦米製作超強版嘸蝦米 CIN 檔〉](http://blog.yorkxin.org/posts/2009/01/11/make-a-hyper-boshiamy-cin-from-its-win-vers)，現在我已經沒在用 Yahoo! 奇摩輸入法了。現在正是時機再試一次（？）

## 有支援的功能

**打繁出簡** - RIME 內建的繁轉簡機制，不同於官蝦是兩個碼表。

**日文漢字模式** - 另一個 table ，註冊成另一個輸入法。

![Screen Shot 2013-12-05 at 01.07.27.png](http://user-image.logdown.io/user/2580/blog/2567/post/165576/ORswcJpWQ7WOUHivlBIc_Screen%20Shot%202013-12-05%20at%2001.07.27.png)

**漢語拼音輸入模式** - RIME 內建的「切換到拼音」的輸入方式，支援反查。按 <kbd>&#96;</kbd> 鍵進入拼音模式，我很想改成 `';` <del>但試了很久試不出來</del>。跟官蝦的注音一樣，是臨時不會拆的時候應急用的。附帶一提，因為是啟動 RIME 內建的拼音輸入法，所以可以以詞為單位輸入。（話說「`han`」竟然沒有「和」這個有點兩光啊……）

**Update**: 改好了，從 v0.2.0 開始是用 `';` 來切換到拼音模式

![Screen Shot 2013-12-11 at 21.39.35.png](http://user-image.logdown.io/user/2580/blog/2567/post/165576/W0D6Mjd3Syu733JET4Nb_Screen%20Shot%202013-12-11%20at%2021.39.35.png)

**找不到字碼 fallback 到英文輸入**，例如：

![Screen Shot 2013-12-05 at 01.03.58.png](http://user-image.logdown.io/user/2580/blog/2567/post/165576/D337QUufRxK0OuR1mkPc_Screen%20Shot%202013-12-05%20at%2001.03.58.png)

## 不支援的功能（官蝦支援的）

* `，，Ｔ` 、`，，ＣＴ` 、`，，Ｊ`
* 注音反查
* liu.box
* 強迫快打／快打反查
* 符號表

## RIME 有支援但沒有使用

* Unicode Ext 擴展漢字 - RIME 有內建「可以組出擴展區的漢字」的選項
* 以詞為單位的自動選字 - 讓「所以」（`ＦＫＩ　Ｕ`）不會再打成「斷護」（`ＦＫ　ＩＵ`）、「然後」（`ＪＦＡ　Ｉ`）不會再打成「撫俞」（`ＪＦ　ＡＩ`）的自動修正演算法。這個我很希望有啊……

## How?

到 https://github.com/chitsaou/rime-boshiamy/releases/latest 下載我寫的轉檔暨安裝程式。

接著，準備正版嘸蝦米的 ibus 字根表，事實上很好找，只要買過正版（無論是 Windows 還是 Mac），就可以去官方網站下載。

![Screen Shot 2013-12-05 at 01.32.03.png](http://user-image.logdown.io/user/2580/blog/2567/post/165576/QkO7UI1AR1W6v31cHeIp_Screen%20Shot%202013-12-05%20at%2001.32.03.png)

把 `boshiamy_*.db` 放到轉換程式的資料夾裡面，然後執行：

```sh
# ~/Downloads/boshiamy-ibus
./install.sh
```

這樣子會把轉換過後的字典檔和 schema 檔複製到 RIME 的用戶資料夾裡面。

最後再把輸入法註冊在 Squirrel 上面，重新 Deploy 就行了。

```diff
# default.custom.yaml
 patch:
   schema_list:
     - schema: luna_pinyin
     - schema: cangjie5
     - schema: luna_pinyin_fluency
     - schema: luna_pinyin_simp
     - schema: luna_pinyin_tw
+    - schema: boshiamy_t
+    - schema: boshiamy_j
```

## Conslusion

親測兩個月，覺得比官蝦順眼，至少我可以自訂配色、字體之類的。

不過，直式選字窗在 Facebook 右下角聊天的時候還是會跳來跳去的，這個具體你試陣子就知道了……。

## 關於智慧財產權的問題

發佈之前我想了很久，到底會不會踩到著作權和商標權的問題。我知道我沒有發佈表格檔應該不會踩到著作財產權的問題，並且嘸蝦米的專利已經過期了，做出 schema 檔也沒有問題。主要有疑慮的是「轉檔程式」和「使用了『嘸蝦米』這個商標」。

不過大致上搜尋了一下， Linux 界有人是自己做碼表再取名叫 Noseeing 來迴避商標的問題，但也有一些專案直接用了 "boshiamy" 這個名字。

至於官方的授權書裡面是這樣寫的（錄自 ibus 表格檔的 README）：

> 本安裝套件之所有內容（包含表格檔、圖示檔及相關文件）均為 行易有限公司 (http://boshiamy.com) 版權所有。
> 
> 本公司授權合法持有嘸蝦米輸入法 7.0 非試用版之使用者自行利用，惟使用者不得任意更改此表格中每個字的編碼規則以及本套件之任何內容，亦不得以轉換格式或片段節錄等任何方法重新散佈！此表格授權使用範圍與使用者持有之授權合約書所載範圍相同，其他未載明之事項，一律依原授權合約書內容辦理之。

我不是法律專家，只看這些文字我還是認為沒有踩到線……。

類似的專案像是 [ethanliu/ibus2cin](https://github.com/ethanliu/ibus2cin) 這個把嘸蝦米 ibus 表格檔轉成 cin 的（跟我做的事很像），上次更新是 2012 年 1 月的事。

---

不過話說回來，我可是一直強調請你去買正版的喲！這種天天用的東西，讓你產能++ 的東西，一千塊錢不貴吧？