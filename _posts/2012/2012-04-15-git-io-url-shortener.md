---
layout: post
title: Git.io URL Shortener (Chrome Extension)
published: true
date: 2012-04-15 15:27
tags:
- github
- chrome
categories: []
redirect_from: /posts/2012/04/15/git-io-url-shortener
comments: true

---


GitHub has its official URL Shortening service, [GIt.io](http://git.io/help).  You can generate a shortened URL of a GitHub URL by sending an HTTP POST request to its API endpint, for example, through the command line:

    $ curl -i http://git.io -F "url=http://github.com/..."

It will return a `201 Created` response, with the shortened URL stored in the `Location` response header.

However, if you *often* need to shorten an URL on GitHub.com, it might be  annoying typing the command manually each time.

I made a [Chrome Extension](https://chrome.google.com/webstore/detail/baceaeopmlhkjbljoiinmbnnmpokgiml) to do that in a really easy way.  When visiting a page on GitHub, you'll see a small **git.io** icon at the end of address bar, click it, and the shortened URL will be generated.  You can copy it to the clipboard by clicking on the shortened URL.

[![Git.io URL Shortener Demo](/images/2012/2012-04-15-git-io-url-shortener/Git.io URL Shortener Demo.png)](http://cl.ly/462O1f1r2n0H1j0I0b00)

## Get It Now!

It's available on the [Chrome Web Store](https://chrome.google.com/webstore/detail/baceaeopmlhkjbljoiinmbnnmpokgiml) (and the [source code is on GitHub](https://github.com/chitsaou/git-io-shortener), too).  Give it a try and see if it saves your time!

## Limitations

### No Custom Code

According to [GIt.io's documentation](http://git.io/help), we can specify `code=yay` to generate a shortened URL with preferred code, in this example, `http://git.io/yay`.  But the purpose of this extension is to help you **shorten URL with one click**, and so far I have no idea on how to design an interface for the preferred code. If you have a good idea, [please tell me](https://github.com/chitsaou/git-io-shortener/issues).

### GitHub Domains Only (Indeed)

Currently it only supports URLs with hostname equals to one of these:

* `github.com`
* `gist.github.com`
* `raw.github.com`
* `developer.github.com`
* `develop.github.com`

By invoking the API endpoint `http://git.io` with a non-GitHub URL, the server will return a `422 Unprocessable Entity` error response, along with the body text:

    URL must match /^((gist|raw|develop(er)?)\.)?github\.com$/

That's how I limit the supported domains.

---

Now I'd like to talk about 2 things about Ajax that I learned from this project.

<!-- more -->

## Sending POST Request with XMLHttpRequest

Git.io is a HTTP-only API, even the shortened URL is stored in the `Location` header of response.  As the [source code of Git.io's service](https://github.com/technoweenie/guillotine) presents, there is no JSON API for the servie, not to say a JSONP service.  So we must call the service by directly sending POST HTTP request to the API endpoint.

Although we can include a jQuery library to deal with Ajax things, I don't want to include such a *big* library witin an non-app extension.  And because I've never programmed with XMLHttpRequest object directly before, I took some document-searching.  The source code of [background.js](https://github.com/chitsaou/git-io-shortener/blob/master/background.js) shows how I send a POST request to the remote server:

```javascript
var xhr = new XMLHttpRequest(); // make a XMLHttpRequest object
var form_data = new FormData(); // make a FormData object for easy serialization

form_data.append("url", url); // add URL to the form data

// set the callback function for this XMLHttpRequest object
xhr.onload = function(e) { // Callback when it is loaded
  if (xhr.status === 201) { // Created
    var shortened_url = xhr.getResponseHeader("Location"); // get the shortened URL
    console.log(shortened_url); // or return the shortened_url with a callback
  }
};

xhr.open("POST", "http://git.io", true);
xhr.send(form_data);  // send form data
```

To send a POST request:

1. Make a new `XMLHttpRequest` object for HTTP request.
2. Make a `FormData` object for storing the form data.
3. Append the data pairs you want to send with `form_data.append(key, value)` one by one.
4. Add a callback to `xhr.onload` event.  Check the status and perform further operations. (According to W3's spec, `load` event is fired when loaded successfully, got an error, or aborted.)

For more XMLHttpRequest and FormData examples, check out:

* [New Tricks in XMLHttpRequest2 - HTML5 Rocks](http://www.html5rocks.com/en/tutorials/file/xhr2/)
* [XMLHttpRequest Level 2](http://www.w3.org/TR/XMLHttpRequest/)
* [Using XMLHttpRequest - MDN](https://developer.mozilla.org/en/DOM/XMLHttpRequest/Using_XMLHttpRequest#Using_FormData_objects)
* [FormData - MDN](https://developer.mozilla.org/en/DOM/XMLHttpRequest/FormData)
* [XMLHttpRequest - Wikipedia, the free encyclopedia](http://en.wikipedia.org/wiki/XMLHttpRequest)

## Dealing with Same Origin Policy in a Chrome Extension

There is a limitaition of XMLHttpRequest: the **[Same Origin Policy](http://en.wikipedia.org/wiki/Same_origin_policy)**.  In short, you cannot send an Ajax request to different hosts, or differnet protocol (`http` v.s. `https`).  The sample code above is not going to work because we're sending a request to `git.io` from `github.com`, which violates the Same Origin Policy.

How to fix it? Well, Chrome Extension API provides a [simple way to solve it](http://code.google.com/chrome/extensions/xhr.html), by requiring a permission to the domain you are going to send Ajax request to.  For example, I added these lines to the `manifest.json`:

    "permissions": [
      "http://git.io/"
    ],

## Closing Up

Although I seldom need to generate shortened URL for a GitHub URL, whenever I need, I have to [RT\*M](http://git.io/help) first, then fire up a terminal, then type the command, then copy it -- *that's annoying*.  So I made this extension, and challenged myself making a Ajax-based Chrome Extension.  I made it, and I learned a lot.  That was good for me.

I think this meme represents what I have done precisely, so I'd like to close this article with it:

[![](/images/2012/2012-04-15-git-io-url-shortener/Git io - I dont always.jpeg)](http://cl.ly/0N1T0V2W2G3N3G1n0k2b)
