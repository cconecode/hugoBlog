---
title: "OC中的mutable与immutable及它们的修饰符"
date: 2020-08-03T22:50:07+08:00
type: post
slug: oc-mutable-immutble
tags: ["iOS", "OC"]
summary: OC 中的对象有一个分类：**可变（mutable）**与**不可变（inmutable）**。比较常见的就是不可变 NSString、NSArray 和 NSDictionary，与可变的 NSMutableString、NSMutableArray 和 NSMutableDictionary。
---

OC 中的对象有一个分类：**可变（mutable）**与**不可变（inmutable）**。比较常见的就是不可变 NSString、NSArray 和 NSDictionary，与可变的 NSMutableString、NSMutableArray 和 NSMutableDictionary。

## 可变与不可变

可变与不可变对象的重要一个区分就是：**它本身是否是可变的**。它本身是否是可变的跟所引用它的对象是没有关系的，引用它的对象赋予新值的时候，只是改变了这个对象指针的所指。

例如，我们可以把一个 NSString 赋给一个对象，在这之后，这个对象的值可以改变。但是原先的 NSString 还会存在在内存中，对象值的改变只是在内存中重新分配了一个 NSString ，然后将这个对象的指针指向它：

```objective-c
NSString *name = @"John"
name = @"Tony"
```

在上面的例子中，name 首先分配了一个值 John。这个分配过程是，首先在内存中开辟了一块空间，然后这块空间中存储了 John 这个字符串，再将 name 指针指向它。再次改变 name 的值为 Tony 时，过程也是相同的。所以，在最后，内存中会有两个存储块，分别存储着 John 和 Tony。在这个过程中，我们看到的是 name 对象的指针的改变，John 和 Tony 字符串本身是不会有任何改变的，我们也改变不了它，因为它们都是“不可变对象”。

而 NSMutableString 不同的点在于：可以对字符串本身进行修改，可以增加字符串、删除或是替换字符串。无论对可变字符串进行任何操作，修改的都是同一块内存中的值，并不会分配新的内存。

所以，当需要频繁地对字符串进行修改时，如需要频繁地调用`stringByAppendingString`方法时，会产生比较大的性能问题。因为`stringByAppendingString`方法返回的是一个新的对象，频繁地创建新对象及分配内存是很消耗资源的。在这个时候，我们应该考虑使用 NSMutableString 对象了。

NSArrary 和 NSDictionary 及它们的子类可变的 NSMutableArray 和 NSMutableDictionary 的主要区别则更为明显：NSArray 和 NSDictionary 一旦初始化之后，它们的值是不能改变的，也就是不能删除或增加了，只能访问或者查询等。而它们的子类可变版的 NSMutableArray 和 NSMutableDictionary，则是可以改变的，都有着对应的增加或删除方法。从这个方面更为明显的可以看出可变对象与不可变对象的区别。

不可变对象可以保障多线程安全，因为本身不可变，所以多线程进行访问时，也不会造成任何问题，确保拿到的值都是一样的。可变对象则对于数据操作提供了很大的便利性，因为数据本身是可修改的，在需要对数据增删改查时，有着很大的帮助。

## 修饰符 copy 与 strong

在 OC 中，对于 NSString 和 NSArray 等类型的属性，一般都会 copy 去修饰，而不是用 strong，这是为什么呢？下面来看一个例子：

```objective-c
// Person.h
@property(copy, nonatomic) NSString *nameWithCopy;
@property(strong, nonatomic) NSString *nameWithStrong;

// main
Person *person = [[Person alloc] init];
NSMutableString *name = [NSMutableString stringWithFormat:@"Jony"];
person.nameWithCopy = name;
person.nameWithStrong = name;

NSLog(@"berfor: nameWithCopy: %@; nameWithStrong: %@", person.nameWithCopy, person.nameWithStrong); // Jony; Jony

// 修改 name 字符串
[name appendString:@".Tony"];

NSLog(@"after: nameWithCopy: %@; nameWithStrong: %@", person.nameWithCopy, person.nameWithStrong); // Jony; Jony.Tony
```

通过上面的例子，会发现使用 strong 修饰的字符串对象，如果将一个可变字符串赋值给它，当可变字符串改变时，strong 修饰的字符串也会发生改变。这是因为，使用 strong 修饰的话，nameWithStrong 和 name 会指向同一个对象，所以当 name 改变时，nameWithStrong 也会跟着改变。

使用 copy 修饰的话，其实是会在赋值之前，复制一个对象。nameWithCopy 指向的是一个新的复制出来的对象，所以无论 name 怎么改变，nameWithCopy 都不会跟着改变。

所以，当对一个有着可变子类的类型进行修饰时，会使用 copy 修饰符，是为了防止数据被意外改变。

但是，对于 NSMutableString 和 NSMutableArray 等可变对象，如果使用 copy 修饰符的话，则会发生意外。如果对于一个 NSMutableString 使用 copy 修饰，在赋值的时候会有一个警告；而对于一个 NSMutableArray 使用 copy 修饰，在调用 addObject 等方法时，则会直接 crash。这是因为，copy 的特性就是复制一个对象，对一个可变对象使用 copy 时，会复制出一个不可变对象，所以就会发生意外。

## 浅拷贝与深拷贝

其实，浅拷贝和深拷贝以及可变和不可变对象是没有什么联系的，只是它们在使用过程中，会造成一些疑惑，所以一般会把它们放在一起讨论。

浅拷贝指的就是地址的拷贝，不会产生新的对象，而是对原对象的引用计数 +1。而深拷贝，则是产生一个新的对象副本，和原对象有着相同的内容，但拥有自己的内存空间，是一个完全独立的新对象。

iOS 中的浅拷贝和深拷贝是调用对象的`copy`和`mutableCopy`方法。这两个方法都是继承自 NSObject 对象，在 NSObect 中，它们的实现分别是调用了`NSCopying`协议的`copyWithZone:`方法和`NSMutableCopying`协议的`mutableCopyWithZone:`方法。

首先，在官方文档中，对于`copyWithZone:`和`copyWithMutableZone:`方法，它们的返回类型分别是：当在讨论可变/不可变时，**copyWithZone 方法返回的是不可变的**；copyWithMutableZone 返回的是可变对象，**无论原对象可变与否**。

其次，copyWithZone 和 copyWithMutableZone 方法通常都是返回一个新的实例，即所谓的深拷贝。不同的地方在于，NSCopying 协议有一个特殊的情况：**当一个类和它的内容为不可变时，是将原对象本身 retain 一遍，即引用计数 +1，而非创建一个新的副本对象**。

所以，从返回对象的类型来看，copy 返回的是不可变对象，mutableCopy 返回的是可变对象。从原对象的拷贝类型来看：当一个不可变对象调用 copy 时，是浅拷贝，否则其他剩余情况，都是深拷贝。