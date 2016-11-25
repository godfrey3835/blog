---
layout: page
title: "Toolbox"
---

敝碼農用工具箱，不定期更新。我都在 Mac 上寫程式，所以這裡幾乎都是 Mac 的工具。推薦、勘誤、吐槽等，請 [@yorkxin](https://twitter.com/yorkxin) 。

<style type="text/css">
table {
  width: 100%;
}

table td:nth-child(1) {
  width: 25%;
}

table td:nth-child(3) {
  width: 20%;
}
</style>

## 編輯器

| 名 | 何 | $ |
|----|----|---|
| [Atom](https://atom.io) | 很好很強大的 code 編輯器 | Free |
| [Sublime Text 3](http://www.sublimetext.com/) | 用來快速改大檔的編輯器 | Free / US$70 |
| [MacVim](https://code.google.com/p/macvim/) | GUI 版的 VIM | Free |
| [TextWrangler](http://www.barebones.com/products/textwrangler/) | 用來處理各種編碼的編輯器 | Free |
| [0xED](http://www.suavetech.com/0xed/) | 二進位編輯器 | Free |

此外在 OS X 的編輯區按鍵（Home / End / PgUp / PgDn）行為跟 Windows 不同，我比較喜歡 Windows 的行為，所以有改裝 OS X 的按鍵規則，請參考 https://gist.github.com/chitsaou/3422794 。

## 日常生活

| 名 | 何 | $ |
|----|----|---|
| [Homebrew](http://brew.sh) | Package Manager for OS X ，必裝不解釋 | Free |
| [iTerm2](http://www.iterm2.com) | 終端機，可以分割視窗，優於 OS X 內建者 | Free |
| [PttChrome](https://chrome.google.com/webstore/detail/pttchrome/hhnlfapopmaimdlldbknjdgekpgffmbo?gl=TW&hl=zh-TW) | 上 BBS 用，支援 SSH | Free |
| [FiraCode](https://github.com/tonsky/FiraCode) | 內建 ligature 的寫程式用字型 | Free |
| [Input Fonts](http://input.fontbureau.com/) | 漂亮的寫程式用字型 | Free |
| [Source Code Pro](https://github.com/adobe/source-code-pro) | Adobe 出品寫程式用字型 | Free |
| [Source Sans Pro](https://github.com/adobe/source-sans-pro) | Source Sans Pro 的 Sans-Serif (P) 版本 | Free |
| [Source Han Sans](https://github.com/adobe-fonts/source-han-sans) | Source 系列字體的 CJK 版本 | Free |
| [Alfred](http://www.alfredapp.com/) | 秒開 App + Workflow Query (Powerpack) | Free / £17 |
| [Copy as Markdown](https://chrome.google.com/webstore/detail/copy-as-markdown/fkeaekngjflipcockcnpobkpbbfbhmdn) | 在 Chrome 拷貝超連結或圖片成 Markdown | Free (我做的) |
| [Native URL Shortener](https://chrome.google.com/webstore/detail/native-url-shortener/ngmiekalinhgehhfjbbiabodfeahckhe) | 縮址工具，特點在於有官方縮址就用官方 (如 youtu.be) | Free |
| [VirtualBox](https://www.virtualbox.org/) | 虛擬機，灌 Windows 用 | Free |

## 終端機 (Terminal) 用

用的是 Zsh ，並且有安裝 [Oh-My-Zsh](https://github.com/robbyrussell/oh-my-zsh) ，這大家都會裝，就不另外列了。

我的 `.zshrc` 和自訂 Theme 貼在這裡： https://gist.github.com/chitsaou/5771533

底下列出我有用的特殊 Zsh 外掛。

| 名（沒連結 = 內建） | 何 |
|----|----|
| history-substring-search | 打片段字串就可以往回搜尋之前打過的指令。 |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | 一邊打指令還有 syntax highlighting 很厲害吧 |
| [Sauce Code Pro for Powerline](https://github.com/Lokaltog/powerline-fonts/tree/master/SourceCodePro) | 專為 Powerline-based theme (\*) 設計的 Font |

(\*) Powerline-based theme: 源自 Vim 的 Powerline ，現在在 Zsh 也有類似的 theme 了。但需要特殊字元（特殊 Font）才能正常顯示，所以有人會把 Open Source 的 Font 加上這些字元之後 release 出來，在 Terminal 指定這種 Font 就可以正常顯示。附帶一提我改裝自 agnoster 的 Theme 也是 Powerline-based 。

## 開發 / 除錯工具

Chrome, Firefox, IE 內建的 Developer Tool 就不列了。

| 名 | 何 | $ |
|----|----|---|
| [Postman](http://www.getpostman.com) | HTTP 測試工具，拿來發 request 測 API 等 | Free |
| [httpie](https://github.com/jakubroztocil/httpie) | 同上，for CLI | Free |
| [pry-byebug](https://github.com/deivid-rodriguez/pry-byebug) | Ruby 2 的 CLI Debugger | Free |
| [better\_errors](https://github.com/charliesome/better_errors) | 給 Rails 用的即時 Error Console | Free |
| [mitmproxy](http://mitmproxy.org) | HTTP Logger，相當於 Windows 的 [Fiddler](http://www.telerik.com/fiddler) | Free |
| [GitUp](http://gitup.co/) | Git 的視覺化操作工具 | Free |
| [GitX (R)](http://rowanj.github.io/gitx/) | Git 的視覺化，追 blame 特別好用 | Free |
| [LiveReload](http://livereload.com) | CSS / JS 存檔即時在前端載入 | 通訊協定 Free / App $9.99 |
| [ImageOptim](http://imageoptim.com/) | 圖片壓縮工具（有 CLI 版） | Free |
| [Skala Color](http://bjango.com/mac/skalacolor/) | Programmer-Friendly 的調色盤，可以輸出 CSS 顏色和 Hex | Free |
| [Modern.IE](http://modern.ie) | Microsoft 官方提供的 IE 測試用虛擬機 | Free |
| [ievms](https://github.com/xdissent/ievms) | 一鍵灌好一堆 Modern.IE 的虛擬機 (VirtualBox) | Free |
| Xcode 內建的 debugger | 以前寫 C 常用。請參考[我寫的入門文](http://blog.yorkxin.org/posts/2009/03/15/fundamental-c-with-xcode) | Free |

## 資料庫

| 名 | 何 | $ |
|----|----|---|
| [Sequel Pro](http://www.sequelpro.com/) | MySQL 連線程式，用途相當於 phpMyAdmin | Free |
| [PSequel](http://www.psequel.com/) | PostgreSQL 連線程式，用途同上 | Free |
| [PG Commander](https://eggerapps.at/pgcommander/) | PostgreSQL 連線程式，用途同上 | Free / US$39 |
| [Postgres.app](http://postgresapp.com/) | 一鍵開 PostgreSQL Server | Free |

## 文件查詢

| 名 | 何 | $ |
|----|----|---|
| [Dash](http://kapeli.com/dash) | 萬能離線文件查詢器，再也不需要上網找文件 | NT$750 |
| [Rubydoc.info](http://rubydoc.info) | Gem 文件查詢 | - |
| [Mozilla Developer Network](https://developer.mozilla.org/en-US/) | HTML / CSS / JavaScript 前端文件查詢，有 Mozilla 掛保證的正確（Dash 可下載離線版） | - |
| [Unicode Checker](http://earthlingsoft.net/UnicodeChecker/) | 離線 Unicode 資料庫速查，含 Unihan、轉碼器 | Free |
| [httpstatus.es](http://httpstatus.es/) | HTTP Status Code 速查，另參考[維基百科](http://en.wikipedia.org/wiki/List_of_HTTP_status_codes) | - |
| [HTML Char Entity](http://dev.w3.org/html5/html-author/charref) | W3C 官方的 HTML character entity 速查 | - |

## 他

| 名 | 何 | $ |
|----|----|---|
| [`base64`](https://developer.apple.com/library/mac/documentation/Darwin/Reference/Manpages/man1/base64.1.html) | OS X 內建的 base64 編解碼器 | - |
| [Ruby-Toolbox.com](https://www.ruby-toolbox.com/) | 某功能不知道要用哪個 Gem 可以來這裡找 | - |


---

## 別人的工具箱

* [awesome-mac](https://github.com/jaywcjlove/awesome-mac)
* [hzlzh/Best-App: 收集&推荐优秀的 Apps (Mac OS & iOS)](https://github.com/hzlzh/Best-App)
* [我的工具箱 - 高見龍](http://blog.eddie.com.tw/2012/01/04/my-toolbox/)

