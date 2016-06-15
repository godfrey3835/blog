---
layout: post
title: rvm + pow 安裝筆記
published: true
date: 2011-06-28 00:00
tags: []
categories: []
redirect_from: /posts/2011/06/28/notes-on-rvm-and-pow-installation
comments: true

---

大四結束了，不論<del>成績</del>如何都要來對系統做大掃除，這次的目的是把我目前混亂的 Rails 開發環境整理一番，使其條理分明。

目前開發環境：
<ul>
	<li>Mac OS X 10.6.x, Xcode 3.2.3, bash</li>
	<li>已經用 <a href="http://mxcl.github.com/homebrew/" target="_blank">brew</a> 安裝 <a href="http://www.rubyenterpriseedition.com/" target="_blank">ree</a> 在系統中</li>
	<li>有一堆 gems</li>
	<li>懶得灌 Passenger ，只會用 <code>rails s</code> 啟動 server <sub>(掩面)</sub></li>
</ul>
目標：
<ul>
	<li>改用 <a href="https://rvm.beginrescueend.com/rvm/" target="_blank">Ruby Version Manager (rvvm)</a></li>
	<li>改用 <a href="http://pow.cx" target="_blank">Pow!! The zero-config Rack server for Mac OS X.</a></li>
</ul>
<div><!--more--></div>
<h1>RVM installation</h1>
首先去 rvm 官網找那條安裝的一行文指令。但直接執行他建議那條，會跑出 <code>~/bin/</code> 和 <code>~/share/</code> 這兩個資料夾，我不喜歡。所以改用他建議的另一條：
<pre>curl -s https://rvm.beginrescueend.com/install/rvm -o rvm-installer
chmod +x rvm-installer
rvm_bin_path=~/.rvm/bin rvm_man_path=~/.rvm/share/man ./rvm-installer</pre>
這會把 rvm 的執行檔放在 <code>~/.rvm/bin</code> 、把 rvm 的 man files 放在 <code>~/.rvm/share/man</code> 。安裝完成後，可以把 <code>rvm-installer</code> 砍掉。

還沒結束，根據安裝程式給的訊息，要做一些 post-install configuration。老實說我仔細看完才發現他寫的一長串<del datetime="2011-06-28T04:58:07+00:00">是狗屁</del>不實用，會把我漂亮的提示符弄不見，整個說明看完才發現適合我的方法寫在最下面，所以我是這樣做：

編輯 <code>~/.bashrc</code> 加入：

[sourcecode language="bash"]<br />
[[ -s &quot;/Users/blahblah/.rvm/scripts/rvm&quot; ]] &amp;&amp; source &quot;/Users/blahblah/.rvm/scripts/rvm&quot;<br />
[/sourcecode]

然後在 <code>~/.bash_profile</code> 最末加入這行：

[sourcecode language="bash"]<br />
source ~/.bashrc<br />
[/sourcecode]

其實我今天才知道 <code>.bashrc</code> 是在 interactive non-login 會載入的，而 <code>.bash_profile</code> 則是在 login 到 shell 的時候才會執行，之後不執行。[<a href="http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html" target="_blank">1</a>, <a href="http://stackoverflow.com/questions/415403/whats-the-difference-between-bashrc-bash-profile-and-environment/415444#415444" target="_blank">2</a>]。

完成以後就開新的 shell 。
<h1>RVM 安裝 Ruby Enterprise Edition (ree)</h1>
接著安裝 ree，也是一行文
<pre>rvm install ree</pre>
然後要把原本 brew 的 ree 已經安的 gems 安裝到 rvm 的 ree 。這方法在 rvm 安裝指令的 post-install screen 有寫：
<pre>rvm system # 切換到目前系統使用的 ruby runtime ，切完可用 which ruby 檢查一下
rvm gemset export system.gems # 把當前 ruby runtime 的 gems 清單匯出到 system.gems
rvm ree # 切換到目前系統使用的 ruby runtime ，一樣可用 which ruby 檢查一下
rvm gemset import system # 從 system.gems 的清單逐一安裝 gem ，compilation may needed.</pre>
如果看到有 gem 安裝失敗，再去找他指定的 log 出來看，通常裡面沒有詳細的錯誤訊息。不妨嗣後手動安裝該 gem ，說不定有更詳細的錯誤訊息。

當然最後是要設定 rvm 預設的 ruby runtime 為 ree
<pre>rvm --default ree</pre>
<h1>安裝 pow</h1>
也是一行文：
<pre>curl get.pow.cx | sh</pre>
打入密碼就行了。

接著就像官網上所講的那樣，
<pre>ln -s /path/to/your/railsapp ~/.pow/</pre>
這樣就可以開啟 http://railsapp.dev/

但如果你跟我一樣喜歡用 <code>*.local</code> ，則要修改 ~/.powconfig ：
<pre>export POW_DOMAINS=local</pre>
再重新安裝 pow：
<pre>curl get.pow.cx | sh</pre>
不過後來發現實際上 pow 不能這麼簡單就解析 *.local 的網域，因為在它前面有個 Mac OS X 的 mDNSResponder 會解掉 *.local ，而這個 mDNSResponder 只解 3 層的 domain name (也就是 yo.railsapp.local) ，而不解析 2 層的 (railsapp.local) 。<a href="http://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man5/resolver.5.html" target="_blank">參考 man 5 resolver</a>。

真的堅持要用的話，有兩個爛方法
<ul>
	<li>在 /etc/hosts 手動指定 railsapp.local 到 127.0.0.1 ，不過這就違反了 Zero-conf 的理念。<a href="http://blog.impaled.org/code/2011/4/more-pow-love-with-configuration.html" target="_blank">參考資料</a>。</li>
	<li>到「系統偏好設定」→「網路」，找到你的網路設備，按「進階」，切換到「DNS」標籤頁，在右方的「搜尋網域」加入「local」和「apple.com」。<a href="http://support.apple.com/kb/HT3473" target="_blank">參考蘋果的說明文件</a>。<br />
這樣子在查找 railsapp.local 時，實際上會去查找 railsapp.local.local ，還蠻髒的。</li>
</ul>
總之這樣就可以連 http://railsapp.local/ 了。
<h1>其他</h1>
也可以參考 <a href="https://github.com/Rodreegez/powder" target="_blank">Powder</a> 和 <a href="https://github.com/sethvargo/powify" target="_blank">Powify</a> 這兩套工具程式。

另外，已知 pow 會跟 Mac OS X 內建的 Apache （網頁共享）衝突，所以如果你還要用後者的話，要嘛關掉 pow ，要嘛用 <a href="http://www.modrails.com/" target="_blank">passenger</a> ，還有精美的 <a href="https://github.com/Fingertips/passengerpane" target="_blank">PassengerPane</a> 可以用，但編譯好的 v1.3 我在用的時候會 crash，不知道是不是因為 32-bit ，我 clone master (有 64-bit) 回來用 Xcode 自行 build 就可以正常使用了。
