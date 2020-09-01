---
title: "Vue学习系列(五)：插槽"
date: 2020-07-16T22:37:48+08:00
type: post
slug: vue-slot
tags: ["Web", "Vue"]
summary: Vue 文档学习第五篇——关于 Vue 中比较重要的一个知识点：插槽
---

Vue 中的插槽相当于一个预占位，它的值会被父组件中的内容所替换。

插槽一共分为三大类：

* **匿名插槽**。也叫默认插槽，没有命名，有且仅有一个
* **具名插槽**。相对于匿名插槽，它有 name 属性。在同一个组件中可以有多个具名插槽
* **作用域插槽**。插槽内容可以访问子组件中的数据

## 匿名插槽

其实匿名插槽也有一个隐含的名字-default，所以也叫 default 插槽。在一个组件中，匿名插槽只能有一个，用`<slot></slot>`表示。在渲染的时候，匿名插槽会被组件之间的内容所代替。如果一个组件没有包含`<slot>`元素，那么它的开始和闭合标签之间的内容会被抛弃：

```html
# child-component
<div>
  <slot></slot>
</div>

# parent-component
<child-component>
  Your profile
</child-component>
```

上面例子中子组件的`<slot>`将会被 “Your profile” 所代替。

匿名插槽也可以提供默认内容，当父组件中不提供任何插槽内容的时候，默认内容将会显示：

```html
# submit-button
<butto type="submit">
  <slot>Submit</slot>
</butto>

#parent-component
<submit-button></submit-button> // 默认内容 Submit 将会被渲染
```

## 具名插槽

具名插槽也就是具有命名的匿名插槽，当同一个组件中需要多个插槽时，可以为不同的插槽进行命名，在使用的时候就可以通过命名确定将使用哪个插槽。

> 在 Vue 2.6.0 之后，`slot`会被废弃，将使用`v-slot`进行代替

子组件：

```html
<div>
  <header>
 		<slot name="header"></slot>
  </header>
  <footer>
 		<slot name="footer"></slot>
  </footer>
</div>
```

父组件：

```html
<base-layout>
  <template v-slot:header>
 		<h1>
      Page title
    </h1>
  </template>
  
  <template v-slot:footer>
 		<p>
      Contact info
    </p> 
  </template>
</base-layout>

# 2.6.0 废弃的语法
<base-layout>
	<h1 slot="header">
    Page title
  </h1>
  <p slot="footer">
    Contact info
  </p>
</base-layout>
```

需要注意的是，v-slot 只能添加在`<template>`上。

## 作用域插槽

当父组件需要访问子组件中的数据时，需要用到作用域插槽。作用域插槽就是将子组件中的数据作为`<slot>` 元素的一个属性绑定上去，绑定在上面的属性称为**插槽 prop**。在父组件中，可以使用带值的`v-slot`或`slot-scope`（2.6.0已废弃）来定义提供的插槽 prop 的名字。

子组件-current-user：

```html
<span>
 <slot v-bind:user="user">
 	{{ user.lastName }} 
  </slot>
</span>
```

父组件：

```html
<current-user>
  <template v-slot:default="slotProps">
 		{{ slotProps.user.firstName }} 
  </template>
</current-user>

#2.6.0 废弃的 slot-scope
<current-user>
	<span slot-scope="slotProps">
 		{{ slotProps.user.firstName }} 
  </span>
</current-user>
```

## 具名插槽的缩写

同 v-on、v-bind 一样，v-slot 也有缩写，它的缩写形式为`#`。同样地，也是只有在有参数的时候才有效，如果想对匿名插槽进行缩写的话，可以使用隐含的`default`取代：`#default`。