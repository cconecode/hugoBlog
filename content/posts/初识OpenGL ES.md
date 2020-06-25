---
 title: 初识 OpenGL ES
 date: 2016/08/29
 tags: ["OpenGL ES"]
 permalink: OpenGLES-1
 slug: opengles-1
 type: post
 summary: 在如今直播盛行，VR可能即将崛起的时代，OpenGL ES将会变得不可或缺。而OpenGL ES的学习曲线比较陡峭，所以写博文来记录学习过程。
---

在如今直播盛行，VR可能即将崛起的时代，OpenGL ES将会变得不可或缺。而OpenGL ES的学习曲线比较陡峭，所以写博文来记录学习过程，同时也希望能够帮助到一起想学习OpenGL ES的同学。由于能力尚浅，文中错误之处敬请指出，谢谢！


# 什么是OpenGL ES
> OpenGL ES（OpenGL for Embedded Systems）是 OpenGL 三维图形API的子集，针对手机、PDA和游戏主机等嵌入式设备而设计。该API由Khronos集团定义推广，Khronos是一个图形软硬件行业协会，该协会主要关注图形和多媒体方面的开放标准。

> OpenGL ES是从OpenGL裁剪定制而来的，去除了glBegin/glEnd，四边形（GL_QUADS）、多边形（GL_POLYGONS）等复杂图元等许多非绝对必要的特性。经过多年发展，现在主要有两个版本，OpenGL ES 1.x针对固定管线硬件的，OpenGL ES 2.x针对可编程管线硬件。OpenGL ES 1.0是以OpenGL 1.3规范为基础的，OpenGL ES 1.1是以OpenGL 1.5规范为基础的，它们分别又支持common和common lite两种profile。lite profile只支持定点实数，而common profile既支持定点数又支持浮点数。OpenGL ES 2.0则是参照OpenGL 2.0规范定义的，common profile发布于2005-8，引入了对可编程管线的支持。OpenGL ES 3.0于2012年公布，加入了大量新特性。              - - - - 维基百科

苹果官方文档中对于OpenGL ES的描述为：
OpenGL ES让App拥有了利用底层图形处理器的能力，iOS设备上的GPU可以执行复杂的2D和3D绘图，以及在最终图像上的每个像素的复杂着色计算。OpenGL ES是低级的、以硬件为中心的基于C的API，可以与iOS应用无缝集成。OpenGL ES规范没有定义窗口层，取而代之，当有任何绘图命令写入，主机操作系统必须定义一个方法来创建OpenGL ES`渲染上下文`，用来接受命令和帧缓冲。

# OpenGL ES基本概念

**坐标系**

<div align="center">
<img src="http://ooo.0o0.ooo/2016/08/29/57c3f86c6f12c.jpg" width="150" height="显示高度" alt="OpenGL ES坐标系"/>
</div>


由于OpenGL ES可以用来绘制2D和3D图形，所以它的坐标是一个三维坐标，如果应用只涉及到2D，那么可以不考虑Z轴。

**纹理坐标**


<div align="center">
<img src="http://ooo.0o0.ooo/2016/08/29/57c3fcfd8bfc2.jpg" width="150" alt="纹理坐标系">
</div>

一般OpenGL ES中的纹理坐标都是二维的，原点在左下角，与计算机中的图像坐标并不一致，二者的差别在于围绕横轴翻转180°。

**顶点数据&&索引**

顶点数据是一个数组，里面存的是顶点坐标。而索引则是顶点数组的对应的索引和串联关系。

```C
// 顶点数据
GLFloat squareVertexData[] = {
    0.5, -0.5, 0.0, //x,y,z
    -0.5, 0.0, 0.0,
    -0.5, -0.5, 0.0,
    0.5, 0.5, 0.0 
}

// 顶点索引
GLuint indices[] = {
    0, 1, 2,
    1, 3, 0
}
```

上面顶点数组里面的一行就代表了坐标系里面的x,y,z三个坐标系，代表了一个顶点的位置，里面总共包含了4个点。索引数组则是顶点数据的索引，每一行代表一个连接关系，从0-1-2，从1-3-0。

# EAGLContext

在使用OpenGL ES之前，必须初始化一个EAGLContext对象，并且将它设置为当前上下文


```ObjectiveC
// 初始化EAGLContext
EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]; 

// 设置为当前上下文
[EAGLContext setCurrentContext:context];
```

注意事项：

* 每个线程都会维护一个当前上下文。
* 设置了一个新的上下文，EAGL会释放当前上下文，并且获取新的上下文。
* 当在同一个线程中转换两个或者更多的上下文时，在设置一个新的上下文作为当前上下文之前，需要调用`glFlush`函数，确保之前的一些命令可以及时传递给图像硬件设备。

调用`glFlush`函数时需导入`OpenGLES/ES2/gl.h`框架。


```C
glFlush()
```

# GLKView

**GLKView介绍**

GLKView管理着OpenGL ES的基础，来提供绘制代码的地方。GLKView提供了基于OpenGL ES并等效于标准UIView的绘图生命周期。一个UIView实例自动配置图像上下文，所以`drawRect:`只需执行Quartz 2D绘图命令，GLKView实例自动配置本身，所以你的绘图方法只需执行OpenGL ES命令。GLKView通过维护一个保存着OpenGL ES绘图命令的帧缓冲对象来实现这一功能，一旦你的绘图方法完成，就会自动把结果呈现给Core Animation。

<div align="center">
<img src="http://ooo.0o0.ooo/2016/08/29/57c460e7a3f36.png" height=300 alt="通过GLKView渲染OpenGL ES内容">
</div>

**GLKView初始化方法**


```ObjectiveC
EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
[EAGLContext setCurrentContext:context];

//  使用代码初始化
//  GLKView *view = [GLKView alloc] initWithFrame:self.view.bounds context:context
    
//    使用Storyboard初始化
GLKView *view = (GLKView *)self.view;
view.context = context; // 关联上下文
    
view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888; // 颜色缓冲区格式
view.drawableDepthFormat = GLKViewDrawableDepthFormat24; // 深度缓冲区格式
view.drawableStencilFormat = GLKViewDrawableStencilFormat8; // 模型缓冲区格式
view.drawableMultisample = GLKViewDrawableMultisample4X; // 允许多重采样 (多重采样主要用于反锯齿，只对多边形的边缘进行抗锯齿处理，资源消耗较小，最常见的反锯齿), 如果允许了多重采样，必须测试性能
```

**GLKViewDelegate**


```ObjectiveC
// 渲染场景代码
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {

}

// 场景数据变化
- (void)update {

}
```

GLKView能够为OpenGL ES的绘制提供一个简单的界面，因为它管理着OpenGL ES渲染过程的部分标准：


* 在调用绘图方法之前，视图：
    * 使`EAGLContext`为当前上下文
    * 基于当前大小、比例因子和drawable属性（如果需要），创建帧缓冲对象和渲染缓冲区
    * 将帧缓冲对象作为绘图命令的当前目标
    * 设置OpenGL ES视图端口来匹配帧缓冲区大小


* 绘图方法执行完后，视图：
    * 解析多重采样缓冲区（如果允许多重采样）
    * 丢弃不需要的渲染缓冲区
    * 将渲染缓冲区内容交给Core Animation缓存和显示

参考：
    [OpenGL ES Programming Guide for iOS
 ](https://developer.apple.com/library/ios/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008793-CH1-SW1)



















