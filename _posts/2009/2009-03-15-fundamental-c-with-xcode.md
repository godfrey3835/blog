---
layout: post
title: "如何用 OS X 的 Xcode 寫 C 語言程式（更新 5.0 / 2013）"
published: true
date: 2009-03-15 00:00
tags:
- C
- xcode
- programming
categories: []
redirect_from: /posts/2009/03/15/fundamental-c-with-xcode
comments: true

---
*（最後更新： 2013/12/01 for Xcode 5.0.x）*

這篇是給新手看的。

如果你在 Windows 習慣使用 Visual C++ 或 Dev-C++ 的話，到了 Mac OS X 可能會突然不知道要怎麼寫程式，尤其當你已經用 Visual C++ 的 Debugger 用得很上手的話。

最近我們系上的課充滿了 C programming，我也稍微摸懂了 Xcode 的若干功能，至少我可以拿它來寫 C 語言的程式了，就像在 Windows 使用 Visual C++ 那樣。

如果這篇只是要教你怎麼按 Compile 的話，那我就是來騙文章數的了，因此這篇的內容還包括 **怎麼使用 Xcode 的 Debugger** 。

<!--more-->

---

## 安裝 Xcode

Xcode 是在 OS X 上面寫 C 語言程式最簡單的方式。首先是去 Mac App Store 下載安裝 Xcode ，網址： https://itunes.apple.com/tw/app/xcode/id497799835?mt=12 。這不用錢，只是要裝很久。安裝完成後，可以在 Launch Pad 裡面找到 Xcode ，按一下開啟。如果找不到的話，可以在 Spotlight （螢幕右上角的放大鏡）裡面搜尋 "Xcode" ，也可以找到。

![Screen Shot 2013-12-01 at 15.27.42.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/XMH0eBTHTtCbw0brEgdY_Screen%20Shot%202013-12-01%20at%2015.27.42.png)

第一次打開 Xcode 你會看到 Welcome to Xcode 的畫面，做為第一次嘗試，請先按下 **Create a new Xcode Project** 。

![Screen Shot 2013-12-01 at 15.32.50.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/bYq8IR38SOPiVfvfhoBy_Screen%20Shot%202013-12-01%20at%2015.32.50.png)

Welcome to Xcode 這個畫面若以後不想看到，可以取消勾選 Show this window when Xcode launches 來永久關閉，往後若要打開新專案，可以按下功能表的 **File → New → Project ...** 。

## 新增 C 語言專案

剛剛說按下 「Create a new Xcode Project」，接著會跳出一個視窗，問你要開什麼專案。對於一般 C 程式作業來說，它被歸類在 OS X 的命令列工具裡面，所以，在左側選 OS X 裡面的 Application ，然後在右邊選 **Command Line Tool** 。

![Screen Shot 2013-12-01 at 15.41.16.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/7oyl8cvvSWKa56Lob40B_Screen%20Shot%202013-12-01%20at%2015.41.16.png)

接著會要你輸入專案名稱，Organization Name 寫你的名字就行， Company Identifier 我不知道是做什麼的（我不是專門寫 OS X 軟體的），但並不會影響接下來的操作，所以像我這樣填一個看起來像樣的（？）就行。最下面的 Type 可以選 C 或 C++ ，還有其他 Objective-C-based Frameworks，這裡我直接選 C 。

![Screen Shot 2013-12-01 at 15.42.58.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/OeFtlK2TRugmCdMiXVKg_Screen%20Shot%202013-12-01%20at%2015.42.58.png)

最後按下 Next ，會要你找一個地方放這個專案，你就找個地方放就行了。

## 認識 Xcode IDE

Xcode IDE 的界面一打開跟 Visual Studio 、 Dev-C++ 都不一樣，從 Windows 來的人可能會不太習慣，不過不要緊，只要認識幾個東西就好了。

但在開始認識之前，請先到 **Xcode → Preferences...** 裡面的 Behaviors ，選 **Running → Starts** ，把 **Show debugger** 打開，並且把 Debug Area 打開，在 **View → Debug Area → Show Debug Area** 。這個預設沒開，但接下來會用到，非常重要，所以先打開。

![Screen Shot 2013-12-01 at 16.47.13.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/NqjAUPYTiiB6d4qg0IXv_Screen%20Shot%202013-12-01%20at%2016.47.13.png)

接下來來認識一下 Xcode Project 視窗的基本配置：

![Screen Shot 2013-12-01 at 15.54.26.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/eSqQS2rtTqC38sou72Ul_Screen%20Shot%202013-12-01%20at%2015.54.26.png)

請先認識：

* **「執行」按鈕 (Run)** ，長得像音樂軟體的 Play ，按下去就是執行程式
* **「停止」按鈕 (Stop)** ，長得像音樂軟體的 Stop ，在程式執行的時候可以強制停止
* **「狀態列」** ，在最上方，會出現的狀態像是編譯或執行的成功與否
* **「左側欄」** ，現在是顯示檔案列表（有其他列表可以切換）
* **「主要工作區」** ，現在裡面是看不懂的東西，等下會切換到程式碼編輯
* **「除錯區」** ，讓你方便對程式碼除錯，我會特別講這一個區域。

## 第一次執行程式

寫程式除了撰寫程式碼本身，最重要的就是要跑程式來看結果。剛剛介紹了「執行」按鈕，看起來可以按它來執行程式，那麼就按按看吧。按下去之後，你會看到狀態列的訊息有所改變，提示 Building 、 Build Success 、Running 等等，最後，你會在 Debug Area 的右邊看到這個：

![Screen Shot 2013-12-01 at 16.03.27.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/C3XtPoWbT6mkeePOvNPg_Screen%20Shot%202013-12-01%20at%2016.03.27.png)

嗯，程式可以執行，可以看到輸出了。

## 第一次修改程式

但是到現在還沒看到程式碼，剛剛說了左側欄是切換到「檔案列表」，也就是說檔案藏在裡面，請找一下 **main.c** ，按一下可以打開，主要工作區會變成程式碼：

![Screen Shot 2013-12-01 at 16.07.13.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/sEU0GDnJSNSDiiIygHVg_Screen%20Shot%202013-12-01%20at%2016.07.13.png)

這個程式碼你應該很熟悉，就是普通的 C 語言 Hello World 而已。

### 自動完成

接下來請試試看修改程式。假如我想要改成印出 10 次 Hello World 的內容，想必你會在 `// insert code here` 這邊加 for loop：

```c
int i;
for (i = 0; i < 10; i++) {
  printf("Hello, World\n");
}
```

你打到一半的時候應該會出現這樣子的東西：

![Screen Shot 2013-12-01 at 16.09.45.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/gI4TrStRjCKpsqOM6ZYw_Screen%20Shot%202013-12-01%20at%2016.09.45.png)

這個功能叫做 **「自動完成」 (Auto Complete)** ，是 Xcode 好用的功能之一，如果你從 Visual Studio 過來應該不陌生，就是打到一半，Xcode 會自動提示你可以寫什麼程式碼，並且按下 **Tab** 就可以自動跳到圓框來打字。你可以試試看，按 Tab 來切換，然後按 Enter 來確認。

自動完成其實無所不在，除了可以自動展開 Syntax 之外，還可以展開變數名稱、function 名稱（統稱 identifiers）、提示有哪些 `.h` 檔可以 include 、提示 struct 的結構。展開 identifers 的例子像是，你想要用 `fputs` ，打 `fp` ，它會自動出現所有 fp 開頭的函式（因為有 include `stdio.h` ，所以抓得到），按鍵盤的上下鍵可以選擇，除此之外，還會在右側欄出現簡單的說明。

如果你按 More 的話，還會出現完整的說明檔，這樣子就不需要上網查文件了。

![Screen Shot 2013-12-01 at 16.28.08.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/LmAI0OiKQ0eyFFsTWESI_Screen%20Shot%202013-12-01%20at%2016.28.08.png)

再提一個秘訣，想要手動 trigger 自動完成的話，可以按 Esc 。例如我先宣告了 `var1, var2, var3` ，想要對其中一個指定某值，打到一半只有 `var` 就跑到別行，再回來的話，可以在 `var` 的後方按 Esc ，就會跳出自動完成：

![Screen Shot 2013-12-01 at 16.34.47.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/YuMTYksOQZ2PDtlkIB9M_Screen%20Shot%202013-12-01%20at%2016.34.47.png)

附帶一提，大小寫隨便打，它也認得出來。

你可以隨便試，你應該會感受到「他好像很聰明的樣子」。

### 自動錯誤提示

我改好了，結果 oops ，好像忘記什麼東西？

![Screen Shot 2013-12-01 at 16.12.08.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/ao21Ze16Q0u5KhLD9Jfi_Screen%20Shot%202013-12-01%20at%2016.12.08.png)

老師有教過變數要宣告齁！

程式寫錯，不用到編譯才知道， Xcode 會一直自動編譯，檢查你程式碼是否可以編譯通過，並且自動 **標示錯誤** ，如果你按下行號旁邊的紅色驚嘆號，它會告訴你錯在哪：

![Screen Shot 2013-12-01 at 16.14.16.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/arO3fNDURbOtN2k9nmhR_Screen%20Shot%202013-12-01%20at%2016.14.16.png)

對，忘記宣告了，補起來之後，這個錯誤訊息就會消失了。

錯誤訊息除了程式寫錯無法編譯之外，還會有編譯器來的警告，例如有個變數宣告了但沒使用：

![Screen Shot 2013-12-01 at 16.18.11.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/ZsanqbuyRLmhb7e7dm2c_Screen%20Shot%202013-12-01%20at%2016.18.11.png)

如何，很方便吧？

### 執行程式與輸入資料

現在再來 Run 一遍，這次不要動滑鼠了，請按鍵盤上的 <kbd>Command + R</kbd> ，一樣會跑「執行」：

![Screen Shot 2013-12-01 at 16.16.54.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/1Iz1SmUHRKWqL8R1HNdn_Screen%20Shot%202013-12-01%20at%2016.16.54.png)

如果是從 Visual Studio 或 Dev-C++ 過來的，你可能會覺得奇怪，為什麼不是熟悉的黑底白字畫面？其實 Xcode 在執行的時候，並不是開一個新的終端機程式，而是直接在自己的 Console 裡面輸入輸出，我猜測這理由是因為 Xcode 是以 GUI 應用程式為主要導向，所以 Console 簡略就好，並且因為 OS X 是一種 UNIX 作業系統，天生就有輸入輸出轉向，可以直接接到 Xcode 裡面也很自然（這個在系統程式的課會教）。話說回來 Eclipse 好像也是長這樣。

不過，預設它並不會在執行的時候自動打開 Console，你必須手動開啟，所以一開始我才會請你先打開 Debug Area 。

接著來試著執行一個具備輸入輸出的簡單程式，輸入整數 `n` ，輸出 n 次 `"Hello, World!\n"`。

```c
int main(int argc, const char * argv[])
{
  int i, n;
  
  if (fscanf(stdin, "%d", &n) == 1) {
    for (i = 0; i < n; i++) {
      printf("Hello, World!\n");
    }
  }
  
  return 0;
}
```

按下 Run ，然後在 Console 裡面輸入 3 ，它就會輸入整數 `n` = 3 ，並且印出 3 次 `Hello, World!` ，跟我們想要的行為一致。

![Screen Shot 2013-12-01 at 16.54.50.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/1mU3yqGNSXSNj7MdHlEV_Screen%20Shot%202013-12-01%20at%2016.54.50.png)

如果你執行到一半想把程式關掉，只要按下 Stop 就行了。

## 使用 Debugger

跟 Visual Studio 一樣，專業的 IDE 一定要有完美的 Debugger 整合，而 Xcode 當然也有，這對於我這種不熟悉命令列式 debugging 的人來說是相當棒的功能。 一般的命令列 debugger 要自己下斷點（告訴它在第幾行）、自己下指令，但有了 Xcode ，你只要動滑鼠就行了。

以下以一個簡單的小程式做範例：

```c
#include <stdio.h>

/* global variables */
int i_am_a_global_variable = 999;

/* functions */

void another_function (int* a)
{
  (*a)++;
  i_am_a_global_variable += *a;
  return;
}

int some_function (int a)
{
  int some_local_var = a;
  printf("some_local_var has been changed to %d\n", some_local_var);
  another_function(&some_local_var);
  printf("some_local_var has been changed to %d\n", some_local_var);
  return 0;
}

int main (void)
{
  int number;
  printf ("enter number:");

  if (fscanf(stdin, "%d", &number) == 1) {
    some_function(number);
    printf("You’ve entered %d\n", number);
  } else {
    printf("No number entered. Bye.\n");
  }
  
  return 0;
}
```

斷點的定義是 **「在執行這一行之前先回到 debugger」** ，也就是說如果你把斷點設在第 12 行，那麼它會在執行第 12 行之前暫停程式執行，進入 debugger。

設斷點的方法很簡單，在行號上 **按一下滑鼠左鍵** 就行了。斷點可以移動，用滑鼠拖曳便是。斷點可以暫時取消，即是點一下讓它變成淺藍色。斷點可以刪除，只要把它 **拖曳出行號區** 就行了，就像 Dock 一樣直觀操作。

現在我把斷點設在 `some_function(number)` 這一行。

![Screen Shot 2013-12-01 at 17.01.39.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/vfg8tE4zQ7WLTmd5LaC9_Screen%20Shot%202013-12-01%20at%2017.01.39.png)

然後執行程式，先在 Console 裡輸入數字，再按下 **Enter** 輸入到程式裡。接著，程式會立刻暫停，你會看到程式碼裡面，標示了停在哪一行，而 Debug Area 左側還會出現目前存在的區域變數。Debug Area 有個工具列，上面有幾個重要的按鈕，用途如圖：

![Screen Shot 2013-12-01 at 17.03.13.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/XWNHYGL2QOoCWmgLaVvU_Screen%20Shot%202013-12-01%20at%2017.03.13.png)

這裡要先介紹通常 Debugger 會有的指令：

* **Continue （繼續）** ：離開 Debugger 繼續執行程式，可能會中斷在下一個斷點
* **Step Over （跳過）** ：跳過（執行）這一行，然後停在下一行
* **Step Into （跳入）** ：目前在的這一行有函式，跳進去
* **Step Out （跳出）** ：目前在的這一行是在某個函式裡面，跳出去到呼叫函式的程式（也就是 return 完畢）

熟悉這四個指令，你就可以在程式碼之間遊走了。

接著我再多設兩個斷點，分別在 `i_am_a_global_variable +=` 和 `another_function(&some_local_var);` 這兩行（不必先把程式停下來，直接按滑鼠左鍵加斷點）。然後按下 **Continue** ，當它執行到 `another_function` 這行之前，就會再停下來進入 Debugger 。

你會發現左邊也有變化，因為進入了 **Function Call 的 Stack** 。你可以在不同的 Stack 之間切換，左邊也會出現不同的 Local Variables，切換的方式是按下 Debugger 導覽列的 function name。

![Screen Shot 2013-12-01 at 17.22.23.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/KdsfA4OIR2ypOq0icUvz_Screen%20Shot%202013-12-01%20at%2017.22.23.png)

接著再按一下 **Continue**，會跑進 `another_function` 裡面，你會發現在左邊窗格會顯示傳進去的指標的記憶體位址和指標所指的記憶體內容，以及，因為這個 function 有參照 (reference) 到全域變數 `i_am_a_global_variable` ，所以 Xcode 也會自動列出：

![Screen Shot 2013-12-01 at 17.39.20.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/77lVASa8Qkuz5L0HFF7H_Screen%20Shot%202013-12-01%20at%2017.39.20.png)

再來一個小範例，這次是陣列：

```c
#include <stdio.h>

int main(void)
{
  int array[] = {1, 2, 3, 4, 5};
  int i;
  for (i = 0; i < 5; i++) {
    printf ("array #%d is %d\n", i, array[i]);
  }
  return 0;
}
```

斷點設在 printf 那一行，然後執行，你會發現它把陣列的內容也列出來了（按 ▼ 可以展開）：

![Screen Shot 2013-12-01 at 17.42.55.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/yjLIoJnRZyBaafGPSLsB_Screen%20Shot%202013-12-01%20at%2017.42.55.png)

那如果是動態產生的陣列呢？

我們知道 [malloc](http://www.cplusplus.com/reference/clibrary/cstdlib/malloc.html), [calloc](http://www.cplusplus.com/reference/clibrary/cstdlib/calloc.html), [realloc](http://www.cplusplus.com/reference/clibrary/cstdlib/realloc.html) 傳回來的是它所分配到的記憶體的開頭位址，那 Xcode 會不會很聰明的把它當作陣列呢？

我們把上面這段程式修改成 `calloc` 的方式：

```c
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
  int *array = (int *) calloc(5, sizeof(int));
  int i;
  for (i = 0; i < 5; i++) {
    array[i] = i + 1;
    printf ("array #%d is %d\n", i, array[i]);
  }
  free(array);
  return 0;
}
```

把斷點設在 `free(array)` 那一行，然後執行，你會發現 Debugger 並不會列出 array 的內容，而是只有指標：

![Screen Shot 2013-12-01 at 17.48.49.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/doMqxDEeQhWlg2qsvKPI_Screen%20Shot%202013-12-01%20at%2017.48.49.png)

從上圖我們知道兩件事：

1. `array` 宣告成 `int *`，所以 Xcode 抓的是它的記憶體位址。
2. 它用 `int` 去解讀 `*array` 指向的記憶體內容，所以得到的是首項的值 `1`，因為 array 的內容是 1, 2, 3, 4, 5。

那如果要看 `array[1]` 或其他內容的話怎麼辦呢？這時候就要用 Expression Monitor 了，可以在這個 variable 列表裡面按右鍵選 **Add Expresssion...** ，然後輸入 `array[1]` 就行了。另外，既然是 Expression ，當然可以輸入運算式，例如 `array[1] + 2` 。

![Screen Shot 2013-12-01 at 17.57.08.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/fkWkuuYTIetHNbUsvbc7_Screen%20Shot%202013-12-01%20at%2017.57.08.png)

---

Debugger 我會用的功能大概就這樣... 不過我覺得這樣也就夠了，用這些就足以抓出邏輯上的錯誤。

## 字型設定

我們每天看 code 的人，總是希望它們要長得順眼，才看得下去。Xcode 當然也可以調整字型。

進入 Xcode 的 Preferences 設定，在 Fonts & Colors 分頁裡面。不過每個項目是分開的，要一次改的話，是先按 <kbd>Command + A</kbd> 全選，然後按下 T 那個 icon ，就可以一次改全部了。附帶一提， Console 的字型是在同一個畫面的「Console」分頁裡面。

![Screen Shot 2013-12-01 at 18.18.32.png](http://user-image.logdown.io/user/2580/blog/2567/post/93598/aZSJS60pQsOMmAJqywGb_Screen%20Shot%202013-12-01%20at%2018.18.32.png)

再附帶一提，我用的字體是 Adobe 出的 [Source Code Pro](http://sourceforge.net/projects/sourcecodepro.adobe/) ，可以免費下載。

---

我會的大概也就這些，不知道算不算新手入門了... XD

---

## 更新記錄

* 2013/12/01 用 Xcode 5.0 重寫教學，並且移除原本關於「切換到 ANSI-C」的段落，因為試不出來。