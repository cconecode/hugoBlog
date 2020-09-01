---
title: "Vue学习系列(三)：Class与Style绑定"
date: 2020-07-12T22:34:05+08:00
type: post
slug: vue-class-style-bind
tags: ["Web", "Vue"]
summary: Vue 文档学习第三篇——关于 Class 与 Style 绑定	
---

将 `v-bind` 用于 `class` 和 `style` 时，Vue 做了专门的增强：表达式结果的类型除了字符串之外，还可以是对象或数组。

## 绑定 HTML Class

### 对象语法

可以传给 `v-bind:class` 一个对象，以动态地切换 class：

```html
<div v-bind:class="{ active: isActive}"></div>
```

上面例子中,数据 property `isActive` 的值决定了这个 class 存在与否。

可以在对象中传入更多字段来动态切换多个 class，此外，`v-bind:class` 指令也可以与普通的 class attribute 共存：

```html
<div 
	class="static" 
	v-bind:class="{ active: isActive, 'text-danger': hasError}"
></div>
```

`isActive` 和 `hasError` 的值将决定显式地是哪个类，当它们的值发生变化时，class 列表也会相应地进行更新。如果有以下 data:

```js
data: {
	isActive: true,
	hasError: false
}
```

那么其结果渲染为：

```html
<div class="static active"></div>
```

绑定的数据对象也可以不必内联定义在模板里：

```js
<div v-bind:class="classObject"></div>

data: {
	classObject: {
		active: true,
		'text-danger': false
	}
}
```

渲染结果也和上面的一样。甚至还可以绑定一个返回对象的计算属性：

```js
data: {
	isActive: true,
	error: null
},
computed: {
	classObject: function() {
		return {
			active: this.isActive && !this.error,
			'text-danger': this.error && this.error.type ==== 'fatal'
		}
	}
}
```

### 数组语法

可以把一个数组传递给 `v-bind:class`，以应用一个 class 列表：

```js
<div v-bind:class="[activeClass, errorClass]"></div>

data: {
	activeClass:  'active',
	errorClass: 'text-danger'
}
```

渲染为：

```html
<div class="active text-danger"></div>
```

## 绑定内联样式

### 对象语法

`v-bind:style` 是一个 JavaScript 对象，尽管它的语法与 CSS 十分相像。一般地，会把它绑定到一个样式对象，这样更清晰：

```js
<div v-bind:style="styleObject"></div>

data: {
	styleObject: {
		color: 'red',
		fontSize: '13px'
	}
}
```

### 数组语法

`v-bind:style` 的数组语法可以将多个样式对象应用到同一个元素上：

```html
<div v-bind:style="[baseStyles, oveeridingStyles]"></div>
```

###