---
title: "Swift中的访问控制"
date: 2020-07-25T22:46:36+08:00
type: post
slug: swift-access-control
tags: ["iOS", "Swift"]
summary: 每一种语言都有自己的访问控制，以实现代码封装。访问控制可以隐藏代码的实现细节，而对外提供一个接口进行访问和使用，从而保护我们的源码。Swift 也提供了自己的访问控制
---

每一种语言都有自己的访问控制，以实现代码封装。访问控制可以隐藏代码的实现细节，而对外提供一个接口进行访问和使用，从而保护我们的源码。

Swift 中的每种类型都可以有不同层级的访问权限，包括class、structure、enumeration，以及属于这些类型下的属性、方法、初始化值等。protocol 也可以限定于特定的上下文，全局常量、变量和方法也可以。

## Modules 和 Source Files

Swift 中的访问控制模型是基于两个概念：modules 和 source files。

module 是 Swift 中分发代码的一个单元——可能是一个 App 或者一个 framework。可以使用`import`关键字导入其他 module。

Xcode 中的每一个 build target 在 Swift 中都会被视作一个单独的模块。如果需要封装或复用代码，在多个 App 中使用，可以将代码组织成一个单一框架。当它被其他 App 导入或在另外一个框架中使用时，这个框架中所有定义的东西都会成为模块的一部分。

source file 是 module 中的单个 Swift 源代码文件，一个源文件可以包含定义不同的类型和方法等。

## 访问级别

Swift 提供了五种不同等访问级别：open、public、internal、file-private、private：

* open 和 public 级别的访问权限，可以在模块内的任一 source file 中访问所定义的实体，也可以在导入的另一模块中的 source file 中访问。当指定框架的公共接口时，一般使用 open 或 public 访问。
* internal 级别的访问权限，这个级别所定义的实体只能在同一模块的 source file 中访问，外部模块的 source file 不能进行访问。定义框架的内部结构时，一般使用这个权限。
* file-private 所定义的实体，只能在定义的 source file 中访问。file-private 一般用于整个文件所需要的功能，而将该功能的具体实现所隐藏。
* private 所定义的实体，只能在封闭的声明及在同一文件中该声明的 extension 所访问。private 一般用于仅单个文件需要的功能，将功能的具体实现隐藏起来。

open 是最高的访问级别，private 是最低的访问级别。

open 只用于类和类成员，与 public 不同，open 所修饰的实体，可以允许模块外的代码继承和覆盖。明确地将一个 class 标记为 open 时，需要考虑到该类作为其他模块的超类所带来的影响。

## 访问权限指南

Swift 的访问级别遵循以下原则：**不能用具有更低级别的另一实体定义任何实体，即访问级别统一性**。如：

* 一个 public 级别的变量，不能将它定义为 internal 、file-private 或 private 类型，因为这些类型可能在使用公共变量的所有地方都不能使用。
* 函数的访问级别不能高于其参数类型和返回类型。

下面是一些具体说明：

### 默认访问级别

如果不显式地指定实体的访问级别，那么它会有一个默认的访问级别——internal。

### 框架的访问级别

开发一个框架时，将其公开的接口定义为 open 或 public，使得其他模块可以访问。

## 访问控制语法

使用`open`、`public`、`internal`、`file-private`或`private`关键字来定义所对应的访问权限。

## 自定义类型

类型的访问级别控制会影响到类型成员（properties、methods 等）的默认访问级别。如：定义了一个类型为 file-private，那么它所有成员的默认访问级别都将是 file-private。

### 元组类型

元组类型的访问权限是该元祖中所使用的所有类型中最严格的访问权限。如：一个元组中有两种不同的类型，一个为 internal，一个为 private，那么这个元组的访问权限则为 private。

### 函数类型

函数类型的访问权限为函数的参数类型和返回类型中最严格的那个。如果计算出函数的访问权限与上下文的默认值不一样，则需要在函数定义时明确地指定其访问权限。

例如，下面代码定义了一个`someFunction`的全局函数，函数自身没有提供特定的访问权限修饰符。可能会期望它拥有一个默认访问权限——internal，但实际上，它并不会这样进行编译：

```swift
func someFunction() -> (SomeInternalClass, SomePrivateClass) {
  // implementation
}
```

这个函数的返回类型为一个元组，元组里面包含两个自定义的类，一个类定义为 internal，一个类定义为 private，根据计算，元组的访问权限为 private。因为函数的返回类型为 private，所以必须`private`修饰符标记该函数的整体访问级别，以使得函数声明有效：

```swift
private func someFunction() -> (SomeInternalClass, SomePrivateClass) {
	// implementation
}
```

如果使用`public`、`internal`或者默认的`interal`修饰这个函数，将会使得这个函数定义无效。

### 枚举类型

枚举中的每个 case 的访问权限都会自动跟枚举的一样，不能为每个 case 指定访问级别。

### 原始值和关联值

枚举中的原始值和关联值的访问级别必须至少与枚举的访问级别一样高。

### 嵌套类型

嵌套类型的访问级别与包含类型一致，除非包含类型为 public。当包含类型为 public 时，嵌套类型将会变成 internal。如果想要一个 public 类型的嵌套类型为 public，必须显式地声明嵌套类型为 public。

## 子类化

可以继承任何定义在同一模块中并且可以当前访问上下文访问的类，也可以继承任何在其他模块中的 open 类。子类的访问权限不能比其父类高。

对于在同一模块中的类，可以覆盖在特定访问上下文中可见的任一类成员（method、property 等）。如果类不在同一模块中，只能覆盖为 open 的类成员。

覆盖可以使继承类比它的父类具有更多种可能的访问权限。例如，A 类是一个 public 类，有一个 file-private 级别的方法——someMethod。B 类为 A 类的子类，它的访问级别为 internal。B 类可以覆盖 someMethod 方法，并将其访问级别修改成 internal，比原先的实现的访问级别更高：

```swift
public class A {
  fileprivate func someMethod() {}
}

internal class B: A {
  override internal func someMethod() {}
}
```

子类成员可以调用父类的成员，即使父类成员的访问级别比子类成员的低，只要对父类成员的调用发生在允许的访问级别上下文中（即，在同一源文件中，可以调用父类中的 file-private 成员，在同一模块中，可以调用父类中的 internal 成员）：

```swift
public class A {
  fileprivate func someMethod() {}
}

internal class B: A {
  override internal func someMethod() {
    super.someMethod()
  }
}
```

## 常量、变量、属性和下标

常量、变量和属性的访问级别不能比它的属性更高。在一个 private 类型中写一个 public 属性是无效的。

如果常量、变量、属性和下标使用了 private 类型，那么它们也必须标记为 private：

```swift
private var privateInstance = SomePrivateClass()
```

### Getters 和 Setters

常量、变量、属性和下标的 getters 和 setters 的访问级别与它们自身一样。可以给 setter 设置一个比其 getter 更低访问级别的权限，以限制变量的读写范围。使用`fileprivate(set)`、`private(set)`、或`internal(set)`的方式分配更低级别的访问权限。

下面是一个例子：

```swift
struct TrackedString {
  private(set) var numberOfEdits = 0
  var value: String = "" {
    didSet {
      numberOfEdits += 1
    }
  }
}
```

上面的`TrackedString`定义了一个叫`value`的 String 类型属性，及一个叫`numberOfEdits`的 Int 类型属性。因为 TrackedString 和 value 都没有显式地指定其访问级别，所以它们的访问级别为默认的 internal，numberOfEdits 属性的 setter 显式地设置为 private，它的 getter 则为默认的 internal。所以并不能在外部设置 numberOfEdits 的值，只能在 TrackrdString 内部进行设置，从而保护了 numberOfEdits 属性不会被外部污染。

## 初始化

自定义初始化方法可以分配一个比它们初始化类型更低或相同的访问级别，但是 required initializers 必须与它所属的类的访问级别相同。

与函数参数一样，初始化方法的参数不能比初始化方法的访问级别更低。

### 默认初始化方法

默认初始化方法与它们所初始化的类型的访问权限一致，除非这个类型定义为 public。如果一个类型定义为 public，那么它的默认初始化方法的访问级别会变成 internal。如果想要一个 public 类型在其他模块中使用的时候，有一个无参数的初始化方法，必须在类型定义的时候，显式地提供一个 public 的无参数初始化方法。

### 结构体类型的默认成员初始化方法

如果结构体中的任一存储属性为 private，那么它的初始化方法也为 private；如果结构体中任一存储属性为 file-private，那么其初始化方法也为 file-private。否则，它的初始化方法为 internal。

## Protocols

如果想给一个 protocol 显式地指定访问级别，需要在它定义的时候进行分配。给 protocol 分配访问级别，使得它只能特定的访问上下文中进行使用。

protocol 中的每个 required 方法的访问级别必须与 protocol 本身一致，这样可以确保任何类型在使用这个 protocol 的时候，它的所有 required 方法都是可见的。

### protocol 继承

当一个协议继承另一个协议时，它的访问级别最多与被继承的协议的访问级别一致。

### protocol 一致性

一个类型可以遵循一个访问级别比自身低的协议。例如，可以定义一个 public 类型，它可以在其他模块中使用，但是它遵循的 internal 协议，只能在协议定义的模块中使用。

## Extensions

extension 中添加的类型成员，它的默认访问级别与被扩展的类型本身的访问级别一致。如果扩展一个 public 或 internal 的类型，添加新的类型成员的默认访问级别为 internal；如果扩展一个 file-private 或 private 的类型，添加的新的类型成员的默认访问级别也为 file-private 和 private。

可以给 extension 添加修饰符，以设置一个新的默认访问权限，对于每个类型成员，依旧可以覆盖新的默认访问级别。

### Extension 中的私有成员

如果类、结构体和枚举的 extension 和它们在同一个文件中，那么 extension 中的行为就会作为原有类型的一部分声明。你可以：

* 在原始声明中声明一个私有成员，在同一个文件中的 extension 可以访问该成员。
* 在一个 extension 中声明一个私有成员，在同一个文件中的另一个 extension 访问该成员。
* 在一个 extension 中声明一个私有成员，在同一个文件中的原始声明可以访问该成员。

这种行为意味着可以使用 extension 以相同的方式组织代码，无论类型中是否有私有成员。