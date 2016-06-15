---
layout: post
title: "在 Heroku 安裝 Redmine (1.1-stable)"
published: true
date: 2011-03-08 00:00
tags: []
categories: []
comments: true

---

<a href="http://redmine.org">Redmine</a> 是一套好用的軟體專案管理系統。有多好用呢？請 Google 一下就知道了。

為了建立屬於自己專屬的 Redmine，我設法在 <a href="http://heroku.com">Heroku</a> 部署 Redmine 1.1-stable。雖然網路上有許多教學，但剛剛參考了<a href="http://forresty.com/2010/03/01/host-redmine-on-heroku/">這一篇</a>，遇到一些問題。所以我把步驟寫下來。這篇文章的內容是整合 Heroku 的部署文件及 <a href="http://www.redmine.org/projects/redmine/wiki/RedmineInstall">Redmine 的安裝文件</a>。

<strong>Update</strong>: 隔天我找到一篇<a href="http://blog.firsthand.ca/2010/10/installing-redmine-on-heroku-with-s3.html">很詳盡的 Step by Step</a>，包括 Amazon S3。
<h1>前置作業</h1>
Heroku 是 Ruby Web application hosting，所以你的系統內要有 <a href="http://www.ruby-lang.org/en/downloads/">Ruby Runtime</a>。同時也得安裝 <a href="http://rubygems.org/">Rubygems</a>。Heroku 是以 <a href="http://git-scm.org">Git</a> 版本控制系統來管理程式原始碼的，當然要安裝 Git。

<!--more-->

然後是必要的 Gems，以下會使用到 <a href="http://gembundler.com/">Bundler</a> 這個方便的 per-application gem 管理工具（其實還有別的，但靠它就可以安裝別的了）。要部署 Ruby 網頁應用程式到 Heroku ，首先當然要去辦 Heroku 帳號，並安裝 Heroku 專屬的 gem。濃縮成一行指令就是：
<blockquote><code>gem install bundler heroku</code></blockquote>
詳情請參考 Heroku 的 <a href="http://devcenter.heroku.com/categories/getting-started">Getting Started 文件</a>。
<h1>取得 Redmine 原始碼</h1>
Redmine 是採用 SVN 版本控制系統，下載方式請參考 <a href="http://www.redmine.org/projects/redmine/wiki/Download">Redmine 的說明</a>。目前最新的穩定版是 1.1-stable，所以我根據官網上面寫的指令，將 Redmine 1.1-stable 抓下來：
<blockquote><code>svn co http://redmine.rubyforge.org/svn/branches/1.1-stable redmine-1.1</code></blockquote>
這會把 Redmine 1.1-stable 的原始碼 checkout 到 <code>redmine-1.1</code> 這個資料夾中。
<h1>設定 Redmine</h1>
<h2>新增 Gemfile 以自動安裝所需的 Gem</h2>
<code>Gemfile</code> 是 Bundler 用來辯識所需要的 Gems 的檔案設定檔，也可以讓 Heroku 在程式碼被 push 到 remote 時，自動安裝 <code>Gemfile</code> 裡所指定的 Gems。在 Heroku 的應用與操作方法詳見<a href="http://devcenter.heroku.com/articles/bundler">官網說明</a>。

新增檔案 <code>Gemfile</code> ，內容如下：

[sourcecode language="ruby"]<br />
source :gemcutter<br />
gem 'rails', '2.3.5'<br />
gem 'i18n', '0.4.2'<br />
[/sourcecode]

然後執行
<blockquote><code>bundle install</code></blockquote>
可能會要求你輸入當前使用者密碼。

這樣子就會把 Rails 2.3.5 及其 dependencies 、i18n 0.4.2 這些 gems 安裝起來，並且產生<code>Gemfile.lock</code> 檔案。
<h2>建立 <code>session_store.rb</code></h2>
<code>session_store.rb</code> 是用來定義 Rails Session 參數，與登入機制有關，但因為牽涉到 Cookie 產生的參數，所以不會放進 repository 中，我們要自己產生。方法是
<blockquote><code>rake generate_session_store</code></blockquote>
<h2>本機 Database 設定</h2>
雖然是部署到 Heroku，本機資料庫是什麼樣子應該無所謂，但因為其中一個 Migration 會建立 <code>public/plugin_assets/README</code> ，沒有這個檔案的話，Heroku 的 Migration 會出錯，因為 Heroku 不允許檔案系統的操作。所以我們先自己建好，再一併放進 Git repository 中，以防出錯。

首先要設定本機資料庫，先從範例檔複製出來：
<blockquote><code>cp config/database.yml.example config/database.yml</code></blockquote>
再修改 <code>config/database.yml</code> ，使其僅保留 <code>development</code> 的設定（Heroku 會自行連接 Database）：

[sourcecode language="text"]<br />
development:<br />
  adapter: sqlite3<br />
  database: db/development.db<br />
[/sourcecode]

完成後，初始化本機的 Database ：
<blockquote><code>rake db:migrate</code></blockquote>
<h1>建立 Git Repository</h1>
如前文所述，Heroku 採用 Git 管理部署到雲端的程式碼，所以要讓  Git 管理 Redmine 的程式碼才行。
<h2>修改 Git 監視的檔案類型</h2>
在建立 Git repository 之前，先修改一下 <code>.gitignore</code> 檔案（讓 Git 永遠忽略符合指定 pattern 的檔案），刪除兩行：
<blockquote><code>/config/initializers/session_store.rb<br />
/public/plugin_assets
</code></blockquote>
然後加入這一行：
<blockquote><code>.svn</code></blockquote>
以上的異動說明如下：
<ol>
	<li><code>session_store.rb</code> ，SVN tree 中沒這個檔案，在上文已經自行產生，必須讓它被部署到 Heroku ，應用程式才能運作。</li>
	<li><code>public/plugin_assets</code> ，SVN tree 中沒這個資料夾，在上文已經自行產生，往後安裝 Plug-in 的時候會用到，但因為我們只能在本機操作 Plug-in 的新增與刪除，不能在 Heroku 操作，所以這個資料夾當然也要給 Git 監視。</li>
	<li><code>.svn</code> 是 SVN 記錄 local checkout 某資料夾的 metadata 所使用，為了保留往後可以從 Redmine SVN repository 新版程式的方便，這裡不予刪除，但因為它不屬於 Git 所管理的範圍，所以要把它加入 <code>.gitignore</code> 中。</li>
</ol>
<h2>建立 Git repository</h2>
執行
<blockquote><code>git init<br />
git add .<br />
git commit -m 'initial commit'</code></blockquote>
到此為止，Redmine 已經準備好可以送上 Heroku 的雲端伺服器了。
<h1>部署到 Heroku</h1>
<h2>新增 Heroku App</h2>
執行
<blockquote><code>heroku create</code></blockquote>
會由 Heroku 挑一個名字給你，並且告訴你該 App 的網址為何。如果你要指定名字的話，就是
<blockquote><code>heroku create dance-okok</code></blockquote>
這樣會建立名為 <code>dance-okok</code> 的 Heroku application，前提是這個名字沒有別人用走。
<h2>將程式碼送上 Heroku</h2>
<blockquote><code>git push heroku master</code></blockquote>
於是你的程式碼就送到 Heroku 的伺服器了，並且會根據 <code>Gemfile</code> 中的描述，將必備的 Gems 安裝在 Heroku 給你的虛擬空間裡面。
<h2>在 Heroku 中初始化資料庫</h2>
雖然在前文中，已經初始化本機資料庫了，但畢竟在 Heroku 上的資料庫還是空的，所以一樣要初始化：
<blockquote><code>heroku rake db:migrate</code></blockquote>
至此，Redmine 的部署已經完成了。請用瀏覽器連至剛剛得到的網址，如果有指定名字的話，像前面的 <code>dance-okok</code>，就會是 <code>http://dance-okok.heroku.com/</code> 。

預設的管理員帳號 <code>admin</code>，密碼 <code>admin</code>。
<h1>後續設定</h1>
Redmine 的官方說明文件中，還要求載入預設資料 (<code>rake redmine:load_default_data</code>)，不過我試了發現 Heroku 會產生錯誤，似乎是因為透過鍵盤選語言的時候，Heroku 不允許我和遠端的 console 互動，所以吃了一記 <code>nil</code>。

幸好 Redmine 初次進入管理介面時，會偵測有無載入預設資料，你可以登入 Redmine 的後台（以管理員登入，按一下左上角的 Administration），它會問你要不要載入預設資料，還能選語言。

接著是如何<a title="讓部署在 Heroku 的 Redmine 強制使用 SSL" href="http://blog.yorkxin.org/2011/03/09/redmine-on-heroku-force-ssl/">讓 Redmine 支援 SSL，及強制進入 SSL</a>（嚴格檢查通訊協定）。
