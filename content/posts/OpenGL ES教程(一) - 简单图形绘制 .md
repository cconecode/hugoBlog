---
 title: OpenGL实战(一) - 简单图形绘制
 date: 2016/08/31
 tags: ["OpenGL ES"]
 permalink: OpenGLES-2
 slug: opngeles-2
 type: post
---

在[上一篇文章中](http://parisdog.club/OpenGLES-1.html)我们学习了OpenGL ES的一些基本概念，剩下的知识我们在实战中不断的补充，后续的文章会以代码+知识点+API解释的方式来写，同样的，如果有写的不好的地方，可以在评论中指出或者直接联系我

<!--more-->

# 渲染屏幕====

首先，将控制器继承自GLKViewController，并初始化一个GLKView，设置为它的View：


```ObjectiveC
// 直接把上篇文章的初始化方法copy过来

// 创建一个上下文，并设置为当前上下文
EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
[EAGLContext setCurrentContext:context];
    
//    使用代码初始化
//    GLKView *view = [GLKView alloc] initWithFrame:self.view.bounds context:context
    
//    使用Storyboard初始化
GLKView *view = (GLKView *)self.view;
view.context = context; // 关联上下文
```

只需在GLKView的代理方法`(void)glkView:(GLKView *)view drawInRect:(CGRect)rect`中，调用`glClear`的系列函数就可以用OpenGL ES对屏幕进行渲染了：


```ObjectiveC
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {

    glClearColor(1, 0, 0, 1); // 清理屏幕的RGB颜色和alpha值，这里我们设置成了红色
    glClear(GL_COLOR_BUFFER_BIT); // 调用glClear来实际执行清理操作, 参数是一个缓冲区，缓冲区有多种格式，上篇文章有提及，现在我们执行的是颜色缓冲区
}
```

现在来做一个酷炫的效果，让屏幕显示闪烁。当设置GLKViewController代理的时候，每一帧动画GLKViewController都会告诉我们，它会在1秒内多次调用`draw`方法，GLKViewController的代理中，我们可以在GLKViewController的代理方法`(void)glkViewControllerUpdate:(GLKViewController *)controller`方法来更新屏幕的颜色。

首先定义两个参数并初始化:


```ObjectiveC
@property (nonatomic, assign) CGFloat redColorFloat; // RGB中红色的色值
@property (nonatomic, assign, getter=isIncreasing) BOOL increasing; // 判断是否增加

self.increasing = YES;
self.redColorFloat = 0.0;
```

设定GLKViewController的刷新频率:


```ObjectiveC
self.preferredFramesPerSecond = 60;
```

更新`(void)glkView:(GLKView *)view drawInRect:(CGRect)rect`中的代码，在GLKViewController的代理方法中更新屏幕颜色:


```ObjectiveC
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {

    glClearColor(self.redColorFloat, 0, 0, 1); // 清理屏幕的RGB颜色和alpha值
    glClear(GL_COLOR_BUFFER_BIT); // 调用glClear来实际执行清理操作, 参数是一个缓冲区，缓冲区有多种格式，上篇文章有提及，现在我们执行的是颜色缓冲区
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller {
    
    if (self.isIncreasing) {
        self.redColorFloat += 1.0 * self.timeSinceLastUpdate;
    }else {
        self.redColorFloat -= 1.0 * self.timeSinceLastUpdate;
    }
    
    if (self.redColorFloat >= 1.0) {
        self.redColorFloat = 1.0;
        self.increasing = NO;
    }
    
    if (self.redColorFloat <= 0) {
        self.redColorFloat = 0;
        self.increasing = YES;
    }
}
```

这样就实现了屏幕黑红闪烁效果，Demo可以在[这里](https://github.com/cconecode/OpenGLESTutorials/tree/master/Tutorial1-ScreenRendering)找到。

# 绘制图形

现在我们来利用OpenGL ES绘制一个正方形。因为OpenGL ES只能渲染三角形，所以要用两个三角形来组成一个正方形。首先创建一组顶点数据和索引数据：


```ObjectiveC
// 顶点数据
    GLfloat verties[] = {
        0.5, -0.5, 0.0,  1.0, 0.0, 0.0, 1.0,   // 前面为x, y, z, 后面为颜色
        0.5, 0.5, 0,     0.0, 1.0, 0.0, 1.0,
        -0.5, -0.5, 0,   0.0, 0.0, 1.0, 1.0,
        -0.5, 0.5, 0,    0.0, 0.0, 0.0, 1.0
    };
    
    // 索引数据
    GLuint indecs[] = {
        0, 3, 2,
        1, 3, 0
    };
```

顶点数据中包括了顶点位置和对应的颜色，索引数据则是顶点数组的索引。然后我们需要向OpenGL ES发送数据和缓存数据：


```ObjectiveC
    glGenBuffers(1, &vertBuffer); // 创建缓冲区对象
    glBindBuffer(GL_ARRAY_BUFFER, vertBuffer); // 指定当前活动缓冲区对象
                                               // GL_ARRAY_BUFFER 坐标，颜色等
                                               // GL_ELEMENT_ARRAY_BUFFER 索引坐标
    
    // 把顶点数据从 CPU 复制到 GPU
    glBufferData(GL_ARRAY_BUFFER, sizeof(verties), verties, GL_STATIC_DRAW);
    // glBufferData(<#GLenum target#>, <#GLsizeiptr size#>, <#const GLvoid *data#>, <#GLenum usage#>)
    // target: 可以是GL_ARRAY_BUFFER(顶点数据)，或者GL_ELEMENT_ARRAY_BUFFER(索引数据)
    // size: 存储相关数据所需要的内存容量
    // data: 用于初始化缓冲区对象，可以是指向某一块内存地址，也可以是NULL
    //usage: 数据分配后如何读写，详细介绍见：http://parisdog.club/OpenGLES-2.html
    
    glGenBuffers(1, &indeBuffer); // 索引数据
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indeBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indecs), indecs, GL_STATIC_DRAW);
```

关于 usage 的一些说明：

* GL_STREAM_DRAW: 数据只指定一次，并且最多只有几次作为绘图和指定图像函数的源数据
* GL_STREAM_READ: 数据从 OpenGL 缓冲区复制过来，并且最多只有几次由应用程序作为数据值使用
* GL_STREAM_COPY: 数据从 OpenGL 缓冲区复制过来，并且最多只有几次作为绘图和指定图像函数的源数据
* GL_STATIC_DRAW: 数据只指定一次，但是可以多次几次作为绘图和指定图像函数的源数据
* GL_STATIC_READ:  数据从 OpenGL 缓冲区复制过来，并且可以多次由应用程序作为数据值使用
* GL_STATIC_COPY: 数据从 OpenGL 缓冲区复制过来，并且可以多次几次作为绘图和指定图像函数的源数据
* GL_DYNAMIC_DRAW: 数据可以多次指定，并且可以多次几次作为绘图和指定图像函数的源数据
* GL_DYNAMIC_READ: 数据可以多次从 OpenGL 缓冲区复制过来，并且可以多次由应用程序作为数据值使用 
* GL_DYNAMIC_COPY: 数据可以多次从 OpenGL 缓冲区复制过来，并且可以多次几次作为绘图和指定图像函数的源数据



在OpenGL ES2.0当中，无论渲染什么图形，都必须用到着色器。着色器是用类C语言-GLSL语言写的，如果想要自定义一个着色器，那么学习这门语言十分有必要。现在`GLKBaseEffect`这个类为我们提供了一些通用的着色器，在还没有掌握GLSL的情况下，我们目前可以使用它来帮我们实现效果：


```ObjectiveC
// 定义和初始化一个GLKBaseEffect实例对象
@property (nonatomic, strong) GLKBaseEffect *effect;

self.effect = [[GLKBaseEffect alloc] init];
// 可以设置 effect 的一些属性，配置光，转化等
```

最后在代理方法中启动着色器:


```ObjectiveC
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {

    glClearColor(0.3, 0.6, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // 启动着色器
    [self.effect prepareToDraw];
    glDrawElements(GL_TRIANGLES, self.count, GL_UNSIGNED_INT, 0);
}
```

这样我们就可以看到最终的效果了：

<div align="center">
<img src="http://ooo.0o0.ooo/2016/09/01/57c7eec495cab.jpg" width=200 alt="最终效果">
</div>

细心观察就会发现，我们想要的结果是一个正方形，现在出来的效果却是一个矩形，这是为什么呢？因为默认的，“Effect”的投影矩阵是一个单位矩阵，它不做任何变换，将场景（-1，-1，-1）到（1，1，1）的立文体范围的物体，投射到屏幕的X：-1，1，Y：-1，1。因此，当屏幕本身是非正方形时，正方形的物体将被拉伸，从而显示为矩形。所以我们要在`update` 中修改投影矩阵：


```ObjectiveC
- (void)update {
 
    CGSize size = self.view.bounds.size;
    float aspect = fabs(size.width / size.height);
    
    GLKMatrix4 projectMartix =    GLKMatrix4MakePerspective(GLKMathDegreesToRadians(130.0), aspect, 0.1, 10.0);
    // 第一个参数代表视角
    // 第二个参数代表比例
    // 第三个参数代表近平面距离
    // 第四个参数代表远平面距离
    
    self.effect.transform.projectionMatrix = projectMartix;
    
    GLKMatrix4 modelMatrix =     GLKMatrix4Translate(GLKMatrix4Identity, 0.0, 0.0, -1.0); // 修改 Z 轴的距离
    self.effect.transform.modelviewMatrix = modelMatrix;
}
```

最终通过这段代码就能得到我们想要的结果了：一个正方形（Demo 在[这里](https://github.com/cconecode/OpenGLESTutorials)）。在学习过程中，踩了很多坑，包括一开始的图像显示不出来，API 的意思也不明确。后来通过 Google 查阅相关资料，把一些 bug 解决了，同时也加深了对 OpenGL ES 的理解，学习到了很多的东西。上面的知识，在代码中我已经注释的很清楚了，如果有不懂的地方或者不正确的地方，欢迎指正交流~















