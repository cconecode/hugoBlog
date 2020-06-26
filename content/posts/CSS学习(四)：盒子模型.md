---
title: "CSS学习(四)：盒子模型"
date: 2020-06-26T15:28:27+08:00
type: post
slug: css-study-box
tags: ["Web", "CSS"]
summary: CSS 学习笔记第四篇。关于 CSS 中最基础也是最重要的概念-盒子模型。
---



<img src="https://figurebed-1254477026.cos.ap-chengdu.myqcloud.com/image-20200604225955216.png" alt="image-20200604225955216" style="zoom:50%;" />

上图为盒子模型。padding 是显示区域与元素边框之间的间距，border 是元素的边框，margin 是元素之间的间距。

## Box-Sizing

元素的 `width` 和 `heihgt` 是控制 *content box* 的宽高。增加 padiing 和 border 不会影响 content box 的宽高，但会影响元素整体的尺寸。也就是说，如果设置了 width 为 80px，border 和 padiing 为 5px，那么元素的整体宽度将会为 100px。如果还设置了 margin 为 10px，那么它将会占用 120px 的空间。

如果设置 `box-sizing` 属性的值为 `border-box`，那么 `width` 和 `height` 属性将会包含 padding 和 border。但 margin 仍会影响元素整体尺寸。

