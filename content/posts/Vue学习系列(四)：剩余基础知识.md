---
title: "Vue学习系列(四)：剩余基础知识"
date: 2020-07-14T22:35:59+08:00
type: post
slug: vue-remain-knowleage
tags: ["Web", "Vue"]
summary: Vue 文档学习第四篇——关于 Vue 中剩下的一些基础知识和前面的总结
---

Vue 通过`Vue`函数创建一个新的 **Vue 实例**：

```vue
var vm = new Vue({
})
```

vue 是一个响应式的框架，其中的数据操作都是双向绑定的，也就是说其中任何一方改变，另一方会马上进行响应发生改变。

## Vue 中的数据选项

一个 vue 实例中，基本上会有以下几个属性，用于操作数据和对数据的管理： 

```vue
new Vue({
	data: 
	props: 
	computed:
	methods:
	watch:
})
```

### data

data 是 vue 实例中的数据对象，其中只能存放数据。其类型可以是 Object 或 Function，子组件中的 data 只能是 function。因为组件可能被用来创建多个实例，如果 data 仍是一个对象，则所有的实例将共享引用同一个数据对象。通过 data 函数，每次创建一个新的实例后，能够调用 data 函数，返回一个初始数据的副本数据对象。

### props

props 用于接收来自父组件的数据。其类型可以为 Arrary<String> 或 Object。当它是一个对象时，可以使用以下选项对其进行高级配置：

* type：它会检查一个 prop 是否是给定的类型，否则抛出警告。可以是下列原生构造函数中的一种：String、Number、Boolean、Array、Object、Date、Function、Symbol，任何自定义构造函数，或以上内容组成的数组。
* default：为 prop 提供一个默认值，如果该 prop 没有被传入，则会使用这个默认值。否则将会使用传入的值
* required：Boolean。规定该 prop 是否为必传值
* validator：Function。自定义验证函数，将传入的 prop 的值作为唯一参数传入，以进行校验

上述用法的简单例子：

```vue
new Vue({
	props: {
		age: {
			type: Number,
			default: 0,
			required: true,
			validator: function(value) {
				return value > 0
			}
		}	
	}
})
```

### computed

vue 实例中的计算属性。如果需要对 vue 中的数据进行复杂计算，则可以将其计算过程移入到计算属性中进行。其计算结果将会进行缓存，除非依赖的属性变化才会进行重新计算。

### methods

methods 主要用于 vue 中方法的具体实现，如 v-on 绑定了某个方法，则可以在 methods 里面实现这个方法。方法中的 this 将指向 vue 实例。

### watch

watch 主要用于监听属性，如果某个属性的值发生变化，则会进行触发。它是一个键值对，键为需要观测的属性，值为发生变化时触发的行为。值可以为：Function、方法名、Object、Array。

当 watch 为一个 Object 时，在 `handler` 属性里面写其回调函数。同时还提供了两个额外的选项：`deep`和`immediate`。`deep`值为 Boolean，用于是否监听对象内部值的变化，适用于一个对象内部都多重嵌套（监听数组不需要）。`immediate`用于立即触发回调，而不用等值发生变化。

下面是简单的例子：

```vue
watch: {
	// 作为 Function
	a: function(val, oldVal) {
	},
	// 方法名
	b: 'changeMethod'，
	// 作为 Object
	c: {
		handler: function(val, oldVal) {}
		deep: true,
		immediate: true
	},
	// 作为 Array，里面的方法会被逐一调用
	d: [
		'handle1',
		function handle2(val, oldVal) {},
		{
			handler: function(val, oldVal) {}
		}
	]
}
```

## Vue 中的指令

vue 指令是带有 `v-`前缀的特殊属性，它们主要作用于 DOM。指令的值一般是一个 JS 表达式，根据表达式的值作出一些响应式行为。

它们主要有：v-bind、v-on、v-model、v-show、v-if、v-for、v-once。其中一些可以接收一个参数，在指令后面以冒号表示。

### v-bind

v-bind 用于动态地绑定一个或多个 HTML 属性，或一个组件 prop 到表达式，也可以绑定 HTML 的 class 和 style。它的值一般为 JS 表达式。在绑定 class 和 style 时，其类型可以为数组或对象。在绑定 prop 时，prop 必须在子组件中声明。

v-bind 可以使用修饰符指定不同的绑定类型，其修饰符有：

* .prop：作为一个 DOM 属性而不是 HTML 属性绑定
* .camel：允许在使用 DOM 模板时将 v-bind 属性名驼峰化
* .sync：会扩展成一个更新父组件绑定值的 v-on 侦听器

v-bind 中的参数还可以是动态化的，动态参数用`[]`括起来表示。v-bind 由于比较常用，还提供了缩写形式-用`:`表示。

例子：

```html
<!-- 绑定一个 HTML 属性 -->
<img v-bind:src="imageSrc">

<!-- 动态参数 -->
<button v-bind:[key]="value"></button>

<!-- 缩写形式 -->
<img :src="imageSrc">

<!-- class 绑定 -->
<div :class="{red: isRed}"></div>

<!-- style 绑定 -->
<div :style="[styleObjectA]"></div>

<!-- prop 绑定 -->
<my-component :prop="value"></my-component>
```

### v-on

v-on 用于绑定事件监听器，事件类型由参数指定，表达式可以是一个方法的名字或一个内联语句。用在普通元素上时，只能监听原生 DOM 事件，用在自定义元素组件上时，可以监听子组件触发的自定义事件。其缩写为`@`。v-on 也支持动态参数

v-on 也提供了修饰符，用于处理不同情况的事件：

* .stop：调用`event.stopPropagation()`
* .prevent：调用`event.preventDefault()`
* .capture：添加事件侦听器时使用 capture 模式
* .self：只有当事件时从侦听器绑定的元素本身触发时才触发回调
* .{keyCode | keyAlias}：只有当事件是从特定键触发时才触发回调
* .once：只触发一次回调
* .left/.right/.middle：(2.2.0)只当点击鼠标左键/右键/中键时触发
* .passive：以 {passive: true} 模式添加侦听器

例子：

```html
<button v-on:click="action"></button>

<button v-on:[event]="action"></button> // 动态参数

<button @click="action"></button> // 缩写
```

### v-if

v-if 的作用是，根据表达式的 truthiness 有条件地渲染元素。v-if 后面还可以接 v-else-if 和  v-else

### v-show

根据表达式的真假值，切换元素的 display 属性。与 v-if 不同之处：使用 v-show 时，元素一直会被渲染，只是改变 display 属性；v-if 根据条件决定是否渲染。

### v-for

v-for 可以基于源数据多次渲染元素或模板，必须使用特定语法：`alias in expression`，为当前遍历的元素提供别名。也可以为数组的索引提供别名。如果要强制重新排序元素，必须使用特殊属性`key`提供一个排序提示。

例：

```html
<div v-for="item in items">
	{{ item.value }}  
</div>

<div v-for="(item, index) in items"></div>

<div v-for="item in items" :key="item.id"></div>
```

### v-once

只渲染元素和组件一次。随后的重新渲染，元素/组件及其所有的子节点将被视为静态内容跳过。