---
title: "CSS学习(三)：CSS层叠与优先级"
date: 2020-06-26T15:05:16+08:00
type: post
slug: css-study-cascade-priority
tags: ["Web", "CSS"]
summary: CSS 学习笔记第三篇，关于 CSS 布局中什么是层叠，以及布局的优先性。
---

## 层叠

### CSS 声明的来源

CSS 声明共有三个来源：`User-agent stylesheets`、`Author stylesheets`、`User stylesheets`。

#### User-agent stylesheets

user-agent stylesheets 是浏览器默认的 stylesheets，对任何 document 都有效。

#### Author stylesheets

Author stylesheets 是最为普遍的一种 stylesheets，是由网页作者提供的。

#### User stylesheets

网页的用户可以选择一个自定义的 user stylesheets 覆盖掉网页原本的 style

### 顺序

层叠算法指定了对于每个 document 元素的每个属性，如何找到它们合适的值：

1. 首先过滤不同来源的规则，仅保留适用于给定元素的规则。
2. 然后根据它们的 importance 对这些规则进行排序，排序从两方面考虑：`!important`标记以及来源。它们的排序如下：
   1. 带有`!important`标记，来源按降序排：`user-agent`、`user`、`author`
   2. 不带有`!important`标记，来源按降序排：`author`、 `user` 、`user-agent`

## 优先级

优先级就是分配给指定的 CSS 声明的一个权重，由匹配的选择器的每一种选择器类型的数值决定。当有多个 CSS 声明的优先级相等时，最后的那个声明将被运用到元素上。当同一个元素有多个声明的时候，优先级才有意义。

优先级由四个部分组成：a、b、c、d

* 如果样式是内联样式，a 等于 1。
* b 等于所有 ID 选择器的数量。
* c 等于所有 class、伪类和属性选择器的数量。
* d 等于所有类型选择器和伪元素选择器的数量。

计算规则为：a-b-c-d，值最大的将会运用到元素上。

### !important

当在一个样式声明中使用`!important`规则时，此声明将会覆盖任何其他声明。虽然，`!important`与优先级无关，但与最终结果直接相关。当两条相互冲突的`important`规则声明被运用到同一元素上时，更大优先级的声明将会被采用。

使用`!important`会破坏样式表中固有的级联规则，使得调试 bug 变得更加困难。下面是一些使用法则：

* 一定要优化考虑使用样式规则的优先级来解决问题
* 只有在需要覆盖全站或外部 CSS 的特定页面中使用`!important`
* 永远不要在插件中使用`!important`
* 永远不要在全站范围内的 CSS 代码中使用`!important`