---
layout: post
title: In iOS Safari, a Universal :hover Selector with Search Input Forces Every Link
  to Require Double-Tap to Navigate
published: true
date: 2013-07-03 22:55
tags:
- css
- iOS
- Safari
- web development
categories: []
comments: true

---


When designing a website for mobile devices, be careful about universal `*:hover`, because it may hurt your iPhone / iPad visitors.

## The Issue

Consider a situation that both of the following conditions exist:

First, the CSS comes with a selector which contains a universal `:hover` selector. For example:

```css
.something :hover {
}
```

Or not combined with other selector, just the universal part:

```css
*:hover {
}
```

Second, the HTML contains a search input box:

```html
<input type="search" />
```

Then, when visiting the page with iOS Safari:

* Every link needs double-tap to navigate instead of single-tap.
* Tap once, the link switches to hover state.
* Tap the same link again, the browser navigates to the target URL.

**See Demo**: [http://cdpn.io/mpBrw](http://cdpn.io/mpBrw) (open with iOS Safari)

**Tested on**: iPhone 5 with iOS 6.1.4 and iPad 3 with iOS 6.1.3.

**Note**: In the first exmaple of CSS selector, no matter whether `.something` matches any element or not, this bug will be triggered (i.e. this bug also happens when `<div class="something">` does not exist).

## Solution

Make `:hover` more specific, and never use `*:hover`. For example:

```css
.link:hover {}
```

For those who are curious about how I get this solution and things about the spec, please read on.

<!-- more -->

## Background

I found this issue when applying a new template to a website. When I was testing it on iPhone Safari, I found some links need to tap twice to navigate.

At first I think there were some CSS that triggers content change so the browser did not fire simulated `click` event (as [Apple's document said](http://developer.apple.com/library/safari/#documentation/AppleApplications/Reference/SafariWebContent/HandlingEvents/HandlingEvents.html#//apple_ref/doc/uid/TP40006511-SW7)), but by inspecting the CSS I couldn't find any layout changes in the element I tapped. Then I tried to find a minimal case by removing JavaScript, HTML classes on some tags, and even some elements. The only one HTML segment that switches this issue is a search box with `type="search"` attribute. By removing this search box, the bug disappeared.

Then I Google'd for a while and found a Chromium bug saying that "[moving mouse into the window triggers layout on placeholder text in the input](https://code.google.com/p/chromium/issues/detail?id=246601)". I fired up Timeline and found that it did trigger layout. I wasn't sure if this is the reason of the double-tap bug, so I took an experiment:

<table>
  <tr>
    <th></th>
    <th>input type="text"</th>
    <th>input type="search"</th>
  </tr>

  <tr>
    <th>With Placeholder</th>
    <td>OK</td>
    <td>Buggy</td>
  </tr>

  <tr>
    <th>Without Placeholder</th>
    <td>OK</td>
    <td>Buggy</td>
  </tr>
</table>

That is, a search input triggers the double-tap bug, but a normal text input does not, no matter whether the placeholder attribute is present or not.

AFAIK, there are [some pseudo elements](http://css-tricks.com/webkit-html5-search-inputs/) in a search input, for example, the drop-down button, and the cancel button. I tried to hide them by setting `display: none` one by one, and finally I found that when hiding the cancel button, the double-tap bug is not triggered:

```css
/* Don't use this in production */
input[type=search]::-webkit-search-cancel-button {
  display: none;
}
```

But no, I don't wanna hide the cancel button. It's a feature, and there should not be any workaround depending on it.

I got no idea. I then tried removing some CSS from the assets package one by one, and I found that when a specific file is removed, the bug is not triggered. I took a look into that file (originally written in SCSS), and there was a strange selector:

```scss
.link {
  :hover {
    // color changes..
  }
}
```

Which compiles to:

```css
.link :hover {}
```

By removing the `:hover` selector, the bug is not triggered, even without the hack on search input's cancel button.

So how can we fix it? In SCSS, to be more specific, it should be sticked with the parent selector, e.g.:

```scss
.link {
  &:hover {
    // color changes..
  }
}
```

which compiles to:

```css
.link:hover {}
```

## The Spec Says

The [W3C CSS Validator](http://jigsaw.w3.org/css-validator/) does not raise any warning when there is a standalone `:hover` selector, so it should be syntactically correct. I then looked up the [CSS3 Selector Spec](http://www.w3.org/TR/css3-selectors) and the only thing I can understand is that `:hover` and `*:hover` are equivalent:

> ### 6.2. [Universal selector](http://www.w3.org/TR/css3-selectors/#universal-selector)
>
> If a universal selector represented by `*` (i.e. without a namespace prefix) is not the only component of a sequence of simple selectors selectors or is immediately followed by a pseudo-element, then the `*` may be omitted and the universal selector's presence implied.

And:

> ### 6.6. [Pseudo-classes](http://www.w3.org/TR/css3-selectors/#pseudo-classes)
>
> [...]
>
> Pseudo-classes are allowed in all sequences of simple selectors contained in a selector. Pseudo-classes are allowed anywhere in sequences of simple selectors, after the leading type selector or universal selector (possibly omitted). [...]


That is, these two selectors are equivalent and will trigger the double-tap bug on iOS Safari:

```css
.something :hover {}
```

```css
.something *:hover {}
```

## Closing Up

Is this a WebKit bug? Or should programmers be careful about the selector syntax? I don't know. I can't find such bug with relevant keywords `%w(universal hover search)` in WebKit or Chromium's bug tracker.

If you're having such issue, you can check if there is any universal `:hover` selector in your CSS.

## References

* [Safari Web Content Guide: Handling Events - Apple Developer](http://developer.apple.com/library/safari/#documentation/AppleApplications/Reference/SafariWebContent/HandlingEvents/HandlingEvents.html#//apple_ref/doc/uid/TP40006511-SW7)
* [How Mobile Safari emulates mouse events - Jesse Hallett](http://sitr.us/2011/07/28/how-mobile-safari-emulates-mouse-events.html)
* [Selectors Level 3 - W3C](http://www.w3.org/TR/css3-selectors/)
