---
layout: post
title: "解決 Boot Camp for Windows 不支援藍芽耳機的方法"
published: true
date: 2011-08-07 00:00
tags:
- mac
- Bluetooth
- windows
categories: []
redirect_from: /posts/2011/08/07/bootcamp-windows-bluetooth-headset
comments: true

---

為了打 Skype （註） ，去買了一支智慧型手機用的藍芽耳機。 在 Mac OS X (10.6.8) 可以正常使用，但 Windows 7 卻不行，配對成功後還叫我安裝驅動程式，自動搜尋卻說找不到，要我自己安裝。

怎麼可以這樣呢？ Windows 7 可是（真） 21 世紀的作業系統耶 QQ

在 Google 了兩個小時以後才發現殘酷的事實：Windows 7 （內建的 Bluetooth 服務）不支援藍芽耳機！這種藍芽耳機所使用的 Bluetooth Profile 是 Hands-Free Profile (HFP) 或 Headset Profile (HSP) ，剛好 Windows 7 內建的 Bluetooth Stack 都不支援，連 A2DP 也不支援。崩潰。（有<a title="Bluetooth Wireless Technology FAQ - 2010" href="http://msdn.microsoft.com/en-us/windows/hardware/gg487349" target="_blank">文件</a>為證）

<!--more-->

在 Wikipedia 的 <a href="http://en.wikipedia.org/wiki/Bluetooth_stack" target="_blank">Bluetooth stack</a> 這條目中，說明了主要廠商的 implementation 及支援程度，很悲慘的是 Windows 7 在 RC 的時候突然就不支援了。而 Broadcom 的 Widcomm 有支援。我想說既然 MacBook Pro 的藍芽晶片是 Broadcom 的，那<a href="http://www.broadcom.com/support/bluetooth/update.php" target="_blank">去他們網站下載</a>總行了吧？沒想到它搜尋了半天竟然不給安裝，估計是晶片的設備廠商設為 Apple 所以被無視了。

接著不知道怎麼 Google 到一個<a href="http://superuser.com/questions/212579/broadcom-bluetooth-driver-for-windows-7-on-macbook-pro" target="_blank">奇招</a>，就是去 <a href="http://www.acer.com.tw/ac/zh/TW/content/drivers" target="_blank">Acer 的網站</a>下載 Aspire 5740 ZG 的 Bluetooth 驅動程式，安裝完成後 HFP 和 HSP 就可以使用了，甚至還可以騙到 Broadcom 官方的安裝程式，我就這樣升級了驅動程式。重新開機之後，連裝置管理員裡面的 Bluetooth Host Device 也變成 Broadcom 了。

當然，Skype 語音測試也沒問題。

不過我覺得這實在不是什麼好方法。 Windows 什麼時候才會內建 HFP / HSP / A2DP 的支援呢？

---

註：因為麥克風內建在電腦裡面，每次用 Skype 打市話，都要對著電腦大喊，喇叭的回音也讓對方很困擾，我則是對於噴在電腦上的口水很困擾。有陣子為了養喉嚨（？）所以都用手機打市話，當月帳單就爆了好幾百塊。只好狠下心去買了一支 Motorola H390 。

但如果跟藍芽滑鼠一起開的話，滑鼠就會 lag ，不管在 Mac OS X 還是 Windows 都會這樣，Google 了半天也是無解。Apple 的更新檔只適用於他們家的 Mighty Mouse 。暫時先忍著，反正打 Skype 也就幾分鐘而已。
