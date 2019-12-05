---
title: What's New in Xcode11
date: 2019-11-05 15:38:21
tags: ["iOS"]
premalink: what's-new-in-xcode11
typora-copy-images-to: ipic
type: post
---

# WWDC19 - What's New in Xcode11

WWDC 2019 已经过去快半年多了，Xcode 11 更新也有段时间了。用了一段时间之后，发现 Xcode 11 较之 Xcode 10 还是有许多地方不一样的，于是便看了 [WWDC 2019 Session 401](https://developer.apple.com/videos/play/wwdc2019/401/)，顺便做一下记录。

<!-- more -->

首先，对 Xcode11 的整体改进做一个预览：

![preview](https://tva1.sinaimg.cn/large/006y8mN6ly1g8n98whgi4j30wc0ha7fe.jpg)

整体的改变还是挺多的，下面一一对改进的功能进行说明。

## 右上角功能键的改进

首先，Xcode 11 改变的是右上角的按钮，Xcode 10 上是三个按钮，到了 11 已经变成了两个按钮：<img src="https://tva1.sinaimg.cn/large/006y8mN6ly1g8n9nrz958j30ee03gq32.jpg" alt="image-20191105165729690" style="zoom:50%;" /> 			<img src="https://tva1.sinaimg.cn/large/006y8mN6ly1g8n9mwnaxgj30cc03iweo.jpg" alt="image-20191105165639942" style="zoom:50%;" />     



原先的 Source Control Log 被移到了右侧栏里面：

<img src="https://tva1.sinaimg.cn/large/006y8mN6ly1g8n9p9xusdj30ec05ktam.jpg" alt="image-20191105165856444" style="zoom:50%;" /> 			<img src="https://tva1.sinaimg.cn/large/006y8mN6ly1g8n9qc8ozdj30ee054dg7.jpg" alt="image-20191105165958024" style="zoom:50%;" />



原先的比较常用的切换 Assitant Editor 和 Authors 一起并入到了 Editor Options 里面，并将 Editor Options 移到了每个独立的编辑窗口里面：

<img src="https://tva1.sinaimg.cn/large/006y8mN6ly1g8n9wj9q5yj30ec05uwgf.jpg" alt="image-20191105170554608" style="zoom:50%;" />  			<img src="https://tva1.sinaimg.cn/large/006y8mN6ly1g8n9x9yx7vj30a00bgdlp.jpg" alt="image-20191105170637216" style="zoom:50%;" />  	  	 	  

*上面 Xcode 11 的 Assistant 就是原先 Xcode 10 右上角的那两个圈圈*

Editor Options 中同时新增了一个 Swift UI 的预览，当项目中使用到了 Swfit UI 的时候，可以预览 Swift UI 的效果

现在 Xcode 11 上面的两个按钮的功能变成了 Library 和 Code Review：

![image-20191105171631101](https://tva1.sinaimg.cn/large/006y8mN6ly1g8na7koerqj30b203iwex.jpg)

Library 的主要功能是：选择 IB 控件、文档、代码块、图片资源以及颜色

Code Review 的主要功能是：比较同一源文件源码的改动

## Editor Splitting

在 Xcode 11 里面，增加了一个 Editor Spliting 的功能，可以随时随地的增加一个 Editor：

![image-20191105171034560](https://tva1.sinaimg.cn/large/006y8mN6ly1g8na1dqbffj307c0460sm.jpg)

Editor Spliting 默认的是往右边增加，按住 option 键再点击这个按钮，就可以在下面增加新的 Editor

可以通过按住 shift + option 并点击源文件，来管理 Editor，点击的源文件那个窗口会变成选中效果，可以用鼠标或者键盘方向键进行移动，移动完成后，点击键盘上的 return，原先选中的源文件就会插入或者移动到当前位置



## Minimap

Xcode 11 比较大的一个改动就是新增了 Minimap：

<img src="https://tva1.sinaimg.cn/large/006y8mN6ly1g8napo7hbsj309w0lmjxt.jpg" alt="image-20191105173354397" style="zoom:50%;" />

Minimap 主要是提供导航作用的，点击 Minimap 的任意位置，源码便会滚动到点击的地方。 当鼠标悬停在上面时，会显示当前的方法名：

<img src="https://tva1.sinaimg.cn/large/006y8mN6ly1g8naszwn6tj30h40l0mxq.jpg" alt="image-20191105173706542" style="zoom:50%;" />

同时按住 cmd 键的话，会显示当前所有的方法名：

<img src="https://tva1.sinaimg.cn/large/006y8mN6ly1g8nau5ip8rj30so0zi461.jpg" alt="image-20191105173813596" style="zoom:33%;" />

当源码中有 warning 或者断点时，在 Minimap 中也会显示

源码中的 marks 在 Minimap 里可以直接看到：

<img src="https://tva1.sinaimg.cn/large/006y8mN6ly1g8nawlhq2ej307w0isglu.jpg" alt="image-20191105174034623" style="zoom:50%;" />

当在源码中搜索关键字时，所有符合条件的在 Minimap 中会有选中效果：

<img src="https://tva1.sinaimg.cn/large/006y8mN6ly1g8nb0ed9c3j30860s8dgh.jpg" alt="image-20191105174413261" style="zoom:33%;" />



## 源码 Editor

Xcode 11 中通过 cmd + 右键点击方法名，可以给方法添加参数注释。新增了参数时，通过这个方法会自动拼接新的参数：

![image-20191105181327456](https://tva1.sinaimg.cn/large/006y8mN6ly1g8nbutwblij31he0b67en.jpg)

cmd + 右键点击参数，选择 Edit All in Scope，可以同时修改方法名、方法内、注释里面的参数名称：

![image-20191105181504863](https://tva1.sinaimg.cn/large/006y8mN6ly1g8nbwii6k1j314e08stb8.jpg)



当对源码进行了修改时，在 Editor 的左侧会出现一个蓝色条，点击这个蓝色条，可以选择 Show Change 和 Discard Change。Discard Change 的作用是撤销修改，Show Change 的作用是显示哪些地方进行了改动：

<img src="https://tva1.sinaimg.cn/large/006y8mN6ly1g8nc3aq6aqj30im06atdg.jpg" alt="image-20191105182136776" style="zoom:50%;" />



除此之外，Xcode 11 还有着更好的自动补全、增加了新的 Theme，优化了一些细节体验