---
title: "CSS学习(七)：Grid布局"
date: 2020-07-01T13:31:41+08:00
type: post
slug: css-study-gridlayout
tags: ["Web", "CSS"]
summary: CSS 学习笔记第七篇。关于 CSS 中的 Grid 布局	
---

相比于 flex 的一维布局（行或列），grid 是一个二维布局系统，也就是说可以同时设置行和列。相比于 CSS 的普通布局，它有着更多的灵活性和更多可能性。

## 基本术语及属性

### Grid 容器

当一个元素的 `display`设为`grid`时，它是一个 grid 容器。

### Grid item

grid 容器的直接子元素称为 grid item。

### Grid line

grid line 是组成网格结构的分隔线，它们可以为垂直的（列网格线）或水平的（行网格线），并且位于行或列的任一侧。grid line 主要作用在于定位每一个网格元素，grid 会为每条 grid line 创建编号，其顺序取决于书写模式，从 1 开始。

### Grid cell

grid cell 是两条相邻的行和两条相邻的列网格线之间的空间，它是 grid 中最小的单元，类似于表格系统中的一个单元格。

### Grid track

两条相邻 grid line 之间的空间，可以想象成 gird 中的一行或一列。可以通过`grid-template-columns`和`grid-template-row`属性定义网格中的行和列。

### Grid area

grid area 是由一个或多个 grid cell 组成的矩形区域，grid area 必须为矩形，不能创建 T 型或 L 型 grid area。

### 轨道大小和`minmax()`

可以使用`minmax()`作为值来控制轨道的最小尺寸和最大尺寸。例如对`grid-auto-rows`使用`minmax(100px, auto)`作为它的值，那么它创建的行的行高会根据内容来自动变换大小，但不会小于 100px。

### fr 单位

grid 引入了一个新的长度单位`fr`来创建灵活的网格轨道，`fr`单位表示网格容器中可用空间的一等份，`1fr`为一等份，`2fr`为二等份。

### 网格间距

两个网格单元之间的横向间距和纵向间距可以用`grid-column-gap`和`grid-row-gap`来控制，或者直接使用两个合并的缩写`grid-gap`。

### 隐式和显式网格

显示网格包含了在`grid-template-columns`和`grid-template-rows`属性中定义的行和列。当在网格定义之外又放了一些元素，或者因为内容的数量而需要更多网格轨道时，网格会在隐式网格中创建行和列。隐式网格中的轨道会自动定义尺寸，也可以用`grid-auto-rows`和`grid-auto-columns`属性来定义一个设置大小的轨道。

### z-index

当网格中的元素有重叠时，可以使用`z-index`来控制显示的顺序，`z-index`的值越大，会显示在越上方。

## Grid 布局特点

grid 布局有以下特点：

* **固定的位置和弹性的轨道大小**。轨道的大小可以使用固定的值，例如 px，也可以使用百分比或专门的`fr`单位来创建灵活的弹性轨道。
* **元素位置**。可以使用行号、行名或者标定一个 grid area 来精确定位元素，grid 同时还有一种算法来控制未给出明确网格位置的元素。
* **创建额外的轨道来包含元素**。可以使用 grid 布局来定义一个显式网格，但是根据规范，加在网格外面的内容也会被处理，必要时会自动增加行和列，尽可能多的容纳所有的列。
* **对齐控制**。可以控制放在 grid 内元素的对齐，也可以控制整个 grid 如何对齐。
* **控制重叠内容**。当多个元素之间彼此重叠时，可以使用`z-index`属性控制重叠区域的显示优先级。

## Grid 网格线定位详解

grid 使用基于网格线的定位控制元素在网格上的位置。使用 grid 布局时，会给网格线编号，分为行和列，从 1 开始。`grid-column-start`和`grid-column-end`控制元素列开始和结束的编号线，`grid-row-start`和`grid-row-end`控制元素的行开始和结束编号线。也可以使用它们的缩写形式：`grid-column`和`grid-row`，`grid-column`和`grid-row`都以`start / end`的形式设置开始和结束编号线。例如：`grid-row: 1 / 4;`表示元素从第一行线开始，延伸到第四行线。

### 默认跨度

如果元素只跨越一个轨道的话，则可以省略`grid-column-end`或`grid-row-end`的值。

### grid-ared 属性

`grid-area`属性是行开始结束和列开始结束的集合，值的顺序如下：

* grid-row-start
* grid-column-start
* grid-row-end
* grid-column-end

也就是用一个属性确定一个元素的定位

### 反方向计数

也可以从行和列结束线开始反方向计数，对于从左至右的书写模式而言，就是最右端的列线和最底端的行线。它们会被记为 -1，然后开始向前数，倒数第二条线被记为 -2。

最后一条线是指显式定义网格中的最后一条线，即由`grid-template-rows`和`grid-template-columns`所定义的网格，并不会把隐式网格加入的行和列计入其中。

### `span`关键字

`span`关键字主要用于“起始线与跨越轨道数量”的定位方法，它与上面的“起始线与结束线”的定位方法不同。`span`可以用在`grid-row-start`/`grid-row-end`和`grid-column-start`/`grid-column-end`属性中。例如：设置`grid-row:1 / span 3`，则表示这个元素从 1 号线开始，跨越 3 个轨道到 4 号线结束；或者设置`grid-row: span 3 / 4`，则表示元素会从 4 号线开始，往前跨越 3 个轨道到 1 号线。

## 网格模板区域

除了使用基于网格线的定位方式，还可以使用对模板区域命名的方式来定位元素。

使用模板区域命名主要分为两步：

1. 用`grid-area`对网格元素进行命名，如：`grid-area:header`

2. 在网格容器中对`grid-template-areas`使用网格元素的命名进行完整的布局：

   ```css
   .header {
   	grid-area: hd;
   }
   .footer {
   	grid-area: ft;
   }
   .content {
    	grid-area: main;
   }
   .grid-container {
    	grid-template-areas:
         "hd hd hd hd hd hd hd"
         "main main main ft ft ft ft"
   }
   ```

`grid-template-areas`的值必须是一个完整的布局，否则会无效。即每一行都应该有相同的单元格，如果网格不是矩形也是无效的。

### 留出空白的网格单元

如果要在网格中留出空白，则在布局中使用"`.`"，`.`之间没有空格的话会被记为一个单元格。

## 对网格线进行命名定位

在使用`grid-template-columns`和`grid-template-rows`定义网格时，可以对网格线进行全部或部分命名，后续可以使用这些命名线进行定位。

对网格线命名，只需要在定义的时候，把网格线的名字写在方括号内，名字随意：

```css
.grid-container {
	grid-template-rows: [main-start] 1fr [main-end] 1fr;
  grid-template-columns: [main-start] 100px [main-end] 100px;
}
```

一旦对网格线进行了命名，就可以使用比序号更方便易用的方式进行定位了。只需要把需要换成对应的命名网格线，更容易理解与记忆。

除此之外，还可以对同一根网格线进行多个命名，只需要把多个名字写进方括号内，用空格隔开。在引用时，可以使用任一名字。

### 由网格区域隐式定义的命名线

如果对网格区域进行了命名，那么就会隐式地创建对应的命名线。如：使用`grid-area`属性创建命名的区域，然后用`grid-template-areas`创建布局，区域的名字为：`hd`、`ft`、`main`。那么，就会隐式地创建了如下命名线：`hd-start`、`hd-end`、`ft-start`、`ft-end`、`main-start`、`main-end`。可以使用这些隐式的命名线来定位其它元素，和显示地命名网格线是一样的。

### 用 repeat() 定义相同名字的多条线

使用`repeat`语法，可以创建多条具有相同名字的网格线，这种方法在某些情况下是有用的。

```css
.grid-container {
	grid-template-columns: repeat(12, [col-start] 1fr);
}
```

上面的写法会创建一个有 12 等宽列的网格，每一列左侧的网格线命名为`col-start`。对于有多条相同名字的网格线，其名字是指第一条线，即上面的`col-start`是指左侧的第一条线。如果要引用其他同名的网格线，则要在其名字后面加上序号，如：`col-start 5`，是指第 5 条网格线。

## 网格布局中的自动定位

网格布局中还有另外一组规则，那就是如果没有为网格项目指定定位信息，它们会把自己放在网格中，每个单元格中放一个。

### 自动定位的默认规则

网格中默认的流向是按行排列项目，网格会首先在第 1 行的每个单元格中放置项目。如果已经通过`grid-template-rows`属性创建了其他行，网格就会继续把项目放到这些行中。如果没有足够的行来放置所有项目，那么就会创建新的隐式行。

#### 调整隐式行的大小

在默认情况下，被自动创建出来的隐式行的尺寸是自适应的，也就是会根据内容自动变换大小，而不会让内容溢出。通过`grid-auto-rows`属性可以控制隐式行的大小，也可以使用`minmax()`设置最大最小尺寸。

#### 按列自动定位

可以通过`grid-auto-flow`属性改变网格的默认流向，将其设为`column`，就可以按列来自动定位项目。同样地，被自动创建出来的隐式列也是自适应大小的，可以通过`grid-auto-columns`控制隐式列的大小。

## 网格中的对齐

不同于 flexbox，grid 中有两条轴用于对齐——块方向的列轴和文本方向的行轴。

### 项目在块方向列轴上的对齐

`align-slef`和`align-items`用于控制项目在块方向上的列轴。`align-items`用于 grid 容器中，如果 grid 容器设置了这个属性，那么所有项目都会采用这个对齐方式。`align-self`则用于控制单个项目的对齐。

它们的值都可以设置为：

* auto
* normal
* start
* end
* center
* stretch
* baseline
* first baseline
* last baseline

`align-self`的默认值为`stretch`，如果项目具有固定宽高比，它的值就会变为`start`。因为如果将一个具有固定宽高比的项目进行拉伸，将会导致它变形。

### 项目在文本方向行轴上的对齐

同`align-self`和`align-items`一样，`justify-self`和`justify-items`用于项目在文本方向上的对齐。它们的值也有：

* auto
* normal
* start
* end
* center
* stretch
* baseline
* first baseline
* last baseline

同样地，默认对齐方式也是`stretch`，除非项目具有宽高比。也就是说，在默认情况下，网格项目会覆盖整个网格区域，除非改变它们的对齐方式。

### 项目轨道在块方向和文本方向上的对齐

如果网格轨道整体所占据的空间小于网格容器，那么就可以设置网格轨道在容器中的对齐。同项目一样，它们也有两个方向的对齐：块方向和文本方向。分别使用`align-content`属性设置块方向的对齐，使用`justify-content`属性设置文本方向的对齐。它们的可选值都是：

* normal
* start
* end
* center
* stretch
* space-around
* space-between
* space-evenly
* baseline 
* first baseline
* last baseline

`align-content`属性的默认值为`start`，即网格轨道整体居于网格的左上角，紧挨着网格的起始线。将其设为`end`，则会紧靠着网格的最后一条线。

与 flex 布局类似，`space-between`、`space-between`和`space-evenly`值也用于分配空间的值。不同的是，如果网格中的项目跨越了多于一条轨道，这些值会使得项目变大。因为网格的间隙变大了，所以项目也变得更大了。