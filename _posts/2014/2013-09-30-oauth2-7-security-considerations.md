---
layout: post
title: OAuth 2.0 筆記 (7) 安全性問題
published: true
date: 2013-09-30 21:49
tags:
- OAuth
categories: []
redirect_from: /posts/2013/09/30/oauth2-7-security-considerations
comments: true

---
這篇整理了 OAuth 2.0 spec 裡面 Section 10 關於安全性問題的討論。關於安全性模型、分析方式、通訊協定的設計背景，可見 [OAuth-THREATMODEL](http://tools.ietf.org/html/rfc6819)。（我沒看，而且我看到的時候已經變成 RFC6819 了）在原文裡面，如果是屬於特定主題的（如 Implicit Grant Type），則我會整理到對應的文章去。剩下來的就在這裡了。

以下的次標題都是我自己加的。

除了 Spec 裡面提到的這些，我還有找到一些 service provider 有提供安全性指南，可以參考：

* [Login Security - Facebook Developers](https://developers.facebook.com/docs/facebook-login/security/)
* [应用安全开发注意事项 - 新浪微博API](http://open.weibo.com/wiki/%E5%BA%94%E7%94%A8%E5%AE%89%E5%85%A8%E5%BC%80%E5%8F%91%E6%B3%A8%E6%84%8F%E4%BA%8B%E9%A1%B9)
* [Amazon OAuth 文件的 Security Considerations](https://images-na.ssl-images-amazon.com/images/G/01/lwa/dev/docs/website-developer-guide._TTH_.pdf)

<!--more-->

## Client 認證的安全性問題 (Section 10.1)

見[系列文第 2 篇](http://blog.yorkxin.org/posts/2013/09/30/oauth2-2-cilent-registration/)。

## 偽裝成別的 Client (Section 10.2)

見[系列文第 2 篇](http://blog.yorkxin.org/posts/2013/09/30/oauth2-2-cilent-registration/)。

## Access Token 的安全性問題 (Section 10.3)

### 保密傳輸、保密儲存

Access Token 的 crednetials 以及任何機密的 Access Token 屬性，都必須要保密傳輸、保密儲存，並且只能在以下角色之間流通：

* Authrization Server
* Access Token 搭配的 Resource Server
* Access Token 所核發的對象 Client

Access Token credentials 必須只能經過 TLS 傳輸，還要搭配 Server Authentication （定義在 RFC 2818: HTTP over TLS）。

### Implicit Flow 的 Token 外洩風險

Implicit Grant Type Flow 的 Access Token 是經過 URI Fragment 傳輸的，可能會外洩給未經授權的第三方。

### 防猜猜樂攻擊

Authorization Server 必須確保 Access Token 不會被未經授權的第三方自動產生、被修改、被猜出如何產生可以用的。

### 決定 scope 時可以對 Client 階級歧視

Client 請求 Access Token 的時候，應該只請求最少需要的 scope 。Authorization Server 在選擇如何遵守所請求的 scope 的時候，應該要考慮 Client 的身份，並且可以核發少於所求的 scope 的 Access Token。（編按：亦即決定 scope 的時候，可以對 Client 實施階級歧視）

### 無機制來確保 Access Token 的權威性

Spec 不為 Resource Server 提供任何方法來確保 Client 出示的 Access Token 真的是 Authorization Server 核發的。

## Refresh Token 的安全性問題 (Section 10.4)

### 核發對象

Authorization Server 可以核發 Refresh Token 給這些 Clients：

* Web Application Clients （跑在 Server 上）
* Native Application Clients

（編按： Angular.js 之類的 client-side app 算 UA-based Clients ，不可以核發 Refresh Token）

### 保密傳輸、保密儲存

Refresh Token 必須要保密傳輸、保密儲存，並且只能在以下角色之間流通：

* Authrization Server
* Refresh Token 核發的對象 Client

Authorization Server 必須把 Refersh Token 和被核發的 Client 綁定。

Refresh Token credentials 必須只能經過 TLS 傳輸，還要搭配 Server Authentication （定義在 RFC 2818: HTTP over TLS）。

（編按：除了「不能給 Resource Server」 、「要求必須綁定 Client」 ，其他跟 Access Token 的保密要求一樣）

### 自動把舊的 Token 撤銷掉

例如，Authorization Server 可以實施 Refresh Token Rotation ：

* 每一次換發 Access Token 的時候，一併換 Rrefresh Token
* 之前的 Referesh Token 就變成無效
* 但是保留在 Authorization Server 裡面

如果 Refresh Token 被偷，還隨後被壞人和合法的 Client 同時使用，那麼其中一個將會出示無效的 Refresh Token ，這樣 Authorization Server 就可以甄別兩方，壞人就會破功。

### 防猜猜樂攻擊

Authorization Server 必須確保 Refresh Token 不會被未經授權的第三方自動產生、被修改、被猜出如何產生可以用的。

## Authorization Code 的安全性問題 (Section 10.5)

見[系列文第 4.1 篇](http://blog.yorkxin.org/posts/2013/09/30/oauth2-4-1-auth-code-grant-flow/)。

## 竄改 Authorization Code 的 Redirection URI (Section 10.6)

見[系列文第 4.1 篇](http://blog.yorkxin.org/posts/2013/09/30/oauth2-4-1-auth-code-grant-flow/)。

## Resource Owner Password Credentials 的安全性問題 (Section 10.7)

見[系列文第 4.3 篇](http://blog.yorkxin.org/posts/2013/09/30/oauth2-4-3-resource-owner-credentials-grant-flow/)。

## Request 的加密傳輸 (Section 10.8)

以下這些資訊禁止沒加密就傳輸：

* Access Token
* Refresh Token
* Resource Owner Passwords
* Client Credentials

Authorization Code 最好不要沒加密就傳輸。（不強求）

`state` 和 `scope` 參數最好不要明文內嵌關於 Client 或 Resource Onwer 的敏感資訊，因為他們可能會沒有加密傳輸、加密儲存。

（編按：這裡的加密傳輸我解釋為 TLS）

## 確保 Endpoint 的權威性 (Authenticity) (Section 10.9)

為了防止中間人攻擊，對於往 Authorization Endpoint 和 Token Endpoint 的 requests：

* Authorization Server 必須要有 TLS 加上伺服器認證 (RFC 2818)
* Client 必須驗證 Server 的 TLS 憑證 (RFC 6150)，and in accordance with its requirements for server identity authentication （看不懂，保留原文…）。

（編按：我理解為必須檢驗憑證的合法，以及憑證鏈的合法。如果 SSL 憑證過期、網域名稱不對、或被 revoke ，或憑證鏈不合法，則視為不合法。）

## Credential 猜猜樂攻擊 (Section 10.10)

Authorization Server 必須防止壞人可以猜到：

* Access Token （自動產生）
* Authorization Code （自動產生）
* Refresh Token （自動產生）
* Resource Owner Password （使用者自己持有）
* Client Credential （自動產生）

至於猜中機率的要求：

對於自動產生、非使用者自己持有的資料，猜中的機率必須不高於 1/(2^128) （2 的 128 次方分之 1）、並且應該不高於 1/(2^160) （2 的 160 次方分之 1）。（編按：所謂 2 的 n 次方分之 1 ，指的是資料的可能性有 2 的 n 次方這麼多種，實務上就是長度為 n-bit 的資料。）

對於使用者自己持有的資料， Authorization Server 必須使用其他手段來保護之。

## 釣魚攻擊 (Section 10.11)

大範圍部署 OAuth 等類似的通訊協定，可能會導致使用者習慣於被轉向到別的網站，在那邊被要求填入密碼。如果使用者在輸入密碼之前，不謹慎確認這些網站的權威性 (authenticity) ，就可能讓壞人利用這個習慣來偷取 Resource Owner 的密碼。

OAuth 的服務提供者應該要嘗試教育使用者關於釣魚攻擊的風險，並且應該要提供一種機制來讓使用者可以很容易就確認正牌網站的權威性。Client 開發者也應該要考慮到安全衝擊，像是使用者會怎麼與 User-Agent 互動（內嵌或外部瀏覽器），以及使用者是否有能力核實 Authorization Server 的權威性。

為了降低釣魚攻擊的風險， Authorization Server 必須在每個用來與使用者互動的 Endpoints 都要求 TLS 。

## CSRF (Section 10.12)

CSRF (Cross-site request forgery) 是一種攻擊手段，壞人讓受害使用者的 User-Agent 跟隨惡意的 URI （例如會以誤導的連結、圖片、轉址等形式提供給 User-Agent）跑到信任的伺服器（通常是透過一個合法的 session cookie 來達成）。

### 對 Client 的 CSRF 攻擊

對 Client 的 Redirection URI 的 CSRF 攻擊，可以讓壞人注入他自己的 Authorization Code 或 Access Token ，這樣會導致 Client 直接使用一個連結到壞人的 Protected Resource 的 Access Token ，而不是受害者自己的 Access Token （例如，把受害者的銀行帳戶資訊儲存到壞人所控制的 Protected Resource）。

Client 必須在 Redirection URI 實作 CSRF 防範。通常的做法是：

* 要求任何 request 附帶一個值，這個值綁定到 User-Agent 的一個獲授權的狀態（例如把一個用來認證 User-Agent 的 session cookie 給 hash 過之後的數值）
* 當 Client 發出 Authorization request 到 Authorization Server 的時候，Client 應該要使用 `state` 參數來傳遞這個值。
* 在使用者授權之後，Authorization Server 會把使用者的 User-Agent 轉向回 Client 並附上 `state` 參數。
* Client 可以檢查這個綁定值是否跟 User-Agent 獲授權的狀態相同，來確認 request 的合法與否。

其用來防範 CSRF 的綁定值，必須包含一個無法猜測的值（如 Section 10.10 所述），且 User-Agent 的獲授權的狀態（session cookie 、 HTML5 local storage 等）必須保存在一個只有 Client 的 User-Agent 可以存取的地方（也就是說要用 same-origin policy 保護）。

在 [Amazon 的文件](https://images-na.ssl-images-amazon.com/images/G/01/lwa/dev/docs/website-developer-guide._TTH_.pdf) 裡面，是建議把 `state` 用 HMAC 簽過，secret 就用 Client Secret ，這樣可以防止人家偽造。

### 對 Authorization Server 的 CSRF 攻擊

對 Authorization Endpoint 的 CSRF 攻擊，可以讓壞人在使用者未參與或未獲警告的情況下，取得給惡意 Client 的使用者授權。

Authorization Server 必須在 Authorization Endpoint 實作 CSRF 防範，並且確保惡意的 Client 不會在 Resource Owner 不知情、沒有明確許可的情況下取得授權，

## Clickjacking （點擊綁架） (Section 10.13)

在 Clickjacking 攻擊裡面，壞人會這樣做：

* 註冊一個合法的 Client。
* 造一個惡意網站，在這網站裡面，有一個透明的 iframe 會載入 Authorization Server 的 Authorization Endpoint 網頁。
* iframe 覆蓋在一組假造的按鈕之上，這精心製作的按鈕會直接放在授權頁面的重要按鈕的下面。
* 當使用者看到那誤導按鈕，並且按下去，使用者實際上是按下了疊在授權頁面之上的隱藏按鈕（例如「給予授權」按鈕）。

如此攻擊者可以晃點 Resource Owner ，讓他不經意授權了 Client 的存取權，而使用者卻不知情。

為了防範這種型式的攻擊， Native Application 在請求使用者授權的時候，最好要使用外部 browser ，而非內嵌一個 browser 到應用程式裡面。對於多數的新瀏覽器來說，可以使用 ["X-Frame-Options" header （非標準）](https://developer.mozilla.org/en-US/docs/HTTP/X-Frame-Options) 來強制要求 Authorization Server 的網頁不能從 iframe 載入。這個 header 可以有兩種值，分別是 "deny" （禁止其從任何框架頁載入）和 "sameorigin" （只允許同樣 origin 的網站透過框架頁載入）。對於舊的瀏覽器來說，[JavaScript Frame-Busting](http://en.wikipedia.org/wiki/Framekiller) 技術可能可以用，但不見得對所有瀏覽器都有效。

相關資料：

* [The X-Frame-Options response header - HTTP | MDN](https://developer.mozilla.org/en-US/docs/HTTP/X-Frame-Options)
* [Combating ClickJacking With X-Frame-Options - IEInternals - Site Home - MSDN Blogs](http://blogs.msdn.com/b/ieinternals/archive/2010/03/30/combating-clickjacking-with-x-frame-options.aspx)

## 程式碼注入以及輸入值的驗證 (Section 10.14)

當輸入值或是其他外部參數沒有被消毒 (sanitizied) 導致改變了應用程式的內部邏輯的時候，就是發生了程式碼注入攻擊。這可能會允許壞人取得應用程式裝置或資料的存取權、造成服務阻斷 (DoS) 、或是造成更大範圍的不良副作用。

Authorization Server 必須對任何接收到的資料消毒（可以的話還要驗證是否正確），特別是 "state" 和 "redirection_uri" 參數。

## Open Redirectors (Section 10.15)

見[系列文第 3 篇](http://blog.yorkxin.org/posts/2013/09/30/oauth2-3-endpoints/)。

## 誤用 Access Token 來在 Implicit Flow 裡面偽裝 Resource Owner (Section 10.16)

見[系列文第 4.2 篇](http://blog.yorkxin.org/posts/2013/09/30/oauth2-4-2-implicit-grant-flow/)。

---

## OAuth 2.0 系列文目錄

* [(1) 世界觀](http://blog.yorkxin.org/posts/2013/09/30/oauth2-1-introduction/)
* [(2) Client 的註冊與認證](http://blog.yorkxin.org/posts/2013/09/30/oauth2-2-cilent-registration/)
* [(3) Endpoints 的規格](http://blog.yorkxin.org/posts/2013/09/30/oauth2-3-endpoints/)
* [(4.1) Authorization Code Grant Flow 細節](http://blog.yorkxin.org/posts/2013/09/30/oauth2-4-1-auth-code-grant-flow/)
* [(4.2) Implicit Grant Flow 細節](http://blog.yorkxin.org/posts/2013/09/30/oauth2-4-2-implicit-grant-flow/)
* [(4.3) Resource Owner Credentials Grant Flow 細節](http://blog.yorkxin.org/posts/2013/09/30/oauth2-4-3-resource-owner-credentials-grant-flow/)
* [(4.4) Client Credentials Grant Flow 細節](http://blog.yorkxin.org/posts/2013/09/30/oauth2-4-4-client-credentials-grant-flow/)
* [(5) 核發與換發 Access Token](http://blog.yorkxin.org/posts/2013/09/30/oauth2-5-issuing-tokens/)
* [(6) Bearer Token 的使用方法](http://blog.yorkxin.org/posts/2013/09/30/oauth2-6-bearer-token/)
* **[(7) 安全性問題](http://blog.yorkxin.org/posts/2013/09/30/oauth2-7-security-considerations/) ← You Are Here**
* [各大網站 OAuth 2.0 實作差異](http://blog.yorkxin.org/posts/2013/09/30/oauth2-implementation-differences-among-famous-sites/)
