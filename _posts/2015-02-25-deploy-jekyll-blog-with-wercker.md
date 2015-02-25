---
layout: post
title: 用 Wercker 來發布 Jekyll blog 到 Amazon S3
published: true
date: 2015-02-25 23:00
tags:
categories: []
comments: true
---

繼續之前的作業，把 Blog 搬到 S3 之後，最麻煩的就是要手動用 command line 寫文章、上傳（deploy）。這是我以前放棄 Octopress 改用 Logdown 的原因。

但是之前看到 Hugo（Go 的 Blog Generator）推薦用 [Wercker](http://wercker.com) 來做雲端 deploy，又前幾天看到 [Bruce 大大的教學文](http://toyroom.bruceli.net/tw/2015/02/22/move-toy-room-blog-to-s3-with-jekyll-and-wercker.html)就覺得似乎很方便，所以也來試試看了，沒想到真的好簡單啊。

不過 Bruce 遇到了官方的 S3Sync 很難用的問題，就這麼剛好在他寫好文章之後的**隔天**官方發表了新的 S3Sync Deploy Step，完全沒有他遇到的麻煩，而且設定相對簡單許多。

以下就來說明一下怎麼設定。

---

設定帳號、開設 GitHub / BitBucket、上傳 code 到 Git Repo、開新 Wercker 專案什麼的，很簡單我就跳過了。比較要想的問題是如何寫 Deploy 設定檔。

## 寫 wercker.yml 設定檔

wercker.yml 是 Wercker 的 deploy 設定檔，教 Wercker 要如何 build & deploy 你的 code。（所以也可以拿來當簡單的 CI 使用）

官方指南在 [Deploying static sites to S3 with Jekyll and wercker](http://devcenter.wercker.com/articles/deployment/jekylls3.html) 這裏，而官方的 deploy step 是 [wercker/s3sync](https://app.wercker.com/#applications/51c82a063179be4478002245/tab/details)。我簡單說明一下怎麼設定。

首先要知道的是，Wercker 分為 Build 和 Deploy 兩大步驟，Build 是告訴 Wercker 如何把你的程式從 source code 變成完成品，Deploy 是把完成品實際上線。對於 Jekyll 來說，Build 就是 `jekyll build`、Deploy 就是透過 S3Sync 把 `_site/` 資料夾裡面的東西放到 S3。

根據官方指南，可以做出這樣的 wercker.yml：

```yml
box: wercker/rvm

build:
  steps:
    # Run a smart version of bundle install
    # which improves build execution time of
    # future builds
    - bundle-install

    # A custom script step
    # that actually builds the jekyll site
    - script:
        name: generate site
        code: bundle exec jekyll build --trace
deploy:
  steps:
    - s3sync:
        key-id: $S3_KEY
        key-secret: $S3_SECRET
        bucket-url: $S3_BUCKET
        source-dir: _site/
        opts: -v --acl-public --cf-invalidate
```

幾個地方要注意：

* box 要選用 [wercker/rvm](https://app.wercker.com/#applications/52c6d6e1728cc898720001e3/tab/details) 而非 [wercker/ruby](https://app.wercker.com/#applications/51ab917fdf8960ba45004497/tab/details)，前者有在追 Ruby 新版本，後者很久沒有更新了。
* Run bundle 要特別使用 `bundle-install` 這個 build step，他會 cache 住 installed gems
* s3sync 的設定 key 是 dash 不是 underscore，有的文件會寫成 underscore
* 不要把真正的 S3 Key 和 S3 Secret 帳號密碼寫死在 wercker.yml 裡面，請使用 $ 開頭的環境變數，之後在 Wercker 設定。
* `source-dir` 要設定成你的 Jekyll 的 build target dir，預設是 `_site/`。
* 如果你有上 CloudFront 的話，記得加 `--cf-invalidate` 這個 option，他會幫你去 CF 做 cache invalidation。
* 其他 S3sync 設定檔可以到 [S3cmd 官方網站](http://s3tools.org/s3cmd-sync) 查詢。
* 記得要在 Jekyll 的 `_config.yml` 裡面把 wercker.yml 給 exclude 掉，不然會跑進 build dir 裡面。

此外 wercker/rvm box 會有預設一個 Ruby 版本，目前是 Ruby 2.0.0。如果你要特別指定 Ruby 版本，就在 Repo 的 root dir 加一個 `.ruby-version` 裡面寫版本號就可以了，跟一般的 Ruby project 一樣。

設定檔完成之後，要 commit 進去 git 裡面。現在可以先 push 上去，讓他 build 看看。

如果你的 Jekyll blog 很不巧需要 install packages，像是我的 blog 以前用到 github-linguist 所以需要 install `libicu-dev` 和 `cmake`（現在不用了），那麼就要使用 [wercker/install-package](https://app.wercker.com/#applications/51c829ea3179be4478002168/tab/details) 這個 step 來設定：

```yml
build:
  steps:
    - install-packages:
        packages: libicu-dev cmake

    - bundle-install

    - script:
        name: generate site
        code: bundle exec jekyll build --trace
```

記得 install packages 要在 bundle install 的前面。

不過這個 package install 似乎不會 cache，每次 build 都重新安裝的樣子（？

## Deploy 的設定

Build 完成要 Deploy 到 S3，但是首先 S3 要設定 deploy user。

先開一個 S3 bucket，接著開 CloudFront distribution，記得設定 default root document 為 `index.html`。

然後要開權限，進去 [IAM](https://console.aws.amazon.com/iam/home) 裡面開 Key：

1. Create New User，拿到 Key ID & Secret Key，存起來，等一下要輸入到 Wercker
2. Create User Policy，選擇 Custom Policy，輸入：

```json
{
  "Statement": [
    {
      "Action": [
        "cloudfront:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "*"
      ]
    },
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::your_bucket_name",
        "arn:aws:s3:::your_bucket_name/*"
      ]
    }
  ]
}
```

好了以後就可以透過這組 access key ID & secret key 來 Deploy 了。

### 到 Wercker 設定 Deploy Env

還記得之前設定檔裡面寫了一些變數嗎？現在請到 Wercker 的 Settings -> Deploy targets 裡面新增一個 Custom Deploy，取名叫做 Production，然後在 Deploy Piepline 那邊設定環境變數（都是 Text type）：

| name | 內容 | Protected? |
|-----|----|----------|
| `S3_KEY` | IAM Key ID，是一組亂碼 | 要打勾 “Protected” |
| `S3_SECRET` | IAM Secret Key，是一組亂碼 | 要打勾 “Protected” |
| `S3_BUCKET` | 你的 S3 bucket name，要 `s3://` 開頭 | 不用 Protect |

接著記得按 Save 才會存檔。

要注意的是 `S3_BUCKET` 要設定成 `s3://` 開頭的，這是 s3sync 的限制，例如你的 bucket name 是 `water_bucket` 就要使用 `s3://water_bucket` 才行。

為了安全起見，請把剛剛從 IAM 下載回來的 IAM Key Pair 砍掉，而且 Wercker 的設定區之後也看不到（因為是 Protected），如果忘記 key 的話，從 IAM 重新生一組就好了。

聰明的你應該瞭解了 Wercker 可以做多個 deploy target，沒錯，你可以另外開一組 S3 bucket 來做 staging site。

## 實際 Deploy

要 Deploy 的時候，是必須從 successful build 才可以 deploy 的，想來也是很理所當然，沒有 build 過的 project 要怎麼 deploy？至於在哪裡按我就不說了，很大一顆很好找。

---

## 結論：Wercker 拿來 deploy 很好用

除了 Jekyll blog 這種小事之外，還可以拿來 deploy 一般的專案，他也支援 deploy 到 heroku，不過現在 heroku 也有 github deploy 的功能了， 我想 Wercker 最大的用途還是 CI 吧。

現在的 workflow 如下：

1. Push master 到 Git Repo
2. Wercker 會自動 auto-build
3. Build 成功之後，手動按 “Deploy to Production”

心臟大顆一點的話可以開 auto deploy master branch to production，這樣 push 上去就全自動了。當然，auto deploy staging branch to staging 也是很好用的。

最後要說清楚的是，我的 code 是上傳到 BitBucket，因為我要放在 private project。如果是直接上 GitHub 的話，應該不需要這一套，直接 GitHub Pages 就自動 build 了。
