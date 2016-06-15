---
layout: post
title: "從 Mongoid 遷移至 ActiveRecord"
published: true
date: 2012-02-21 20:01
tags:
- rails
- activerecord
- Mongoid
categories: []
redirect_from: /posts/2012/02/21/migrate-from-mongoid-to-activerecord
comments: true

---


[Ruby Taiwan](http://ruby-taiwan.org) 是從 [Ruby China](http://ruby-china.org) fork 出來的論壇系統。原先 Ruby China 後端的資料庫系統使用的是 [MongoDB](http://mongodb.org/)，並搭配 [Mongoid](http://mongoid.org/) 這套 ORM for Rails，完全取代掉 Rails 的 ActiveRecord + 關聯式資料庫（如 MySQL） 的組合。

據說 MongoDB 在效能上比 MySQL 有過之而無不及，但因為 Mongoid 無法應用一些 ActiveRecord 特殊的功能或專屬的 gem，導致 Ruby Taiwan 要 refactor code 愈來愈困難，可以說是還沒享受到 MongoDB 的好處，就已經被 unmaintainable code 絆住腳了。因此 Ruby Taiwan 便決定要整個搬去 ActiveRecord + MySQL 。至於效能的話，最後面會提到。

不知道是吹著什麼風，現在很流行從 MySQL 搬去 MongoDB ，卻不流行反著搬， Google 一下關於 MongoDB 到 MySQL 的關鍵字，出來的全都是 MySQL 到 MongoDB 。只有[一篇文章][denmarkin-mongodb-to-ar]簡單地提到 MongoDB 到 MySQL 時要注意的一些事情，而且剛好他也是用 Ruby on Rails ，總算還是有一些參考資料。

[denmarkin-mongodb-to-ar]: http://denmarkin.tumblr.com/post/4475718721/jump-back-from-mongoid-to-activerecord "Jump back from Mongoid to ActiveRecord"

步驟大概是這樣：

1. 先把 ORM 換成 ActiveRecord
2. 把 Mongoid 寫成的 model 一個一個改成 ActiveRecord 版本
  * schema 要改，且需要注意 MongoDB 與 MySQL 資料型態的差異
  * Mongoid-only method 要改
  * 有些硬幹的資料模型要整個 refactor 掉
3. 搬資料

以下就把這次搬家時改到的東西寫下來。

遷移過程的 commits 在 [Ruby Taiwan 的 repository](https://github.com/rubytaiwan/ruby-taiwan/compare/94a3eec92371a23617e43f8ae1d8e995a712bf96...a794e08ff5a643b3ba43d717ca462d73c3646748) 。

<!-- more -->

## 一、用 ActiveRecord 取代 Mongoid 為 ORM

首先在 `Gemfile` 加入

```ruby
# Gemfile
gem 'mysql2'
```

然後在 `application.rb` 砍掉 `require 'xxxxxx/railtie'` ，改成 `require 'rails/all'`

先別砍掉 `mongoid` 系列的 Gem ，之後搬資料會用到。但是 Mongoid 這個 gem 一但安裝上去，就會覆寫掉 Rails 的 ORM 設定。如果需要暫時讓兩個 ORM 都可以使用（例如：搬資料的時候），就必須在 `config/application.rb` 裡面明確指定[（參考）][stackoverflow-ar-generators]：

```ruby
# config/application.rb
config.generators do |g|
  g.orm :active_record
end
```

[stackoverflow-ar-generators]: http://stackoverflow.com/questions/8404001/mongoid-and-activerecord-generators "ruby on rails 3 - Mongoid and ActiveRecord generators - Stack Overflow"

接下來只要 generator 裡面有使用到 ORM 的，都會正確使用到 ActiveRecord 了，例如 migration 或是 model generator 。

最後再進 Model 裡面砍掉所有的 `include Mongoid::xxxx` ，改繼承 `ActiveRecord::Base`

*Hint*: 有聞 Rails 4.0 也會改為全部要 `include ActiveRecord::XXX` 的方式，到時候看到這篇文章請自動腦補。

### 替換 ORM 的查詢操作

Mongoid 有一些查詢用的操作是跟 ActiveRecord 不相容的，要換掉：

- `desc(field)` (scope) 改成 `order("field DESC")`
- `asc(field)` (scope) 改成 `order("field ASC")`
- `object._id` (attribute) 改成 `object.id`

要注意的是，如果原本的程式裡面有連續排序了兩次，則 MySQL 的行為跟 MongoDB 不一樣。例如 Ruby China [原本的程式碼](https://github.com/rubytaiwan/ruby-taiwan/blob/94a3eec92371a23617e43f8ae1d8e995a712bf96/app/models/topic.rb#L44)裡面就有這一段：

```ruby
scope :last_actived, desc("replied_at").desc("created_at")
```

我一開始以為是這樣改成 ActiveRecord 版本：

```ruby
scope :last_actived, order("replied_at DESC, created_at DESC")
```

但其實這樣是錯的。

MongoDB 排序的原則是：

1. 如果兩筆資料都有 `replied_at` ，則直接照 `replied_at` 排序。
2. 其中一筆沒有 `replied_at` 或是其值 `NULL` 的話，則照 `created_at` 排序。

但 MySQL 是這樣排：

1. 先照 `replied_at` 排序， `NULL` 最小。
2. 如果兩筆資料的 `replied_at` 都一樣的話，才比較 `created_at`。


顯然這兩種演算法是不同的。那怎麼辦呢？改成這樣就行：

```ruby
scope :last_actived, order("IFNULL(replied_at, created_at) DESC")
```

這個 `IFNULL` 根據[官方文件][mysql-ifnull]，會先判斷 `replied_at` 是否為 `NULL` ，不是 `NULL` 就回傳 `replied_at` ，是 `NULL` 就回傳 `created_at` （備案）。這樣就符合原本的演算法了。

[mysql-ifnull]: http://dev.mysql.com/doc/refman/5.5/en/control-flow-functions.html#function_ifnull "Control Flow Functions - MySQL 5.5 Reference Manual"

### 簡單的全文搜尋

MongoDB 有內建[全文搜尋](http://www.mongodb.org/display/DOCS/Full+Text+Search+in+Mongo)，Mongoid 也提供叫做 `search_in` 的 mixin，這樣子的話就可以在該 model 裡面進行全文搜尋。但 ActiveRecord 沒有內建這種東西，要做全文搜尋的話，一般也是使用 [ThinkingSphinx](http://freelancing-god.github.com/ts/en/) 之類的東西。不過搬家是第一任務，這麼複雜的東西以後再搞。

這個全文搜尋有簡單、暴力的解決方案：[Ransack][ransack-gem]。什麼叫暴力呢？就是 issue `LIKE '%something%'` 這種 SQL query ，而且有 escape ，非常安心。

[ransack-gem]: https://github.com/ernie/ransack "Ransack"

## 二、重新定義 Database Schema

這裡應該是最費工的，一定要一步一步慢慢來，因為 **MongoDB 沒有 collection schema** ，而且 MongoDB 有**某些資料型態是 MySQL 所沒有的**。

MongoDB 的查詢語言是 JSON 加上一些[特殊的 operators](http://www.mongodb.org/display/DOCS/Advanced+Queries)，而且輸出的結果也是 JSON 的樣子，人眼要 parse 很辛苦。幸好在 OS X 有一個叫做 [MongoHub][mongohub-app] 的應用程式，雖然很難用，雖然還是得自己打 JSON query，但至少是 GUI 的，輸出的結果會整理成樹狀，也比較易懂。

[mongohub-app]: http://mongohub.todayclose.com/ "MongoHub"

### Schema-less 的困擾

在 MongoDB 裡面，每個 document 可以有自己的 fields ，要怎麼加都很彈性。所以就算你看到某個 document 有這個那個 fields ，**不代表每一個 document 都有同樣的 fields**。

在 Ruby China 的程式碼裡面，就會在 Model 裡面自動 `include` 一些 module ， Mongoid 也會為它們自動增加一些 fields ；而沒有 `include` 該 module 的 document，就不會有那些 fields ，如果在 Ruby 端呼叫相對應的 instance method ，也只會噴 `NoMethodError` exception。

甚至 Mongoid 還支援 [Dynamic Fields](http://mongoid.org/docs/documents/dynamic.html) ，這時候就算你沒有定義 field 還是有可能會寫入到 MongoDB 裡面。不過 Ruby China 的程式碼並沒有使用到這個 *"feature"*。

所以，就算 Mongoid 要求你在 Model 裡面定義 Schema（`field`、`index`），不代表每個 document 都會遵循這個 schema 。你必須要**每個 class、每個 module** 都清楚明白它會指定什麼 field ，才有辦法在 Relational Database 裡面重新定義 schema 。

### 特殊資料型態的轉換

MongoDB 有某些[資料型態](http://bsonspec.org/#/specification)，在 [MySQL 裡面](http://dev.mysql.com/doc/refman/5.5/en/data-types.html)並不存在，或是功能有所不同，而這也反應在 ORM 的 API 上面。光 [Mongoid 的文件](http://mongoid.org/docs/documents/fields.html)裡面列舉出來支援的資料型態，就有以下這些不存在於 ActiveRecord ：

- `Array`
- `Hash`
- `Range`
- `String`
- `Symbol`

會特別寫 `String` 是因為，在 ActiveRecord 裡面會依需求使用 `string` (`VARCHAR`) 或 `text` 表示，下文詳述。

#### Array type

MongoDB 可以直接塞 embedded Array 進去 field，但 MySQL 沒有。可以在 ActiveRecord 裡面重新定義成 `text` ，並且在 model 端做 `serialize` ；如果資料有必要跟別的 table 做 join ，就 normalize 出來，並另外寫成一個 model 給人家做關聯。

例如在 Ruby China 的程式碼中，有以下這些地方使用到 array ：

**User 的 `authorizations`**。這個還必須用 `@user.authorizations` 才拿得到，不能直接找 `Authorization.where(:user_id => 123)` ，因為它是 embedded。

**User、Topic、Node 的 `follower_ids`**。這個在 refactor 的時候，直接造了一個新的 polymorphic Following model。

**Reply 的 `mentioned_user_ids`**。這個直接改成 `text` 並且用 `serialize` 處理掉：

```ruby
serialize :mentioned_user_ids, Array
```

在以上講到的這些地方，多多少少會出現為了儲存成 array ，而使用到 `.map(&:id)` 之類的操作，除了改成 `serialize` 的 field 還需要保留，其他的都不必保留了，使用 association 提供的操作便是。

#### String type

MongoDB 裡面的 `String` 不像 MySQL 的 `VARCHAR` 有限制長度，所以當你看到一個 field 定義的 datatype 是 `String` 的時候要留意，它可能是用來**當做文本內容**，也就是 `TEXT` type。在轉換 schema 的時候，必須要觀察原本程式的行為（如表單裡該欄位的長相），才能確定要換成哪個 type 。

例如在 Ruby China 的程式碼中，這些 field 定義為 `String`，但卻是文本內容，必須定義成 `TEXT`：

- User#bio
- Topic#body
- Reply#body
- SiteConfig#value
- Site#desc

#### Hash type (Embedded Document)

MongoDB 可以塞一個 embedded document 進去一個 field ，在 Mongoid 裡面就表示成 `Hash` ；這種東西可能也是沒有 schema 的。這次在 Ruby China 裡面沒遇到；如果你遇到了，可以考慮也把它做 `serialize` ，並鎖 serialization type 為 `Hash` 來防止存錯資料。

#### Symbol type

Ruby China 的程式碼裡面沒有使用到資料型態為 `Symbol` 的 field。如果你遇到了，應該有 3 種方法：

1. serialize 掉，但 YAML parsing 會花一點時間
2. 全部改成 `string` ，改這個可能會花很多時間
3. 如果是用來表達狀態，則改用 State Machine 實作（見下文）， refactor 一次、終身免疫（？）

#### Range type

Ruby China 的程式碼裡面也沒有使用到資料型態為 `Range` 的 field。如果你遇到了，應該有 2 種方法：

1. serialize 掉，但 YAML parsing 會花一點時間
2. 開兩個 field 分別記錄 begin 和 end

## 三、重構資料結構與關聯

這些跟 MongoDB 轉到 MySQL 的差異比較沒有關係，只是原本的程式碼用到了很多硬幹的地方，導致資料結構和關聯性變得很冗長且難以維護。我不確定是否 Mongoid 沒有提供這些功能，但這些可以在 ActiveRecord 輕易地實現。

### 客製化的 counter

Ruby China 的 model 有用到不少的 counter cache ，但卻都是自己製作的程式。這些在 ActiveRecord 都有提供。

#### Referencing counter

Referencing counter 我指的是「topic 有 replies ，**每次增刪都把 counter 記在一個欄位，避免動態計數**」這種東西。Ruby China 原本的程式碼是自己寫一個 module ，再動態地加上一個 field ，並透過 callback 去增值。在 ActiveRecord 裡面可以透過 `:counter_cache` 來做，具體請參考[這個教程][counter-cache]。

[counter-cache]: http://railscasts.com/episodes/23-counter-cache-column "Counter Cache Column - RailsCasts"

#### Read counter

此外還有另一個是 Read counter ，在 Post 及 Topic model 裡面，叫做 `hits` ，我指的是 Post、Topic 被閱讀的次數，每讀一次就 +1 。

這個 counter 是通過 Redis 提供的，我可以理解如果使用 Redis 的話有一些好處，諸如少一條 SQL Query 、沒有 race condition 之類的。不過 MySQL 也是 thread-safe 的，且網站還沒有大到需要透過 Redis 來加速這個功能，就姑且放在 MySQL 裡面吧。

具體的做法是透過 `increment_counter` [（參考）][increment-counter] ：

```ruby
# app/models/topic.rb
class Topic < ActiveRecord::Base
  def visit
    self.class.increment_counter(:visit_count, self.id)
  end
end
```

在 Controller 用 after_filter 去 hook ：

```ruby
# app/controllers/topics_controller.rb
class TopicsController < ApplicationController
  after_filter :only => :show do
    @topic.visit
  end
end
```

[increment-counter]: http://api.rubyonrails.org/classes/ActiveRecord/CounterCache.html#method-i-increment_counter "Increment Counter"

### 軟刪除 (soft-delete)

Ruby China 的程式裡面，有為 User、Topic、Reply、Post、Comment、Site 做軟式刪除（soft-delete），這個目的是為了

1. 刪掉東西其實是封存，以後有什麼爭議就有個依據
2. User 刪掉之後，原本產生的內容還會存在，不會一併砍掉，避免 reference 消失導致 runtime error

#### ActsAsArchive - 資源回收桶

其中 Topic、Reply、Post、Comment、Site 直接改用 [ActsAsArchive][acts-as-archive] ，刪掉的話就像是丟到資源回收桶， associations 也會自動呼叫 dependency hook。但是 ActsAsArchive 在 rubygems 上面的版本過舊，舊到根本不能在 Rails 3.2 上面運作，所以其實是使用另一個[由 stipple 維護的版本][acts-as-archive]。

此外，雖然 ActsAsArchive 號稱你改了原 table 的 schema 它會自動 migrate ，我實際操作之後卻沒有這個效果。這個問題先擺著，等別人來改。

[acts-as-archive]: https://github.com/stipple/acts_as_archive "ActsAsArchive"

#### State Machine - 抽象描述物件狀態

而 User 的軟刪除還要**保留原本該 user 產生的內容**，如 topics、replies 等等，要是使用 ActsAsArchive，會變成完全不同的 class，原本資料表裡面的東西也會消失，reference 也就消失了，與需求不符。

所以 User 實際上是改用[有限狀態機][finite-state-machine]來實作軟式刪除，並且將原本硬幹的 state （有 `normal`、`blocked`、`deleted`）整合起來，使用到的 Gem 是 [state_machine][state-machine-gem] 。為什麼不用 AASM 呢？因為 **state_machine 可以查詢 transition table**，但 AASM 不行，這對於要跟 [cancan](https://github.com/ryanb/cancan) 整合的站來說非常方便，檢查權限的時候可以**檢查是否該物件能夠接受某個 event**，而不是檢查 state 的值。

具體的使用方法可以參考 [state_machine 的 README][state-machine-gem]，或我在 Ruby Taiwan 寫的[這篇簡介](http://ruby-taiwan.org/topics/150)。

[finite-state-machine]: http://en.wikipedia.org/wiki/Finite-state_machine "Finite-state Machine - Wikipedia"

[state-machine-gem]: https://github.com/pluginaweek/state_machine "state_machine"

## 四、搬資料

雖然成功在 ActiveRecord 重新把資料模型給造出來了，但舊的資料還是要搬過去。

搬資料的原則是這樣：

1. 從 Mongoid model 拿資料出來，直接**打 SQL Query 進 ActiveRecord**
2. 上傳圖片 (Photo) 不搬，因為原本就沒有打開這個功能。
3. 某些即將 deprecated 的功能所依賴的 model 也不搬

其中**直接打 SQL Query** 這件事我到後來才明白。

一開始我很天真地認為，應該是從 Mongoid 版本的 model 拿出 instance ，再 create 一個 ActiveRecord 版本的 model instance 會比較好，但這樣一來 association id 就會全部亂掉了，不合用。

幸好 ActiveRecord 還是可以讓我們直接 issue `INSERT` query ，而且是搭配 Arel 來產生有 escape 過的 SQL ，參考的程式是 [ActiveRecord Migration 的程式碼][migration-insert] ，如下：

```ruby
table = Arel::Table.new("site_configs")
stmt = table.compile_insert(table["id"] => 5, table["key"] => "123", table["value"] => "456")
ActiveRecord::Base.connection.insert stmt
```

當然，為了簡化欄位對應的操作，[搬資料的程式][ruby-taiwan-move-data]有稍微模組化。

[migration-insert]: https://github.com/rails/rails/blob/3-2-stable/activerecord/lib/active_record/migration.rb#L733 "ActiveRecord::Migration#record_version_state_after_migrating"

[ruby-taiwan-move-data]: https://github.com/chitsaou/ruby-taiwan/blob/bye-mongo/lib/tasks/transfer.rake "ruby-taiwan/lib/tasks/transfer.rake"

### 實際搬資料

1. 從舊的 branch 裡面撿回 Mongoid 的 model 程式碼（你看 git 多方便），
2. 一個個冠上 `MongoDB::` 的 namespace ，丟進 `app/models/mongodb/`。如此就不會跟已經寫好的 ActiveRecord models 相衝突。
3. 執行[轉檔程式][ruby-taiwan-move-data]： `rake transfer`。

### 收尾

Mongoid 到這裡可以說是完全無用了，要清掉的東西如下：

- 砍掉 Gemfile 裡相關的 gem
- 砍掉轉檔程式
- 改掉 model localization 的 namespace

## 結語

這次從 Mongoid 搬到 ActiveRecord 其實花了很多時間。且不說原本的程式碼有許多地方值得 refactor ，光是 MongoDB 太隨意導致 Rails 端的程式碼與資料庫本身不一致，就搞得頭很痛了。

所以我認為 MongoDB 不適合 Rails app 最大的理由是：**沒有 Schema** 。

在 Mongoid 改了 schema 不必與資料庫後端同步，導致一個 collection 內部的 documents 之間就有可能少一個欄位、多一個欄位，默默地佈下地雷。當要記錄的資料非常依賴於其資料結構時（姑且稱它為 **"record"**），我認為就必須使用有 schema 的資料模型。

雖然會造成資料模型不一致的原因，應該是那幾個 `include` 進去的 modules ，但它就是造成了不一致： `include` 之後的 document 都有新的 field ，之前的就沒有。哪天該 field 被砍掉了，又被加回來了，該如何處理原本就有該 field 內容的 documents ？

此外，沒有 counter cache ，還得要自己做，這個就有點重新造輪子。不過這應該要怪 Mongoid ，說不定別的 MongoDB ORM 有。

### 效能？

至於大家最關心的可能是：

**MongoDB 的效能不是比 MySQL 好嗎？搬了之後效能不會下降嗎？**

根據 [@XDite](http://blog.xdite.net) 在 deploy 之後的觀察（[1](https://twitter.com/#!/xdite/status/171883236446846977), [2](https://twitter.com/#!/xdite/status/171896863354658816), [3](https://twitter.com/#!/xdite/status/171911846729744385)），以及我在開發過程中的感受，事實上，

**換到 ActiveRecord 之後變得*超快ㄉ*！！！**

當然我沒有實際做過 benchmark 也不好鐵口直斷，但我個人猜測是 Mongoid 這個 ORM 寫爛了，別的 MongoDB ORM 會不會比較好？就等五樓來證實了。
