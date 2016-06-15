---
layout: post
title: Solution to “VirtualBox can't operate in VMX root mode” error in Windows 7
published: true
date: 2010-12-26 00:00
tags: []
categories: []
redirect_from: /posts/2010/12/26/vbox-vmx-win7
comments: true

---

I was trying out various virtualization solutions on Windows 7, including <a href="http://www.microsoft.com/windows/virtual-pc/" target="_blank">Microsoft Virtual PC</a> and <a href="http://virtualbox.org" target="_blank">VirtualBox</a>.  I booted a VM in Virtual PC and felt that it wasn't good enough, so later I installed VirtualBox.  But when I was about to launch the VM, I saw this error message:


> VirtualBox can't operate in VMX root mode.
>
> VBox status code: -4011 (VERR_VMX_IN_VMX_ROOT_MODE).

The reason is that there was still a Virtual PC host instance in my memory, which occupied the CPU's VT-X resources.  The trivial solution is to have the Windows host a restart, but since I didn't wanna close my other applications, I did some Google-ing for solutions and only found ones for Linux hosts.  Nobody has a solution for Windows 7 with Virtual PC.

After that I searched for some Virtual PC-related keywords in Services and Task Manager, and found that the resource owner is the process named `vpc.exe` .  Killing this process solves this problem, and no restart is needed.

By the way, VirtualBox runs Windows XP <del>twice as</del> fast than Virtual PC does.
