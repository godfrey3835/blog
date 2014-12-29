---
layout: post
title: Off-Screen Flash Breaks Text Cursors on Internet Explorer 9 - Solution
published: true
date: 2012-10-25 23:27
tags:
- Flash
- web development
- IE
categories: []
comments: true

---


I'm recently working on an issue about embedded Flash video on Internet Explorer 9.

When you have an embedded Flash movie, text cursors in text inputs (e.g. `textarea` and `input[type=text]`) may be out of user's control, if the Flash is out of the screen, and the embedded code uses `wmode=transparent` or `wmode=opaque`.

I've put [reduced code here](http://jsfiddle.net/U8C4D/7/). If you scroll down until the Flash is out of the screen, and try to set text cursor by mouse click or keyboard arrows, the first time it is moved, but if you continue pressing arrow keys or clicking, the cursor seems not moving. A typical use case is, when you're typing in the text box, and try to move cursor by arrow keys, then you'll see that the cursor does not move. 

Actually the cursor **does** move, but does not visually move to the new position; you're still seeing it at the old position. The cursor stops blinking, and may or may not be visible. If you then start typing something, the new characters will be inserted at the "new position".

It can be reproduced on Windows 7 Internet Explorer 9. I cannot reproduce this on Windows 7 IE8. Clearly it is an IE9 bug.

I never learned Flash, so the first thing I could do was asking Google. [Some](http://www.codingforums.com/archive/index.php/t-139233.html) [people](http://forums.adobe.com/message/2689460) [did asked](http://www.winvistatips.com/rapid-beam-movements-html-textbox-t817450.html) [questions](http://answers.microsoft.com/en-us/ie/forum/ie9-windows_7/shockwave-flash-object-add-on-breaks-text-cursor/ac031a2e-426d-4274-9df5-11d3ad09452e) about this; there was even a [reduced test page](http://estrip.org/articles/read/paul/55536/Why_i_hate_IE_IE_flash_offscreen_wmode_transparent_cursor_bug.html). But no solution or workaround was provided.

<!-- more -->

## `wmode=transparent` Causes this, but It's Necessary

I then learned that `wmode=transparent` is necessary to avoid embedded plugins being stuck at the top layer ([source (Adobe)](http://helpx.adobe.com/x-productkb/multi/swf-file-ignores-stacking-order.html
)). By default `wmode` is set to `window`, which means it works as a standalone window, not really embedded in your content.

For example if you want to overlap elements on Flash videos, without `wmode=transparent`, those Flash videos will overlap them, no matter how high the `z-index` of your elements are. Therefore, it cannot be avoid to use `wmode=transparent`.

## Solution: An Always-Visible Flash

Then an idea came to my mind: if the cursor is out of control only when the Flash is not visible, then making a **always-visible Flash** may "solve" the problem.

And the answer is **YES**, it solves the problem. Here is how I did it:

First, you need [swfmill](http://swfmill.org), a tool to make simple Flash movie with XML. On OS X, you can install it with Homebrew:

    $ brew install freetype libpng # dependencies
    $ brew link freetype
    $ brew install swfmill

Create a file with the following content (code modified from [swfmill's doc](http://swfmill.org/doc/using-swfmill.html)):

```xml 1px.xml
<?xml version="1.0" encoding="utf-8" ?>
<movie width="1" height="1" framerate="12">
  <background color="#ffffff"/><!-- or a color matching your background color -->
  <frame/>
</movie>
```

Convert it to Flash video (SWF):

    $ swfmill simple 1px.xml 1px.swf

Then embed it when the client is IE9, by conditional comment:

```html
<!--[if IE 9]>
<object width="1" height="1" data="http://url/to/1px.swf" type="application/x-shockwave-flash" style="position: fixed; bottom: 0; left: 0;">
  <param name="wmode" value="transparent" />
</object>
<![endif]-->
```

This will put an 1px by 1px `<object>` element at the bottom-left corner of the window, which means it is always visible.

Now all the text inputs should function normally. Problem solved. At least for websites I'm working with.

---

I've fought against this issue for 2 days. I've tried alternating HTML tree, disabling JavaScript / CSS, and even inspected other websites containing Flash video, to find a minimal case for reproduction, until I noticed that it is related to the visibility of Flash video.

I Google'd this for 2 days and found no solution or workaround. So I put it down here. It worked for me, so if you're encountering the same issue, try this solution.

---

**Update**: I've [reported this issue](http://connect.microsoft.com/IE/feedback/details/770989/off-screen-flash-breaks-text-cursors-windows-7) to Microsoft, and they said they're not going to fix this issue now, but will fix it in the future. I think it's because they're busy on other critical bugs in IE10 for Windows 7. Actually I also found this issue on IE10 Release Preview for Windows 7. However there is no way to specify [conditional comment](http://msdn.microsoft.com/en-us/library/ie/hh801214.aspx) in IE10 ([some hacks available](http://www.impressivewebs.com/ie10-css-hacks/)). For now IE10 for Windows 7 is not released yet; once it's released I'll try to find a workaround for it and update my post.
