---
layout: post
title: "在 JavaScript 實作 Mixin / Concern"
published: true
date: 2014-06-10 17:19
tags:
- javascript
- CoffeeScript
categories: []
comments: true

---
有這樣的需求：

* 某兩個 class 要共用某一組 functions / variables
* 發現到 JavaScript 只能單繼承，不支援 mixin (module)

CoffeeScript 也沒能很好解決這個問題。不過在 [CoffeeScript Cookbook » Mixins for classes](http://coffeescriptcookbook.com/chapters/classes_and_objects/mixins) 這裡提了一個很有趣的做法，就是先混成兩個要繼承的 classes，再給新的 Class 繼承。缺點是 mixin 有更動的時候，不會反映在之前 include 過的 class 裡面。

## 土砲 Mixin

於是找到了 Addy Osmani 大師的 [Learning JavaScript Design Patterns > Mixin Pattern](http://addyosmani.com/resources/essentialjsdesignpatterns/book/#mixinpatternjavascript) 這篇文章，裡面是借用了 Underscore / Lo-Dash 的 `_.extend` 來實作的，看來非得這樣做不可了。

寫起來會像這樣：

```coffeescript concern.js.coffee
Function::include = (mixin) ->
  _.extend(this.prototype, mixin)
```

```coffeescript duck.js.coffee
this.Duck =
  quake: ->
    "quake quake"
  
  walk: ->
    "walks like a duck"
```

```coffeescript yazi.js.coffee
class Yazi
  @include Duck
```

```coffeescript kamo.js.coffee
class Kamo # "duck" in Japanese
  @include Duck
```

```coffeescript app.js.coffee
yazi = new Yazi()
kamo = new Kamo()

yazi.quake() #=> "quake"
kamo.quake() #=> "quake"
```

此外也可以在新的 class 裡面覆寫 function / variable 就是了。

然而這種做法跟第一種做法一樣，mixin 有更動的時候，不會反映在之前 include 過的 class 裡面。

要注意的是，因為我們專案用的是 CoffeeScript，所以寫起來像 `@include` 這樣子看起來很簡潔有力，如果換成 JavaScript 的話會變得比較醜一點，以下是 CoffeScript 編出來的結果：

```javascript kamo.js
var Kamo = (function() {
  var Kamo = function() {};

  Kamo.include(Duck);
  
  return Kamo;
})();

var kamo = new Kamo();
kamo.quake(); //=> "quake"
```

## ActiveSupport::Concern 化

當然也可以弄得像 [ActiveSupport::Concern](http://api.rubyonrails.org/classes/ActiveSupport/Concern.html)，我是說 `included` callback:

```coffeescript concern.js.coffee
Function::include = (mixin) ->
  functions = _.omit(mixin, "included", "classFunctions")

  _.extend(this.prototype, functions)
  _.extend(this, mixin.classFunctions) # insert class functions in class itself

  # Call "included" callback function if available
  if typeof mixin.included is "function"
    # call included(mixin, base)
    # this = the mixin included, base = the class which called `include`
    mixin.included.call(mixin, this)
```

```coffeescript duck.js.coffee
this.Duck =
  quake: ->
    "quake quake"
  
  walk: ->
    "walks like a duck" 

  included: (base) ->
    console.log "mixing this class as a duck: #{base}"

  classFunctions:
    kindOfDuck: -> true
```

```coffeescript kamo.js.coffee
class Kamo
  @include Duck
```

```js app.js
// Console prints "mixing this class as a duck: function Kamo() { ..."
Kamo.kindOfDuck() //=> true

var animal = new Kamo()
animal.quake() //=> "quake quake"
```

至於怎麼弄到可以像 Rails 4.1 的 [Concerning](http://api.rubyonrails.org/classes/Module/Concerning.html) 我還沒想出來……。
