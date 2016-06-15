---
layout: post
title: "[作品] 中華民國身份證字號驗證程式 - 使用 jQuery.Validate"
published: true
date: 2009-02-03 00:00
tags: []
categories: []
redirect_from: /posts/2009/02/03/jquery-validate-roc-citizen-id
comments: true

---

最近在研究 <a href="http://docs.jquery.com/Plugins/Validation">jQuery.Validate</a>，這是可以讓你做出「表單還沒送出前就先驗證資料是否正確」效果的 Plug-in，如果網站的 JavaScript 已經採用 <a href="http://jquery.com">jQuery</a> 當作 Library 的話，那麼直接導入 jQuery.Validate 是比較容易的。類似的 Library 如 <a href="http://www.livevalidation.com/">LiveValidation</a>。

<a href="http://www.yorkxin.org/work:jquery-validate-roc-citizen-id">示範網頁在這裡</a>；因為 WordPress 不讓我放 Embedded Javascript，所以就到另一個網頁看吧。

做法很簡單：先導入 jQuery.Validate，然後針對要輸入身份證字號的地方，撰寫兩個自定的 Validate 條件，一個是檢驗它是否符合 <code>/^[A-Z]{1}[1-2]{1}[0-9]{8}$/</code> 的 Regular Expression，另一個是<a href="http://my.so-net.net.tw/idealist/Other/SSN.html">透過算數方式檢查</a>它是否符合邏輯。

<!--more-->

首先導入 jQuery 及 jQuery.Validate，這個應該不用多說：

[sourcecode language="html"]<br />
  &lt;script type=&quot;text/javascript&quot; src=&quot;/path/to/jquery.js&quot;&gt;&lt;/script&gt;<br />
  &lt;script type=&quot;text/javascript&quot; src=&quot;/path/to/jquery.validate.js&quot;&gt;&lt;/script&gt;<br />
[/sourcecode]

以下是一個範例的表單，表單的 <code>id</code> 不能省略，<code>input</code> 的 <code>id</code> 也不能省略：

[sourcecode language="html"]<br />
  &lt;form id=&quot;citizenid_validation&quot; action=&quot;some_action.php&quot; method=&quot;get&quot;&gt;<br />
    &lt;input type=&quot;text&quot; name=&quot;citizenid&quot; value=&quot;&quot; id=&quot;citizenid&quot;&gt;<br />
  &lt;/form&gt;<br />
[/sourcecode]

接著在 JavaScript 裡定義兩個驗證方案，一個是驗證它是否符合<code>/^[A-Z]{1}[1-2]{1}[0-9]{8}$/</code> 的 Regular Expression：

[sourcecode language="javascript"]<br />
  $(document).ready (function () {<br />
    /* user_citizenid regex method */

    jQuery.validator.addMethod(&quot;ROC_Citizen_ID_regex&quot;,

      function(citizenid, element) {<br />
        citizenid = citizenid.replace(/\s+/g, &quot;&quot;);

        return (<br />
            this.optional(element) ||<br />
            /^[A-Z]{1}[1-2]{1}[0-9]{8}$/.test(citizenid)<br />
          );<br />
      }, &quot;格式有誤&quot;<br />
    );<br />
  });<br />
[/sourcecode]

另一個是以算數方式檢驗：

[sourcecode language="javascript"]<br />
  $(document).ready (function () {<br />
    jQuery.validator.addMethod(&quot;ROC_Citizen_ID_arithmetic&quot;,<br />
      function(citizenid, element) {

          var local_table = [10,11,12,13,14,15,16,17,34,18,19,20,21,<br />
                             22,35,23,24,25,26,27,28,29,32,30,31,33];<br />
                         /* A, B, C, D, E, F, G, H, I, J, K, L, M,<br />
                            N, O, P, Q, R, S, T, U, V, W, X, Y, Z */

        var local_digit = local_table[citizenid.charCodeAt(0)-'A'.charCodeAt(0)];

        var checksum = 0;

        checksum += Math.floor(local_digit / 10);<br />
        checksum += (local_digit % 10) * 9;

        /* i: index; p: permission value */<br />
        /* this loop sums from [1] to [8] */<br />
        /* permission value decreases */

        for (var i=1, p=8; i &lt;= 8; i++, p--)<br />
        {<br />
          checksum += parseInt(citizenid.charAt(i)) * p;<br />
        }

        checksum += parseInt(citizenid.charAt(9));    /* add the last number */

        return (<br />
            this.optional(element) || !(checksum % 10)<br />
          );<br />
      }, &quot;似乎偽造&quot;<br />
    );<br />
  });<br />
[/sourcecode]

最後，把 jQuery.Validate 的規則綁定到表單元件 (form element) 就行了：

[sourcecode language="javascript"]<br />
  $(document).ready(function () {<br />
    $(&quot;#citizenid_validation&quot;).validate ({<br />
      success: function(label) {<br />
        label.text(&quot;正確&quot;)<br />
      },<br />
      rules: {<br />
        citizenid: {<br />
          required: true,<br />
          ROC_Citizen_ID_regex: true,<br />
          ROC_Citizen_ID_arithmetic: true<br />
        }<br />
      }<br />
    });<br />
  });<br />
[/sourcecode]

當然這三件事可以放在同一個 <code>$(document).ready( function () {/*裡面*/})</code>。

---

by the way, 事實上「<a href="http://www.cis.nctu.edu.tw/~is86007/magicshop/ROCid.html">身份證字號產生器</a>」是很好寫的，反正前 9 個字可以隨便寫，透過算數方法就可以算出最後一個數字是多少。不信的話，你把前面 9 個字隨便亂填，第 10 個字從 0 到 9 都試試看，一定有一個是正確的...

<span style="color:#ff0000;"><strong>警告</strong>：<span style="color:#000000;">本文描述內容僅為學術研究用途，</span>使用非本人的身份證字號</span><a href="http://tinyurl.com/yka85s2"><span style="color:#ff0000;">是犯法的</span></a><span style="color:#ff0000;">！</span>
