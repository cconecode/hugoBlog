---
title: "Swift相对于OC的特性"
date: 2020-08-15T14:20:48+08:00
type: post
slug: swift-oc
tags: ["iOS", "Swift"]
summary: Swift 在经过一段时间的发展，在 Swift5.0 ABI 稳定了，Swift 整个生态也比较丰富，使得可以在生产环境放心得使用 Swift 进行开发了。相对于 OC 繁琐的语法，以及外界不太认同的方括号调用，Swift 在语法层面及语言设计层面，显得更加 modern，开发起来也比较顺手
---

Swift 在经过一段时间的发展，在 Swift5.0 ABI 稳定了，Swift 整个生态也比较丰富，使得可以在生产环境放心得使用 Swift 进行开发了。相对于 OC 繁琐的语法，以及外界不太认同的方括号调用，Swift 在语法层面及语言设计层面，显得更加 modern，开发起来也比较顺手。唯一的成本就是由 OC 切换到 Swift 的重构成本了。

经过比较长一段时间的学习和使用 Swift，总结一下 Swift 和 OC 有着哪方面的不同，带来了哪些便利的特性，也方便由 OC 开发人员向 Swift 比较顺利的进行切换。在我看来，Swift 相比于 OC，主要有以下特性需要注意：Runtime、Function、Structure、Optional、Extension、Generic。下面我们逐一进行分析

## Runtime

在 OC 中，runtime 是一个实际的库，我们可以通过`#import <objc/runtime.h>`的方式导入并且使用它。runtime 给予了 OC 很多动态的特性：动态绑定、动态加载、动态解析、消息转发、KVC 和 KVO 等。通过这些特性，可以在运行时对代码进行修改，使用一些黑魔法简化代码，以及实现一些比较难的功能等。具体的对于 OC 的 runtime 分析，网上有很多的文章写得很全，可以查找学习。

在 Swift 中，纯 Swift 类的函数在编译期就已经确定了调用哪一个函数，Swift 本身是一个静态类型语言，所以也就不具备动态性。但是，由于 Swift 可以和 OC 混编，调用 OC 中的方法。所以，对于继承自 OC 的类，保留了其运行时动态的特性，可以利用 Runtime 机制动态获取属性和方法等。

在 Swift 中，如果没有显式地继承自 NSObject，都会隐式地继承 SwiftObject。SwiftObject 实现了 NSObject 协议的所有方法及一部分 NSObject 类的方法，主要是进行了重写，将方法实现改为 Swift 相关的。

如果想在 Swift 中利用 runtime，有两个关键字比较重要：`@objc`和`dynamic`。`@objc`关键字是想 Swift 代码在 OC 中可访问的，即将 Swift API 导出给 OC 用，`dynamic`关键字则是表明想在 Swift 中使用 OC 的动态分发。对于添加 @objc 修饰符的属性或方法，Swift 还是会将其优化成静态调用，所以无法将其动态地修改。而对于 dynamic 修饰的属性或者方法，会自动添加 @objc 修饰，并且具有了动态的特性，可以在运行时进行修改。

```swift
class MyClass {
  func swiftMethod() {}
  @objc func swiftAndOCMethod() {}
  dynamic func swiftDynamicMethod() {}
}
```

对于上面声明的三个方法，第一个是纯 Swift 方法，第二个可以在 OC 中访问这个方法，而第三个方法，则具有了 OC 的动态分发特性，可以利用 Runtime 机制进行动态绑定或方法交换等。

## Function

在 Swift 中，函数的地位被提升，变成了一等公民。我们可以将函数赋值给一个变量，也可作为参数进行传递，和将函数作为另一个函数返回类型。除此之外，还有着默认参数、可选的返回值等。

Swift 中的函数声明比较简单，主要由函数名称、参数、返回类型和函数体构成，其中参数和返回类型是可选的，如果没有的话可以为空：

```swift
func funcName(parameters) -> returnType {
  // 函数语句
}
```

### 函数的返回值

Swift 的函数可以有多个返回值，以元组作为其返回类型：

```swift
func minMax(array: [Int]) -> (min: Int, max: Int) {
  
}
```

元组返回类型也可以是可选的，即一个函数可以有返回值，也可以没有返回值，依据实际情况进行处理，声明一个有着可选元组返回类型的函数：

```swift
func minMax(array: [Int]) -> (min: Int, max: Int)? {

}
```

上面的 minMax(array:) 函数可以有返回值，也可以没有返回值

### 函数的参数名称和参数标签

Swift 中函数的参数都有参数名称（parameters name）和参数标签（arguments label），参数名称用于函数实现中使用，参数标签则用于函数调用的时候使用。默认情况下，参数标签等于参数名称：

```swift
func someFunction(firstParameter: Int, secondParameter: Int) {

}
```

上面这个例子中，firstParameter 和 secondParameter 既是参数名称也是参数标签。

也可以指定参数标签，参数标签写在参数名称之前，用空格分开：

```swift
func someFunction(argumentLabel parameterName: Int) {
  
}
```

在函数内部实现的时候，使用的是 parameterName，而在函数调用的时候，则是通过`someFunction(argumentLabel:)`的方式进行调用。

如果想忽略参数标签，则用`_`代替：

```swift
func someFunction(_ parameterName: Int) {

}
```

在函数调用的时候就会变成`someFunction(1)`的方式。

### 参数默认值

在函数声明的时候，可以给函数的参数提供默认值，如果在函数调用的时候，这个参数有传参，那么就使用传递过来的参数，如果没有传参，则使用函数定义时的默认值：

```swift
func someFunction(max: Int, min: Int = 5) {

}
```

上面这个例子中，max 参数没有默认值，必须由外部提供，而 min 参数有默认值，如果外部没有提供，则使用默认的值 5。`someFunction(max: 6, min: 3)` min 为 3，`someFunction(max: 6)` min 为 5。需要注意的是，在函数声明的时候，先将没有默认值的参数声明在前，有默认值的参数声明在后面。因为有默认值的参数调用的时候是可以忽略的，所以在函数调用的时候，这样的声明不会造成歧义。

### 可变参数

函数的参数还可以是**可变参数**，可变参数意味着函数的参数个数不确定，可能没有，也可能有多个。通过在函数参数类型后面加`…`来声明一个可变参数：

```swift
func someFunction(_ numbers: Double...) {

}
```

可变参数在函数体内可以当作一个有着适当类型的数组进行使用，如上面的例子中，numbers 参数在函数体内就变成了一个 [Double]  数组。

### 函数类型

每一个函数都有着特定的**函数类型**，由函数的参数类型和返回值类型构成：

```swift
func addTwoInts(_ a: Int, _ b: Int) -> Int {

}
```

如上面函数的函数类型是`(Int, Int) -> Int`，由它的两个参数的类型 Int 和返回值类型 Int 构成。

一个函数可以作为值，赋值给一个有着相同函数类型的变量：

```swift
var mathFunction: (Int, Int) -> Int = addTwoInts
```

上面的例子中，`addTwoInts` 作为一个值赋给了`mathFunction`变量，因为它们有着相同的函数类型。

有了函数类型，函数就可以当作是另一个函数的参数进行传递，也可以当作是另一个函数的返回值了：

```swift
// 函数作为参数进行传递
func mathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
	print(mathFunction(a, b))
}

// 函数作为返回值
func chooseStep(backward: Bool) -> (Int) -> Int {
  
}
```

函数作为返回值的时候可能会有点迷惑，因为有太多的`->`了，只要记住，函数中的第一个`->`后面的都是返回类型，就比较容易分辨了。比如上面的的例子中，第一个`->`后面的部分`(Int) -> Int`，就是一个传入类型为 Int、返回类型也为 Int 的普通的函数类型。

### defer 关键字

`defer`的作用在于：它所声明的 block 会在当前代码执行推出后被调用，也就是相当于提供了一种延时调用的方式。所以`defer`一般用于释放或销毁资源，如 FileHandle 的关闭等。不过需要注意的是，defer 的作用域是当前 scope，所以如果在函数中有 if 判断，if 中有 defer 操作，这个 defer 的作用域是 if 中的 scope，而非函数的 scope。也就是等 if 执行完之后，defer 马上会生效，而非函数执行完之后。在使用过程中一定要小心

## Structure

在 Swift 中，结构体提升到了与 Class 相同的地位。在 Swift 的结构体中，可以像 Class 一样定义属性和方法，使得它的功能性大大提升。结构体和 Class 主要相同点在于：

* 可以定义属性，用于存储值
* 可以定义函数
* 可以定义下标，提供以下标语法的方式访问它们的值
* 可以定义构造器，用于设置初始化状态
* 可以使用 Extension 拓展功能
* 可以遵守协议以提供一些标准功能

除此之外，Class 有着自己另外的功能，包括：

* 继承，可以从另一个类中继承一些特性
* 类型转换
* Deinitializers 允许类的实例释放所引用的资源
* 引用计数允许对一个类实例有多个引用

### 值类型与引用类型

结构体和 Class 最主要的区别就是，结构体是值类型的，而 Class 是引用类型的。值类型是指将值分配给一个变量或者常量，以及作为函数参数传递时，会将值复制一份然后传递。而引用类型则是传递的指针引用，是对相同实例的共同引用。也就是说，值类型赋值给另外一个变量的话，是完完全全的一个新对象，两个对象处于不同的内存块，对其中一个变量进行修改，不会影响另一个变量。引用类型由于传递的是指针引用，所以两个变量将访问同一块内存区域，对其中一个变量的修改，也会引起另外一个变量的改变。

下面用一个例子尝试说明一下：

```swift
struct Person {
  var name = ""
}
class Student {
  var person = Person()
  var address = ""
}
let person = Person(name: "John")
var tony = person
tony.name = "Tony"  // 此时 person 的 name 仍为 John，而 tony 的 name 则为 Tony，二者改变不会互相影响

let student = Student()
student.address = "1-01"
let otherStudent = student
otherStudent.address = "2-03" // student 和 otherStudent 的 address 都被修改为 2-03，因为它们所引用的是同一个对象
```

### mutating

由于结构体是值类型的，所以它的属性的值不能被实例方法所修改。如果想要在实例方法中修改属性的值，则需要使用`mutating`关键字来修饰函数：

```swift
struct Point {
	var x = 0.0, y = 0.0
	mutating func moveBy(x deltaX: Double, deltaY: Double) {
		x += deltaX
		y += deltaY
	}
}
```

## Optional

当一个变量的值可能为 nil 的时候，可以使用 optional 类型。optional 有两种声明方式，一种是在变量类型后面加`?`，另一种是使用`Optional`关键字：

```swift
let number: Int?
let number: Optional<Int>
```

当需要使用一个 optional 类型时，需要对其进行解包。主要解包的方式两种有：**可选绑定**和**无条件解包**

### 可选绑定

可选绑定主要有`if let`和`guard let`两种，它们在使用过程中也有一定的区别。首先看一看它们的语法：

```swift
// if let
let name: String?
if let unwrapValue = name {
  print(unwrapValue)
}else {
  print("name is nil")
}

// guard let
guard let unwrapValue = name else {
	print("name is nil")
  return
}
print(unwrapValue)
```

它们在语法上是比较相似的，但是执行逻辑却不一样。`if let`会检查 optional 类型的值是否为 nil，如果不为 nil，则将其赋给另一个变量，这个变量为解包后的值，然后执行语句块内的代码。如果值为 nil，则会执行 else 的判断。`guard let`则更像是一个断言，如果`guard let`内的条件判断为 false，则会执行`guard else`里面的代码，否则执行后面剩下的代码。

虽然都是将解包后的值赋给了一个新的变量，但是它们的作用域却不同。`if let`解包后的值只能在函数体内使用，`guard let`解包后的值的作用域与`guard let`是同等级的。

`guard let`后面还能使用`where`关键字对解包后的值作进一步的筛选，有着更强大的判断功能。`if let`只能判断它的值是否为 nil。

### 无条件解包

无条件解包用于确定知道 optional 类型一定有值，即不为 nil。在变量后面加`!`对 optional 类型进行无条件解包：

```swift
let name: String?
let unwrapValue = name!
```

在使用无条件解包的时候一定要谨慎，因为如果对一个 nil 进行无条件解包，会报一个运行时错误。

## Extension

Swift 中的 extension 和 OC 中的 category 比较相似，都可以用于在不知道源码的情下况扩展类的功能。与 category 不同的是，extension 是没有名字的。

extension 主要有以下功能：

* 添加计算属性
* 定义方法
* 提供新的构造器
* 使得原本的类遵循某个协议

## Generic

Swift 中的泛型是一个比较重要的特性，它使得我们可以写出更灵活、复用性更高的代码。泛型所解决的问题是：在编写程序时，会遇到某两个函数的功能非常类似，只不过处理的数据类型不同。如果没有泛型，则需要为每一种类型都定义一个方法，使得代码非常冗余。而泛型像是一个通用数据，在使用的时候才会确定它的具体类型。

Swift 中的泛型一般用`<占位符>`来声明，这个占位符一般会使用单个的字母`T`、`V`、`E`等。假设我们有一个函数，用于交换两个值。因为函数参数需要指定类型，如果不使用泛型，则需要为每一种类型都写一个函数。如`swapInt`、`swapString`等。使用泛型的话，只需要声明一个函数就够了：

```swift
func swapValue<T>(_ a: inout T, _ b: inout T) {
	//
}
```

在使用中，传入的类型将会替代掉声明中的`T`。

### 类型约束

为了确保代码的安全，可以使用类型约束使泛型的类型必须继承自某个类，或者遵守某个特定的协议。它的语法如下：

```swift
func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {

}
```

### 泛型好处

* 泛型是类型安全的，如果传入的是 Int 类型，则不能处理 String 类型
* 无需装包和解包，传入时类型已经确定，无需额外的装包和解包
* 无需类型转换