---
title: "Vue学习系列(一)：模板语法"
date: 2020-07-10T22:26:40+08:00
type: post
slug: vue-templategrammar
tags: ["Web", "Vue"]
summary: Vue 文档学习第一篇——关于模板语法
---

Vue.js 使用了基于 HTML 的模板语法，允许开发者声明式地将 DOM 绑定至底层 Vue 实例的数据。所有 Vue.js 的模板都是合法的 HTML，所以能被遵循规范的浏览器和 HTML 解析器解析。

在底层的实现上，Vue 将模板编译成虚拟 DOM 渲染函数。结合响应系统，Vue 能够智能地计算出最少需要重新渲染多少组建，并把 DOM 操作次数减到最少。

## 插值

### 文本

数据绑定最常见的形式就是使用 "Mustache" 语法（双大括号）的文本插值：

```html
<span>Message: {{ msg }}</span>
```

Mustache 标签会将被替代为对应数据对象上`msg` property 的值。无论何时，绑定的数据对象上`msg` property 发生了改变，插值处的内容都会更新。

通过使用**v-once 指令**，可以进行一次性地插值，当数据改变时，插值处的内容不会更新。但会影响到该节点上的其它数据绑定：

```html
<span v-once>这个将不会改变: {{ msg }}</span>
```

### 原始 HTML

双大括号会将数据解释为普通文本，而非 HTML 代码。为了输出真正的 HTML，需要使用`v-html`指令:

```html
<p>Using mustaches: {{ rawHtml }}</p>
<p>Using v-html directive: <span v-html="rawHtml"></span></p>
```

### Attribute

Mustache 语法不能作用在 HTML attribute 上，遇到这种情况应该使用 `v-bind` 指令：

```html
<div v-bind:id="dynamicId"></div
```

对于 boolean attribute（它们只要存在值就为 true），`v-bind`工作起来略有不同，在下面这个例子中：

```html
<button v-bind:disabled="isButtonDisabled">
    Button
</button>
```

如果 isButtonDisabled 的值是 null、undefined 或 false，则 disabled attribute 甚至不会被包含在渲染出来的 `<button> `元素中。

### 使用 JavaScript 表达式

对于所有的数据绑定，Vue.js 都提供了完全的 JavaScript 表达式支持：

```html
{{ number + 1 }}
{{ ok ? 'YES': 'NO'}}
{{ message.split('').reverse().join('') }}

<div  v-bind:id="'list-' + id"></div>
```

这些表达式会在所属 Vue 实例的数据作用域下作为 JavaScript 被解析。有个限制就是，每个绑定只能包含**单个表达式**，所以下面的例子都不会生效：

```html
<!--  这是 statement，不是 express -->
{{ var a = 1}}

<!--  控制流也不会生效，使用 三元表达式 -->
{{ if(ok) {return message }}}
```

## 指令

指令是带有`v-`前缀的特殊 attribute。指令 attribute 的值预期是**单个 JavaScript 表达式**。指令的职责是：当表达式的值改变时，将其产生的连带影响，响应式地作用于 DOM：

```html
<p v-if="seen">
    now you see me
</p>
```

这里，`v-if` 指令将根据表达式 `seen` 的值来插入或移除 `<p>` 元素。

### 参数

一些指令能够接收一个“参数”，在指令名称之后以冒号表示。例如，`v-bind` 指令可以用于响应式地更新 HTML attribute：

```html
<a v-bind:href="url">...</a>
```

在这个例子中，`href` 是参数，告知 `v-bind` 指令将该元素的 `href` attribute 与表达式 `url` 的值绑定。

另一个例子是 `v-on` 指令，它用于监听 DOM 事件：

```html
<a v-on:click="doSomething">...</a>
```

在这个例子中，参数是监听的事件名。

### 动态参数

> 2.6.0 新增

从 2.6.0 开始，可以用方括号括起来 Javasc 表达式作为一个指令的参数：

```html
<a v-bind:[attributeName]="url">...</a>
```

这里的 `attributeName` 会被作为一个 JavaScript 表达式进行动态求值，求得的值会作为最终的参数来使用。

#### 对动态参数的值的约束

动态参数预期会求出一个字符串，异常情况下值为 `null`。这个特殊的 `null` 可以被显式地用于移除绑定。任何其它非字符串类型的值都会触发一个警告。

#### 对动态参数表达式的约束

动态参数表达式有一些语法约束，因为某些字符串，如空格和引号，放在 HTML attribute 名里面是无效的。在 DOM 中使用模板时，还需要避免使用大写字符来命名键名，因为浏览器会把 attribute 名全部强制转为小写。

### 修饰符

修饰符是以半角句号 `.` 指明的特殊后缀，用于指出一个指令应该以特殊方式绑定。例如，`.prevent` 修饰符告诉 `v-on` 指令对于触发的事件调用 `event.preventDefault()`:

```html
<form v-on:submit.prevent="onSubmit">....</form>
```

## 缩写

在构建由 Vue 管理所有模板的**单页面应用程序（SPA - single page application）**时，Vue 为 `v-bind` 和 `v-on` 两个最常用的指令，提供了特定简写：

### `v-bind`缩写

```html
<!-- 完整语法 -->
<a v-bind:href="url">...</a>

<!-- 缩写 -->
<a :href="url">...</a>

<!-- 动态参数的缩写 -->
<a :[key]="url">...</a>
```

### `v-on`缩写

```html
<!--  完整语法 -->
<a v-on:click="doSomething">...</a>

<!-- 缩写 -->
<a @click="doSomething">...</a>

<!-- 动态参数的缩写 -->
<a @[event]="doSomething">...</a>
```

