---
title: "CSS学习(六)：Flex布局"
date: 2020-06-28T13:29:40+08:00
type: post
slug: css-study-flexbox
tags: ["Web", "CSS"]
summary: CSS 学习笔记第六篇。关于 CSS 中的 Flex 布局	
---

在 CSS 普通流中，只有 float 和 position 能改变元素的位置。它们在某些方面有着一定的局限性，flex 盒子则会使得很多布局变得更加容易。

## Flexbox

Flexbox 是 CSS 弹性盒子布局模块（Flexible Box Layout Module）的缩写，它被专门设计出来用于创建横向或是纵向的一维页面布局。只需要将想要进行 flex 布局的父元素的 display 设为 `flex`，所有的子元素都会按照 flex 进行布局。

## Flex 模型

当元素为 flex 盒子时，会沿着两个轴来布局：

<img src="https://figurebed-1254477026.cos.ap-chengdu.myqcloud.com/image-20200622233644297.png" alt="image-20200622233644297" style="zoom:70%;" />

* **主轴（main axis）**：沿着 flex 元素放置的方向延伸的轴（页面上的行或列），该轴的开始和结束被称为 **main start** 和 **main end**。
* **交叉轴（cross axis）**：是垂直于 flex 元素放置方向的轴，该轴的开始和结束被称为 **cross start** 和 **cross end**。
* 设置了 `display: flex` 的父元素被称为 **flex 容器**。
* 在 flex 容器中子元素被称为 **flex item**。

## Flex 特性及属性说明

### 主轴方向

flexbox 提供了 `flex-direction` 属性，用于确定主轴的方向，默认值为 `row`。将其设为 `column` 的话，元素将会按列布局。`row-reverse` 和 `column-reverse` 则是按行和列反向排列。

### flex-wrap

默认情况下，flex items 会尽可能地排列在一行内，即使会溢出。使用`flex-wrap` 属性可以改变这一情况，它的默认值为 `nowrap`。将其设为 `wrap` ，如果 flex items 溢出的话，则会从上到下的换行显示。`wrap-reverse` 则是从下到上的换行显示。

### flex-flow

`flex-flow` 是 `flex-direction` 和 `flex-wrap` 两个属性的缩写，默认值为 `row no-wrap`。

### justify-content

`justify-content` 属性定义了主轴的对齐方式。当一行内的 flex item 都为 inflexible，或它们为 flexible 但已经达到了最大尺寸时，它会帮助分配剩下的空间。默认值为 `flex-start` 

* `flex-start`：items 被挤向主轴开始处。

* `flex-end`：items 被挤向主轴结尾的处。

* `start`：items 被挤向**书写模式**的开始处。

* `end`：items 被挤向**书写模式**的结尾处。

* `left`：items 被挤向容器的左侧位置。除非 `flex-direction` 没有意义，不然会表现得跟 `start` 一样。

* `right`：items 被挤向容器的右侧位置。除非 `flex-direction` 没有意义，不然会表现得跟 `end` 一样。

* `center`：items 居中

* `space-between`：item 平均分布，第一个 item 位于行开始的位置，最后一个 item 位于行结束的位置。

* `space-around`：items 平均分布，并且周围有着相等的空间。所有 item 两侧都有相等的空间，所以第一个 item 左侧会有一个单位的空间，但与第二个 item 之间会有两个单位的空间。

* `space-evenly`：items 平均分布，但每两个 item 之间的空间都相等。

  <img src="https://i.loli.net/2020/06/24/GCWekawq1PMxNmo.png" alt="image-20200624163440480" style="zoom:33%;" />

`space-between` 在某些版本的 Edge 不被支持，`start/end/left/right` 不被 Chrome 支持。`flex-start`、`flex-end` 和 `center` 则是较为安全的，基本上所有浏览器都支持。

还有两个额外的关键字 `safe` 和 `unsafe` 。使用 `safe` 会确保，无论使用哪种定位方式，都不能将元素推到无法显示内容的屏幕外（data loss）。

### align-items

`align-items` 规定了 flex items 在当前行的交叉轴如何放置，默认为 `stretch`。

* `stretch`：拉伸以填满整个容器（遵从 max-width / min-width）
* `flex-start`/`start`/`self-start`：items 位于交叉轴的开始处。他们的区别在于遵循 `flex-direction` 规则还是书写模式规则
* `flex-end`/`end`/`self-end`：items 位于交叉轴的结尾处。区别在于遵循 `flex-direction` 规则还是书写模式规则
* `center`：items 居中于交叉轴
* `baseline`：items 基于它们的 baseline 对齐

<img src="https://i.loli.net/2020/06/24/jf2opncS73JeWZR.png" alt="image-20200624164005601" style="zoom:33%;" />

### align-content

当交叉轴上有多余空间时，`align-content` 规定了容器内的每一行是怎么对齐的，与 `justify-content` 规定每个 item 在主轴上如何对齐类似，默认为 `stretch`

* `flex-start / start`：items 位于容器的开始处。flex-start 遵循 flex-direction 方向，start 遵循书写模式方向。
* `flex-end / end`：items 位于容器的结尾处。遵循方向同上
* `center`：items 居中于容器。
* `space-between`：items 平均分布，第一个 item 位于容器开始处，最后一个 item 位于容器结尾处。
* `space-around`：items 在每行周围平均分布，且间距相等。
* `space-evenly`：items 平均分布，且周围空间相等。
* `stretch`：每一行拉伸以占用剩余空间。

<img src="https://i.loli.net/2020/06/24/mxlBKdF7WQh8kYO.png" alt="image-20200624164041061" style="zoom:33%;" />

## flex items 属性

### order

flex items 可以通过 `order` 属性改变它们的显示顺序，但并不会改变原本的 DOM 结构。`order` 默认为 0，值越大越靠后，相同 order 的 items 以源顺序显示。

### flex-grow

`flex-grow` 决定了 items 在 flex 容器内可占用多少空间，它接受无单位的数值作为它的值，但负数无效。如果所有 item 的 `flex-grow` 都设为 1，那么容器的剩余空间将会均分地分配给所有子元素。如果某个子元素的值为 2，那么它会比其他子元素多占 2 倍的空间。

### flex-shrink

`flex-shrink` 给 items 提供了收缩的能力，默认为 1，负数无效。

### flex-basic

`flex-basic` 定义了在剩余空间分配之前元素的默认大小，它可以为长度或关键字。`auto` 关键字意味大小着取决于它的高度和宽度，`content` 关键字意味着 item 的大小取决于它的内容，但 `content` 关键字目前还不支持。

如果 `flex-basic` 设为 0，那么内容周围不会有多余的空间；如果设为 auto，那么额外的空间将会按照 `flex-grow` 的值进行分配。

### flex

`flex` 是 `flex-grow`、`flex-shrink` 和 `flex-basic` 组合的缩写，第二个和第三个参数为可选的，默认值为 `0 1 auto`。

### align-self

`align-self` 允许每个 flex item 覆盖默认的对齐方式（或由 `align-items` 属性指定的对齐方式）。它的值有 `auto`、`flex-start`、`flex-end`、`center`、`baseline`和 `stretch`。