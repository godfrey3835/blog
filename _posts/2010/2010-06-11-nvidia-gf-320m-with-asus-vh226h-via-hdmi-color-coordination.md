---
layout: post
title: nVidia GeForce 320M + ASUS VH226H via HDMI 的色彩調整
published: true
date: 2010-06-11 00:00
tags: []
categories: []
redirect_from: /posts/2010/06/11/nvidia-gf-320m-with-asus-vh226h-via-hdmi-color-coordination
comments: true

---

因為（中略千萬字），所以現在螢幕是透過 HDMI 接 VH226H，顯示晶片是 nVidia GeForce 320M。

在 Mac OS X 那邊，透過色彩校正就可以得到不錯的效果了，可是在 Windows 這裡，即使把同樣的 ICC 設定檔複製過來，還是會發現螢幕有點過亮，如果要說是甚麼感覺，大概就是隔一層很髒的玻璃吧。

踹了好久終於找到解決方法了：

桌面上點「NVIDIA 控制面板」，選擇「顯示→調整桌面色彩設定」，右邊的 3. 套用以下的增強，把「數位色彩格式」從 RGB 改成 YCbCr444，按下「套用」，and voila，髒髒玻璃不見了！

<a href="http://chitsaou.files.wordpress.com/2010/06/e89ea2e5b995e68a93e59c96-2010-06-11-01-15-41.png"><img class="alignnone size-full wp-image-1021" title="nVidia Control Panel / Display Color" src="http://chitsaou.files.wordpress.com/2010/06/e89ea2e5b995e68a93e59c96-2010-06-11-01-15-41.png" alt="" width="630" height="542" /></a>

附帶一提，原本 Windows 的音訊輸出設備裡面沒有 HDMI Audio Output，在上述控制面板的「變更解析度」中，先把音效輸出關掉，再開起來，就有了耶~~

---

至於那個中略千萬言的故事，待我日後娓娓道來…。
