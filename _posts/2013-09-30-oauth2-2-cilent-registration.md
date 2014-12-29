---
layout: post
title: OAuth 2.0 筆記 (2) Client 的註冊與認證
published: true
date: 2013-09-30 21:41
tags:
- OAuth
categories: []
comments: true

---
在 OAuth 2.0 的 spec 裡面，關於註冊 Client (Registration) 這件事，只定義了抽象的概念、類型 (profiles) 與要求，以及基於保密能力把 Clients 分成兩類： **confidential** 和 **public**。

而認證 (Authentication) 的流程則是有規定需要傳送的資料。所謂的認證，就是 Client 要向 Authorization Server 證明自己的身份，若把 Client 比喻為人類使用者的話，就像是打帳號密碼之類的動作。在 spec 內建的流程中，需要認證 Client 的地方只有 Token Endpoint，就是「發給你 Token 的時候」認證。其中 Implicit Flow 並沒有認證 Client （也沒有經過 Token Endpoint）。

<!--more-->

## Client 的註冊

Spec 不規定 Client 如何向 Authorization Server 註冊自己，通常是用 HTML 界面。註冊時， Authorization Server 與 Client 之間不需要有直接互動，如果 Authorization Server 支援的話，註冊的過程可以依賴其他的手段來建立互相的信任、取得 Client 的註冊資料（Redirection URI 、Client Type 等）。例如，可以透過內部的通道來搜尋 Client 。

註冊的時候， Client 的開發人員應該要做這些事：

* 指定 Client Type （見下文）
* 指定 Redirection URL （如 Section 3.1.2 所述）
* 提供其他 Authorization Server 要求的資料（名稱、網站、Logo 等）

*Section 2*

### Client Types

在 spec 裡面，根據有沒有能力保密 client 的 credentials （帳號密碼），定義了兩種 Client Types：

**confidential**：Client 可以自我保密 client 的 credentials（例如跑在 Server 上面，且可以限制 credentials 的存取），或是可以用別的手段來確保認證過程的安全性。

**public**：Client 無法保密 credentials （Native App 或是跑在 Browser 裡面的 App），或是無法用任何手段來保護 client 的認證。

Authorization Server 不應該自行猜測 Client 屬於何種。（不過現實卻不是這樣，見下文。）

單一的 Client 可能會分離成不同的組件 (components) ，如一個跑在 Server 、一個跑在 Client 。若 Authorization Server 沒有支援這種 Client ，或沒有指南文件，則開發人員時必須為各個組件註冊不同的 Clients。

*Section 2.1*

### Client Profiles

OAuth 2.0 的 spec 是為以下這些類型的 Clients 來設計的：

**Web Application**：

* 屬於 confidential
* 跑在 Web Server 上面。
* Client Credentials 及 Access Token 儲存在 Server 上面，於 Resource Owner 不可見。

**User-Agent-based Application**

* 屬於 public
* Client 的程式是從 Web Server 下載到 Resource Owner 的 User-Agent 來執行的。
* 通訊協定過程的數據以及 credentials 可以很容易被 Resource Owner 取得（而且通常看得到）。
* 也因為這種 app 直接跑在 User-Agent 裡面，所以可以在取得 Authorizations 的時候無縫接軌。

**Native Application**

* 屬於 public
* 安裝在 Resource Owner 的設備上，也在其上執行。
* 通訊協定過程的數據與 credentials 可以被 Resource Owner 取得。
* 任何包在 app 裡面的 Client Credentials 都要假設可以被解出來。
* 相對而言，動態取得的 credentials ，像是 Access Token 、 Refresh Token ，可以得到某種程度的保護。至少，如果把這些 credentials 存放在 Client 會使用的伺服器上，也可以得到保護。
* 在某些平台上，這些 credentials 可能會被保護起來，從而不讓其他在同一台設備上的其他 apps 取得。（OS X 的 Keychain Access 就是這種機制）
* 關於 Native Application 有更多實作上的考量，請見後文。

舉例：

| 應用程式 | Profile | Type |
|---------|---------|------|
| 自動抓 Facebook 照片的某個伺服器程式 | Web Application | Confidential |
| 可以連結 Facebook 帳號的 Firefox Add-On | UA-based Application | Public |
| iPhone 版的 Facebook 即時通訊程式 | Native App | Public |


*出自 Section 2.1，範例除外*

### 現實中的 Client Registration

雖然規定註冊時要填寫 Client Type ，實務上好像沒什麼網站會要求填寫 Client Type 的，甚至 Client Profile，在整份 API 裡面，即使會區分 client ，也是把 client 依其 Profiles 區分。

### Client Identifier （識別號）

Client 的惟一識別號，註冊時取得，對 Authorization Server 也是惟一的。

會被 Resource Owner 看到，所以絕對不可以在 Client Authentication 的時候單獨使用。

其長度 spec 並不規定。Client 不可自己猜測。Authorization Server 應該要在文件裡提及。

*Section 2.2*

## 認證 Client 的方式 (Authentication)

**confidential**：要有認證流程，其流程要符合 Authorization Server 的安全規範。通常是用事先核發的 credentials （如 Password 、非對稱式金鑰）。

**public**：可以有認證方式（不必備），但絕對不能以 Public Client 的認證方式來識別 (identify) 個別的 client 。

Client 每一次 request 只能用一種方式來認證。

*Section 2.3*

### 用 Client Password 來認證

#### 方法 (1): HTTP Basic Auth

持有 Password 的 Client 可以用 HTTP Basic Auth 來認證（見 RFC 2617）。帳密要先用 urlencode 編過。

例如 ID 是 `s6BhdRkqt3` 、 Secret 是 `7Fjfp0ZBr1KtDRbnfVdmIw` ，則步驟如下：

Step 1: 根據 Basic Auth 的規則，把 ID 和 Secret 連起來，中間用冒號 `:` 分開，變成這樣：

    s6BhdRkqt3:7Fjfp0ZBr1KtDRbnfVdmIw

Step 2: 用 base64 編過，變成這樣：

    czZCaGRSa3F0Mzo3RmpmcDBaQnIxS3REUmJuZlZkbUl3

Step 3: 加上 `Basic` 前綴：

    Basic czZCaGRSa3F0Mzo3RmpmcDBaQnIxS3REUmJuZlZkbUl3

Step 4: 最後得到的 HTTP Auth 的 header 就是：

    Authorization: Basic czZCaGRSa3F0Mzo3RmpmcDBaQnIxS3REUmJuZlZkbUl3

#### 方法 (2): POST

此外還有另一種方法（不建議使用）是使用 POST 發送以下資料：

| 參數名 | 必/選 | 註 |
|----|----|----|
| client_id | 必 | |
| client_secret | 必 | 若本來就是空白的密碼，則可留空。

注意事項：

* **這種方法不建議使用**
* 應該限制在無法使用 Basic Auth 或其他 HTTP Authentication 方式的 Client 來使用。
* 不可以把參數放在 URI 裡面。
* 要經過 TLS (https) 。
* 因為牽涉到密碼，所以要防暴力破解。

範例：（換發 Access Token 時，Client 要認證自己）

    POST /token HTTP/1.1
    Host: server.example.com
    Content-Type: application/x-www-form-urlencoded
    
    grant_type=refresh_token&refresh_token=tGzv3JOkF0XG5Qx2TlKWIA
    &client_id=s6BhdRkqt3&client_secret=7Fjfp0ZBr1KtDRbnfVdmIw

*Section 2.3.1*

### 其他認證方式

沒規定不能有別的，只要 Authorization Server 沒有安全上的疑慮就好了。

不過，如果要做別的認證方式，必須要建一張表記錄認證方式跟 Client ID 。

### 實際上的利用方式

理想與現實總是有段差距。實務上，許多大網站只支援 POST ，Basic Auth 則不一定支援。而 Facebook 則是只支援 GET （不符合「不可以放在 URI 裡面」的要求）。

## 未註冊的 Clients

沒規定不能有這種 Client 存在，spec 裡面也不討論。

## 關於 Native Application

Native Application 指的是在 Resource Owner 的設備上面安裝、執行的 Client （即桌面應用程式、手機 App），需要特別考慮安全性、平台相容性、整體的 User Experience 。

Authorzation Endpoint 會要求 Client 和 Resource Owner 的 User-Agent 之間的互動。Native Application 可以調用外部的 User-Agent 或是內嵌一個在應用程式裡面。用法如下。

### 外部 User-Agent：

* 用 Redirection URI 捉到來自 Authorization Server 的 response ，這個 URI 的 Scheme 要事先向 OS 註冊，才能讓 Client 成為 Scheme 的處理程式（如 `facebook:`）。
* 手動複製貼上 credentials 。
* 跑在本機的 Web Server。
* 安裝一個 User-Agent 的擴充套件。
* 提供一個 Redirection URI 來識別出一個放在 Server 上的、由 Client 控制的 resurce ，讓 resource 可以被 Native Application 取得（例如 Facebook 有一個固定的 Redirection URI）。

### 內嵌 User-Agent:

* 直接監視其狀態變化來得到 response （例如看到網址變成事先指定的，就表示得到了 redirection）
* 直接存取其 cookie。

### 外部或內嵌 User-Agent 的選擇

在選擇要用哪一種 User-Agent 的時候，請考慮以下這些事：

* 外部的 User-Agent 會增加達成率 (completion rate) ，因為 Resource Owner 可能已經登入到 Authorization Server 了，如此就可以免去重新登入的麻煩，從而讓使用者無縫接軌（不需要重新登入）。Resource Owner 也可能會依賴 User-Agent 特有的功能來協助登入（如自動填寫密碼、二步驗證）。
* 內嵌的 User-Agent 也許會增進使用的方便性，因為這樣就不需要切換到另一個視窗。
* 內嵌的 User-Agent 會導致安全上的挑戰，因為 Resource Owner 要在一個來歷不明的視窗裡面填入帳號密碼，如果是一般的外部 User-Egent，可以有別的視覺指引來辯認（如 URI、SSL Certificate）。內嵌的 User-Agent 會教育使用者去相信來歷不明的認證請求，進而讓釣魚攻擊更容易執行。

### Grant Flow 的選擇

Native Application 可以用的流程是 Implicit Grant 和 Authorization Code Grant 。在選擇要用哪一種的時候，請考慮以下這些事：

* 使用 Authorization Code Grant 的 Native Application 最好不要兼使用 client credentials ，因為 Native App 無法保密這些資料。
* 使用 Implicit Grant 的時候，不會拿到 Refresh Token 不會，這樣子一旦過期，就需要重覆認證的流程。

*Section 9*

## 安全性問題

這裡的安全性問題出自 Section 10 ，因為跟 Client Authentcation 有關，所以直接放進來。

### Client 認證的安全性問題 (Section 10.1)

Authorization Server 設立 Client credentials 是為了認證 Client。建議 Authorization Server 考慮使用比 Client password 更強的認證方式。Web Application Clients 必須確保 Client password 和其他 credentaisl 的保密。

Authorization Server 不可以為了認證 Client 而核發 Client Passwords 或是其他 credentials 給 Native Application 或是 User-Agent-Based Application Clients ，但是可以核發給特定設備上面的 Native Applciation 。

如果 Client 認證無法實施，Authorization Server 應該使用別的方式來驗證 Client 的身份。例如，要求 Client 預先設定 Redirection URI，或是讓 Resource Owner 來確認 Client 的身份。雖然，在詢問 Resource Owner 的授權的時候，即使有正確的 Redirection URI ，也不足以驗證 Client 的身份， 但是可以防止 credentails 傳遞到假的 Client 。

對於未經認證的 Clients （如 Public Clients），Authorization Server 必須考慮與其互動時會引發的安全性衝擊，且核發給這種 Clients 的其他 credentials 有外洩的可能（例如 Refresh Token），應致力降低其可能性。

### 偽裝成別的 Client (Section 10.2)

Client 可能會被駭，像是 credentials 外洩。這種情況發生時，惡意的 Client 可以偽裝成被駭的 Client 並取得存取 Protected Resource 的權限。

Authorization Server 必須儘可能認證 Client 。如果 Authorization Server 因為 Client 的性質而不能認證之（例如 In-Browser App 就不能認證），那麼 Authorization Server 必須要求其預先設定 Redirection URI 來接收授權的 response，並且應該利用其他手段來保護 Resource Owner 使用這種潛在的惡意 Client 。

Authorizatino Server 應該要強化明確的 Resource Owner 授權流程，並且提供 Resource Owner 關於 Client 要求的授權範圍 (scope) 以及時效。Resource Owner 在當下的 Client 的環境裡面，要不要檢閱這些資訊、要不要授權或拒絕請求，則是他的自由。

當 Authorization Server 收到重複的授權請求的時候，要是 Resource Owner 本人沒有與 Authorization Server 互動、Client 沒有認證自己、又沒有其他方法可以確定重複的請求是來自真正的 Client 而不是偽裝的，則 Authorization Server 不應該處理重複的授權請求。

### Open Redirector

沒要求 Client 事先指定 Redirection URI ，可能會使得 Authorization Endpoint 變成 Open Redirector 。詳見[系列文第 3 篇](http://blog.yorkxin.org/posts/2013/09/30/oauth2-3-endpoints/)關於 Open Redirector 的安全性問題。

---

## OAuth 2.0 系列文目錄

* [(1) 世界觀](http://blog.yorkxin.org/posts/2013/09/30/oauth2-1-introduction/)
* **[(2) Client 的註冊與認證](http://blog.yorkxin.org/posts/2013/09/30/oauth2-2-cilent-registration/) ← You Are Here**
* [(3) Endpoints 的規格](http://blog.yorkxin.org/posts/2013/09/30/oauth2-3-endpoints/)
* [(4.1) Authorization Code Grant Flow 細節](http://blog.yorkxin.org/posts/2013/09/30/oauth2-4-1-auth-code-grant-flow/)
* [(4.2) Implicit Grant Flow 細節](http://blog.yorkxin.org/posts/2013/09/30/oauth2-4-2-implicit-grant-flow/)
* [(4.3) Resource Owner Credentials Grant Flow 細節](http://blog.yorkxin.org/posts/2013/09/30/oauth2-4-3-resource-owner-credentials-grant-flow/)
* [(4.4) Client Credentials Grant Flow 細節](http://blog.yorkxin.org/posts/2013/09/30/oauth2-4-4-client-credentials-grant-flow/)
* [(5) 核發與換發 Access Token](http://blog.yorkxin.org/posts/2013/09/30/oauth2-5-issuing-tokens/)
* [(6) Bearer Token 的使用方法](http://blog.yorkxin.org/posts/2013/09/30/oauth2-6-bearer-token/)
* [(7) 安全性問題](http://blog.yorkxin.org/posts/2013/09/30/oauth2-7-security-considerations/)
* [各大網站 OAuth 2.0 實作差異](http://blog.yorkxin.org/posts/2013/09/30/oauth2-implementation-differences-among-famous-sites/)