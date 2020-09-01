---
title: "Vue学习系列(二)：计算属性与侦听器"
date: 2020-07-11T22:29:26+08:00
type: post
slug: vue-computedproperty
tags: ["Web", "Vue"]
summary: Vue 文档学习第二篇——关于计算属性与侦听器	
---

## 计算属性

Vue 中可以在 `computed` 中使用**计算属性**的 getter 来处理复杂逻辑：

```js
var vm = new Vue({
	el: '#example',
	data: {
		message: 'Hello'
	},
	computed: {
        	//  计算属性的 getter
		reversedMessage: function() {
			return this.message.split('').reverse().join('')
		}
	}
})
```

### 计算属性缓存 vs 方法

可以通过在表达式中调用方法来达到上述例子的效果：

```js
<p>Reversed message: "{{ reversedMessage() }}"</p>

//  在组件中
methods: {
    reversedMessage: function() {
        return this.message.split('').reverse().join('')
    }
}
```

可以将同一函数定义为一个方法而不是一个计算属性，它们最终结果是相同的。不同的是，计算属性是基于它们的响应式依赖进行缓存的，只在相关函数依赖发生改变时它们才会重新求值。

### 计算属性 vs 侦听属性

Vue 也提供了另一种更通用的方式来观察和响应 Vue 实例上的数据变动：**侦听属性**。当有一些数据需要随着其它数据变动而变动时，计算属性比侦听属性要好，因为计算属性是响应式的，可以减少很多代码量，而侦听属性是监听回调，也就意味着更多的代码冗余：

```js
//  侦听属性
var vm = new Vue({
    el: '#demo',
    data: {
        firstName: 'Foo',
        lastName: 'Bar'
        fullName: 'Foo Bar'
    },
    watch: {
        firstName: function(val) {
            this.fullName = val + ' ' + this.lastName
        }
        lastName: function(val) {
    	this.fullName = this.firstName + ' ' + val
	}
    }
})

// 计算属性
var vm = new Vue({
    el: '#demo',
    data: {
        firstName: 'Foo',
        lastName: 'Bar'
    }
    computed: {
    	fullName: function() {
    		return this.firstName + ' ' + this.lastName
           }
    }
})
```

### 计算属性的 setter

计算属性默认只有 getter，也可以在需要的时候提供一个 setter：

```js
computed: {
	fullName: {
		get: function() {
			return this.firstName + ' ' +  this.lastName
		},
		set: function(newValue) {
			var names = newValue.split(' ')
			this.firstName = names[0]
			this.lastName = names[names.length - 1]
		}
	}
}
```

