---
layout: post
title: "我的 Mac OS X Snow Leopard 字型改這樣"
published: true
date: 2009-10-29 00:00
tags: []
categories: []
redirect_from: /posts/2009/10/29/my-snow-leopard-defaultfontfallbacks-plist
comments: true

---

其實我很愛 HeitiTC 的漢字。

但也僅限於漢字 …它的日文假名和注音符號真的有夠醜！

在使用 Snow Leopard  三天之後決定換掉了。

不過不是用 TCFail 而是手動改的，因為他提供的選項不符需求。

什麼意思呢？

就是我想要看 Hiragino 的漢字卻又想要有粗體。

<a href="http://zonble.github.com/tcfail/">TCFail</a> 提供的ヒラギノ角ゴ並沒有辦法顯示粗體，而真正 Mac OS X 使用的日文字型是 AquaHiraKaku (Lucida Grande 的拉丁字、 AquaKana 的假名、 Hiragino Kaku Pro N W3 的漢字)。

然後很意外地 Snow Leopard 竟然有簡體中文版的 Hiragino Sans GB，就拿它來當 fallback 字體了。（靠！為什麼沒有繁體中文版的）

看起來非常愉悅！

注音符號也終於有圓角了，除了在 menubar 上面的 = =

另一個缺點是注音符號的「ㄧ」會變成直的...
<p style="text-align:center;"><a href="http://chitsaou.files.wordpress.com/2009/10/e89ea2e5b995e5bfabe785a7-2009-10-29-21-43-32.png"><img class="aligncenter size-full wp-image-676" title="螢幕快照 2009-10-29 21.43.32" src="http://chitsaou.files.wordpress.com/2009/10/e89ea2e5b995e5bfabe785a7-2009-10-29-21-43-32.png" alt="螢幕快照 2009-10-29 21.43.32" width="706" height="172" /></a>
我的 <a href="http://gist.github.com/221439">DefaultFontFallbacks.plist 在這裡</a>。

修改的方法很簡單

到這個檔案夾：

<blockquote><code>/System/Library/Frameworks/ApplicationServices.framework \ <br />
Versions/A/Frameworks/CoreText.framework/ \<br />
Versions/A/Resources</code></blockquote>

或按 TCFail 的 工具 → 開啟設定檔所在資料夾

把 DefaultFontFallbacks.plist 複製出來

改一改

再把改好的檔案丟回去（需要 Root 權限）

接下來開啟的程式都會遵照這個設定，當然你要登出也不是不行。
