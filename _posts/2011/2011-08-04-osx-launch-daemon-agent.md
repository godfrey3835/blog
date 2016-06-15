---
layout: post
title: Mac OS X 的 Launch Daemon / Agent
published: true
date: 2011-08-04 00:00
tags:
- mac
- daemon
categories: []
redirect_from: /posts/2011/08/04/osx-launch-daemon-agent
comments: true

---

因為想做某個應用，今天研讀了 Apple Developer 網站上的 <a title="Daemons and Services Programming Guide - Apple Developer" href="http://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/BPSystemStartup/" target="_blank">Daemons and Services Programming Guide</a> ，終於懂了 Mac OS X 的 Launch Daemon / Agent 是做什麼用的，筆記一下。為了避免專有名詞翻譯不同造成誤解，我試著統統不翻譯。不過我對 Mac OS X 的 system programming 涉世（？）未深，要是有解釋不對的地方，路過的大俠請不吝指教。

以下的操作全是在 Mac OS X 10.6.8 完成的。

---
<h1>What is launchd ?</h1>
Mac OS X 從 10.4 開始，採用 <code>launchd</code> 來管理整個作業系統的 services 及 processes 。傳統的 UNIX 會使用 <code>/etc/rc.*</code> 或其他的機制來管理開機時要啟動的 startup services ，而現在的 Mac OS X 使用 <code>launchd</code> 來管理，它的 startup service 叫做 <strong>Launch Daemon</strong> 和 <strong>Launch Agents</strong> 。而視為 service 的程式，就該是 background process ，不應該提供 GUI ，也不應該跳到 （console 的）foreground 。當然有些例外，例如聽快速鍵之後跳出視窗的程式。

<!--more-->

<code>launchd</code> 管理的 background process 有四種：
<ol>
	<li><strong>Launch Daemon</strong>: 在開機時載入 (load) 。</li>
	<li><strong>Launch Agent</strong>: 在使用者登入時載入。</li>
	<li><strong>XPC Service</strong>: 好像是 10.7 才有的，我還沒灌 10.7 ，先跳過。</li>
	<li><strong>Login Items</strong>: 在 User 登入時執行。有兩種方法可以用程式新增項目到 Login Item：</li>
<ol>
	<li>Shared File List：會出現在 Account 偏好設定的 Login Item 清單。</li>
	<li>Service Management Framework：這個就不會出現在 Login Item 清單。</li>
</ol>
</ol>
（以下把重點放在 Launch Daemon / Agent 。至於 XPC 和 Login Item 就留待其他比較在行的大大來解釋。）
<h1>Launch Daemon &amp; Launch Agent</h1>
Launch Daemon 和 Launch Agent 是同一種東西在不同 scopes 的異名。Launch Daemon 是 system-wide 的 service ，稱為 daemon，Launch Agent 是 per-user 的 service ，稱為 agent，前者在開機時會載入 （load） ，後者在使用者登入時（才）會載入。

如果你打開 Activity Monitor ，並切換到 Hierarchy view ，你會發現有個 <code>launchd</code> 會在最上層，跟它同層的只有 <code>kernel_task</code> ，它下面有很多 child processes 的 user 都是 <code>root</code> ，其中還有一個 <code>launchd</code> ，啟動的 user 是你自己，它底下的 child processes 的 user 也幾乎都是你自己。當這些 processes 是由 <code>launchd</code> 載入 <strong><code>launchd</code> property list file</strong> 來執行的時候，前者由 <code>root</code> 執行的稱為 Launch Daemons ，後者由使用者執行的稱為 Launch Agents 。

<strong><code>launchd</code> property list file</strong> 就是你會在 LaunchDaemon 或 LaunchAgents 目錄中看到的 <code>*.plist</code> 檔案（以下統稱 plist 檔，反正本文講到的 plist 檔也只有這種用途）。它是 XML 格式，不過咱們別這麼糾結手刻 XML ，你直接按兩下打開就是 Property List Editor ，滑鼠點一點就好，不糾結。
<h2>launchd Service Process Lifecycle</h2>
由 launchd 所管理的 services （Launch Daemon 、 Launch Agent）是要先由 launchd 載入（load）以後才會執行（run），但載入之後並不一定馬上執行。在蘋果的官方文件說明了 kernel 載入完成後會發生的事，用來說明 Launch Daemons 、Launch Agents 及其 processes 的生命週期。

開機時，會先<a href="http://developer.apple.com/library/mac/documentation/Darwin/Conceptual/KernelProgramming/booting/booting.html" target="_blank">載入 OS Kernel</a> ，載入完成後就執行 <code>launchd</code> ，用來載入 system-wide services （daemons）。這個 system-wide <code>launchd</code> 在開機時會做這些事：
<ol>
	<li><strong>載入 (load)</strong> 存放在這些目錄下的 <code>plist</code> ：</li>
<ul>
	<li><code>/System/Library/LaunchDaemons</code></li>
	<li><code>/Library/LaunchDaemons</code></li>
</ul>
	<li><strong>註冊</strong>那些 <code>plist</code> 裡面設定的 sockets (port) 和 file descriptors</li>
	<li><strong>執行 (run)</strong> <code>KeepAlive = true</code> 的 daemons ，當然 <code>RunAtLoad = true</code> 的也會啟動。</li>
</ol>
該 run 的 run 好後， <code>loginwindow</code> 就出現了，提示使用者登入。有設定自動登入的話，就會跳過這關。

在使用者登入以後，會執行屬於該使用者的 <code>launchd</code> ，負責處理 Launch Agent ，做的事跟上面載入 Launch Daemon 很像，差別在於它從以下的目錄載入 <code>plist</code>：
<ul>
	<li><code>/System/Library/LaunchAgents</code></li>
	<li><code>/Library/LaunchAgents</code></li>
	<li><code>~/Library/LaunchAgents</code></li>
</ul>
由使用者執行的任何程式也都是 <code>launchd</code> 來執行的，所以 <code>launchd</code> 也是該使用者的所有 processes 之母。

在使用者登出、關機或重新開機時，會觸發 <strong>Termination event</strong>。接受登出、關機、重新開機使用者指令的 process 是 <code>loginwindow</code> 。它會先向使用者確認，一但確認，就會對每個由該使用者的 <code>launchd</code> 所啟動的 processes 送出 termination signal，如果是 Cocoa 則送出 Cocoa API 的 event，其他的就送出 <code><a href="http://en.wikipedia.org/wiki/SIGTERM" target="_blank">SIGTERM</a></code> 要他們自我了斷，45 秒之後，除了 Cocoa 的應用程式可以丟出某個 error 來取消這整個 termination process，其他還沒結束的都會被 kill 掉。

這就是為什麼 <code>loginwindow</code> 這個 process 會一直存在，它要負責把該使用者執行起來的 processes 統統清掉。而 per-user services 都關掉以後，就回到 <code>loginwindow</code> ，或是執行關機、重新開機的流程，後兩者就是照著差不多的流程去關掉所有 system-wide services 。

---
<h1><code>launchd</code>-compatible Daemon Programming Guide</h1>
以下是該文件中提及關於配合 <code>launchd</code> 開發 daemon 時應注意的事，提到關於 <code>plist</code> 的 key 就請參考 <a href="http://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man5/launchd.plist.5.html" target="_blank"><code>man 5 launchd.plist</code></a> 。以下的 daemon 指的是 Launch Daemon 所要運行的 process ，所以 Launch Agent 也一併適用。
<h2>Listen to <code>SIGTERM</code></h2>
如上文所提及的，由於 <code>loginwindow</code> 這個 process 在要關掉你的 daemon 時會先送 <code><a href="http://en.wikipedia.org/wiki/SIGTERM" target="_blank">SIGTERM</a></code> ，要你自我了斷，等太久沒關掉才會 <code>SIGKILL</code> 。如果你的程式需要在結束之前做什麼事，一定要聽 <code>SIGTERM</code> 這個 signal 。
<h2>On-Demand Daemon</h2>
Launch Daemon / Agent 預設不會讓某個 process 一直執行，當它的設定沒有 <code>KeepAlive = true</code> 時，它會根據被執行的 process 的 CPU usage 和 requests （如 TCP/IP service）來決定要不要送出 <code>SIGTERM</code> 叫他自盡。

當該 service 需要被使用時，而相對應的 program 沒有跑成 process 時，會自動把該 service 給跑起來。例如某個 TCP/IP service 聽某個 port，當這個 port 有封包進來時， <code>launchd</code> 會把相對應的 service 給啟動，這種行為叫做 <strong>on-demand</strong> 。

當然，也有 non-on-demand daemon （好繞舌），其實也就是 <strong>keep-alive daemon</strong> ，這也是傳統意義上的 daemon ，我是說那種一直躲在牆角默默執行，直到有人找他，他才跳出來回一下話，回完了以後又繼續躲在牆角的那種。只要把 <code>KeepAlive</code> 這個 key 設成 <code>true</code> ，它就會在 <code>plist</code> 被 <code>launchd</code> 載入 (load) 時執行 (run) 起來。要是那個 process 死掉，<code>launchd</code> 會知道，馬上再把它開起來。所以如果你試著去 Activity Monitor 砍掉這種 daemon ，它就馬上會復活。
<h2>No <code>fork</code> or <code>exec</code></h2>
傳統的 system programming 會教你用 <code><a href="http://en.wikipedia.org/wiki/Exec_(operating_system)" target="_blank">exec</a></code> 、<code><a href="http://en.wikipedia.org/wiki/Fork_(operating_system)" target="_blank">fork</a></code> 等等的 POSIX API 來做一隻 daemon ，但配合 <code>launchd</code> 時，由於 daemon 的生命週期是由 <code>launchd</code> 來控制的，除非強制要求 Kepp-Alive，否則要生要死是 <code>launchd</code> 決定，更何況 Keep-Alive 還要考慮 daemon process 在結束以後自動重新執行，所以在配合 <code>launchd</code> 寫 daemon 時，蘋果建議你不要用傳統的 <code>fork</code> 和 <code>exec*</code> 。當然， <code>plist</code> 檔案中的 <code>ProgramArguments</code> 就是 <code>exec*</code> 系列 subroutine 的參數。

當一個 process 跑起來 10 秒內就死掉， launchd 會判定為 crash ，然後試著重新執行。要是你用傳統的 <a href="http://en.wikipedia.org/wiki/Fork-exec" target="_blank">fork-exec</a> style ，就可能會造成無限迴圈。
<h2>No <code>setuid</code> / <code>setgid</code> / <code>chroot</code> / <code>chdir</code> etc.</h2>
為了安全性的考量，蘋果強烈建議你不要自己呼叫 <code>setupd</code>, <code>setgid</code>, <code>chroot</code>, <code>chdir</code> 等等 system subroutines ，而是透過 <code>plist</code> 檔的設定值來讓 <code>launchd</code> 幫你完成，參考 <code>UserName</code> 、<code>GroupName</code> 、<code>RootDirectory</code> 、 <code>WorkingDirectory</code> 的 keys 。
<h2>No pipe redirection hell for <code>fd</code> <code>0</code>, <code>1</code> or <code>2</code></h2>
在寫 log 或輸出訊息時也不用煩惱開檔等等問題，你可以設定 <code>StandardOutPath</code> 、 <code>StandardErrorPath</code> ，只管輸出到 <code>stdout</code> 或 <code>stderr</code> 就好了。而 <code>StandardInPath</code> 也可以讓你的 process 一執行就從 <code>stdin</code> 吃指定 path 的內容。也就是說， <code>launchd</code> 幫你把 <code>fd</code> = <code>0</code>, <code>1</code>, <code>2</code> 的東西都傳便便。

---
<h1>其他應用</h1>
<h2>工作排程</h2>
Launch Daemon / Agent 的設定檔可以指定該 service 的執行週期及執行時間，也就是說，它可以替代傳統的 <code>at</code>, <code>periodic</code> 和 <code>cron</code> 。這些設定值的 key 請參考 <code>StartInterval</code> 和 <code>StartCalendarInterval</code>。

搭配 <code>LaunchOnlyOnce</code> 的話可以模擬 <code>at</code> ，但對我來說，如果要用 <code>launchd</code> 只臨時做一件事，還不如直接 <code>at</code> 方便。
<h2>監視檔案或目錄異動</h2>
Launch Daemon / Agent 可以監視某個 path 的異動，設定在 <code>WatchPaths</code> 這個 key。這裡所說的 path 可以是 directory 或是某個特定的檔案，只要該 path 有異動，就會執行你的 job 。

也可以用來清 queue ，只要 directory 裡面有東西，就會執行 job 直到空為止，可以用來做 mail server 或 notification 。設定在 <code>QueueDirectories</code> 這個 key 。

---

See also:
<ul>
	<li><a href="http://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man5/launchd.plist.5.html" target="_blank">man 5 launchd.plist</a></li>
	<li><a href="http://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/launchctl.1.html" target="_blank">man 1 launchctl</a> ，也就是管理 Launch Daemons / Agents 的工具</li>
	<li><a href="http://developer.apple.com/library/mac/technotes/tn2083/" target="_blank">Technical Note TN2083: Daemons and Agents</a></li>
</ul>
