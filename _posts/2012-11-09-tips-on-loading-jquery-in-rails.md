---
layout: post
title: Rails 載入 jQuery 的小技巧
published: true
date: 2012-11-09 23:47
tags:
- rails
- jquery
- web development
categories: []
comments: true

---


Rails app 既然是 web app 就多少會用到 jQuery ，我們雖然有 [jquery-rails](https://github.com/rails/jquery-rails) gem 可以直接用，但並不是最好的方法。透過一些小技巧，可以省下一點點網路流量。

以下是前陣子研究出來的實作方法，不確定是不是 Best Practice ，但至少是 Better Practice。

## jQuery 本體：通過 Google CDN

現在我們有 [Google 的 CDN](https://developers.google.com/speed/libraries/) 可以拉 jQuery ，使用它的話可以幫你省下約 32KB 的網路流量，尤其以常常 deploy 新版本的網站來說，每次 `application.js` 有異動就得重新下載，把 jQuery 交給 Google CDN 的話， browser 就不必重新下載 jQuery 了。而且 Google CDN 有不少網站都在使用，它的 header 裡面指定的 cache 時效又很久，所以 browser 只要下載一次，以後都不會再下載了（前提是 jQuery 的 cache 沒有被 browser 清掉）。

但在使用它之前，還是得先安裝 jquery-rails gem。

### jquery-rails gem

在 `Gemfile` 加入這一行然後跑 `bundle install`

```ruby
gem "jquery-rails"
```

但是一定要把 `//= require jquery` 從 assets pipeline 的 JavaScript 裡面***移除***。

你或許會想說，不 require 它，還安裝 gem 做什麼？因為我們要 Rails app 能夠輸出一個獨立的 `jquery.min.js` ，好讓 browser 連不上 Google CDN 的時候，還可以從 Rails 下載 jQuery，為了保持版本號一致，才要安裝 jquery-rails。

### 從 Google CDN 拉 jQuery

在 view 裡面這樣寫，使用 Google CDN 來拉 jQuery ：

```erb
<%= javascript_include_tag "//ajax.googleapis.com/ajax/libs/jquery/#{Jquery::Rails::JQUERY_VERSION}/jquery.min.js" %>
<script>window.jQuery || document.write('<script src="<%= javascript_path("jquery.min") %>"><\/script>')</script>
```

<!-- more -->

第 1 行是從 Google 的 CDN 拉壓縮過（minified + gzipped）的 jQuery 回來。其中 `Jquery::Rails::JQUERY_VERSION` 可以得到 `jquery-rails` gem 所帶的 jQuery 版本號碼，以求與下面的 local fallback 版號一致。

第 2 行則是可以避免使用者的網路暫時不能從 Google CDN 下載 jQuery （或 Google CDN 掛了，或在不能上網的地方寫程式），先檢查 `window.jQuery` 有沒有存在，沒有的話就插入一個 `<script>` tag 來載入 Rails app 提供的 `jquery.min.js` (Local Fallback)，為了維持版號一致，第 1 行裡面用一個 constant 來替換掉寫死的 jQuery 版號。

使用 `document.write` 的理由是要同步載入，如果用 JavaScript 動態產生 HTMLScriptElement 再插入，則會變成非同步載入，很有可能它執行到第一個 `$` 的時候， `jquery.min.js` 還沒下載執行完，那就會噴 `undefined variable` exception 了。

### Local Fallback

為了讓 Rails app 可以提供 `jquery.min.js` ，有兩個做法。

一個是在 `config/environments/production.rb` 指定 precompile 它

```ruby
config.assets.precompile += ["jquery.min.js"]
```

另一個做法是打開：

```ruby
config.assets.compile = true
```

這樣子的話第一個需要從 Rails 下載的人會最衰，他要等 Rails 在線上同步 compile `jquery.min.js` （之後 assets pipeline 會 cache 它）。但考量到 Google CDN 的 availability 很高，那遇到這種衰事的人應該也很少，所以這不失為一個方法。

## jQuery UI

jQuery UI 也是常用的 Library ，不過一整包拉下來其實很大包，而且 jquery-rails 這個 gem 裡面，只有 jQuery UI 的 JavaScript ，沒有 jQuery UI 的 CSS 和圖檔（這樣是要怎麼玩…）。

我們可以使用 [jquery-ui-rails](https://github.com/joliss/jquery-ui-rails) 這個 gem 。它把所有的 jQuery UI modules 一個一個拆開，再接到 sprockets 來管理 dependency。

於是你如果要使用 jQuery UI Tabs 的話，你只要在你的 JavaScript 裡面寫一行：

```javascript
//= require jquery.ui.tabs
```

再在 CSS 裡面寫一行：

```css
/*
 *= require jquery.ui.tabs
 */
```

就好了！它的 dependency `core` 和 `widget` 都不需要手動 require。但有時候會有衝突，例如 `jquery.ui.droppable` 裡面有 `jquery.ui.draggable` ，所以不能再 require 後者。遇到衝突的時候 Assets Pipeline 會噴奇怪的錯誤訊息，這時候可以到 [jquery-ui-rails 的 repository](https://github.com/joliss/jquery-ui-rails) 檢查一下 dependency 。（重覆 require dependency 會出錯？這不科學。）

不過這個 gem 目前有個問題是，它會在產生的 jQuery UI JavaScript 裡面綁 jQuery ，所以**如果你又從 CDN 下載 jQuery 的話，等於是下載兩次、執行兩次**。

怎麼解決呢？我們暫時是用以下的方法解決。

### `jquery-ui-rails` gem (Techbang-modified)

在此介紹我們 [T客邦 自己 fork 的版本](https://github.com/techbang/jquery-ui-rails/)，因為我們有針對它與 jQuery from Google CDN 配合的情況，特別調整過。

`Gemfile` 裡加入：

```ruby
gem "jquery-ui-rails", :github => "techbang/jquery-ui-rails", :tag => "techbang-v2.1.0"
```

這樣就 OK 了，用法跟原版的 jquery-ui-rails 一樣，只差在必須手動載入 jQuery 。不過這個 fork 要解決的問題就是 jQuery from CDN 的重覆下載、重覆執行問題，所以，本來就是要手動從 CDN 載入 jQuery 的。

至於 Pull Request ，後來發現有人送了[一樣功能的異動](https://github.com/joliss/jquery-ui-rails/pull/21)，等他 merge 之後我會把這個段落給更新。

### 如果你真的需要一整包 jQuery UI

我不建議這樣做。它很大包，光是 JavaScript 的話就算 minify + gzip 也要 60KB+ ，實際上可能只會用到少數元件。最好的方法是有用到的再包進 Assets Pipeline ，從自己的伺服器下載。但如果你真的需要整包，應該也從 CDN 下載。

不過原版的 jquery-ui-rails 無從得知 jQuery UI 版號， T客邦的 fork 有加上 `Jquery::Ui::Rails::JQUERY_UI_VERSION` 這個常數，從這裡可以得知版號，就不會拉錯了。jQuery UI 的版號尤其重要，因為 major 版號不同還可能會導致 CSS 爆掉。

例如，從 Google CDN 下載：

```erb
<%= javascript_include_tag "//ajax.googleapis.com/ajax/libs/jqueryui/#{Jquery::Ui::Rails::JQUERY_UI_VERSION}/jquery-ui.min.js" %>
<script>window.jQuery || document.write('<script src="<%= javascript_path("jquery.ui.all") %>"><\/script>')</script>
```

但是， Google CDN 只有提供 JavaScript ，沒有提供 CSS 和圖片素材。所以要是你需要 CSS 的話，應該是要使用官方的 CDN （詳見 [jQuery UI 網站頁尾](http://jqueryui.com/)）。但 remote CSS 我不知道有什麼方法可以測試「下載失敗」的情況，我也沒這樣使用過，所以就等有需要的人研究吧。
