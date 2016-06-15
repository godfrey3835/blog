---
layout: post
title: Microsoft Sculpt Mobile Mouse and Mac
published: true
date: 2014-04-12 22:13
tags:
- mac
- Microsoft
- mouse
categories: []
redirect_from: /posts/2014/04/12/microsoft-sculpt-mobile-mouse-and-mac
comments: true

---
*tl;dr:* Everything works properly, except the Windows Button. But you can remap it to Mouse Button 4 using KeyRemap4MacBook.

I just got a new mouse: [Microsoft Sculpt Mobile Mouse](http://www.microsoft.com/hardware/en-us/p/sculpt-mobile-mouse/43U-00001). And because I only use Mac OS X, I didn't expect that all the features are available on OS X. The reason I choose Microsoft's mouse over Logitech's is because that many people reported that horizontal scrolling, or "spin", is *not working at all* on OS X.

Here is the test result for those who want to get one but don't know whether it works on your Mac.

<!--more-->

## Horizontal Scrolling (Tilt Button)

Works out-of-the-box. But don't expect that it is as smooth as built-in Trackpad or the Magic Mouse.

## Windows Button

Does not work properly. It is not recognized as Mouse button 4, but it can be remapped by [KeyRemap4MacBook](https://pqrs.org/macosx/keyremap4macbook/index.html.en).

Interestingly, if you use an app that can inspect keyboard inputs, the Windows button actually sends Command key to OS X, which is equivalent to Windows key on Windows. That's why it is possible to open Start Menu on Windows 7 without any driver.

Here is the log when I record events in EventViewer of KeyRemap4MacBook. The operations are:

1. Click and hold Windows button - it is recognized as <kbd>Command_R</kbd> with `Cmd` flag.
2. Release Windows button - it is recognized as <kbd>Command_R</kbd> but no `Cmd` flag (key up?)
3. Click and hold Windows button and press <kbd>i</kbd> on the keyboard - it sends <kbd>Cmd+i</kbd>

And it actually works like a Command key: if you select a Finder item and try step 3, it will open "Info" window, just like pressing <kbd>Cmd+i</kbd> on keyboard.

![Screen Shot 2014-04-12 at 21.52.18.png](http://user-image.logdown.io/user/2580/blog/2567/post/193424/uiTc2ucRReyfs9pyjwbh_Screen%20Shot%202014-04-12%20at%2021.52.18.png)

## Disabling the Windows Button

If you don't want it work anymore, you can disable that button in Keyboard system preferences. The downside is that, if you have a Microsoft keyboard connecting to that receiver, then your Windows key on that keyboard will be disabled too. (I don't have one so I don't care about that)

![Screen Shot 2014-04-12 at 21.59.29.png](http://user-image.logdown.io/user/2580/blog/2567/post/193424/vC7Ymg9RiGIeUWoZmpBv_Screen%20Shot%202014-04-12%20at%2021.59.29.png)

## Remapping the Windows Button

Because the Windows button simply sends <kbd>Command_R</kbd>, to remap that button without affecting the actual Right Command from keyboard, the remapping must be assigned solely to the mouse. Fortunately it is possible to do this with KeyRemap4MacBook. After read [the document of private.xml](https://pqrs.org/macosx/keyremap4macbook/xml.html.en) I figured out how to remap the Windows button to Mouse button 4:

```xml
<?xml version="1.0"?>
<root>
  <deviceproductdef>
    <productname>SCULPT_MOBILE</productname>
    <productid>0x07b2</productid>
  </deviceproductdef>

  <item>
    <name>Windows Button to Mouse Button 4 (Microsoft Sculpt Mobile Mouse)</name>
    <identifier>com.microsoft.mouse.sculpt_mobile.win_button</identifier>
    <device_only>DeviceVendor::MICROSOFT,DeviceProduct::SCULPT_MOBILE</device_only>
    <autogen>
      __KeyToKey__
      KeyCode::COMMAND_R,
      KeyCode::VK_MOUSEKEY_BUTTON_BUTTON4
    </autogen>
  </item>
</root>
```

Now you can assign Mouse Button 4 to whatever you want! (for example, Exposé)

Again, if you've also connected a Microsoft keyboard with the same receiver, your right Command will be overridden to Mouse Button 4.

## IntelliPoint (The Driver)

I downloaded 8.2.0 (v305) from Microsoft's website. Unfortunately the mouse is not recognized by IntelliPoint, and I cannot map any button to whatever I want.

BTW I tried Windows version too, and it is also not possible to remap the Windows button.

![Screen Shot 2014-04-12 at 22.02.10.png](http://user-image.logdown.io/user/2580/blog/2567/post/193424/QJ7CNkJsQOu9HOBnFSe5_Screen%20Shot%202014-04-12%20at%2022.02.10.png)

Note: it seems that there is a bug in IntelliPoint for Mac: the remapping is not activated immediately after boot, until Microsoft Mouse system preferences is opened. [There is a workaround for that](https://discussions.apple.com/message/23562699#23562699).

## Conclusion

Since there is a way to use Windows button on OS X, I'll use it.
