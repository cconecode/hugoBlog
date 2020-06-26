---
title: "CSS学习(二)：兄弟和子选择器"
date: 2020-06-26T15:01:09+08:00
type: post
slug: css-study-childselector
tags: ["Web", "CSS"]
summary: CSS 学习笔记第二篇，关于兄弟和子选择器。
---

## 相邻兄弟选择器

相邻兄弟选择器`+`介于两个选择器之间，当第二个元素**紧跟在**第一个元素之后，并且两个元素都是属于**同一个父元素**的话，则**第二个元素**被选中：

```css
/* 语法 */
former_element + target_element {}

/*  img 后面紧跟的 p 将被选中 */
img + p {
    font-style: bold;
}
```

## 通用兄弟选择器

兄弟选择符，位置不需要紧邻，只需要同层级，`A~B` 选择`A` 元素之后**所有同层级** `B` 元素：

```css
former_element ~ target_element { }

/* 选择 p 元素之后所有同层级的 span 元素 */
p ~ span {
    color: red;
}
```

## 子类选择器

当使用 `>` 选择符分隔两个元素时，它只会匹配作为第一个元素的**直接后代（子元素）**的第二个元素：

```css
/* 语法 */
element_1 > element_2 {}

/*  选择 div 下面的 span 子元素 */
div > span {
	background-color: blue;
}
```

## 后代选择器

当使用**空格**连接两个元素时，匹配作为第一个元素的**后代元素**的第二个元素：

```css
/* 语法 */
element_1  element2 {}

/* 选择 div 的所有后代 span 元素 */
div span {
    background-color: blue;
}
```

