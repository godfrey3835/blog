---
layout: post
title: 'Ruby: "Ambiguous Time: 1895-12-31 23:59:59"'
published: true
date: 2013-08-26 22:30
tags:
- ruby
- "時區"
categories: []
redirect_from: /posts/2013/08/26/ruby-ambiguous-time
comments: true

---
在[T客邦](http://www.techbang.com)的某站某個網址，有時候會出現這個 Exception ：

    TZInfo::AmbiguousTime: 1895-12-31 23:59:59 UTC is an ambiguous local time.

出現的機率很低，大概數個月才一次， User Agent 都是搜尋引擎的 bot ，所以也不能算是惡意 request 。這個 exception 不會影響網站的運作，但就是很好奇為什麼會出現。

前些日子終於找到時間來深入研究了，結果是 TZInfo 這個時區 gem 的問題。

<!--more-->

## Ambiguous Time: 程式無法正確轉換當地時間到 UTC

根據文件， [TZInfo](http://tzinfo.github.io/) 裡面的 [AmbiguousTime](http://tzinfo.rubyforge.org/doc/TZInfo/AmbiguousTime.html) exception ，只會從 [Timezone.period\_for\_local](http://tzinfo.rubyforge.org/doc/TZInfo/Timezone.html#method-i-period_for_local) 和 [Timezone.local\_to\_utc](http://tzinfo.rubyforge.org/doc/TZInfo/Timezone.html#method-i-local_to_utc) 裡面 raise 出來，表示「這個本地時間在 UTC 可能有多個對應的時間，所以不知道怎麼轉成 UTC」。示例：

    > time = Time.new(1895,12,31,23,59,59)
     => 1895-12-31 23:59:59 +0800
    
    > TZInfo::Timezone.get("Asia/Taipei").local_to_utc(time)
     => TZInfo::AmbiguousTime: Time: 1895-12-31 23:59:59 UTC is an ambiguous local time.
    
    > TZInfo::Timezone.get("Asia/Shanghai").local_to_utc(time)
     => 1895-12-31 15:54:02 UTC

上述示例使用的 TZInfo 版本是 [0.3.37](https://rubygems.org/gems/tzinfo/versions/0.3.37) 。

如果升級到 [TZInfo 1.0.1](https://rubygems.org/gems/tzinfo/versions/1.0.1) 就沒有這個問題，但是， TZInfo 1.0 系列的時區資料，是直接讀 OS 內建的 [IANA TZ Database](http://www.iana.org/time-zones) ，而不是像以前的版本，是將 IANA TZ Database parse 出來變成 Ruby representation ，包成 gem ，載入 tzinfo 的時候將資料結構塞到記憶體裡面。示例：

    > time = Time.new(1895,12,31,23,59,59)
     => 1895-12-31 23:59:59 +0800
    
    > TZInfo::Timezone.get("Asia/Taipei").local_to_utc(time)
     => 1895-12-31 15:59:59 UTC
    
    > TZInfo::Timezone.get("Asia/Shanghai").local_to_utc(time)
     => 1895-12-31 15:54:02 UTC

原本在 0.3.x 使用的資料庫，抽出成 [tzinfo-data](https://rubygems.org/gems/tzinfo-data) ，在 TZInfo 1.0.x ，如果 gemset 裡面有安裝了 tzinfo-data ， TZInfo 就會改用 tzinfo-data 並讀取 Ruby representation ，這樣的話，就會發生同樣的錯誤。

<del>要排除這個問題，最簡單的做法當然就是升級 TZInfo 到 1.x 系列，因為顯然這個問題只有在 0.3.x 才有。不過 Rails 綁 `tzinfo ~> 0.3.37` （3.2 系列綁在 ActiveRecord ， 4.0 系列綁在 ActiveSupport），所以寫 App 的人也沒辦法直接 override 。最後我們決定 wontfix。</del>

**更正啟事**：[根據 TZInfo gem 維護者的說法](https://github.com/tzinfo/tzinfo-data/issues/1)，會 raise AmbiguousTime 才是正確的行為，因為根據 TZ Database 的規則，把這樣的時區轉換視為「在 UTC 時間到 1895 年 12 月 31 日 15:54:00 的時候，在 Asia/Taipei 時區的時鐘，要往回撥 6 分鐘」，因此，從當地時間轉到 UTC 就有兩種選擇，所以才會是 AmbiguousTime 。至於為什麼採用 OS 內建的資料庫就沒事，請見下文。

他提出的 Workaround 是，既然程式不知道要選哪一個時間，就幫他選一個吧，例如，第一個：

		> TZInfo::Timezone.get("Asia/Taipei").local_to_utc(time) {|periods| periods.first }
		=> 1895-12-31 15:53:59 UTC

## 整整 6 分鐘的 AmbiguousTime

嘗試窮舉哪些時間會有問題：

```ruby
require 'tzinfo'

tpe = TZInfo::Timezone.get("Asia/Taipei")

time = Time.new(1895,12,31,0,0,0)

while time.year < 1896
  begin
    tpe.local_to_utc time
  rescue TZInfo::AmbiguousTime => e
    puts "Conversion failed: #{time}" 
  ensure
    time += 1
  end
end
```

這結果是從 23:54:00 到 23:59:59 每一秒都有問題：

    Conversion failed: 1895-12-31 23:54:00 +0800
    # ...
    Conversion failed: 1895-12-31 23:59:59 +0800

但只有整整 6 分鐘。

去翻了 IANA TZ Database ，發現到有定義 Local Mean Time 是 **GMT+8:00:06** ，並且這個定義直到 1896 年才廢止，改用時區 UTC+8 ，符合史實：日本統治台灣之後，在 1896 年訂台灣和一部份珫球群島採西部標準時，以現在的說法就是 UTC+8 。見 [http://en.wikipedia.org/wiki/Time_in_Japan](http://en.wikipedia.org/wiki/Time_in_Japan) 。

    # Zone  NAME        GMTOFF  RULES   FORMAT  [UNTIL]
    Zone    Asia/Taipei 8:06:00 -       LMT     1896 # or Taibei or T'ai-pei
                        8:00    Taiwan  C%sT

所謂「整整 6 分鐘都無法轉換」可能跟這個 LMT 的定義有關。

<del>目前只能猜想是 TZInfo library 的問題，可能是 0.3.x 的轉換程式沒有考慮到某些極端狀況。若你的程式很在意這個「從無到有」的過渡時期，請考慮改用 TZInfo 1.0.x 。</del>

**更正啟事：** [根據 TZInfo gem 維護者的說法](https://github.com/tzinfo/tzinfo-data/issues/1)，**Ambiguous Time 是預期的行為**，至於為什麼使用 OS 內建的 TZ Database 和使用 tzdata-info 的結果不同，可能是 OS 內建的版本不支援 64-bit timestamp。問完之後會再整理成一篇，圍觀網址： [https://github.com/tzinfo/tzinfo-data/issues/1](https://github.com/tzinfo/tzinfo-data/issues/1) 。

---

後來稍微考據了一下台灣的時區過渡過程，發現了一些有趣的事，[下一篇文章詳述](http://blog.yorkxin.org/2013/08/26/time-zone-in-taiwan/)。