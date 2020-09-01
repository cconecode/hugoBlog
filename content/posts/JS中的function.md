---
title: "JS中的function"
date: 2020-07-03T22:16:53+08:00
type: post
slug: js-function
tags: ["Web", "JS"]
summary: JS 中 function 的学习记录
---

## JS Basic

JS 中的 function 为第一类对象，可以赋值给一个变量，也可以将其作为其它 function 的参数进行传递。

function 也是一个对象，可以拥有自己的属性。

JS 中定义 function 主要有两种方法，第一种为**声明式**，其格式为：

```js
function functionName(xx, xx) {
	// 函数语句
}
functionName(xx, xx)
```

第二种为**表达式**，就是将函数赋值给一个变量，通过变量调用，其格式为：

```js
var func = function(xxx) {
	// 函数语句
}
func(xxx)
```

还有一种特殊的函数，叫箭头函数，也叫 `lamabada` 函数，其格式为：

```js
param => expression
```

还有一种特殊的表达式叫做**立即调用函数表达式（IIFE）**，即当函数定义完之后会立即调用执行：

```js
(function() {
	// 函数语句
})()
```

该函数分为两部分，第一部分是包含在第一个 () 里面的一个匿名函数，第二部分再用 () 创建了一个立即执行函数表达式。

## JS 的参数

### argument 和 parameters

JS function 中 argument 和 parameters 的区别：parameters 就是俗称的形参，即函数中定义的参数名称；argumen 则为实参，即函数调用中实际传递的参数。

### 剩余参数

JS 中的**剩余参数**允许我们将一个不定量的参数表示为一个数组，其语法格式为：

```js
function(a, b, ...restArg) {
	restArg[0] // 函数传递的第三个参数
}
```

上面例子中，restArg 是一个由剩余参数组成的真数组。

### 默认参数

JS 中的 function 可以使用**默认参数**减少重复参数的传递，其语法格式为：

```js
function(arg1, arg2 = xxx) {
	// 函数语句
}
```

如果在调用函数中，arg2 没有传递参数，则会使用在函数定义时的默认参数；如果有参数传递，则会使用传递的参数。

### arguments 和 this

function 有两个隐藏参数：`arguments`和 `this` 

#### arguments

arguments 是所有传递给函数的参数的集合，可以用 arguments[i] 来获取对应序号的参数，下标从 0 开始，使用 length 属性可以获取 参数的数量。虽然可以通过下表获取参数和有 length 属性，但 arguments 不是一个数组。

arguments 有一个特性：当非严格模式中的函数没有包含剩余参数、默认参数和解构赋值，那么 arguments 会跟踪参数的值（即当参数改变时，arguments 也会改变；arguments 改变时，参数也会改变）；如果包含剩余参数、默认参数或解构赋值，那么 arguments 不会跟踪参数的值。在严格模式下，arguments 不会跟踪参数的值。[严格模式](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Strict_mode) [解构赋值](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)

```js
// 不包含剩余参数、默认参数和解构赋值
function func(a) {
    arguments[0] = 99
    console.log(a) // 99
	a = 5
	console.log(arguments[0]) // 5
}
func(10)

// 包含剩余参数、默认参数或解构赋值
function func(a = 55) {
    a = 99
    console.log(arguments[0]) // 10
    arguments = 5
    console.log(a) // 10
}
func(10)

// 严格模式
"use strict"
function func(a) {
    a= 99 
    console.log(arguments[0]) // 10
}
func(10)
```

#### this

function 中另一个隐式参数为 this，是指与函数调用相关联的对象，也叫函数上下文（function context）

JS 有四种调用函数的方式：

* 作为一个**函数调用**，如 func()
* 作为一个**方法调用**，如 ninjia.func()，作为对象的一个属性调用
* 作为一个**构造函数**，如 new Func()
* 通过 function 的 apply 或 call 方法

当作为一个函数调用时，函数的上下文即 this 对象的值分为两种情况：在非严格模式下，它是全局上下文（window 对象）；在非严格模式下，则为 `undefined`。

当 function 作为一个对象的属性且被调用时，这个对象就成了函数上下文并通过 this 参数在函数中生效。

当函数为构造函数，在使用关键字 new 调用函数时会触发以下步骤：

1. 创建一个新的空对象
2. 这个对象以 this 参数传递给构造函数，并作为这个构造函数的上下文
3. 返回新构造的对象为 new 命令的值

如果构造函数有返回值，那么：

* 如果返回值是一个对象，那么 new 命令返回的将会是这个对象
* 如果返回值是一个非对象，那么返回值会被忽略，新创建的对象会被返回

构造函数与普通函数的区别在：构造函数以大写字母开头，普通函数以小写字母开头；构造函数必须使用 new 关键字调用，如果没有使用，则与普通函数一样。

为了防止调用构造函数时忘记 new，有两个解决方法：

* 在构造函数内部使用严格模式，因为在严格模式下，this 为 undefined，忘记使用 new 会报错
* 在构造函数内部判断有没有使用 new 命令，没有的话直接返回一个实例对象：

```js
function Ninjia() {
	if (!(this instanceof Ninjia)) {
		return new Ninjia()
	}
}
```

除了上面三种方式，JS 提供了一种在调用函数时指定任一对象为函数上下文的手段，通过采用每一个 function 都有的方法：`apply`和`call`。使用 apply 方法时，有两个参数，第一个参数作为函数上下文的对象，第二个参数是一个包含参数的数组。call 的机制与 apply 相同，不同的地方在于，参数是直接传递的，而非包含在一个数组里面：

```js
juggle.apply(ninjia, [1, 2, 3, 4])
juggle.call(ninjia, 5, 6, 7, 8)
```

箭头函数没有自己的 this 对象，它会在**被创建**的时候选择 this 参数的值（who create，who is）。

除了 apply 和 call 可以控制函数的上下文之外，每个函数都有`bind`方法，bind 方法会创建并返回一个有着相同函数体的新函数，第一个参数指定为 this，其余参数作为新函数的参数，不考虑函数调用的方式。

```js
const module = {
	x: 42,
    getX: function() {
        return this.x
    }
}

const unboundGetX = module.getX
console.log(unboundGetX) // 在 global scope 中调用函数，结果为 undefined

const boundGetX = unboundGetX.bind(module)
console.log(boundGetX) // 42
```

