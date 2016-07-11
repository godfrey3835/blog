---
layout: post
title: "利用 CSS 分別設定中文字、英數、注音、假名的字體：使用 CSS3 @font-face"
published: true
date: 2012-06-17 17:23
tags:
- css
- fonts
- web development
categories: []
redirect_from: /posts/2012/06/17/assign-fonts-for-specific-characters
comments: true

---


先曬一下結果的畫面，也可以用 Chrome 或 Safari ，[打開這裡看 demo](http://playground.yorkxin.org/mixed-font-face/)（目前 Firefox 不支援）：

[![](/images/2012/2012-06-17-assign-fonts-for-specific-characters/Screen Shot 2012-06-17 at 17.51.48.png)](http://cl.ly/0I3q2y0k2r2M212C3u3o)

以上**全都是用 CSS 做出來的**，不是一個一個反白再選字體（要是這樣我也不用寫一篇了）。

要做到這一點，必須使用 CSS3 `@font-face` 提供的 `unicode-range` descriptor 。這招也不是沒有人玩過，在 2011 年底，就有人拿來[設定西文裡面 "&amp;" (ampersand) 的字體](http://24ways.org/2011/unicode-range)了，而在中文圈裡，[@ethantw](https://twitter.com/ethantw) 在 2011 年中期開始製作[漢字標準格式・標點樣式](http://ethantw.net/lab/han/biaodian_fuhao_yangshi.html)，來修正不同漢字地區的標點符號，當前的版本也應用了 `unicode-range`。

以下就來解釋如何完成的。

<!-- more -->

## CSS3 @font-face 的 unicode-range

根據 [W3C 的 spec](http://www.w3.org/TR/css3-fonts/#descdef-unicode-range) ，`unicode-range` 是這樣用的：

```css
@font-face {
  font-family: MyCustomFont;
  unicode-range: U+00-7F; /* ASCII */
  src: local(Helvetica), local(Arial); /* 先找 Helvetica ，沒有的話用 Arial */
}
```

這樣子的話，在 CSS 裡面就可以使用 `font-family: MyCustomFont` ，但是它只會套用在 U+00 到 U+7F 這些字元（[Basic Latin](http://en.wikipedia.org/wiki/Basic_Latin_%28Unicode_block%29)，即 ASCII），即使 Helvetica 和 Arial 有提供其他字元，例如帶有重音符號的拉丁字母 `é` （U+00E9，在 [Latin-1 Supplement block](http://en.wikipedia.org/wiki/Latin-1_Supplement_%28Unicode_block%29)），它還是不會套用這個字體。

![](/images/2012/2012-06-17-assign-fonts-for-specific-characters/Screen Shot 2012-06-17 at 21.36.01.png)

### unicode-range 的寫法

`unicode-range` 的 syntax 有以下 3 種（範例由 W3C spec 而來）：

- `U+416` - 單一個 code point
- `U+400-4FF` - 某個 code point 區間（含頭尾）
- `U+4??` - 尾碼任意的 code point，以這個例子來說，等義於 `U+400-4FF`。

如果要指定多個 ranges ，就是用逗號 `,` 分開：

```css
@font-face {
  /* ... */
  unicode-range: U+123, U+456-7FF, U+9??;
}
```

`unicode-range` 預設值是 `U+0-10FFFF` ，也就是涵蓋了所有 [Unicode 的 code point space](http://en.wikipedia.org/wiki/Unicode_block)，白話的意思就是「不寫的話，這個 font face 要套用到所有字元」。

## 對同一個 font-family 的特定 unicode-range 設字體

這招在 W3C 的 spec 有教，以下的例子是「拉丁字、注音符號、日文假名用特別的字體，其他用預設的 Heiti TC（如果沒有 Heiti TC，就使用微軟正黑體）」。我們都知道，Heiti TC 的拉丁字、注音符號、日文假名都很醜，至於微軟正黑體是為了在 Windows 7 上面 Demo 用的：

```css
@font-face {
  font-family: MyCustomFont;
  src: local(Heiti TC), local("微軟正黑體");
  /* no unicode-range; default to all characters */
}

/* Latin characters 專用 */
@font-face {
  font-family: MyCustomFont; /* 同樣的 font-family */
  unicode-range: U+00-024F;  /* Latin, Latin1 Sup., Ext-A, Ext-B */
  src: local(Helvetica),     /* OS X preferred */
       local(Arial);         /* Other OS */
}

/* 注音符號專用 */
@font-face {
  font-family: MyCustomFont;      /* 同樣的 font-family */
  unicode-range: U+3100-312F;     /* Bopomofo */
  src: local(LiHei Pro),          /* OS X */
       local("微軟正黑體"); /* Windows Vista+ */
}

/* 日文假名專用 */
@font-face {
  font-family: MyCustomFont;            /* 同樣的 font-family */
  unicode-range: U+3040-30FF;           /* Hiragana, Katakana */
  src: local(Hiragino Kaku Gothic Pro), /* OS X */
       local(Meiryo);                   /* Windows Vista+ */
}

body {
  font-family: MyCustomFont, sans-serif;
}
```

最後的結果，就是拉丁字、注音符號、日文假名用了另一種字體，而其他的文字則是用 Heiti TC；在 Windows 上面，則是使用微軟正黑體（假設使用者沒有自行安裝 Mac OS X 的字體）。

[![](/images/2012/2012-06-17-assign-fonts-for-specific-characters/Screen Shot 2012-06-17 at 21.42.43.png)](http://cl.ly/3b2L352q1J1o2v2S0d2p)

## 覆寫 Generic Family

[Generic Family](http://www.w3.org/TR/css3-fonts/#generic-font-families) 就是 sans-serif 、 serif 這些基本的 style 。我在嘗試 `@font-face` 的時候，很好奇能不能把 `font-family` 指定成 Generic Family ，用來覆寫瀏覽器預設（或在偏好設定裡指定）的這些字體。實際試了一下，還真的可以，只要把上面的 CSS 裡面的 `MyCustomFont` 改成 `sans-serif` ，然後把 `body` 的 `font-family` 設成 `sans-serif` ，效果就跟之前一樣。

## 最終效果

文章一開頭的效果跟上面所示的例子其實不太一樣：

1. 沒有預設字體，交給瀏覽器決定。
- 漢字用 Heiti TC
- 其他一樣

並且把 `serif` 也加進來。[實際 demo 在此](http://playground.yorkxin.org/mixed-font-face/)。

[![](/images/2012/2012-06-17-assign-fonts-for-specific-characters/Screen Shot 2012-06-17 at 17.51.48.png)](http://cl.ly/0I3q2y0k2r2M212C3u3o)

## 後記：Web Font

會做這個實驗，是前幾天看到 [@ethantw](https://twitter.com/ethantw) 做的[漢字標準格式・標點樣式](http://ethantw.net/lab/han/biaodian_fuhao_yangshi.html)，可以讓標點符號符合台、港式（置中）或中、日式（左下角）的標點。我很是好奇他怎麼能夠只針對標點符號去設定字體，於是打開了他的 CSS ，發現他在 `@font-face` 裡面使用了 `unicode-range`。

我以前只知道 `@font-face` 拿來玩 Web Font，也就是說即使你的電腦裡沒有這個字體，也可以讓瀏覽器去下載並套用。現在才知道 `@font-face` 裡面可以寫 `unicode-range` 並且重覆寫 `font-family: MyCustomFont` 來製作出混合了數種字體的新字體。

事實上，上一次 [Chrome 18 字體亂象](http://blog.yorkxin.org/2012/05/03/chrome-18-chinese-font-fail-and-solution/)發生時，我曾經嘗試在 User Agent Stylesheet （`Custom.css`）裡面覆寫 `sans-serif` 的字體為 `Helvetica` ，想說這樣應該可以讓 Chrome 的字體 fallback 機制回到 OS X 處理。但那時候這樣做卻沒有成功，所以轉而去搞 Extension 。日前 Safari 6 也出現了同樣的功能，於是試了一下 [custom stylesheet](http://blog.yorkxin.org/2012/06/17/safari-6-per-script-font-fallback/) ，還真的可以 hack 掉 fallback 機制，那時候再回去 Chrome 試這招 override `sans-serif` 的 hack，竟然就可以了。

不過說到 Web Font 這技術，因為設計給漢字文化圈的字體都比較大（以 MB 為單位，因為字元多），所以這項技術只流行在歐美的網站（用拉丁字母，數十 KB 而已）。當然台灣也有[救世字](http://www.justfont.com/)在嘗試提供中文 Web Font 服務，最近的 [HITCON 2012](http://hitcon.org/2012/) 也展示了這項服務的潛力。

## 參考資料
- [Character range: the unicode-range descriptor - CSS Fonts Module Level 3 - W3C](http://www.w3.org/TR/css3-fonts/#descdef-unicode-range)
- [Unicode block - Wikipedia](http://en.wikipedia.org/wiki/Unicode_block)
- [24 ways: Creating Custom Font Stacks with Unicode-Range](http://24ways.org/2011/unicode-range)
