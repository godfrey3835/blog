---
layout: post
title: "關於 Ruby 的 autoload 與 Rails 的 autoload_paths 以及 reopen module / class"
published: true
date: 2014-02-10 13:04
tags:
- ruby
- rails
categories: []
comments: true

---
最近在實作一個特別的需求，做了一個 gem 搞這種事：

* 在 Gem 裡面， `lib/models/post.rb` 定義 `Post < ActiveRecord::Base`
* 在 App 裡面， `app/models/post.rb` 打開 `class Post` 多寫一些 app-specific methods

然後就搞了三天搞不定。

具體的現象是：

* 在 Gem 裡面，不論是使用 [`Kernel#autoload`](http://ruby-doc.org/core-2.1.0/Kernel.html#method-i-autoload) 還是 Rails 的 `config.autoload_paths <<` 來做到自動載入，都無法在 App 改寫 Post class 。
* 如果在 Gem 裡面不做 autoloading ，則 Rails 會去抓 App 裡面的 `app/models/post.rb`, which is not inherited from ActiveRecord::Base 。

之後試了繼承（很難搞）和 module ，最後是用 ActiveSupport::Concern 包了 module ，把 association 之類的東西寫在 `included do` 裡面，解決。

今天讀到這篇文章 [Rails autoloading — how it works, and when it doesn't](http://urbanautomaton.com/blog/2013/08/27/rails-autoloading-hell/) ，對於 Ruby 和 Rails 的 "autoload" 有粗略的瞭解了。簡單整理如下：
 
* Ruby 的 `Kernel#autoload` 是告訴 Ruby runtime 「要找某個 constant 的時候，可以載入某檔案」，比較像是「登記」，在登記之後， Ruby runtime 若發現程式裡面有要用某個 const ，但沒有定義，就會載入該檔案，這是發生在「第一次使用」的時候，用第二次就不會觸發。
* Rails 的 autoloading 跟 Ruby 的 `Kernel#autoload` 完全不一樣，實作方式是用 `Module#const_missing` ：抓不到（const 在 runtime 沒定義）的時候才自動根據 constant 找檔名，例如 `Taiwan::Taipei::SungShan` 就是會找 `taiwan/taipei/sung_shan.rb` 。
* 承上，「要去哪裡找檔案」這件事，是在 `config.autoload_paths` 設定的，這個 array 就是「要自動從檔案載入缺失的 const 的時候，就去依序搜尋哪些路徑」，類似 shell 的 `$PATH` 。如果檔案不存在，就會 raise NameError ；如果檔案存在，但 const name 跟所要找的不同，就會出現「Expected app/models/user.rb to define User」這種錯誤。
* 承上，第一次載入完成以後，就可以在 Runtime 裡面找到，所以不會再度觸發 `const_missing` 來自動搜尋。

所以：

* `Kernel#autoload` 不應跟 Rails 的 `autoload_paths` 混淆，要視為兩個完全不同的功能
* 誰第一次載入誰算數， Rails 只在找不到該 const 的時候才會去 `autoload_paths` 搜尋
* 所以，如果某個 const (class / module) 已經在 runtime 裡面定義了，那麼要在 Rails 裡面 reopen 它，就必須確定它一定會執行，例如 initializers 裡面，或是手動 require 它。如果是放在某個 autoload paths 裡面，例如 `app/models/` ，則 Rails 並不會執行之，因為同名的 const 已經在 Runtime 裡面了。

這也就是為什麼會有「在 gem 和在 app 裡面，同名的 model class 是 mutually-exclusive，除非手動 require 才能改寫其內容」。也就是說，想要在 gem 裡面定義一個 model ，然後在 rails app 裡面 reopen 它，是不可能的，必須要手動載入它的 reopening。

說得更 general 一點就是：如果該 class / module 已經在 Gem 裡面載入，則要在 Rails 裡面 reopen 它，就必須放在 `autoload_paths` 以外的地方，並且手動 require 之。

---

該文很推薦一讀，除了詳細說明了 Ruby 和 Rails 的 autloading 機制，還提到一些陷阱，例如說 Rails 的 autoloading 其實不會理 [Module.nesting](http://ruby-doc.org/core-2.1.0/Module.html#method-c-nesting) (lexical context of current line) ，這樣子某些情況下會變成「第一次可以成功 autoload ，但第二次卻說 NameError 找不到 const」這種問題。