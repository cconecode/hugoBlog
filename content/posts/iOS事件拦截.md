---
 title: iOS 事件拦截
 date: 2016/07/20
 tags: ["事件拦截"]
 toc: true
 permalink: iOSEvent
 type: post
---

在项目中遇到一个需求，检测用户三分钟未点击屏幕，就出现广告轮播图。很自然的就联想到事件拦截了，然而之前对于 iOS 的事件机制并不是太过于了解，所以利用这次机会进行了深入学习。

# iOS事件机制
iOS 中的事件分为三类：触摸事件（单点、多点、手势），传感器事件（加速传感器）和远程控制事件（[官方文档](https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/Introduction/Introduction.html)），我们遇到情况是第一种也就是触摸事件的机制。

## 响应者链
当一个事件发生时，如果 first responder 不做处理，那么就会往下传递，如果下一个 responder 也不处理，那么就会继续传递到再下一个 responder 中，直到有一个 responder 处理或者没有 responder 了，如果没有 responder 处理这个事件，那么这个事件就被抛弃了。这些 responder 按照传递顺序连接起来就构成了响应者链。

iOS 中的响应者链：
![苹果官方关于响应者链的描述](https://lh3.googleusercontent.com/-6DVPdEbo12A/V48oTEjGXfI/AAAAAAAAAAk/Vn_s04cJOlk/I/14689996896970.jpg)

从图中我们可以观察到，响应者链有以下几个特点：

* 响应者链通常由 initial view 开始。

* View 的 nextResponder 是它的 superView，如果 View 已经是它所在的 ViewController 中的 top view，那么 next responder 就是它所在的 ViewConTroller。
* ViewController 如果有 superViewController，那么它的 nextResponder 就是它superViewController 最上面的 View。如果没有，那么它的 nextResponder 就是 Window。

* Window 的 nextResponder 指向 Application，Application 是整个响应者链的顶层，它的 nextResponder 指向 nil。也就是说当事件传递到 Application 不被处理的话就会被抛弃了。

由于 UI 的复杂性，整个响应者链是需要通过计算的，而计算顺序基本是与响应者链分发相反的。`无论哪种事件，都是系统本身先获得，再交给 UIApplication，由 UIApplication 决定交给谁去处理。` 关于事件分发的计算网上有很多文章，我就不赘述了。通过上述了解，我们可以得出一个结论：`如果我们需要拦截一个事件，最好的机会是在 UIApplication 里面。`
# 需求具体实现
## OC 版
根据上面的结论，我们目前的思路是继承 UIApplication，然后实现某一方法，进行事件拦截。根据查阅资料，重写 UIApplication 的 `sendEvent`方法可以达到目的，sendEvent介绍如下：

>  **sendEvent:**

> Dispatches an event to the appropriate responder objects in the application.

> 
```ObjectiveC
-(void)sendEvent:(UIEvent *)event
```
>  **Parameters**
> event
> A UIEvent object encapsulating the information about an event, including the touches involved.

> **Discussion**
> Subclasses may override this method to intercept incoming events for inspection and special dispatching. iOS calls this method for public events only.

具体代码实现：
1. 新建一个继承 UIApplication 的 CTApplication，重写 sendEvent 方法，并判断是否为触摸事件：

```ObjectiveC
#import "CTApplication.h"

@implementation CTApplication

- (void)sendEvent:(UIEvent *)event {

    if (event.type == UIEventTypeTouches) {
        if ([[event.allTouches anyObject] phase] == UITouchPhaseBegan) {

        }
    }
 [super sendEvent:event];
}

@end
```

2.由于需要检测用户多长时间没有点击屏幕，需要加一个定时器来进行倒计时，设置定时器的方法写在 CTApplication 的 init 方法中：

```ObjectiveC
#import "CTApplication.h"

/** 不点击屏幕的时间 */
static NSTimeInterval const showTime = 180;

@interface CTApplication ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CTApplication

- (instancetype)init {

    if (self == [super init]) {
        [self setTimer];
    }
    return self;
}
- (void)setTimer {

    self.timer = [NSTimer timerWithTimeInterval:showTime target:self selector:@selector(showPicture) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)showPicture {
	/** 在这里对广告轮播图进行设置 */
}
```

3.再回到 sendEvent 方法中，如果该方法被触发了，那么让定时器失效，重新开始定时：


```ObjectiveC
- (void)sendEvent:(UIEvent *)event {
    
    [super sendEvent:event];
    if (event.type == UIEventTypeTouches) {
        if ([[event.allTouches anyObject] phase] == UITouchPhaseBegan) {

            [self.timer invalidate];
            [self setTimer];
        }
    }
}
```
4.最后，在 main 函数中还要做对应的更改，替换 UIApplication 的调用：

```ObjectiveC
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CTApplication.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        return UIApplicationMain(argc, argv, NSStringFromClass([AppDelegate class]), NSStringFromClass([CTApplication class]));
    }
}
```


## Swift版
首先新建一个 UIApplication 的子类 CTApplication：

```Swift
import Foundation
import UIKit

class CTApplication: UIApplication {

    override func sendEvent(event: UIEvent) {

        super.sendEvent(event)
    }
}
```

由于 Swift 中没有 main 函数，所以需要自己手动建一个 main 函数，并设置入口：


```Swift
import Foundation
import UIKit

UIApplicationMain(Process.argc, Process.unsafeArgv, NSStringFromClass(CTApplication), NSStringFromClass(AppDelegate))
```

这时，Appdelegate 中的`@UIApplicationMain`会报错。下面是苹果官方对于`@UIApplicationMain`关键字的描述：

> Apply this attribute to a class to indicate that it is the application delegate. Using this attribute is equivalent to calling the UIApplicationMain function and passing this class’s name as the name of the delegate class.

> If you do not use this attribute, supply a main.swift file with a main function that calls the UIApplicationMain(::_:) function. For example, if your app uses a custom subclass of UIApplication
as its principal class, call the UIApplicationMain(::_:) function instead of using this attribute.

意思就是在类的最顶部声明 `@UIApplicationMain`，表示该类是Application 的 delegate，另外一种做法就是在 main.Swift 中调用 UIApplicationMain 函数，设置 delegate 和 application。而我们采取的是后面的办法，所以 delegate 冲突了，自然就会报错，只要把 Appdelegate 上的 `@UIApplicationMain` 关键字删除就可以了。剩下的操作与 OC 中的是一样的。

具体的代码上传到 github 上了：






