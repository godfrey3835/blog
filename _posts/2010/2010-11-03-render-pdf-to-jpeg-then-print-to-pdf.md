---
layout: post
title: "把 PDF 算圖成 JPEG 再拼成 PDF 的 Shell Script 工序指令"
published: true
date: 2010-11-03 00:00
tags: []
categories: []
redirect_from: /posts/2010/11/03/render-pdf-to-jpeg-then-print-to-pdf
comments: true

---

因為有某個需要所以做了這樣的工序指令。它會把 PDF 先算圖成 JPEG，放在一個暫存資料夾，再把資料夾裡面的 JPEG 拼接成 PDF，最後刪除暫存資料夾。

這支工序指令需要 <a href="http://www.imagemagick.org/">ImageMagick</a> 的 <code>convert</code> 程式才能動。Unix-like OS 怎麼裝我就不說了，在 Windows 應該也可以用同樣的方法做出 .BAT 的巨集。

原本打算算圖成 PNG 的，但是發現出來的圖檔比 JPEG 在容量上大很多，而且算圖時間也比 JPEG 多了好幾倍。有興趣的話，你可以把程式碼中有標記的那兩行改成 PNG 來實驗看。

這程式我想應該還有值得改善的地方，也請路過的前輩提出改進建議吧！

至於為甚麼不用 OS X 的機器人呢？因為它太慢了，而且不能拿到 Linux 上面用<del>，更重要的是身為宅宅一定要寫點程式的</del>。

[sourcecode language="bash"]<br />
#!/bin/sh<br />
# (c) 2010 Yu-Cheng Chuang &lt;ducksteven@gmail.com&gt;.  Licensed under GNU/GPL v2.<br />
if [[ $# -le 0 ]]; then<br />
  echo &quot;usage: $0 [files]&quot;<br />
  exit 1<br />
fi<br />
echo &quot;$# Files to convert&quot;<br />
for i in $@; do<br />
    folder=`echo &quot;$i&quot; | sed &quot;s/\.pdf$//g&quot;`<br />
    echo &quot;$folder&quot;<br />
    mkdir $folder

    echo &quot;Phase 1: Render PDF pages to JPEG images...&quot;<br />
    # change .jpg to .png to render pages to PNG images<br />
    # you can also specify -quality &lt;1..100&gt; option for image compression quality<br />
    convert -density 150 $i $folder/$i.jpg

    echo &quot;Phase 2: Print images into PDF&quot;<br />
    # if you have changed the intermediate file extension above,<br />
    # you need to change the extension here, too.<br />
    convert -page A4 $folder/\*.jpg scanned/$folder.pdf

    rm -rf $folder/<br />
done<br />
[/sourcecode] 
