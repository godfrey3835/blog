---
layout: post
title: Chrome 18 以上中文字體變醜的原因及暫時解法
published: true
date: 2012-05-03 21:43
tags:
- chrome
- font
- webkit
- web development
categories: []
redirect_from: /posts/2012/05/03/chrome-18-chinese-font-fail-and-solution
comments: true

---
**長話短說：** Chrome 22 [直接安裝 Extension](https://chrome.google.com/webstore/detail/lndmkajeoopejggihiomoaepinlhblmm) 、 Chrome 21 以下[請至這裡看安裝說明](https://github.com/chitsaou/no-per-script-font)。

最近 Chrome 18 Stable 版本發佈。有些人發現了一個問題：**中文字體變醜了**。所謂的醜，具體上來說是「**使用了另一種大家以前不習慣的字體**」。

你會在 Facebook 、 Plurk 等網站看到「跟以前不太一樣的中文字」，例如以下是 Facebook 的字體在 Chrome 18 以前及 Chrome 18 的比較：

[![](/images/2012/2012-05-03-chrome-18-chinese-font-fail-and-solution/chrome-18-font-windows.png)](http://cl.ly/3V140u3q2W3m3K2d2Z45)

甚至是在 Wikipedia 載入的過程中看到字體會跳動。有影片為證：

http://www.youtube.com/watch?v=_vvJakSs_Rk

## OS X 版本：日文假名、英文字一起遭殃

好死不死的是，在 OS X 的 Chrome 是把簡體中文換成 STHeiti （华文黑体，長得很像 Heiti SC ，也就是 OS X 預設的系統字體「黑體-繁」的簡體版），因為我把系統字體換成 Hiragino Sans GB ，所以就又看到了**天底下最醜的日文假名**：

[![](/images/2012/2012-05-03-chrome-18-chinese-font-fail-and-solution/chrome-18-kana.png)](http://cl.ly/3O3q462W1j0Z1S1J2X3r)

還有，在 OS X 的繁體中文換成儷黑 Pro ，導致以往在 OS X 會自動 fallback 到系統字體 Helvetica 的拉丁字，現在全都走樣了：

[![](/images/2012/2012-05-03-chrome-18-chinese-font-fail-and-solution/chrome-18-latin.png)](http://cl.ly/0w3e2y1E3m1Y0s2c1p0k)

完整的 test case 可以打開這個網頁： http://jsbin.com/IQeLOLI/1

我對字體比一般人敏感，所以當我在 beta 發現這些事的時候，非常受不了，就換回 stable 了，以為這是 bug 總有一天會修好的，結果竟然上了 stable （！）。

此外，我還很討厭 Heiti SC / Heiti TC 或儷黑 Pro 當做內文字體，主因是 OS X 裡面的 Heiti 系列字體，粗體不夠粗，而儷黑 Pro 沒有粗體（你看到的都是軟體模擬的），這我不能接受。因此實際上我的 OS X 是換成英文版，並且通過 [TCFail](http://zonble.github.com/tcfail/) 協助把中文的字體改成 Hiragino Sans GB （佟青黑體）。沒記錯的話，當時 TCFail 就是因為大家討厭 Heiti TC 所以才出現的修改器。

Chrome 是我打開電腦到關閉電腦都會使用的軟體，一天到晚看著它，當然希望要看到漂亮的字體（至少是我自己修改作業系統設定到滿意的），而不是由他自己決定字體。

## Chromium Team: 要讓大家可以依文字換字體

既然是碼農，又剛好 Chrome 是 Open Source 的 Chromium 改來的，那當然要發揮碼農的天性：「**開票問！**」我去 Chromium 的 issue tracker 很兇地問說[為什麼要由 Chrome 自行決定字體](http://code.google.com/p/chromium/issues/detail?id=121461)？使用系統的 fallback 不好嗎？

<!-- more -->

結果這部份的負責人（？）很客氣地回我說這是長期以來的計畫，早在 2008 年就打算要加入像 Firefox 那種，可以[依書寫文字 (script) 自己指定 Generic Font Family 的字體](http://code.google.com/p/chromium/issues/detail?id=2685)的功能（Per-Script Font）。只是現階段的字體名稱是寫死的，要以後才會加入可以讓使用者自由設定的介面。為此還加入了一個實驗中的 API ，可以讓 extension 設定書寫文字的字體，還附一個[測試用的 extension](http://code.google.com/p/chromium/issues/detail?id=114805)。另外他也說到，將字體名稱設為空字串 `""` 的話，這個功能就會被停用 。

如果仔細去看那張票，會發現底下有人抱怨「我在學日文，結果泥馬給我看中文漢字害我都寫錯！！！」（[#44](http://code.google.com/p/chromium/issues/detail?id=2685#c44), [#54](http://code.google.com/p/chromium/issues/detail?id=2685#c54), [#65](http://code.google.com/p/chromium/issues/detail?id=2685#c65)）。記錄上可以發現在 2012 年 1 月左右，這個「功能」開始實作，還有 [feature proposal](https://sites.google.com/a/chromium.org/dev/developers/design-documents/extensions/proposed-changes/apis-under-development/font-settings)。

但滿足了學日文的人，卻苦到中文世界的人。

## 中文字體亂跳的原因

為什麼說是爽到日文人，苦到中文人？因為日文只有一種書寫文字，但中文有兩種：繁體中文（`Hant`） 和簡體中文（`Hans`）。既然 Chrome 是根據「書寫文字」來判斷，那問題就是「怎麼判斷是哪種文字」？很顯然必須一個準則。所以我打開了 Inspector ，看到如下事實：

1. Facebook 的 `<html>` tag 其 `lang` 屬性是 `zh`。
2. Wikipedia 中文版的 `div#mw-content-text` 其 `lang` 屬性，原始碼是寫 `zh` ，但 inspector 卻是寫 `zh-tw` ，說明了在某個時候有執行 JavaScript ，將它改為 `zh-tw` ，造成「字體跳一下」。

所以我的推論是：**當 `lang` 是 `zh` 的時候， Chrome 將它視為簡體中文**。……好啦其實很符合現實狀況。

## 透過 Exntesion 來「修正」這個問題

既然都有 [experimental API](http://code.google.com/chrome/extensions/beta/experimental.fontSettings.html) 可以用了（而且已經上 beta channel），又有測試用的 Extension 可以玩，那能不能把字體設為空字串來關掉這個功能，直到 Chromium 最終把那傳說中的選項頁面實作出來呢？

可以！[我做了一個 exntesion](https://github.com/chitsaou/no-per-script-font) ，來**自動把繁體中文、簡體中文的字體都設為空字串**，使「依書寫文字決定字體」的功能失效，回歸給作業系統來處理。

首先你要確定 Google Chrome 版本是 19 以上。只想先看看效果的話，也可以用 [Chrome Canary](https://tools.google.com/dlpage/chromesxs) ，它的設定檔是獨立於 Chrome ，但根據我的實驗，如果在 Windows 的話，要把 Canary 的顯示語言換成繁體中文，才能套用到繁體中文的系統字體。

然後如果你的 Chrome 版本是 21 （含）以下，要再打開 Experimental Extension API：在網頁列輸入 `chrome://flags` 按下 enter ，接著找到「**實驗性擴充功能 API**」（Experimental Extension APIs）這個項目，按下「啟用」（Enable）之後， Chrome 會提醒你重新啟動 Chrome ，按下去就是了。

接著到[這裡](https://github.com/chitsaou/no-per-script-font/downloads)下載我所做的 Chrome Extension ，是一個 `.crx` 的檔案（20 版和 22 版目前的 API 不一樣，請下載正確的版本）。下載完成後 Chrome 應該會問你要不要安裝，如果沒有的話，再把那檔案挖出來，並且按兩下安裝。

它會把繁體中文（`Hant`）和簡體中文（`Hans`）的 `standard` 、 `serif`  、 `sansserif` 、 `fixed` 字體都直接設定為空字串 `""`，來關掉 per-script font 的功能，也就是跟以前一樣，讓作業系統來決定中文的字體。現有的分頁可能不會馬上看到改變，要開新的分頁（新的 process）才會看到改變。

像是 **Wikipedia 字體不再亂跳**了、在 Windows 上面， **Facebook 終於回到原本的新細明體**了、在 **OS X 終於不用再看噁心的日文假名**了、**Helvetica 回來了**、<s>正直和良知也都回來了（誤）</s>。

[![](/images/2012/2012-05-03-chrome-18-chinese-font-fail-and-solution/chrome-18-no-per-script-font-comparison.png)](http://cl.ly/3h1z1j1U2w1l010f3I2R)

這個 Extension 使用了還在測試中的 [`chrome.experimental.fontSettings` API](http://code.google.com/chrome/extensions/beta/experimental.fontSettings.html) ，也就是這個 extension 可能哪天就不能用了。事實上我在寫這篇文章的同時，就發現了 Canary 上了[新版本的 API](http://code.google.com/chrome/extensions/dev/experimental.fontSettings.html) ，稍微有點不同，會導致原本在 Beta 版做的 extension 失效。

**Update**: 我有更新到支援 Chrome 22 了，在這個版本裡面， fontSettings 已經不再屬於 experimental API 。

## 完全自訂字體（官方的測試用 Extension）

除了全部改用空字串來關掉功能之外，當然也可以自訂字體，而這也是 Chromium Team 的目標。前文提及， Chromium Team 為了這個 API 製作測試用的 Extension ，以下就來說明如何安裝。

跟我做的 Extension 一樣，它只能安裝在 Chrome 19 ，不能用在 20 以上（目前的 Dev / Canary），理由一樣是他們最近改了 API 的 method name ，簡單來說就是不相容。哪天它也上了 Beta 版我會更新此文，基本上就表示這個 extension 不能直接拿來用了。

首先[按這裡下載](https://src.chromium.org/viewvc/chrome/trunk/src/chrome/common/extensions/docs/examples/api/fontSettings.zip?revision=126853&pathrev=126853)那個測試用的 Extension（[來自原 Patch](https://src.chromium.org/viewvc/chrome?view=rev&revision=126853)），解壓縮後你會看到資料夾裡面有一個 `manifest.json` ，記得這個資料夾。然後到擴充套件裡，先打勾右上角的「開發人員模式」（Developer mode），再按下「載入未封裝的擴充套件...」（Load unpacked extension…），瀏覽到你剛剛解壓縮並發現 `manifest.json` 的資料夾。

這樣會出現一個叫做 **Font Settings** 的擴充套件，視窗右上角工具列會出現一個小按鈕。按下它，就可以選擇書寫文字以及其 generic font family 的字體。如果你是用 OS X 打開，你會發現繁體中文被設為 LiHei Pro 及 LiSung Pro，簡體中文被設為 STHeiti 及 STSong 。這當然不是我要的（笑）。

我的設定方法是：**全部照抄「偏好設定」裡面的全域字體**，也就是讓作業系統去決定要用什麼中文字體，如下圖是我在 Windows 設定的方法（繁體、簡體都要改）：

[![](/images/2012/2012-05-03-chrome-18-chinese-font-fail-and-solution/chrome-18-fontsettings-windows.png)](http://cl.ly/0R3K1j452y3J130n0R0t)

如果是 OS X ，預設應該是 Standard = Times, Serif = Times, Sans-Serif = Helvetica ，這樣設定不會吃虧。

## 目前的 Per-Script 字體

如果你好奇的話，以下是目前 Chrome 在繁體中文、簡體中文預設的字體，透過 Extension API 查詢而得。其中「無指定」的意思是它會 fallback 到 Global Font：

<table>
    <tr>
        <th>Script</th><th>Generic Family</th><th>Font Name (OS X)</th><th>Font Name (Windows)</th>
    </tr>
    <tr>
        <td rowspan="4">繁體中文（Hant）</td><td>Standard</td><td>LiHei Pro</td><td>新細明體</td>
    </tr>
    <tr>
        <td>Serif</td><td>LiSong Pro</td><td>新細明體</td>
    </tr>
    <tr>
        <td>Sans-Serif</td><td>LiHei Pro</td><td>新細明體</td>
    </tr>
    <tr>
        <td>Fixed</td><td>（無指定）</td><td>細明體</td>
    </tr>
    <tr>
        <td rowspan="4">简体中文（Hans）</td><td>Standard</td><td>华文黑体（STHeiti）</td><td>SimSun</td>
    </tr>
    <tr>
        <td>Serif</td><td>华文宋体（STSong）</td><td>SimSun</td>
    </tr>
    <tr>
        <td>Sans-Serif</td><td>华文黑体（STHeiti）</td><td>SimSun</td>
    </tr>
    <tr>
        <td>Fixed</td><td>（無指定）</td><td>NSimSun</td>
    </tr>
</table>

## 結語

就像前面所說的， Chrome 是我從開機就會一直使用的軟體，也就是說它顯示的字體好壞，關係著我的心情，尤其是整個作業系統裡面，就只有 Chrome 的字體不一樣，這樣的感覺實在不舒服。

我一直把它當做是個 bug ，沒想到 Chromium Team 把它當 feature 來做。我比較希望它是個選項，而不是一定要打開的功能。當然這個功能的負責人說它還在試驗中，愈多的反饋可以讓他愈早 merge 新版本進 stable ，如果不出聲的話，或許就會當做是默認了。

**Update**: 所以我想到了一個可以兩全其美的方法，並另外[開了一張票給 Chromium](https://code.google.com/p/chromium/issues/detail?id=126103) ，希望是可以被 approved 啦。當然我還是會繼續選擇關閉 per-script font 的功能，因為我不想看到那些醜到爆的英文數字 =..=
