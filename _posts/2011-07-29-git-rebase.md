---
layout: post
title: Git-rebase 小筆記
published: true
date: 2011-07-29 00:00
tags:
- git
categories: []
comments: true

---

最近剛好有個機會整理很亂的 Git commit tree，終於搞懂了 rebase 的用法，筆記一下。

大家都知道 Git 有個特色就是 branch 開很大開不用錢，但很多 branches 各自開發，總要在適當時機 merge 進去 master 。看過很多 git 操作指南都告訴我們，可以妥善利用 rebase 來整理看似很亂或是中途可能不小心手滑 commit 錯的 commits ，甚至可以讓 merge 產生的線看起來比較簡單，不會有跨好幾十個 commits 的線。

## rebase 的意義：重新定義參考基準

首先要提一下 rebase 的意思，我擅自的直譯是「重新 *(re-)*定義某個 branch 的參考基準 *(base)*」。把這個意思先記起來，比較容易理解 rebase 的運作原理。就好比移花接木那樣（稼接），把某個樹枝接到別的樹枝。

在 git 中，每一個 commit 都可以長出 branch ，而 branch 的 base 就是它生長出來的 commit ，rebase 也就是把該 branch 所長出來的 commit 給改去另一個 commit 。不過，因為 rebase 會調整 commit 的先後關係，弄不好的話可能會把你正在操作的 branch 給搞爛，所以在做 rebase 之前，最好開一個 backup branch ，什麼時候出差錯的話，reset 回 backup 就行了。

以下用實際的例子來操作比較容易解釋。看 log 的程式是 [GitX (L)](http://gitx.laullon.com) 。

**Update** 2012/06/28：也可以看 [ihower 的錄影示範](http://ihower.tw/blog/archives/6704/) ，實際操作會比讀文字來得容易懂。

<!--more-->

例如我要寫個網頁，列出課堂上的學生。我把樣式的設計 (`style`) 跟主幹 (`master`) 分開，檔案有 `index.html` 和 `style.css` 。

到目前為止有以下的 commit history：

[![](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-25-at-00-58-36.png)](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-25-at-00-58-36.png)

`style` 完成了一小部份，而接下來要修飾的頁面是 `master` 裡面有改過的，如何讓 `style` 可以繼承 `master` 呢？就是用 rebase 把 `style` branch 給接到 `master` 後面了，因為 rebase 是「重新定義基準點」。就像是在稼接時，把新枝的根給「接」在末梢上。

rebase 的基本指令是 `git rebase <new base-commit>` ，意思是說，把目前 checkout 出來的 branch 分支處改到新的 commit。而 commit 可以使用 branch 去指（被指中的 commit 就是該 branch 的 **HEAD**），所以現在要把 `style` 這個 branch 接到 `master` 的 **HEAD** （`dc39a81e`），就是在 `style` 這個 branch 執行
	
	git rebase master

完成之後，圖變這樣：

[![](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-25-at-01-00-38.png)](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-25-at-01-00-38.png)

果然順利接起來了。

而在執行的過程中會看到：

	First, rewinding head to replay your work on top of it...
	Applying: set body's font to helvetica
	Applying: adjust page width and alignment

這是它的操作方式，照字面上的意思，就是它會嘗試把當前 branch 的 **HEAD** 給指到你指定的 commit （在這裡是原本 `master` 的 **HEAD**，也就是 `dc39a81e`），然後把每個原本在 `style` 上面的 commits （`d242d00c..0b373e34`） 給**重新 commit** 進去 `style` 這個 branch (re-apply commits)。也由於是「**重新 commit**」，所以 rebase 以後的 commit ID (SHA) 都不一樣。

那如果過程中有 conflict 呢？後文會提到。

## fast-forwarding: 可以的話，直接改指標，不重新 commit

接著再開個新的 branch 叫 `list` ，專門改學生清單，同時<del>另一個人</del>也在改 `style` 這個 branch ，修飾網頁的整體裝飾。改啊改，變成這樣分叉的兩條線：

[![image](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-25-at-01-14-55.png)](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-25-at-01-14-55.png)

`list` 改到一個段落，沒有問題了，就想 merge 進 `master` 。在 `master` branch 做

	git merge list

這時 git 發現，剛好 `master` 直接指到 `list` 的 **HEAD** commit 也行 ，所以 git 直接就改了 `master` 的 commit ID ，也就是所謂的 **fast-forward**，熟悉 C 語言的同學應該對這種指標移動不陌生。完成之後就是這樣：

[![image](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-25-at-01-16-30.png)](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-25-at-01-16-30.png)

## `rebase --onto`: 指定要從哪裡開始接枝

`list` 繼續改，`style` 還是繼續改，變這樣：

[![image](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-25-at-01-26-05.png)](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-25-at-01-26-05.png)

現在 `style` 要開始裝飾學生清單了，而學生清單是 `list` 這個 branch 在改的。於是 `style` 應該要 rebase 到 `list` ，可是這時管 `list` 的說，我後面幾個 commits 還沒敲定，你先拿 `64a00b7e (add their ages)` 這個 commit 當基準，這我改好了。所以這時候，應該要把 `style` 這個 branch 接到 `64a00b7e` 的後面。

該怎麼辦呢？這時就要用 `git rebase --onto` 了。指令是

    git rebase --onto <new base-commit> <current base-commit>

意思是說，把當前 checkout 出來的 branch 從 `<current base-commit>` 移到 `<new base-commit>` 上面 ，就像是在稼接時，把新枝的根給「種」在某個點上，而不是接在末梢。（這似乎也是稼接最常用的方式？有請懂園藝同學的指教一下）

再看一下 commit history：

[![image](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-25-at-01-26-05.png)](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-25-at-01-26-05.png)

現在 `style` 是 based on `dc39a81e (add some students)`，要改成 based on `64a00b7e (add their ages)`，也就是

* `<current base-commit>` = `dc39a81e`
* `<new base-commit>` = `64a00b7e`

那就來試試看

	git rebase --onto 64a00b7e dc39a81e

[![image](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-25-at-01-36-05.png)](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-25-at-01-36-05.png)

果然達到了目的，`style` 現在是 based on `64a00b7e` 了（當然 commit IDs 也都不同了）。

## conflict 的處理

接著改 `style` 的人修改了學生清單的樣式，可是他很機車，他要改 `index.html` 裡面的東西（實際情況是，`list` 裡寫了一個 `table`，但寫 css 總要有些 `class` 或 `id` 的 attributes 才能設定）。剛好改 `list` 的人也在他自己的 branch 裡面改，這時候，在 rebase 試著 re-apply commits 的過程中，必定會產生 conflict。

[![image](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-25-at-02-12-081.png)](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-25-at-02-12-081.png)

現在 `list` 要利用到 `style` 裡面修飾好的樣式，在這個情況下，就是把 `list` 給 rebase 到 `style` 上面，也就是在 `list` branch 做 `git rebase style` 。不過你會看到這個：

    First, rewinding head to replay your work on top of it...
    Applying: add gender column
    Using index info to reconstruct a base tree...
    Falling back to patching base and 3-way merge...
    Auto-merging index.html
    CONFLICT (content): Merge conflict in index.html
    Failed to merge in the changes.
    Patch failed at 0001 add gender column

    When you have resolved this problem run "git rebase --continue".
    If you would prefer to skip this patch, instead run "git rebase --skip".
    To restore the original branch and stop rebasing run "git rebase --abort".

跟預期的一樣出現了 conflict。當然，它會先試著自動 merge ，但如果改到的行有衝突，那就得要手動 merge 了，打開他說有衝突的檔案，改成正確的內容，接著使用 `git add <file>` （要把該檔案加進去 staging area，處理 rebase 的程式才能 commit），再 `git rebase --continue` 。

完成以後就會像這樣：

[![image](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-25-at-02-22-47.png)](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-25-at-02-22-47.png)

## Interactive Mode: <del>偷天換日</del>，自定重新 commit 的詳細步驟

接著 `style` 和 `list` 又陸續改了一些東西，主要是 `list` 裡面加了表單元件，而 `style` 則繼續修飾網頁整體設計。到了一個段落，該輪到 `style` 修飾 `list` 的表單了。目前的 commit history 長這樣：

[![image](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-29-at-17-53-44.png)](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-29-at-17-53-44.png)

不過在 `style` 要 rebase 到 `list` 上面之前，管 `list` 的人想把 `list` 上面的一些 commits 給整理過，因為他發現有這些問題：

* `"wrap the form with div"` 太後面了，想移到前面
* `"fix typo of age field name"` 跟 `"add student id and age..."` 可以合併
* `"add student id and age ..."` 裡面東西太多，該拆成兩個
* `"form to add more *studetns*"` 這 message 有錯字 "studetns"
* `"add gender select box"` 裡面的程式碼有打錯字（囧

上面提到了 rebase 運作的方式是重新 commit 過一遍，那這個「重新 commit」的過程，能不能讓程式設計師來干預，達到<del>偷天換日</del>修改 commit 的目的呢？當然可以，只要利用 rebase 的 **Interactive Mode**。Git 的靈活就在這裡，連 commit 的內容都可以改。

如何啟動 interactive mode 呢？只要加入 `-i` 的參數就行了。以這個例子來說，`list` branch 是 based on `0580eab8 (fill in gender column)` ，要從這個 commit 後面重新 apply 一次 commits ，也就是：

    git rebase -i 0580eab8

接著會以你的預設編輯器打開一個檔案叫做 `.git/rebase-merge/git-rebase-todo` ，裡面已經有一些 git 幫你預設好的內容了，其實就是原本 commits 的清單，你可以修改它，告訴 git 你想怎麼改：

``` text git rebase -i
pick 2c97b26 form to add more studetns
pick fd19f8e add student id and age field into the form
pick 02849bf fix typo of age field name
pick bd73d4d wrap the form with div
pick 74d8a3d add gender select box

# Rebase 0580eab..74d8a3d onto 0580eab
# ...[chunked]
```

第一個欄位就是操作指令，指令的解釋在該檔案下方有：

* `pick` = 要這條 commit ，什麼都不改
* `reword` = 要這條 commit ，但要改 commit message
* `edit` = 要這條 commit，但要改 commit 的內容
* `squash` = 要這條 commit，但要跟前面那條合併，並保留這條的 messages
* `fixup` = squash + 只使用前面那條 commit 的 message ，捨棄這條 message
* `exec` = 執行一條指令（但我沒用過）

此外還可以調整 commits 的順序，直接剪剪貼貼，改行的順序就行了。

### 調整 commit 順序、修改 commit message

首先我想要把 `"wrap the form with div"` 移到 `"form to add more studetns"` 後面，然後 `"form to add more studetns"` 要改 commit message （有 typo），那就改成這樣：

``` text git rebase -i
reword 2c97b26 form to add more studetns
pick bd73d4d wrap the form with div
pick fd19f8e add student id and age field into the form
pick 02849bf fix typo of age field name
pick 74d8a3d add gender select box
```

接著儲存檔案後把檔案關掉（如 vim 的 `:wq`），就開始執行 rebase 啦，遇到 `reword`  時會再跳出編輯器，讓你重新輸入 commit message 。這時我把 `studetns` 改正為 `students` ，然後就跟平常 commit 一樣，存檔並關掉檔案。

``` text git commit
form to add more students

# Please enter the commit message for your changes. Lines starting
# ...[chunked]
```

完成後會看到：

    Successfully rebased and updated refs/heads/list.

再看 commit history ，的確達到了目的，而且 `list` 這個 branch 一樣還是 based on `0580eab8` ，後面那些剛剛 rebase 過的 commits 統統換了 commit ID ：

[![image](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-29-at-18-21-28.png)](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-29-at-18-21-28.png)

### 合併 commits

剩下這些要做：

* `"fix typo of age field name"` 跟 `"add student id and age..."` 可以合併
* `"add student id and age ..."` 裡面東西太多，該拆成兩個
* `"add gender select box"` 裡面的程式碼有打錯字

現在來試試看合併，一樣是 `git rebase -i 0580eab8` ，並使用 `fixup` 來把 commit 給合併到上一個（如果用 `squash` 的話，會讓你修改 commit message ，修改時會把多個要連續合併的 commit messages 放在同一個編輯器裡）：

``` text git rebase -i
pick c3cff8a form to add more students
pick 7e128b4 wrap the form with div
pick 0d450ea add student id and age field into the form
fixup 8f5899e fix typo of age field name
pick e323dbc add gender select bo
```

完成後再看 commit history ，的確合併了：

[![image](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-29-at-18-24-50.png)](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-29-at-18-24-50.png)

### 修改、拆散 commit 內

剩下了拆 commit 和訂正 commit 內容。現在先來做訂正 commit ，這個學會了就知道怎麼拆 commit 了。

在這裡下 `edit` 指令來編輯 commit 內容：

``` text git rebase -i
pick c3cff8a form to add more students
pick 7e128b4 wrap the form with div
pick 53616de add student id and age field into the form
edit c5b9ad8 add gender select box
```

存檔並關閉之後，現在的狀態是停在剛 commit 完 `"add gender select box"` 的時候，所以現在可以偷改你要改的東西，存檔以後把改的檔案用 git add 加進 staging area ，再打

	git rebase --continue

來繼續，這時候因為 staging area 裡面有東西，git 會將它們與 `"add gender select box"` 透過 `commit --amend` 一起重新 commit 。

最後是拆 commit 。怎麼拆呢？剛剛做了 `edit` ，不是停在該 commit 之後嗎？這時候就可以偷偷 reset 到 `HEAD^` （即目前 HEAD 的**前一個**），等於是退回到 HEAD 指到的 commit 的前一個，於是該 commit 的 changes 就被倒出來了，變成 *changed but not staged for commit* ，再根據你的需求，把 changes 給一個一個 commit 就行了。

實際的操作如下。首先是用 `edit` 指令來編輯 commit 內容：

``` text git rebase -i
pick c3cff8a form to add more students
pick 7e128b4 wrap the form with div
edit 53616de add student id and age field into the form
pick 4dbcf49 add gender select box
```

接著使用

	git reset HEAD^
	
來把目前的 HEAD 指標給指到 HEAD 的前一個，指完之後，原本 HEAD commit 的內容就被倒出來，並且也不存在 stage area 裡面， git 會提示有哪些檔案現在處於 changed but not staged for commit：

    Unstaged changes after reset:
    M	index.html

現在我可以一個一個 commit 了，原本是 `add student id and age field` ，我想拆成一次加 student id field ，一次加 age field 。commit 完成以後，再打

	git rebase --continue
	
這次因為 staging area 裡面沒東西，所以就繼續 re-apply 剩下的 commits 。

現在打開 log 看，拆成兩個啦！

[![image](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-29-at-20-18-30.png)](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-29-at-20-18-30.png)

掌管 `list` branch 的人折騰完了，便告訴管 `style` 的說，可以 rebase 了，<del>git 再度拯救了苦難程序員的一天</del>。

[![image](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-29-at-21-04-34.png)](http://chitsaou.files.wordpress.com/2011/07/screen-shot-2011-07-29-at-21-04-34.png)

---

更多 rebase ：

* [Git 版本控制系統(3) 還沒 push 前可以做的事](http://ihower.tw/blog/archives/2622) by ihower
* [寫給大家的 Git 教學](http://www.slideshare.net/littlebtc/git-5528339) by littlebtc

