---
layout: post
title: "各大網站 OAuth 2.0 實作差異"
published: true
date: 2013-09-30 21:50
tags:
- OAuth
categories: []
comments: true

---
因為我現在要自己做 OAuth 2 的服務，所以當然要先看一下別人怎麼做。

然而，即使 OAuth 2.0 的 spec 規定了很多通訊協定上的實作細節，但現實總是跟理想有所差距，各大網站的 OAuth 2 實作都或多或少與 spec 有差異，真正完全照 spec 來做的很少（功能閹割的不算數）。不過概念上都符合 OAuth 2 ，只是實作上有差。

我去看了以下這些網站的 OAuth 2 API 文件，清單是從 [Wikipedia / OAuth / List of OAuth service providers](http://en.wikipedia.org/wiki/OAuth#List_of_OAuth_service_providers) 找來的。為了排版美觀， Grant Type 的 Authorization Code 簡寫成 Auth Code， Client Credentials 簡寫成 Client Cred.，Resource Owner Password 簡寫成 Password。檢閱日期是 2013 年 9 月 27 日，未來各 API 可能會改變，導致下表的情況跟現況不一致。

| Service     | spec<br>相容 | 支援的 Grant Types | scope<br>分隔 | Refresh<br>Token | Client 認證 |
|-------------|---------------|----------------|----|----|----|
| [Facebook](https://developers.facebook.com/docs/facebook-login/login-flow-for-web-no-jssdk/)  | ✕ | Auth Code, Implicit, Client Cred. | comma | △ (自製) | GET |
| [GitHub](http://developer.github.com/v3/oauth/) | ✕ | Auth Code, Password (自製) | comma | ✕ | POST |
| [Twitter](https://dev.twitter.com/docs/auth/application-only-auth) | ◯ | Client Cred. | (無 scope) | ✕ | Basic |
| [Google](https://developers.google.com/accounts/docs/OAuth2) | ✕ | Auth Code, Implicit | space | ◯ | POST |
| [Microsoft](http://msdn.microsoft.com/en-us/library/live/hh243647.aspx) | ✕ | Auth Code, Implicit | ？？？ | ◯ | POST |
| [Dropbox](https://www.dropbox.com/developers/core/docs#oa2-authorize) | ◯ | Auth Code, Implicit | (無 scope) | ✕ | Basic, POST |
| [Amazon](https://images-na.ssl-images-amazon.com/images/G/01/lwa/dev/docs/website-developer-guide._TTH_.pdf) | ◯ | Auth Code, Implicit | space | ◯ | Basic, POST |
| [Bitly](http://dev.bitly.com/authentication.html) | ✕ | Auth Code (半自製), Password | (無 scope) | ✕ | POST (Auth Code),<br> Basic (Password) |
| [新浪微博](http://open.weibo.com/wiki/%E6%8E%88%E6%9D%83%E6%9C%BA%E5%88%B6%E8%AF%B4%E6%98%8E) | ✕ | Auth Code | comma | ✕ | Basic, GET |
| [豆瓣](http://developers.douban.com/wiki/?title=oauth2) | ✕ | Auth Code, Implicit | comma | ◯ | POST |
| [BOX](http://developers.box.com/oauth/) | ✕ | Auth Code | (無 scope) | ◯ | POST |
| [Basecamp](https://github.com/37signals/api/blob/master/sections/authentication.md) | ✕ | Auth Code | (無 scope) | ◯ | POST |

<!--more-->

大概總結一下：

關於 Endpoints:

* GitHub 和 Basecamp 省略了 `response_type` 和 `grant_type` ，猜測是因為只有一種流程。但一樣情況的 Twitter 、 BOX 、新浪微博，則依然要傳 switch 參數。
* 通常 Authorization Endpoint 都是跟主站放在一起的，而不是放在 API 裡面，我想這個目的是要讓 User 直接用 cookie 登入並授權。

關於 Grant Types:

* 幾乎大家都至少會支援 Authorization Code Grant （Twitter 不支援）。
* 適合實作第三方登入的尤其會支援 Implicit 來做無縫接入（新浪微博似乎是個例外）。
* Client Credentials 很少有人會支援（Twitter 用來給 App 存取「非代表使用者」的資料）。
* Resource Owner Password 很少有人支援。GitHub 有一種類似的用法，但不是照規格，而是一種自製的流程。
* 除了內建的四種 Grant Types ，某些服務還會設計自己的 Grant Type，像是 Microsoft 就有一個叫 Sing-In Control Flow ，是 Implicit 的一種變體。

關於 Client Authorization （認證）：

* 大部份都有支援 POST
* 並非全部都有支援 HTTP Basic Auth ，但規格書裡面規定的是要至少支援 Basic Auth ，因為這一點，所以我把很多個服務標成「不相容 spec」
* 少數有使用 GET

關於資料格式：

* space 的分隔符 (delimiter) 很多用 `,` 逗號 (comma) ，照規格書用空格 (space) 的也有，不過還有完全不存在 "scope" 的概念，授權範圍就是完全存取。
* Microsoft 的 delimiter 我不知道到底是用什麼，詳情見下文。
* Token Type 雖然不是每個都是 "Bearer" ，但基本上概念都接近。目前沒有看到使用 MAC Token 的。

其他：

* Refresh Token 不是大家都有支援。
* 某些服務會提供 SDK ，像是 Facebook 、新浪微博，這樣子在網頁、手機上面，不需要手動規劃流程，由 SDK 完成，這樣也可以防止 App 在流程中動手腳，偷走密碼之類的資料。

以下各服務的筆記。

## Facebook

文件： https://developers.facebook.com/docs/facebook-login/login-flow-for-web-no-jssdk/

### Grant Types

* Authorization Code
* Implicit
* Client Credentials (用來取得 App Access Token)

### Endpoints

* Authorization Endpoint: `https://www.facebook.com/dialog/oauth` （非 graph.facebook.com）
* Token Endpoint: `https://graph.facebook.com/oauth/access_token`

### 特色

* 概念上跟 OAuth 2 雷同，但沒有完全照標準。
* scope 用逗號 `,` 分隔 （非標準）
* Client Authentication 用 GET （非標準）
* Authorzation Endpoint 有提供同時拿 Authorization Code 和 Access Token 的功能（我不清楚是什麼用途）
* Implicit Flow 在使用 Token 之前，建議 validate ，防偽造攻擊。詳見 [Confirming Identity](https://developers.facebook.com/docs/facebook-login/login-flow-for-web-no-jssdk/#confirm) 段落。
* Token 分成很多種，分別有不同的用途。詳見 [Access Tokens](https://developers.facebook.com/docs/facebook-login/access-tokens/)。
* Desktop App 的 Redirection URI 固定為 `https://www.facebook.com/connect/login_success.html` ，並要求開發者內嵌一個 browser （如 WebView），監視其 state change 來取得 Access Token。
* 有自己的 Token Refresh 機制，見 [Re-authentication](https://developers.facebook.com/docs/facebook-login/reauthentication/)。
* Token Type 不是 Bearer Token，但用起來很像。

其他值得參考的文件：

* [Access Tokens](https://developers.facebook.com/docs/facebook-login/access-tokens/) - 不同 Access Token 用於各種 Scenario 的詳細操作步驟
* [Permissions](https://developers.facebook.com/docs/facebook-login/permissions/) - 即 scopes 的定義
* [Login Security](https://developers.facebook.com/docs/facebook-login/security/#appsecret) - 安全性指南
* [Securing Graph API Calls](https://developers.facebook.com/docs/reference/api/securing-graph-api/) - 建議跑在 Web Server 上面的程式，用數位簽章簽過 reqeust

### 關於固定的 Redirection URI

前面提到說它的 Redirection URI 固定為　`https://www.facebook.com/connect/login_success.html` ，這個 URI 我覺得很有意思，打開來是這樣的內容：（斷行是我自己加的，原文沒斷行）

```html
Success <br /><b style="color:red">安全警告：請以保護密碼的相同態度處理以上網址，切勿和任何人分享。</b>
<script type="text/javascript">
setTimeout(function() {
  window.history.replaceState && window.history.replaceState({}, "", "blank.html#_=_");
},500);
</script>
```

看這段 JavaScript，用途是「500ms 之後自動把瀏覽器的歷史記錄消滅掉，並且讓現在網址變成 `blank.html#_=_`」。這是什麼用途呢？

我猜測搭配 Implicit Grant Flow 用的。在 Implicit Grant Flow 裡面， Access Token 會包在 Fragment 裡面（就是網址最後面的那個 `#xxxx`），這樣子一來會被 User-Agent 放進歷史記錄裡，二來如果人眼看得到這個 User-Agent 的 Location Bar ，就可以看到 Access Token 。

所以 Facebook 推薦給 Desktop App 的實作方式，就是程式監視內嵌的 User-Agent 的當前網址，看到這個固定的 Redirection URI ，就可以抓 Access Token 了。而不管有沒有抓到，網頁裡的 script 都會把 Access Toekn 消除掉。

又，這種 `#_=_` 也常常在 Facebook 第三方登入的時候看到，我猜測也是基於相同的原因，不過還沒有證實。

## GitHub

文件： http://developer.github.com/v3/oauth/

### Grant Types

* Authorization Code
* Resource Owner Password （自製，非標準）

### Endpoints

用於 Authorization Code:

* Authorization Endpoint: `https://github.com/login/oauth/authorize`
* Token Endpoint: `https://github.com/login/oauth/access_token`

Resource Owner Password Grant Flow 是自製的流程，叫做 Authorizations，用的是 RESTful API，不是直接套用 OAuth 標準。在 Grant 的時候不使用上述的 Endpoints。

### 特色

* scope 用 `,` 逗號區隔（非標準）
* Client Authentication 支援 POST Auth （非標準）
* 所謂「自製的 Resource Owner Password Grant Type」，我指的是 GitHub 另外提供「讓 Resource Owner 自行管理 Authorizations」的 API ，見 [OAuth Authorizations API](http://developer.github.com/v3/oauth/#oauth-authorizations-api) 段落。
* 因為 Endpoint 只需要支援 Authorization Code Grant ，所以省略了 `respose_type` 和 `grant_type`。
* 沒有 Refresh Token
* Token 沒有時效，亦即除非手動 revoke ，否則永遠有效。
* Token Type 不是 Bearer Token，但用起來很像。

### GitHub.app 即是使用 OAuth

GitHub 的 Mac GUI 應用程式就是用 OAuth 來存取資料的。你可以打開 Keychain Access ，找到 *"github.com/mac (you@example.com)"* 這個項目，按 Show Password 就可以看到 OAuth Access Token 了：

![Screen Shot 2013-09-30 at 2.46.03 PM.png](http://user-image.logdown.io/user/2580/blog/2567/post/143112/xQ9h86TQDmXKQB5CKT7T_Screen%20Shot%202013-09-30%20at%202.46.03%20PM.png)

用同樣的 Access Token 可以 call API：

```text
$ curl -i -H "Authorization: token bXXXXXXXXXXXXXXXXXXXXXXXXXXXXXb" https://api.github.com/user
HTTP/1.1 200 OK
Server: GitHub.com
X-OAuth-Scopes: notifications, repo, user
X-Accepted-OAuth-Scopes: user, user:email, user:follow, site_admin
X-GitHub-Media-Type: github.beta
X-Content-Type-Options: nosniff
# 部份略

{
    "login": "chitsaou",
    "id": 10737
    (略)
}
```

## Twitter

文件： https://dev.twitter.com/docs/auth/application-only-auth

### Grant Types

* Client Credentials

### Endpoints

* Token Endpoint: `https://api.twitter.com/oauth2/token`

### 特色

* 與 spec 相容
* 只准用在 Application-only Path ，即是「代表 App 操作」。如果要「代表 User 操作」，則必須走 OAuth 1.0a 的流程。見 [OAuth Signed](https://dev.twitter.com/docs/auth/obtaining-access-tokens) 文件。
* Client Authentication 用 Basic Auth （標準）。
* Access Token 使用 Bearer Token 標準 (RFC 6750) 。
* 沒有 Refresh Token
* Access Token 沒有時效，但文件裡提及 app credentials 會過期，這個我搞不懂。（原文是 *Obtain or revoke a bearer token with incorrect or expired app credentials*）
* 用 Bearer Token (RFC 6750)

## Google

文件： https://developers.google.com/accounts/docs/OAuth2

### Grant Types

* Authorization Code
* Implicit

還有一種 Grant Flow 叫做 ["for Devices"](https://developers.google.com/accounts/docs/OAuth2ForDevices) ，這是專門為 User-Agent 功能很少的設備來設計的，例如遊戲機、印表機。

### Endpoints

* Authorization Endpoint: `https://accounts.google.com/o/oauth2/auth`
* Token Endpoint: `https://accounts.google.com/o/oauth2/token`

### 特色

* scope 用空白分隔。（標準）。
* Client Authentication 用 POST （非標準）。
* 特別提到 Authorization Code Grant Flow 適用 Chrome App
* 特別提到 Implicit Grant Flow 最好 validate token （同 Facebook）
* 把 Native App 歸類在「使用 Authorization Code Grant Flow」裡面，但如此一來 secret 就不再是 secret ，會被抓出來。
* 對於 Native App，預設有一個 Redirection URI 叫做 `urn:ietf:wg:oauth:2.0:oob` 。跟 Facebook 的 Desktop App 指南一樣，這是可以給內嵌 browser 監視其 state change 來取得 Access Token 的方式。見 [Using OAuth 2.0 for Installed Applications / Choosing a Redirect URI](https://developers.google.com/accounts/docs/OAuth2InstalledApp#choosingredirecturi)
* 有 Refresh Token
* 用 Bearer Token (RFC 6750)

## Microsoft (Windows Live)

文件： http://msdn.microsoft.com/en-us/library/live/hh243647.aspx

### Grant Types

* Authorization Code Grant
* Implicit
* Sign-in Control （自製，從 Implicit Flow 變化來的，本文略）

### Endpoints

* Authorization Endpoint: `https://login.live.com/oauth20_authorize.srf`
* Token Endpoint: `https://login.live.com/oauth20_token.srf`

### 特色

* scope 分隔不明。（沒明說，照文件的[範例](http://msdn.microsoft.com/en-us/library/live/hh243649.aspx#authorization_rest)是空格，但 [omniauth-live-connect](https://github.com/plexinc/omniauth-live-connect/blob/master/lib/omniauth/strategies/live_connect.rb#L6) 卻是逗號）
* Client Authentication 用 POST （非標準）。
* 在 Authorization Code Grant Type Flow 裡面，可以自行指定 App 為 Desktop 或 Mobile ，這樣子 Redirection URI 會固定為 `https://login.live.com/oauth20_desktop.srf` 。跟 Facebook 的 Desktop App 指南一樣，要求開發者內嵌一個 browser （如 WebView），監視其 state change 來取得 Access Token。不過跟 Facebook 不同的是，它裡面打開是空空如也，沒有 script 來把 access token 藏起來。
* 有 Refresh Token
* Access Token 沒有時效，但文件裡提及 app credentials 會過期，這個我搞不懂。（原文是 *Obtain or revoke a bearer token with incorrect or expired app credentials*）
* Token Type 沒明說，但看起來也不是 MAC Token ，而是類似 Bearer Token。

## Dropbox

文件： https://www.dropbox.com/developers/core/docs

### Grant Types

* Authorization Code
* Implicit

### Endpoints

* Authorization Endpoint: `https://www.dropbox.com/1/oauth2/authorize` （非 api.dropbox.com）
* Token Endpoint: `https://api.dropbox.com/1/oauth2/token`

### 特色

* 與 spec 相容
* 沒有 scope 的概念
* Client Authentication 支援 Basic Auth 和 POST Auth
* 用 Bearer Token (RFC 6750)

## Amazon

文件： http://login.amazon.com/website 裡面的一份 [PDF](https://images-na.ssl-images-amazon.com/images/G/01/lwa/dev/docs/website-developer-guide._TTH_.pdf)

### Grant Types

* Authorization Code
* Implicit

### Endpoints

* Authorization Endpoint: `https://www.amazon.com/ap/oa` （非 api.amazon.com）
* Token Endpoint: `https://api.amazon.com/auth/o2/token`

### 特色

* 與 spec 相容
* scope 用空格分隔（標準）。
* Client Authentication 支援 Basic Auth 或 POST （標準）。
* 特別提到 Implicit Grant Flow 最好 validate token （同 Facebook）
* 有 Refresh Token
* 使用 Bearer Token (RFC 6750)。

另外文件裡面還提到安全性問題 (Security Considerations)，是從 Spec 的 Security Considerations 來的，但比 spec 的好讀……。

其中我特別注意到的幾點：

* CSRF - 建議把 state 用 HMAC 編碼過，其 secret 就是 client secret 。
* Implicit Flow 的 Resource Owner 偽裝 - 建議要向 Server 驗證 Access Token。
* Open Redirector - 最好不要在 Redirection Endpoint 裡面放 `&url=xxx` 這種東西。
* Code Injection - 最好把 state 驗證過沒問題再拿來用，顧客資料 (customer profile) 也要如此做。

## Bit.ly

文件： http://dev.bitly.com/authentication.html

### Grant Types

* Authorization Code (部份自製，非標準)
* Resource Owner Password

### Endpoints

* Authorization Endpoint: `https://bitly.com/oauth/authorize`
* Token Endpoint: `https://api-ssl.bitly.com/oauth/access_token`

### 特色

Bit.ly 的情況比較特別，它雖然有 Authorization Code Grant Flow ，但實作的細節卻跟 OAuth 2.0 有點不同，這個不同就導致它與 spec 不相容：

* 發 Access Token 不用 JSON 而是用 URL-encoded string （但 Password Grant 卻是用 JSON）。
* Client Authentication 用 POST 而不是 Basic Auth （但 Password Grant 卻是用 Basic Auth 而不是 POST）。

其他特色：

* 沒有 scope 的概念。
* Client Authentication 用 Basic Auth （Password Grant）或 POST （Auth Code Grant），互相不能交換。
* 沒有 Refresh Token
* Token Type 沒有明說是哪一種。

## 新浪微博

文件： http://open.weibo.com/wiki/%E6%8E%88%E6%9D%83%E6%9C%BA%E5%88%B6%E8%AF%B4%E6%98%8E

### Grant Types

* Authorization Code
* Implicit

### Endpoints

* Authorization Endpoint: `https://api.weibo.com/oauth2/authorize`
* Token Endpoint: `https://api.weibo.com/oauth2/access_token`

### 特色

* scope 用逗號 `,` 分隔（非標準）。
* Client Authentication 用 Basic Auth（標準）和 GET。
* 有 Refresh Token
* 有 Token 自動展期機制。
* Token Type 不是 Bearer Token。 Call API 的時候可以用 GET 或 Header 送 token。
* 有對 Client 分等級，不同等級有不同的 Rate Limiting 和 Token 時效。

另外它還提供了[应用安全开发注意事项](http://open.weibo.com/wiki/%E5%BA%94%E7%94%A8%E5%AE%89%E5%85%A8%E5%BC%80%E5%8F%91%E6%B3%A8%E6%84%8F%E4%BA%8B%E9%A1%B9)這份文件可以參考，雖然是從 Spec 裡面的 Security Considerations 拉出來的。

## 豆瓣

文件： http://developers.douban.com/wiki/?title=oauth2

### Grant Types

* Authorization Code
* Implicit

### Endpoints

* Authorization Endpoint: `https://www.douban.com/service/auth2/auth`
* Token Endpoint: `https://www.douban.com/service/auth2/token`

### 特色

* scope 用逗號 `,` 分隔（非標準）。
* Client Authentication 用 POST （非標準）。
* 有 Refresh Token
* 用 Bearer Token (RFC 6750)。
* 有對 Client 分等級，不同等級有不同的 Rate Limiting 和 Token 時效。
* Error Response 是自己設計的標準，有自己定義錯誤代碼表，其中不少是直接從 OAuth 2.0 Spec 來的。

## BOX

文件： http://developers.box.com/oauth/

### Grant Types

* Authorization Code

### Endpoints

* Authorization Endpoint: `https://www.box.com/api/oauth2/authorize`
* Token Endpoint: `https://www.box.com/api/oauth2/token`

### 特色

* 沒有 scope 的概念。
* Client Authentication 用 POST （非標準）。
* 有 Refresh Token
* 使用 Bearer Token (RFC 6750)。
* 對於「禁止轉回 Redirection Endpoint」的錯誤情況，會出現一個精美的頁面來提示錯誤。
* 有 self-revoke 的流程。

## Basecamp (37signals)

文件： https://github.com/37signals/api/blob/master/sections/authentication.md

### Grant Types

* Authorization Code

### Endpoints

* Authorization Endpoint: `https://launchpad.37signals.com/authorization/new`
* Token Endpoint: `https://launchpad.37signals.com/authorization`

### 特色

* 沒有 scope 的概念。
* Client Authentication 用 POST （非標準）。
* 有 Refresh Token
* 用 Bearer Token (RFC 6750)。
* 改密碼就會直接 revoke Access Tokens 。

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
* [(7) 安全性問題](http://blog.yorkxin.org/posts/2013/09/30/oauth2-7-security-considerations/)
* **[各大網站 OAuth 2.0 實作差異](http://blog.yorkxin.org/posts/2013/09/30/oauth2-implementation-differences-among-famous-sites/) ← You Are Here**
