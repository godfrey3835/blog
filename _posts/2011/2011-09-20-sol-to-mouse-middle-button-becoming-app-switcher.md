---
layout: post
title: 'Mac OS X: 滑鼠中鍵變成切換應用程式的解法'
published: true
date: 2011-09-20 00:00
tags:
- mac
categories: []
redirect_from: /posts/2011/09/20/sol-to-mouse-middle-button-becoming-app-switcher
comments: true

---

前幾天我從強者我朋友手中借來一台 MacBook ，接上一般的滑鼠之後，發現滑鼠中鍵失效了，變成切換應用程式，也就是 Command + Tab 會出現的畫面。滑鼠中鍵對我來說是非常重要的一個按鍵，我用來在終端機貼上、開啟新分頁，沒有它我就像少了一隻手指頭。

所以我花了兩個小時找答案。

答案就在 <code>~/Library/Preferences/com.apple.symbolichotkeys.plist</code> 裡面，打開它（用 Xcode），在 <code>AppleSymbolicHotKeys</code> 這個 Dictionary 中，刪除編號為 <code>71</code> 的項目，再登入，就好了。

那為什麼這樣會好呢？以下是 trouble-shooting 的過程。

---

<!--more-->

為了確認是軟體或硬體問題，我開了一個新的帳號，結果該帳號的中鍵運作正常，可見是帳號的偏好設定。

於是就跑去滑鼠偏好設定找，發現沒有可以指定中鍵按下去的行為的設定。但是 Google 了一下，在 <a href="http://support.apple.com/kb/HT1581" target="_blank">Mighty Mouse 的偏好設定面板</a>裡面有，可見這台 MacBook 之前應該是接了 Mighty Mouse 並設定中鍵 = 切換應用程式，才會有這個問題。

那簡單啦，就是把 Mighty Mouse 接回來然後改設定。可是我又沒有 Mighty Mouse ，那只好自己 trace 了。但是我翻遍了 <code>~/Library/Preferences</code> 、 <code>/Library/Preferences</code> 關於滑鼠的設定檔 (<code>.plist</code>) ，都沒有指定 Mouse Button 3 的行為。甚至隱藏檔 <code>~/Library/Preferences/.GlobalPreferences.plist</code> （個人的系統偏好設定）也沒有。怎麼辦呢？

於是我想，每次 Dock 當掉都會導致 Command + Tab 失效，所以它應該也是 Dock 管的，而 Dock 跟 Exposé 是神聖不可分割的，所以我到 Exposé &amp; Spaces （那部 MacBook 執行 Mac OS X 10.6）偏好設定，把 Exposé 的所有視窗指定給 Mouse Button 3 ，馬上就出現黃色三角形，表示有衝突。再按下中鍵，的確變成 Exposé 的所有視窗。那是跟誰衝突呢？找不到呀。

於是去看了 <code>~/Library/Preferences</code> ，根據「修改日期」降冪排序，發現有一個檔案 <code>com.apple.symbolichotkeys.plist</code> ，每當我改變 Exposé 的滑鼠觸發鍵時，就會被修改，那應該跟他有關。

於是去 Google 關於這個檔案的資料，原來是跟快速鍵設定有關。到這裡我以為它只跟鍵盤有關，懷疑了很久，還試著找 Apple 官方的開發者文件，但不曉得是關鍵字下錯還是怎樣，總之就是找不到。

那就土法煉鋼，既然是 plist ，它好歹是 XML 檔案，用 <code>diff</code> 總行了吧？不過因為它是 binary XML ，不能 diff ，要使用 Xcode 的 Property List Editor ，另存新檔成 plain-text XML 就可以了（如果是 Xcode 4.x ，就得使用 <code>plutil -convert xml1 xxxx.plist</code> 這個指令來轉成 XML）。

我先把右鍵設成「所有視窗」，另存新檔。接著設為中鍵，再另存新檔。接著再設為第四鍵（這滑鼠就是有五鍵），再另存新檔。拿 Xcode 內建的 FileMerge 來看，三個檔案交叉比較，有兩個項目，分別是 38 和 40 ，裡面的值會隨著我更改 Exposé 設定而變動，大概像這樣：

```xml
<key>38</key>
<dict>
  <key>enabled</key>
  <true/>
  <key>value</key>
  <dict>
    <key>parameters</key>
    <array>
      <integer>2</integer><!-- ☆ -->
      <integer>2</integer><!-- ☆ -->
      <integer>0</integer>
    </array>
    <key>type</key>
    <string>button</string>
  </dict>
</dict>
<key>40</key>
<dict>
  <key>enabled</key>
  <true/>
  <key>value</key>
  <dict>
    <key>parameters</key>
    <array>
      <integer>2</integer><!-- ☆ -->
      <integer>2</integer><!-- ☆ -->
      <integer>131072</integer>
    </array>
    <key>type</key>
    <string>button</string>
  </dict>
</dict>
```

打☆的那 4 行，當設為右鍵（第二鍵）時是 <code>2</code>，設為中鍵（第三鍵）時是 <code>4</code> ，設為第四鍵時是 <code>8</code> 。至於第 40 項的 <code>131072</code> ， Google 告訴我這個代表 Shift ，我想應該就是慢動作 Exposé 吧。

到這裡就明白了，中鍵的號碼是 <code>4</code> ，會衝突就代表還有另一個項目也是設為 <code>4</code> 。那怎麼找呢？我使用一般的文字編輯器，在設為中鍵（提示有衝突）的檔案裡，找 `<integer>4</integer>` 這個字串，果然在第 71 項裡面發現了一樣的陣列，裡面也是三個整數 <code>4</code>, <code>4</code>, <code>0</code> ，在其他地方都沒找到。就是他了。刪掉他，登出再登入，解決。

以上就是整個流程。我 Google 了很久都沒有答案，寫下來給以後遇到相同問題的人參考。有空我再翻譯成英文吧～
