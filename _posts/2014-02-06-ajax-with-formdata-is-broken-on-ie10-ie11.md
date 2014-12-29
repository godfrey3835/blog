---
layout: post
title: Ajax with FormData is Broken on IE10 / IE11 in Some Conditions
published: true
date: 2014-02-06 23:19
tags:
- Ajax
- IE
- IE10
- IE11
- XHR2
categories: []
comments: true

---
If you've ever implemenetd sending form with Ajax, then, in some conditions, the request will be corrupted and the server may not be able to parse the request.

For example, there is usually an "I Agree to Term of Service" check box at the end of a registration form. I've made a [jsbin](http://jsbin.com/muqem/latest) sample which sends request to [RequestBin](http://requestb.in/10voz8j1?inspect) so you can see the raw request without proxy software.

The form is simple, like this:

```html
<form id="regform" action="/users" method="post">
  Username:
  <input type="text" name="user[username]" value="johnappleseed">

  Password:
  <input type="password" name="user[password]" value="s3cr37">
  
  Password Again:
  <input type="password" name="user[password_confirmation]" value="s3cr37">
  
  <!-- This input is our topic. -->
  <input type="checkbox" name="user[accept_tos]" value="1">
  I agree to Term of Service
  
  <input type="submit" name="commit" value="Sign Up">
</form>
```

And replace the submission of that form by Ajax. Here I use [FormData](https://developer.mozilla.org/en-US/docs/Web/API/FormData) to build XHR payload from a form element (see also: [Using FormData Objects on MDN](https://developer.mozilla.org/en-US/docs/Web/Guide/Using_FormData_Objects)):

```js
var form = document.getElementById("regform");

$(form).on("submit", function(e) {
  e.preventDefault();

  $.ajax({
    url:         form.action,
    type:        form.method,
    data:        new FormData(form), // build payload from a Form element
    contentType: false,              // tell jQuery not to adjust content-type
    processData: false               // tell jQuery not to convert raw data to string
  });
});
```

Let's leave  "I Agree to Term of Service" unchecked and submit the form (via Ajax).

In Chrome and Firefox, the form submission will success, as expected. You can capture raw HTTP request by [mitmproxy](http://mitmproxy.org/) or [Fiddler](http://www.telerik.com/fiddler) on Windows. Here is the request body I got:

    ------WebKitFormBoundaryoiKOSCNarm2sYgDv
    Content-Disposition: form-data; name="user[username]"
    
    johnappleseed
    ------WebKitFormBoundaryoiKOSCNarm2sYgDv
    Content-Disposition: form-data; name="user[password]"
    
    s3cr37
    ------WebKitFormBoundaryoiKOSCNarm2sYgDv
    Content-Disposition: form-data; name="user[password_confirmation]"
    
    s3cr37
    ------WebKitFormBoundaryoiKOSCNarm2sYgDv--

However in IE10 and IE11, the request body will be corrupted and the submission will fail:

    -----------------------------7de3af25e0204
    Content-Disposition: form-data; name="username"
    
    johnappleseed
    -----------------------------7de3af25e0204
    Content-Disposition: form-data; name="password"
    
    s3cr37
    -----------------------------7de3af25e0204
    Content-Disposition: form-data; name="password_confirmation"
    
    s3cr37
    -----------------------------7de3af25e0204
    Content-Disposition: form-data; name="
    -----------------------------7de3af25e0204--

See that unfinished `name="`? That is not encoded properly, and makes some HTTP server apps hard to parse the payload and may throw errors. In [Rack](http://rack.github.io/) (HTTP server app protocol for Ruby,) it would [raise EOFError](https://github.com/rack/rack/blob/1.5.2/lib/rack/multipart/parser.rb#L117) and the client will get 500 Internal Server Error.

<!--more-->

Let's take another example. This time we have 3 radio buttons with a same name:

```html
<form id="theform" action="/people" method="post">
  Name: <input type="text" name="person[name]" value="John Appleseed">

  <input type="radio" name="person[sex]" value="male"> Male
  <input type="radio" name="person[sex]" value="female"> Female
  <input type="radio" name="person[sex]" value="not_specified"> (Not Specified)

  <input type="submit" name="commit" value="Create Person">
</form>
```

Now check "Male" and press Submit.

In Chrome and Firefox, the form submission will success, and the request body is:

    ------WebKitFormBoundaryoiKOSCNarm2sYgDv
    Content-Disposition: form-data; name="person[name]"
    
    John Appleseed
    ------WebKitFormBoundaryoiKOSCNarm2sYgDv
    Content-Disposition: form-data; name="person[sex]"
    
    male
    ------WebKitFormBoundaryoiKOSCNarm2sYgDv--


But in IE10 and IE11, the request body will be corrupted.

    -----------------------------7de3598e0204
    Content-Disposition: form-data; name="person[name]"
    
    John Appleseed
    -----------------------------7de3598e0204
    Content-Disposition: form-data; name="person[sex]"
    
    male
    -----------------------------7de3598e0204
    Content-Disposition: form-data; name="
    -----------------------------7de3598e0204--

Now, if you refresh the page and does not check any option, press Submit, you'll see again the same corrupted request body.

    -----------------------------7de2a834e0204
    Content-Disposition: form-data; name="person[name]"
    
    John Appleseed
    -----------------------------7de2a834e0204
    Content-Disposition: form-data; name="
    -----------------------------7de2a834e0204--

Now check "Not Specified" and do the experiment again, this time the request is successfully sent.

    -----------------------------7de3a52ae0204
    Content-Disposition: form-data; name="person[name]"
    
    John Appleseed
    -----------------------------7de3a52ae0204
    Content-Disposition: form-data; name="person[sex]"
    
    not_specified
    -----------------------------7de3a52ae0204--

The issue is: if the *last* checkable input is not checked, then the request body will be corrupted.

What about check boxes? Unfortunately, you can still reproduce this behavior with check boxes.

And what about checkable inputs with different names? Yes, reproduceable.

BTW this is not a jQuery bug. It can be reproduced without jQuery, i.e. `new XMLHttpRequest()` to send the form with Ajax.

## Minimal Reproduceable Case

The minimal test case is:

* Have a checkable input (radio / check box) as the last input of the form.
* That input is not checked.
* Submit the form by Ajax with XHR2 + FormData.

I hit this issue when I'm building a form that will be sent via Ajax, with a file upload input ─ so multipart will be used, and FormData is useful, ─ therefore I *have to* use XHR2 + FormData to send requests, rather than converting it to URL-encoded query string.

## Workarounds

Since this issue only happens when **the last input is a checkable input and is not checked**, adding another hidden input that has arbitrary name is a workaround:

```html
  <input type="checkbox" name="user[accept_tos]" value="1">
  I agree to Term of Service

  <!-- Workaround to avoid corrupted XHR2 request body in IE10 / IE11 -->
  <input type="hidden" name="_dontcare">

  <input type="submit" name="commit" value="Sign Up">
```

For the Create Person example:

```html
  <input type="checkbox" name="person[sex]" value="male"> Male
  <input type="checkbox" name="person[sex]" value="female"> Female
  <input type="checkbox" name="person[sex]" value="not_specified"> (Not Specified)

  <!-- Workaround to avoid corrupted XHR2 request body in IE10 / IE11 -->
  <input type="hidden" name="_dontcare">

  <input type="submit" name="commit" value="Create Person">
```

Now the XHR in IE10 / IE11 works, but payload will contain `_dontcare=<nothing>`, just ignore it.

## Notes

The issue still exist if you use `<button>` as a submit button instead of `<input type="submit">`.

The issue does not exist if you don't send the form via Ajax, even if the form element has `enctype="multipart/form-data` set.

Tested on IE10 and IE11 in virtual machines provided by [ModernIE](http://modern.ie).

I have opened a new issue on Microsoft's [Internet Explorer Feedback](https://connect.microsoft.com/IE/feedback/details/817001/ajax-with-formdata-api-will-send-corrupted-request-body-if-the-last-input-is-checkable-and-is-not-checked).