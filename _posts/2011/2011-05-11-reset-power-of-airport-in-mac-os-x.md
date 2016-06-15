---
layout: post
title: Mac OS X 重開 AirPort 的指令
published: true
date: 2011-05-11 00:00
tags: []
categories: []
redirect_from: /posts/2011/05/11/reset-power-of-airport-in-mac-os-x
comments: true

---

以下適用於 Mac OS X 10.6，其他版本沒試過。

先執行

<code>/usr/sbin/networksetup -listallhardwareports</code>

看看你的 AirPort 的 Device 是哪一個，例如 <code>en1</code> 。

然後執行以下指令（<code>en1</code> 要換成你的 device name）

<code>/usr/sbin/networksetup -setairportpower en1 off<br />
/usr/sbin/networksetup -setairportpower en1 on</code>

要包成服務的話，就打開 Automator，在程式庫找到「系統工具」裡的「執行 Shell 工序指令」，把上面的指令貼進去，儲存成服務，取個你喜歡的名字，收工。

為什麼要做這種服務呢？因為師大分部的無線網路常常斷線，我常常要關掉 AirPort 再打開，煩死了，所以乾脆去<a href="http://macstuff.beachdogs.org/blog/?p=44" target="_blank">找指令</a>並且用 Automator 做成服務，再設個快速鍵，一鍵搞定。

<strong>Update:</strong>

雖然有這種指令：
<code>/usr/sbin/networksetup -setnetworkserviceenabled "Airport" off<br />
/usr/sbin/networksetup -setnetworkserviceenabled "Airport" on</code>

但是發現這樣子會 session timeout，需要再重連到某個 AP ，並再度登入。而分部的 WiFi 要連上得等很久，所以不合用。FYI。
