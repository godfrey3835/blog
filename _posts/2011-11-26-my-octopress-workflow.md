---
layout: post
title: Octopress 搬家記 (2) -- 程式碼與網站內容的管理
published: true
date: 2011-11-26 23:11
tags:
- git
- Octopress
- heroku
categories: []
comments: true

---


我搬的文章只有一小部份，其他的會視流量決定要不要搬。為了可以轉址，我把 blog 放到 Heroku 。在 Octopress 的網站上有說明如何做。不過它的方法會強迫我把 compiled HTML 都放進 `master` ，我是有點潔癖的人，我覺得這樣感覺非常不良。

## Blog 原始碼、草稿、上線網站管理流程簡介

我希望把程式碼及發表的文章，與 compiled HTML 隔離開來，且草稿先不公開。草稿可以放到 dropbox ，而程式碼加上已發表的文章，可以放到 GitHub 公開出來。我想到的管理方式是這樣子：

[![img](http://farm7.staticflickr.com/6238/6405497433_b55d622963_z.jpg)](http://www.flickr.com/photos/chitsaou/6405497433/)

<!-- more -->

### 生自己的 blog：

1.  從 Octopress 的 `master` 給 fork 出來，這可以透過 GitHub 直接 fork  。
- 然後把自己的 repository 拉下來，照官方文件安裝。
- 還可以加一個 local branch 去 track Octopress 的 `master` ，升級也方便了。

### 寫新文章：

1. 開一個草稿 branch ，命名為 `drafts/blahblah`
- checkout 到那個 branch ，然後開新文章、寫文章、 commit 他的 markdown 檔。
- 想備份的話，就 push 到 Dropbox 。

### 定稿：

1. 把該草稿的 branch 給 merge 進 master （我一律使用 `--no-ff` 來產生 merge commit）。
- `master` 只存放原始碼，不存放 `public/` 裡面的 compiled HTML 。

### 發佈到線上：

1. checkout 到 `deploy` branch
- 將 `master` 給 merge 進 `deploy`（我一律使用 `--no-ff` 來產生 merge commit）。
- 跑 `rake generate` 來重新 compile 整個站
- 把 `public/` 全部 commit
- 最後再 push 進 `heroku/master` 來丟上線。

## 設定 Heroku 的部署方案

不過一開始困擾了一下，因為我想在 GitHub 放 `master` ，但 Heroku 又規定，只有 push 到 `heroku/master` 的東西，他才會拿來 deploy 。好在 Git 可以指定某 branch 預設要 push 去的地方，找了一下子就找到[答案](http://stackoverflow.com/questions/3596940/how-do-i-make-a-local-branch-track-a-remote-branch-with-a-different-name)了。

先透過 Heroku 官方文件設定好你的 remote `heroku` 之後，就可以動工了。

開一個 `deploy` branch

    git branch deploy

### 設定 deploy branch 與 Heroku remote 的互動

叫 `deploy` branch 去追 `heroku` 的 `master` 

    git config branch.deploy.remote heroku
    git config branch.deploy.merge heroku/master

叫 `heroku` remote 把 `deploy` branch 給 push 到他的 `master`：

    git config remote.heroku.push refs/heads/deploy:refs/heads/master

這樣子，如果在 `deploy` branch 執行 `git push` 就會把 `deploy` 給 push 到 `heroku/master` 了，而不是把 `master` 給 push 過去。

### 設定 deploy branch 監視 `public`

還沒完工，現在 `deploy` branch 一樣會忽略 `public/` 。

先 checkout 到 `deploy/` 。

改 `.gitignore` ，刪掉

    public

然後加入 `.gitignore`

    git add .gitignore

然後當然要 commit

    git commit -m "track public/ under deploy branch"

最後你可以試爆一下：

    rake generate
    git add public/
    git commit -m 'deploy'
    git push

如果 `git push` 不給你 push ，可能你之前有 push 過 local 的 `master` ，加個 `-f` 參數可以強制覆蓋。

## 設定 Dropbox 放草稿

GIt 可以用 `file://` 來把 remote branch 的 URL 給指到磁碟區上的一個目錄，這樣就太好了，草稿可以做版本控制，又不必公開。

首先去你的 Dropbox 資料夾開一個空的 repository ：

    cd ~/Dropbox/
    git init --bare myblog.git

現在你會看到 Dropbox 目錄底下有一個 `myblog.git` 的目錄。

然後回到 Octopress 的 repository ，加那個目錄為 `dropbox` remote。例如你的 `myblog.git` 的完整路徑是 `/Users/nyan/Dropbox/myblog.git` ，那就打：

    git remote add dropbox file:///Users/nyan/Dropbox/myblog.git

注意 `file:` 後面有 3 條 `/` ，前兩條用來判斷 protocol ，第 3 條是根目錄的意思。

現在就可以用 `git push dropbox drafts/blahblah` 來把某個草稿給 push 到 Dropbox 了。

但是，我不知道怎麼設定只要符合 `draft/` 開頭的 branch 統統 push 進 dropbox ......
