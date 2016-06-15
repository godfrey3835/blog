---
layout: post
title: OAuth 2.0 筆記 (1) 世界觀
published: true
date: 2013-09-30 21:40
tags:
- OAuth
categories: []
redirect_from: /posts/2013/09/30/oauth2-1-introduction
comments: true

---
最近需要實作 OAuth 2 認證，不是接別人的 OAuth 2 ，而是自己製作出可以讓別人接我們的 OAuth 2 的服務（俗稱 Provider）。但看到既有的 OAuth 2 server library 如 [rack-oauth2](https://github.com/nov/rack-oauth2) 卻都看不懂，所以花了很久的時間來研讀 [RFC 6749](http://tools.ietf.org/html/rfc6749) 這份 OAuth 2.0 的 spec ，讀完之後總算懂 library 在幹嘛了。老闆建議我寫懶人包，所以就寫了這篇，一來筆記，二來讓別人可以透過這份懶人包來快速入門 OAuth 2。（不過說懶人包其實也不懶人，完全就是把 spec 翻譯出來啊……。）

以下文字盡量註明 RFC 6749 原文的出處。有些原文我可能會省略，例如與 OAuth 1.0 的差異（spec 裡面有些段落有提及）、擴充 OAuth 2.0 的功能 (Extension)，這是為了讓懶人包 focus 在 OAuth 2.0 的基本使用方式。專有名詞基本上不翻譯，只適度加註中文，這是為了可以和 library 裡面常用的變數名稱保持一致。

另外，我有把 spec 原文的 txt [轉成 Markdown](https://gist.github.com/chitsaou/6590756) 來方便閱讀。

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
* [各大網站 OAuth 2.0 實作差異](http://blog.yorkxin.org/posts/2013/09/30/oauth2-implementation-differences-among-famous-sites/)

<!--more-->

## 簡介 OAuth 2.0

在傳統的 Client-Server 架構裡， Client 要拿取受保護的資源 (Protected Resoruce) 的時候，要向 Server 出示使用者 (Resource Owner) 的帳號密碼才行。為了讓第三方應用程式也可以拿到這些 Resources ，則 Resource Owner 要把帳號密碼給這個第三方程式，這樣子就會有以下的問題及限制：

* 第三方程式必須儲存 Resource Owner 的帳號密碼，通常是明文儲存。
* Server 必須支援密碼認證，即使密碼有天生的資訊安全上的弱點。
* 第三方程式會得到幾乎完整的權限，可以存取 Protected Resources ，而 Resource Owner 沒辦法限制第三方程式可以拿取 Resource 的時效，以及可以存取的範圍 (subset)。
* Resource Owner 無法只撤回單一個第三方程式的存取權，而且必須要改密碼才能撤回。
* 任何第三方程式被破解 (compromized)，就會導致使用該密碼的所有資料被破解。

OAuth 解決這些問題的方式，是引入一個認證層 (authorization layer) ，並且把 client 跟 resource owner 的角色分開。在 OAuth 裡面，Client 會先索取存取權，來存取 Resource Owner 擁有的資源，這些資源會放在 Resource Server 上面，並且 Client 會得到一組不同於 Resource Owner 所持有的認證碼 (credentials) 。

Client 會取得一個 Access Token 來存取 Protected Resources ，而非使用 Resource Owner 的帳號密碼。Access Token 是一個字串，記載了特定的存取範圍 (scope) 、時效等等的資訊。Access Token 是從 Authorization Server 拿到的，取得之前會得到 Resource Owner 的許可。Client 用這個 Access Token 來存取 Resource Server 上面的 Protected Resources 。 

實際使用的例子：使用者 (Resource Owner) 可以授權印刷服務 (Client) 去相簿網站 (Resource Server) 存取他的私人照片，而不需要把相簿網站的帳號密碼告訴印刷服務。這個使用者會直接授權透過一個相簿網站所信任的伺服器 (Authorization Server) ，核發一個專屬於該印刷服務的認證碼 (Access Token)。

OAuth 是設計來透過 HTTP 使用的。透過 HTTP 以外的通訊協定來使用 OAuth 則是超出 spec 的範圍。

*Section 1*

## OAuth 2.0 的角色定義

* **Resource Owner** - 可以授權別人去存取 Protected Resource 。如果這個角色是人類的話，則就是指使用者 (end-user)。
* **Resource Server** - 存放 Protected Resource 的伺服器，可以根據 Access Token 來接受 Protected Resource 的請求。
* **Client** - 代表 Resource Owner 去存取 Protected Resource 的應用程式。 "Client" 一詞並不指任何特定的實作方式（可以在 Server 上面跑、在一般電腦上跑、或是在其他的設備）。
* **Authorization Server** - 在認證過 Resource Owner 並且 Resource Owner 許可之後，核發 Access Token 的伺服器。

Authorization Server 和 Resource Server 的互動方式不在本 spec 的討論範圍內。Authorization Server 跟 Resource Server 可以是同一台，也可以分開。單一台 Authorization Server 核發的 Access Token ，可以設計成能被多個 Resource Server 所接受。

*Section 1.1*

## 基本流程概觀與資料定義

以下是抽象化的流程概觀，以比較宏觀的角度來描述，不是實際程式運作的流程（圖出自 Spec 的 Figure 1）：

    +--------+                               +---------------+
    |        |--(A)- Authorization Request ->|   Resource    |
    |        |                               |     Owner     |
    |        |<-(B)-- Authorization Grant ---|               |
    |        |                               +---------------+
    |        |
    |        |                               +---------------+
    |        |--(C)-- Authorization Grant -->| Authorization |
    | Client |                               |     Server    |
    |        |<-(D)----- Access Token -------|               |
    |        |                               +---------------+
    |        |
    |        |                               +---------------+
    |        |--(E)----- Access Token ------>|    Resource   |
    |        |                               |     Server    |
    |        |<-(F)--- Protected Resource ---|               |
    +--------+                               +---------------+
    
                    Figure 1: Abstract Protocol Flow

上圖描述四個角色的互動方式：

(A): Client 向 Resource Owner 請求授權。這個授權請求可以直接向 Resource Owner 發送（如圖），或是間接由 Authorization Server 來請求。

(B) Client 得到來自 Resource Owner 的 Authorization Grant （授權許可）。這個 Grant 是用來代表 Resource Owner 的授權，其表達的方式是本 spec 裡定義的四種類別 (grant types) 的其中一種（可以擴充）。要使用何種類別，則是依 Client 請求授權的方法、 Authorization Server 支援的類別而異。

(C): Client 向 Authorization Server 請求 Access Token ，Client 要認證自己，並出示 Authorization Grant。

(D): Authorization Server 認證 Client 並驗證 Authorization Grant 。如果都合法，就核發 Access Token 。

(E): Client 向 Resource Server 請求 Protected Resource ，Client 要出示 Access Token。

(F): Resource Server 驗證 Access Token ，如果合法，就處理該請求。

*Section 1.2*

### Authorization Grant （授權許可）

Authorization Grant 代表了 Resource Owner 授權 Client 可以去取得 Access Token 來存取 Protected Resource 。Grant 不一定是具體的資料，依 spec 裡面定義的四種內建流程，有對應不同的 grant type ，甚至在某些流程裡面會省略之，不經過 Client。

Client 從 Resource Owner 取得 Authorization Grant 的方式（前段圖中的 (A) 和 (B) 流程）會比較偏好透過 Authorization Server 當作中介。見[系列文第 3 篇](http://blog.yorkxin.org/posts/2013/09/30/oauth2-3-endpoints/)的流程圖。

### Access Token

Access Token 用來存取 Protected Resource ，是一個具體的字串（string），其代表特定的 scope （存取範圍）、時效。概念上是由 Resoruce Owner 授予，Resource Server 和 Authorization Server 遵循之 (enforced)。

Access Token 可以加上用來取得授權資訊的 identifier （編號或識別字等），或內建可以驗證的授權資訊（如數位簽章）。也就是說，可以由 Authorization Server 間接判定這個 Access Token 的 scope 及時效，也可以嵌在 Token 裡面，但為了防止竄改，要以加密演算法來實作資料的驗證。

Spec 裡面只定義抽象層，代替傳統的帳密認證，並且 Resource Server 只需要知道此一 Access Token ，不需要知道其他的認證方式。Access Token 可以有不同的格式、使用方式（如內建加密屬性）。Access Token 的內容，以及如何用它來存取 Protected Resource ，則定義在別的文件，像是 RFC 6750 (Bearer Token Usage) 。

*Section 1.4*

#### Access Token Type

Client 要認得 Access Token Type 才能使用之，若拿到認不得的 Type ，則不可以使用之。例如 RFC 6750 定義的 Bearer Token 的用法就是這樣：

    GET /resource/1 HTTP/1.1
    Host: example.com
    Authorization: Bearer mF_9.B5f-4.1JqM

*Section 7.1*

### Refresh Token

用來向 Authorization Server 重新取得一個新的 Access Token 的 Token ，像是現有的 Access Token 過期而無效，或是權限不足，需要更多 scopes 才能存取別的 Resource。在概念上，Refresh Token 代表了 Resource Owner 授權 Client 重新取得新的 Access Token 而不需要再度請求 Resource Owner 的授權。Client 可以自動做這件事，例如 Access Token 過期了，自動拿新的 Token，來讓應用程式的流程更順暢。

需注意新取得的 Access Token 時效可能比以前短、或比 Resource Owner 給的權限更少。

Authorization Server 不一定要核發 Refresh Token ，但若要核發，必須在核發 Access Token 的時候一併合發。某些內建流程會禁止核發 Refresh Token。

Refresh Token 應該只遞交到 Authorization Server ，不該遞交到 Resource Server 。

Refresh Token 的流程圖：

    +--------+                                           +---------------+
    |        |--(A)------- Authorization Grant --------->|               |
    |        |                                           |               |
    |        |<-(B)----------- Access Token -------------|               |
    |        |               & Refresh Token             |               |
    |        |                                           |               |
    |        |                            +----------+   |               |
    |        |--(C)---- Access Token ---->|          |   |               |
    |        |                            |          |   |               |
    |        |<-(D)- Protected Resource --| Resource |   | Authorization |
    | Client |                            |  Server  |   |     Server    |
    |        |--(E)---- Access Token ---->|          |   |               |
    |        |                            |          |   |               |
    |        |<-(F)- Invalid Token Error -|          |   |               |
    |        |                            +----------+   |               |
    |        |                                           |               |
    |        |--(G)----------- Refresh Token ----------->|               |
    |        |                                           |               |
    |        |<-(H)----------- Access Token -------------|               |
    +--------+           & Optional Refresh Token        +---------------+
    
            Figure 2: Refreshing an Expired Access Token

(A) Client 向 Authorizatino Server 出示 Authorization Grant ，來申請 Access Token 。

(B) Authorization Server 認證 Client 並驗證 Authorization Grant 。如果都合法，就核發 Access Token 。

(C) Client 向 Resource Server 請求 Protected Resource ，Client 要出示 Access Token。

(D) Resource Server 驗證 Access Token ，如果合法，就處理該請求。

(E) 步驟 (C) 和 (D) 一直重覆，直到 Access Token 過期。如果 Client 自己知道 Access Token 過期，就跳到 (G)；如則，就發送另一個 Protected Request 的請求。

(F) 因為 Access Token 不合法，Resource Server 回傳 Token 不合法的錯誤。

(G) Client 向 Authorization Server 請求 Access Token ，Client 要認證自己，並出示 Refresh Token。Client 認證的必要與否，端看 Client Type 以及 Authorization Server 的政策。

(H) Authorization Server 認證 Client 、驗證 Refresh Token ，如果合法，就核發新的 Access Toke （也可以同時核發新的 Refresh Token）

步驟 (C), (D), (E), (F) 關於 Resource Server 如何處理 request 、檢查 Access Token 的機制，不在本 spec 的範圍內，跟 Token 的格式有關。RFC 6750 的 Bearer Token 有定義，見[系列文第 6 篇](http://blog.yorkxin.org/posts/2013/09/30/oauth2-6-bearer-token/)。

*Section 1.5*

## 四種內建授權流程 (Grant Flows)

Spec 裡面定義了四種流程，分別是:

* Authorization Code Grant Type Flow
* Implicit Grant Type Flow
* Resource Owner Password Credentials Grant Type Flow
* Client Credentials Grant Type Flow

此外還可以擴充。根據流程的不同，有不同的實作細節。Client 的類型也會限制可以實作的流程，例如 Native App 就不准使用 Client Credentials ，因為這些密碼會外洩。

實務上不需要實作所有流程。我看了許多大網站的 OAuth 2 API，大部份會支援 Authorization Code Grant Flow，其他的則不一定。之後寫一篇文章整理。

這裡提一下 Clients 的類型，分成 Public 和 Confidential 兩種，根據能不能保密 Client Credentials 來區分，可以的就是 Confidential （如 Server 上的程式），不行的就是 Public （如 Native App、In-Browser App）。詳見[系列文第 2 篇](http://blog.yorkxin.org/posts/2013/09/30/oauth2-2-cilent-registration/)。

### (1) Authorization Code Grant Flow

* 要向 Authorization Server 先取得 Grant Code 再取得 Access Token （兩步）。
* 適合 Confidential Clients ，如部署在 Server 上面的應用程式。
* 可以核發 Refresh Token。
* 需要 User-Agent Redirection。

### (2) Implicit Grant Flow

* Authorization Server 直接向 Client 核發 Access Token （一步）。
* 適合非常特定的 Public Clients ，例如跑在 Browser 裡面的應用程式。
* Authorization Server 不必（也無法）驗證 Client 的身份。
* 禁止核發 Refresh Token。
* 需要 User-Agent Redirection。
* 有資料外洩風險。

### (3) Resource Owner Password Credentials Grant Flow （使用者的帳號密碼）

* Resource Owner 的帳號密碼直接拿來當做 Grant。
* 適用於 Resource Owner 高度信賴的 Client （像是 OS 內建的）或是官方應用程式。
* 其他流程不適用時才能用。
* 可以核發 Refresh Token。
* 沒有 User-Agent Redirection。

### (4) Client Credentials Grant Flow （Client 的帳號密碼）

* Client 的 ID 和 Secret 直接用來當做 Grant
* 適用於跑在 Server 上面的 Confidential Client
* 不建議核發 Refresh Token 。
* 沒有 User-Agent Redirection。

## 技術要求

### 必須全程使用 TLS (HTTPS)

因為資料在網路上面傳遞會被看見，所以 Spec 裡面規定全程必須使用 TLS ，而因為 OAuth 是基於 HTTP 的，所以就是 **統統要使用 https** 。實務上是定義在 Endpoints 。在某些 Client 無法實作有 TLS 的 Endpoint ，則會適度放寬限制。所以雖然這段標題寫的是「全程使用」，實際上是只有一些地方有規定需要經過 TLS ，但這個「一些」就包含了幾乎所有經過網路的地方，所以我就直接寫全程了。

至於 TLS 的版本，在 spec 寫成的時候，最新版是 TLS 1.2 ，但實務上利用最廣泛的卻是 TLS 1.0 。所以在 Spec 裡似乎沒有明確定義 TLS 的版本。

*Section 1.6*

### User-Agent 要支援 HTTP Redirection

OAuth 2 用 HTTP 轉址 (Redirection) 用很兇， Client 或 Authorization Server 用轉址來把 Resource Owner 的 User-Agent 轉到別的地方。另外雖然 spec 裡面的範例都是 302 轉址，若要用別的方式來轉址也行，這屬於實作細節。

*Section 1.7*

## 存取 Protected Resource 的方式

關於 Client 如何利用 Access Token 存取 Protected Resource 的方式，在 OAuth 2.0 的 spec 裡面只有定義概念，具體的機制沒有定義：

* Client 要出示 Access Token 來向 Resource Server 存取 Protected Resource。
* 具體出示機制不定義，通常是用 Authorization header 搭配該 Access Token 定義的 auth scheme ，如 Bearer Token (RFC 6750) ，見[系列文第 6 篇](http://blog.yorkxin.org/posts/2013/09/30/oauth2-6-bearer-token/)。
* Resource Server 必須驗證 Access Token 並確認其尚未過期、確認其 scope 包含所要存取的 resource 。
* 具體驗證機制不規定，通常是 Authorization Server 和 Resource Server 之間互相傳輸資料 (interaction) 以及同步化 (coordination)。

*Section 7*

### 錯誤的回應方式

Spec 裡面也不定義機制，只定義了概念以及基本的共用協定：

* 要是 Resource Request 失敗，則 Server 最好要提示錯誤 。至於 error code ，登記的方式規定在 Section 11.4。
* 任何新定義的 Authentication Scheme （如 Bearer Token）都最好要定義一個機制來提示錯誤，其 value 要使用 OAuth 2.0 spec 裡面規定的方式定義。
* 新定義的 Scheme 可能會只使用子集。
* 如果 error code 用具名參數（如 JSON 之類的 dictionary）回傳，則其參數名稱必須使用 `error`。
* 要是有個 Scheme 可以用在 OAuth 但不是專門設計給 OAuth ，則可以用一樣的方式來把它裡面的 error code 清單拿進來用 ※。
* 新定義的 Scheme 可以用 `error_description` 和 `error_uri` ，其意義要跟 OAuth 定義的一致。

※ *MAY bind their error values to the registry in the same manner*

*Section 7.2*

Section 11.4 裡面有規定怎麼提出新 error code 的 proposal ，有興趣的同學就看一下吧。

---

## OAuth 2.0 系列文目錄

* **[(1) 世界觀](http://blog.yorkxin.org/posts/2013/09/30/oauth2-1-introduction/) ← You Are Here**
* [(2) Client 的註冊與認證](http://blog.yorkxin.org/posts/2013/09/30/oauth2-2-cilent-registration/)
* [(3) Endpoints 的規格](http://blog.yorkxin.org/posts/2013/09/30/oauth2-3-endpoints/)
* [(4.1) Authorization Code Grant Flow 細節](http://blog.yorkxin.org/posts/2013/09/30/oauth2-4-1-auth-code-grant-flow/)
* [(4.2) Implicit Grant Flow 細節](http://blog.yorkxin.org/posts/2013/09/30/oauth2-4-2-implicit-grant-flow/)
* [(4.3) Resource Owner Credentials Grant Flow 細節](http://blog.yorkxin.org/posts/2013/09/30/oauth2-4-3-resource-owner-credentials-grant-flow/)
* [(4.4) Client Credentials Grant Flow 細節](http://blog.yorkxin.org/posts/2013/09/30/oauth2-4-4-client-credentials-grant-flow/)
* [(5) 核發與換發 Access Token](http://blog.yorkxin.org/posts/2013/09/30/oauth2-5-issuing-tokens/)
* [(6) Bearer Token 的使用方法](http://blog.yorkxin.org/posts/2013/09/30/oauth2-6-bearer-token/)
* [(7) 安全性問題](http://blog.yorkxin.org/posts/2013/09/30/oauth2-7-security-considerations/)
* [各大網站 OAuth 2.0 實作差異](http://blog.yorkxin.org/posts/2013/09/30/oauth2-implementation-differences-among-famous-sites/)
