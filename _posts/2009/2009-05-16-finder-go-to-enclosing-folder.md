---
layout: post
title: A "Go to Enclosing Folder" button for Finder / 「前往上層檔案夾」的 Finder 按鈕 (Leopard
  Only)
published: true
date: 2009-05-16 00:00
tags: []
categories: []
redirect_from: /posts/2009/05/16/finder-go-to-enclosing-folder
comments: true

---

(繁體中文翻譯在底下)

I would like to bring the "Go to Parent Directory" feature to my Mac OS X's Finder, which is available since Windows 95.

Although there are already many solutions that you may found with Google (e.g. <a href="http://hasseg.org/blog/?p=114">this</a>, <a href="http://www.macosxhints.com/article.php?story=20070326144320146">this</a> and <a href="http://setupmac.com/addons/finder-up-button/">this</a>), I still want to make it myself.

All the three solutions are written in AppleScript, calling the built-in AppleScript functions of Finder.  However I think it would be faster if we just trigger the Menu Item.

<a title="Flickr 上 chitsaou 的 Mac OS X Finder Go to Enclosing Folder English" href="http://www.flickr.com/photos/chitsaou/3535586004/"><img src="http://farm3.static.flickr.com/2406/3535586004_9907809b2c_o.png" alt="Mac OS X Finder Go to Enclosing Folder English" width="265" height="358" /></a>

After I studied <a href="http://www.macosxhints.com/article.php?story=20060921045743404">an article which teaches you how to trigger a Menu Item</a>, I made one myself, which is <span style="color:#ff0000;">Leopard Only</span>:
<ol>
	<li>Download here → <a href="http://dl.getdropbox.com/u/159570/works/goToEnclosingFolder.zip">http://dl.getdropbox.com/u/159570/works/goToEnclosingFolder.zip</a></li>
	<li>If your OS X  is not in English, open <code>goToEnclosingFolder.app</code> with Script Editor, then modify the respective menu item titles in the source code, and save it.</li>
	<li>Then drag the <code>goToEnclosingFolder.app</code> to the Toolbar of the Finder and enjoy it.</li>
</ol>
Compared to the <a href="http://hasseg.org/blog/?p=114">Tiger-compatible solution</a>, I feel it (a little bit) faster by triggering the menu item directly.

However, because of the fact that this needs to call the System Events application, <span style="text-decoration:line-through;">which is Leopard Only,</span> <span style="color:#888888;">(</span><strong><span style="color:#888888;">update</span></strong><span style="color:#888888;">: my fault! System Event is <span style="color:#000000;"><strong>NOT</strong></span> Leopard Only, but it is sure that this application is Leopard Only.  See </span><a href="http://uranusjr.twbbs.org/2009/05/go-one-level-up-in-finder/"><span style="color:#888888;">here</span></a><span style="color:#888888;"> for more details, and thanks to uranusjr; he also provided a better and faster version of this application)</span> this AppleScript Application is Leopard Only, too.

If you wanna see the source code, just open the goToEnclosingFolder.app with Script Editor.app, or scroll down to the rear of this post to see the pasted code.

---

[中文版]

<!--more-->

就... Windows 檔案總管有上一層的按鈕，可是 Mac OS X 到 10.5 還是沒有 = =

所以自己做ˊˋ

其實已經有現成的可以拿來用了 (<a href="http://hasseg.org/blog/?p=114">這個</a>、<a href="http://www.macosxhints.com/article.php?story=20070326144320146">這個</a> 和 <a href="http://setupmac.com/addons/finder-up-button/">那個</a>)，不過它們都是直接 Call Finder 提供的 AppleScript functions。我在想是不是直接 Trigger 那個功能表比較快？

<a title="Flickr 上 chitsaou 的 Mac OS X Finder Go to Enclosing Folder TC" href="http://www.flickr.com/photos/chitsaou/3534771143/"><img src="http://farm3.static.flickr.com/2280/3534771143_a49e57663b_o.png" alt="Mac OS X Finder Go to Enclosing Folder TC" width="250" height="351" /></a>

所以我研究了一下 <a href="http://www.macosxhints.com/article.php?story=20060921045743404">教你如何用 AppleScript Trigger 功能表的這篇文章</a> ，然後做了一個 <span style="color:#ff0000;">Leopard Only </span>的版本：
<ol>
	<li>抓 → <a href="http://dl.getdropbox.com/u/159570/works/goToEnclosingFolder-zh-TW.zip">http://dl.getdropbox.com/u/159570/works/goToEnclosingFolder-zh-TW.zip</a></li>
	<li>然後把 <code>goToEnclosingFolder-zh-tw.app</code> 拉到 Finder 的 Toolbar 上面，就好了。</li>
</ol>
我是覺得有比 <a href="http://hasseg.org/blog/?p=114">這個適用於 Tiger 的程式</a> 要快一點啦。

缺點就是，<span style="text-decoration:line-through;">因為 System Events 要到  Leopard 才有</span>，<span style="color:#888888;">(</span><strong><span style="color:#888888;">修正</span></strong><span style="color:#888888;">: 我錯惹! System Event <span style="color:#000000;"><strong>不是</strong></span> Leopard 的專利，我只能確定這樣寫的程式只能在 Leopard 上面動。感謝 uranusjr 的</span><a href="http://uranusjr.twbbs.org/2009/05/go-one-level-up-in-finder/"><span style="color:#888888;">指正</span></a><span style="color:#888888;"> ，同時提供了一個更好更快速的程式寫法) </span>所以這個程式當然也是 Leopard Only。

程式碼的話，直接用「工具指令編輯程式」開這個應用程式就行了，或是你可以看本文下方的貼上版。

至於為甚麼這篇要先寫英文版，科科，想分享給洋鬼子啊不行喔 XD (爆)

---

Source Code in English:

[sourcecode language='ruby']<br />
tell application "System Events"<br />
	tell process "Finder"<br />
		tell menu bar 1<br />
			tell menu bar item "Go"<br />
				tell menu "Go"<br />
					click menu item "Enclosing Folder"<br />
				end tell<br />
			end tell<br />
		end tell<br />
	end tell<br />
end tell

[/sourcecode]

中文版的程式碼：

[sourcecode language='ruby']<br />
tell application "System Events"<br />
	tell process "Finder"<br />
		tell menu bar 1<br />
			tell menu bar item "前往"<br />
				tell menu "前往"<br />
					click menu item "上層檔案夾"<br />
				end tell<br />
			end tell<br />
		end tell<br />
	end tell<br />
end tell

[/sourcecode]

---

p.s.: 亦可參考 <a href="http://uranusjr.twbbs.org/2009/05/go-one-level-up-in-finder/">uranusjr 所修改的版本</a>，是直接 call shortcut key 的。
