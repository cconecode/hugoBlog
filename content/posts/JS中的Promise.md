---
title: "JS中的Promise"
date: 2020-07-03T22:23:04+08:00
type: post
slug: js-promise
tags: ["Web", "JS"]
summary: JS 中关于 Promise 的学习和一点理解	
---

首先，promise 是 JS 中的一个对象，它返回的是希望在将来收到的值，而不是现在。所以，promise 非常适用于处理异步操作。一般在使用的时候，promise 代表了一个异步操作的最终完成或失败。

promise 本质上是一个函数返回的对象，可以在它上面绑定回调函数，这样就不用将回调函数作为这个函数的参数传入，从而避免了回调地狱。

## Promise 的状态

promise 有三种状态：

1. **pending**：promise 初始化时的状态
2. **fulfilled**：promise 已经完成，即 success 状态
3. **rejected**：promise 被拒绝，即 failure 状态

当 promise 处于 pending 状态时，它有可能变为 fulfilled 状态，也有可能变为 rejected 状态。当变为 fulfilled 状态时，会传递一个值。当变为 rejected 状态时，会传递一个失败信息。promise 的状态只能由 pending 变为 fulfilled 或 rejected，不能由 fulfilled 变为 pending 或 rejected，也不能由 rejected 变为 pending 或 fulfilled。

## Promise 的方法

promise 作为一个对象，有着许多自己的方法，一般使用比较多的是`then`、`catch`、`finally`。

### then

then 主要用于为当前 promise 添加一个 fulfilled 和 rejected 状态的回调函数，不过在实际情况中，一般用于 fulfilled 状态会比较多。

then 有两个可选参数：`onFulfilled`和`onRejected`，分别对应 fulfilled 状态和 rejected 状态的回调。这两个参数必须为函数类型：

```js
promise.then(onFulfilled, onRejected)
```

当只有一个参数的时候，对应的是 fulfilled 回调。如果只想处理 rejected 状态的话，则需要将第一个参数设为 undefined：

```js
promise.then(undefined, onRejected)
```

onFulfilled 和 onRejected 函数都有一个参数。onFulfilled 函数的参数为最终的结果，而 onRejected 函数的参数则为拒绝的原因。

then 方法会返回一个新的 promise。

### catch

catch 方法用于处理拒绝也就是 rejected 状态的情况。它的行为与 then 只处理 rejected 状态差不多，实际上内部调用的也是`promise.then(undefined, onRejected)`。与 then 相同，它也会返回一个 promise：

```js
promise.catch(onRejected)
```

### finally

finally 用于无论 promise 结果是 fulfilled 还是 rejected，都会执行的一个回调函数。避免了同样的语句在 then 和 catch 中各写一次的情况。它也会返回一个 promise。

```js
promise.finally(onFinally)
```

## Promise 特点

promise 在使用时，有着以下特点：

* 在本轮事件循环运行完成之前，回调函数是不会被调用的
* 即使异步操作已经完成，在这之后通过 then() 添加的回调函数也会被调用
* 通过多次调用 then() 可以添加多个回调函数，它们会按照插入的顺序执行
* 由于 then() 会返回一个新的 promise，可以创建一个 promise 链连续执行多个异步操作。在上一步异步操作执行成功之后，下一步异步操作会带着上一步的执行结果。

## Promise 使用例子

下面是一个 promise 使用的例子，将一个传入回调改成 promise 形式：

```js
doSomething(function(result) {
	doSomethingElse(result, function(newResult) {
    doThirdThing(newResult, function(finalResult) {
      console.log(finalResult)
    }, failureCallback)
  }, failureCallback)
}, failureCallback)

// Promise 形式
doSomething().then(function(result) {
  return doSomethindElse(result)
})
.then(function(newResult) {
  return doThirdThing(newResult)
})
.then(function(finalResult) {
  console.log(finalResult)
})
.catch(failureCallback)
```

## Promise 构造函数

由于现代函数都会返回一个 promise，所以使用 promise 的情况比较多，而自己手动创建一个 promise 的情况则比较少。

promise 的构造函数为：

```js
new Promise(function(resolve, reject) {
	//...
})
```

它接受一个 function 为参数，这个 function 被称为 executor。executor 自身也带有两个参数：`resolve`和`reject`，它们也都是函数。promise 构造函数执行时，会立即调用 executor 函数。executor 内部通常会执行一些异步操作，当异步操作完成时，要么调用 resolve 函数将 promise 状态改为 fulfilled，要么调用 reject 函数将 promise 状态改为 rejected。如果在 executor 函数中抛出一个错误，那么 promise 的状态变更为 rejected。