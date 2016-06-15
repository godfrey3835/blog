---
layout: post
title: "[鯖] 用 Apache + mod_proxy + Virtual Host + Mongrel 跑 Ruby on Rails"
published: true
date: 2007-07-17 00:00
tags: []
categories: []
redirect_from: /posts/2007/07/17/apache-mongrel-ror
comments: true

---

標題好長 XD

總之是最近開始玩 <a href="http://en.wikipedia.org/wiki/Ruby_on_Rails">Ruby on Rails</a>，礙於網路環境，必須在 80 Port 上 (HTTP 的慣用 Port) 同時跑 Apache (為了 PHP) 和 Rails，然而 Rails 基本上是自己有 (HTTP) Server，例如 <a href="http://www.webrick.org/">WEBrick</a> 或 <a href="http://mongrel.rubyforge.org/">Mongrel</a>，也就是一定得要綁一個 port 的 (預設是 3000)。因此，最近兩天為了研究出怎麼透過 Apache 來做連線轉移(?)，搞得七暈八素 XD

一開始是用 <a href="http://www.zhangzhang.net/articles/2006/09/30/Linux-Installs-Ruby-On-Rails">Apache + FastCGI</a>，但怎麼搞就是搞不定，而且會開啟一大串的 <code>ruby18</code> 執行緒，把系統資源吃光= =||。後來<a href="http://blog.orez.us/">傑洛</a>說他是用 Apache 的 <code>mod_proxy</code> + Mongrel 實做的，剛剛找到<a href="http://lightyror.thegiive.net/2006/12/apache-22-mongrel.html">這篇文章</a>，<strike>歷經一番寒徹骨後</strike>總算是搞定了，寫點筆記吧 XD (其實這篇筆記跟原文大同小異，設定檔也是抄的居多，算是自己的筆記吧)

以下的環境是 FreeBSD 6.1，原本就有裝 Apache 2.2、PHP 5、Ruby、Rails 等套件，FreeBSD 可以參考<a href="http://lightyror.thegiive.net/2006/10/freebsd-ruby-on-rails.html">這篇文章</a>建置 Ruby on Rails 環境 (<code>fcgi</code> 我沒裝)。另外，IP 位址和 <code>metro.yorkxin.org</code> 都是亂寫的 XD

<!--more-->

首先當然是先搞定 Virtual Host 的部分。 在 DNS Records 加入新的 A Record，把自訂的 hostname 對應到該主機的 IP，例如我是這麼做的：
<blockquote><code>metro.yorkxin.org</code> → <code>210.70.138.201</code></blockquote>
接著開始搞機器。先安裝 Mongrel：
<blockquote><code>gem install mongrel</code></blockquote>
再來是 Apache 的部分。如果沒有 <code>/usr/local/libexec/apache22/mod_proxy.so</code> 的話，代表 <code>mod_proxy</code> 沒有裝起來，那麼就先重編 Apache 吧：
<blockquote><code>cd /usr/ports/www/apache22/<br />
make deinstall # 移除舊版，當然設定檔都會留著<br />
make WITH_PROXY_MODULES=yes install<br />
apachectl restart # 其實我不知道有沒有必要 XD
</code></blockquote>
那麼現在應該有 <code>mod_proxy.so</code> 了。

接著修改 <code>/usr/local/etc/apache22/httpd.conf</code>，加入
<blockquote><code>LoadModule proxy_module libexec/apache22/mod_proxy.so<br />
LoadModule proxy_balancer_module libexec/apache22/mod_proxy_balancer.so<br />
LoadModule proxy_http_module libexec/apache22/mod_proxy_http.so</code></blockquote>

<code>&lt;proxy balancer://examplecluster&gt;<br />
BalancerMember http://127.0.0.1:3000<br />
&lt;/proxy&gt;</code>
其實 proxy balancer 的部份可以設 cluster ，這待會再說。

接著設定 Virtual Host 的部分，我的設定檔是在 <code>/usr/local/etc/apache22/extra/httpd-vhost.conf </code>：
<blockquote><code>&lt;virtualhost *:80&gt;<br />
ServerName metro.yorkxin.org<br />
ServerAdmin metro@yorkxin.org<br />
DocumentRoot &quot;/home/metro/saba/demo/public&quot;<br />
# ProxyPass /images ! # 這三行在原本的文章裡面有<br />
# ProxyPass /stylesheets ! # 但不知怎麼的，我加了這三行就跑不動<br />
# ProxyPass /javascripts ! # 所以先移除，如果你知道箇中原因請指教 :)<br />
ProxyPass / balancer://examplecluster/<br />
ProxyPassReverse / balancer://examplecluster/<br />
&lt;/virtualhost&gt;</code></blockquote>
---

再來就是生成 Rails Application 了，例如我是放在 <code>/home/metro/saba/</code> 裡面(當然，使用者是 <code>metro</code> 而不是 <code>root</code>)，那麼就執行：
<blockquote><code>rails demo</code></blockquote>
最後當然就是啟動 Mongrel Server 啦，請在 Rails Application 的根目錄 (這個例子中是 <code>/home/metro/saba/demo/</code>，而且非 <code>root</code>) 執行：
<blockquote><code>mongrel_rails start</code></blockquote>
不過，所有執行階段的訊息都會噴到終端機上，而且還得要用 root 重啟 Apache，有點麻煩。所以我是以 Daemon 的方式啟動 Mongrel：
<blockquote><code>mongrel_rails start -d</code></blockquote>
這樣一來，shell prompt 就會操之在我了，而且也不必透過 root 重啟 Apache (但我還在觀察中，不敢下定論...)

現在就可以透過 <code>http://metro.yorkxin.org/</code> 直接連到 Rails 程式了。

---

最後，<a href="http://lightyror.thegiive.net/2006/12/apache-22-mongrel.html">原文</a>中提到 Proxy Balancer 可以做 Cluster ，而這似乎也是透過 mod_proxy 架 Rails Server 的目的。就<a href="http://blog.innerewut.de/articles/2006/04/21/scaling-rails-with-apache-2-2-mod_proxy_balancer-and-mongrel">這篇文章</a>的範例來看，好像是為了分散機器負擔，總之是前端只有一台主機負責接收 HTTP Requests ，後面可以有好多台主機、好多支 Mongrel Servers 來分散負擔。不過我參考的這篇<a href="http://lightyror.thegiive.net/2006/12/apache-22-mongrel.html">原文</a>，把 Cluster 都開在 localhost，我試著實作後發現，跑了五隻 Mongrel 在 localhost ，其負擔不減反增= =? 也許是我設錯地方了也說不定。

總之是先筆記下來好了，搞不好以後會用到= ==

Cluster 也就是所謂的多開(?)， 如果用一般的 <code>mongrel_rails -p xxxx start</code> 一一指定那會累死，所以 Mongrel 提供了 Cluster Module，方便使用。具體的操作說明可看<a href="http://lightyror.thegiive.net/2006/10/mongrel-part-2-mongrel-cluster.html">這篇</a>。

安裝 Mongrel 的 Cluster Module：
<blockquote><code>gem install mongrel_cluster</code></blockquote>
接著在  Rails Application 的根目錄輸入指令：
<blockquote><code>mongrel_rails cluster::configure -e development -p 3000 -N 5</code></blockquote>
這是一次設定，會把設定值寫入到 <code>config/mongrel_cluster.yml</code>，以後直接改這個 yml 就行了。<code>-e</code> 是啟動時的環境，Rails Application 提供 <code>production</code>/<code>development</code>/<code>test</code> 三種模式，老實說我不知道這各代表什麼 XD 我剛學嘛(逃)。<code>-p</code> 是 Port 的起始值，<code>-N</code> 是要開的 Clusters 個數。

設好後當然就啟動了：
<blockquote><code>mongrel_rails cluster::start</code></blockquote>
接著會一一把 3000 ~ 3004 port 的 Mongrel Server 開起來，而且就直接開在背景了。要停下來也就是
<blockquote><code>mongrel_rails cluster::stop</code></blockquote>
---

結果這樣一設，我的 Rails Application 速度不增反減，也許是不該開在同一台機器上吧 XDrz 所以我目前還是用 Daemon 單開。

---

以上有誤之處還請指教，我才剛學啊 QQ
