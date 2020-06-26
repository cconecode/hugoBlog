---
title: "CSS学习(一)：属性选择器"
date: 2020-06-26T14:53:07+08:00
type: post
tags: ["Web", "CSS"]
slug: css-study-arrtibuteselector
summary: CSS 学习笔记第一篇，关于 CSS 中的属性选择器。
---

## 语法

`[attr]`

​	表示带有以 attr 命名的属性的元素

`[attr=value]`

​	表示带有以 attr 命名的属性，且属性值为 *value* 的元素

`[attr~=value]`

​	表示带有以 attr 命名的属性，并且该属性是一个以空格作为分隔的值列表，其中至少有一个值为 *value*

`[attr|=value]`

​	表示带有以 attr 命名的属性，并且属性值为 *value* 或是以 *value-* 为前缀开头

`[attr^=value]`

​	表示带有以 attr 命名的属性，并且属性值是以 *value* 开头的

`[attr$=value]`

​	表示带有以 attr 命名的属性，并且属性值是以 *value* 结尾的

`[attr*=value]`

​	表示带有以 attr 命名的属性，并且属性值包含有 *value* 的元素

`[attr operator value i]`

​	在属性选择器的右方括号前添加一个用空格隔开的字母 `i`或 `I` ，可以在匹配属性值时忽略大小写

`[attr operator value s]`

​	在属性选择器的右方括号前添加一个用空格隔开的字母 `s` 或 `S`，可以在匹配属性值时区分大小写

## Example

```css
/* 存在 title 属性的 <a> 元素 */
a[title] {
    color: purple;
}

/* 存在 href 属性并且属性值匹配 "https://example.org" 的 <a> 元素 */
a[href="https://example.org"] {
    color: green;
}

/* 存在 href 属性并且属性值包含 "example" 的 <a> 元素 */
a[href*=example] {
    font-size: 2em;
}

/* 存在 href 属性并且属性值以 ".org" 结尾的 <a> 元素 */
a[href$=".org"] {
    font-style: italic;
}

/* 存在 class 属性并且属性值包含 "logo" 的 <a> 元素 */
a[class~="logo"] {
    padding: 2px;
}

/* 存在 href 属性，并且属性值包含 "insensitive"，不区分大小写的 <a> 元素 */
a[href="insensitive" i] {
    color: cyan;
}

/* 存在 href 属性，并且属性值包含 "cAsE"，区分大小写的 <a> 元素 */
a[href="cAsE" s] {
    color: pink;
}
```

