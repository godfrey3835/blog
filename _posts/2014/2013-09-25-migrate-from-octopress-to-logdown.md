---
layout: post
title: "從 Octopress 到 Logdown 的搬家方法 (Disqus + 自訂域名)"
published: true
date: 2013-09-25 21:29
tags:
- logdown
- Octopress
categories: []
redirect_from: /posts/2013/09/25/migrate-from-octopress-to-logdown
comments: true

---
我的配置是 Disqus + 自訂域名

## 已知問題

先列一下已知問題：

1. 網址的 Path 一定要有前綴，所以若之前網址沒有前綴（如 `/2013/08/27/post-slug`），則 Facebook Like 會重設。
* 匯入文章不支援 Categories / Tags
* 匯入時的時區都會是 UTC
* 文章裡面的 h2 (`##`) 等標題都會往下掉一級。

## 匯入文章

首先，確認 `source/_posts` 底下所有檔案都是 `.md` 或 `.markdown` 結尾，原檔是 `.html` 的需要全部改名成 `.md` 或 `.markdown` ，因為 Logdown 只吃這兩種檔名。

原文若是 HTML 不需要改，他吃得下，但若你原本用別的標記語言像是 Org (?) ，則必須改寫成 HTML 或 Markdown 。

接著全選打包成 zip ，上傳到後台的 Import 裡面，匯入就成功了。

如果原本有用到一些特殊的 liquid tag 像是 gist ，則最好打開來檢查有沒有問題。

文章裡面的 h2 (`##`) 等標題都會往下掉一級，也就是 `##` 實際產生的是 `<h3>` 、 `###` 實際產生的是 `<h4>`。這樣子會造成 heading 跟以前不一樣，若你跟我一樣很在意則最好修一下，做法是 `%s/^##/#/g` 。

### 已知問題：

categories 跟 tags 都沒有成功匯入，不過這件事因為我不太在意，所以打算之後再手動補，如果你文章很多就等之後 bug 修掉再匯入吧。

時區問題：

文章的發表時間會全部視為 UTC 直接寫入資料庫，並且輸出的時候看到的是 UTC+8 ，也就是說如果你原本的文章寫的發表時間是在台灣 UTC+8 的時間，那麼匯入之後，發表時間會往後 +8:00。要修的話請注意，凡是在 16:00 （下午四點）以後發表的文章，加 8 小時之後都會跑到隔天去，所以要修得一次修日和時。

若這些 bug 對你來說很麻煩，可以先全部改成 UTC （Markdown 裡面的時間 -8:00）或是等 bug 修好再處理。

<!--more-->

## 確認網址

確認網址是為了搬 Disqus 。

我原本 blog 網址只有 `/2013/08/27/post-slug` ，但 Logdown 目前只能做到 `/posts/2013/08/27/post-slug` ，也就是前面要有一個前綴，我發現雖然可以只輸入一個字 `p` ，但不能用，因為自動轉址只支援 `posts` ，這個 bug 已經回報了。

如果舊的網址是 `http://blog.yorkxin.org/2013/08/27/post-slug` ，則新的網址就是 `http://blog.yorkxin.org/posts/2013/08/27/post-slug` 。

## 關 Disqus

為了避免搬家的過程有人留言，使得搬到新網址之後出現舊網址的留言，我把留言板關掉了。具體方法是在後台有個選項，是指定 n 日之後自動禁止留言，我選 1 日，然後我的最新文章是在 1 天以前發表的，所以最新文章也不能留言了，目的達成。

缺點是，如果今天忍不住寫文章就破功了。

## 搬 Disqus

如果網址沒有變，就不需要這一步。我需要搬是因為我有改網址， Disqus 是跟網址，所以必須做這一步。如果你搬家之後沒有要用自訂域名，這一步還是要做，因為網址變成 `http://xxx.logdown.com` 開頭。

Disqus 要把網址 map 到新的，是用 [URL Mapper](http://help.disqus.com/customer/portal/articles/912757) ，具體方法：

1. 打開 Discussions → Tools
2. 按 Start URL mapper
3. 按 "you can download a CSV here" ，文字以後可能會不同，但意思就是下載 CSV ，他把連結寄到我的信箱，下載來是一個 gz ，解之，得 CSV 。
4. CSV 裡面是所有 Disqus 記載的你的 Forum 的他知道的所有網址。
5. 我們要改這 CSV 檔。用試算表軟體打開，裡面只有一個欄位，右邊加 B 欄，輸入新網址。這時候可以善用取代工具。
6. 存檔成 CSV ，用 Excel 的記得把分隔符號選成半形逗號 `,` 。
7. 上傳到 URL Mapper 的那個上傳框，坐等。

以我的情況，要把所有網址的根目錄前面加上 `/posts` 前綴。

基本上我認為只要在 Discussions 後台看到網址都是新的，就可以認定轉換成功了。

## 預覽新站的 Disqus

在正式換自訂域名的 DNS 記錄之前，先偷看一下 Disqus 有沒有問題。

做法是這樣：

1. 先用 `nslookup domains.logdown.com` 記下 IP
2. 編輯 `/etc/host` ，加入一行 `XXX.XXX.XXX.XXX blog.yorkxin.org` ← 第二個參數是我的自訂域名
3. 打開瀏覽器，看留言板有沒有出現該有的留言。

測完記得刪掉那一行設定。

## 改自訂域名的 CNAME

我因為有用自訂域名，所以還需要去改 DNS Record 。

## 收尾

因為 DNS 記錄會快取至多 24 小時，所以我保守一點，留 24 小時再收尾。

打開 Disqus ：把 Disqus 的 1 日禁言取消，然後把舊站的 Disqus 關掉以免又有人去舊網址留言。

砍掉舊的 Octopress ：我是放在 Heroku 上面，先去後台關掉就連不上了。

收工。

## Theme 怎麼處理

我原本的 CSS 是從 Octopress 預設的改來的。我是這樣處理：

首先，去後台改用 Octopress Theme ，如此就會產生 Octopress 預設的 Theme 的 HTML 。

接著要把 CSS 無縫接軌過去：

去 Google Drive 開一個資料夾，設公開，塞一個 index.html 裡面留空沒關係。打開檔案，按「預覽」，會得到公開網址。例如我的是 `https://googledrive.com/host/0B3dHedG11rzWbkxBN243cll1Vlk/index.html` ，記下前面的 `/host/0B3dHedG11rzWbkxBN243cll1Vlk`

接著進入原本的 Octopress Repository ，把 `config.rb` （Compass 設定檔）改成這樣：

```ruby
# Publishing paths
http_path = "/host/0B3dHedG11rzWbkxBN243cll1Vlk"
http_images_path = "/host/0B3dHedG11rzWbkxBN243cll1Vlk/images"
http_fonts_path = "/host/0B3dHedG11rzWbkxBN243cll1Vlk/fonts"
css_dir = "public/stylesheets"
```

也就是把 path 那些都加上 Google Drive 的 path 。

接著進去 Terminal 編譯 CSS：

```
$ compass compile
```

最後會在 public 底下得到這些檔案：

* stylesheets/screen.css
* images/ # 資料夾
* fonts/ # 資料夾

把這兩個上傳到 Google Drive 剛剛開的資料夾，並且手動打版號，例如把 screen.css 改名成 screen-2013-09-25-v1.css 。

現在打開 Google Drive 的網址，看有沒有檔案，例如 https://googledrive.com/host/0B3dHedG11rzWbkxBN243cll1Vlk/stylesheets/screen-2013-09-25-v1.css

現在打開 Logdown 的 Theme ，按 Edit HTML ，並且把預設的 screen.css 從 head 裡面刪掉，改成上面的網址。如果有用到 Google Web Fonts 的話，也別忘了拷貝進去 HTML 。

這樣就 OK 了。

不過有個問題，就是 Octopress 產生的程式碼上色的 HTML 跟 Logdown 的不一樣，導致現在那邊的 CSS 是很醜的，我只能再找時間修。

**Update:** 修好了，具體是把 `code` 這一層 selector 加上 `pre`。 Patch:

```diff
diff --git a/sass/partials/_syntax.scss b/sass/partials/_syntax.scss
index 77ac8d7..3ceeb30 100644
--- a/sass/partials/_syntax.scss
+++ b/sass/partials/_syntax.scss
@@ -103,7 +103,7 @@ p, li {
     padding: 0 .3em;
     margin: -1px 0;
   }
-  pre code { font-size: 1em !important; background: none; border: none; }
+  pre, pre code { font-size: 1em !important; background: none; border: none; }
 }

 .pre-code {
@@ -206,6 +206,7 @@ pre, .highlight, .gist-highlight {
   &::-webkit-scrollbar-thumb:horizontal { background: $solar-scroll-thumb;  -webkit-border-radius: 4px; border-radius: 4px }
 }

+.highlight pre,
 .highlight code { @extend .pre-code; background: #000;}
 figure.code {
   background: none;
```

另外，因為沒有 「Octopress 自己加上行號所以導致 table 不能上 style」的衝突問題，所以也可以加上 table style 了，我的是長這樣：

| Lorem | Ipsum | Dolar |
|-------|-------|-------|
| Hello | World | 科科 |

Patch:

```diff
diff --git a/sass/base/_typography.scss b/sass/base/_typography.scss
index a328bed..4750a80 100644
--- a/sass/base/_typography.scss
+++ b/sass/base/_typography.scss
@@ -62,7 +62,7 @@ h5, section h4, section section h3 {
 h6, section h5, section section h4, section section section h3 {
   font-size: .8em;
 }
-p, blockquote, ul, ol { margin-bottom: 1.5em; }
+p, blockquote, ul, ol, table { margin-bottom: 1.5em; }

 ul { list-style-type: disc;
   ul { list-style-type: circle; margin-bottom: 0px;
@@ -159,3 +159,18 @@ blockquote {
   white-space: pre-wrap;
   word-wrap: break-word;
 }
+
+table {
+  th, td {
+    padding: .2em .4em;
+    border: 1px solid $table-border-color;
+  }
+
+  th {
+    font-weight: bold;
+  }
+
+  thead {
+    background-color: $table-th-background-color;
+  }
+}
```