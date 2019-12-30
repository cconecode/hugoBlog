---
title: "Dart使用"
date: 2019-12-20T14:12:06+08:00
type: post
tags: ["Dart","Flutter"]
---

Dart 是 Google 开发的一门跨平台的客户端优化语言，Flutter 也是采用 Dart 进行开发的。下面结合 [Dart 官方文档](https://dart.dev/guides/language/language-tour)对 Dart 进行一个简单的学习和了解。

## 重要概念

在学习 Dart 之前，有些关于 Dart 语言的概念需要牢记在心：

* 所有可以放进变量中的东西都是**对象**，所有对象都是**类**的一个实例。包括数字、函数和 null，都是对象。所有对象都继承自 `Object` 类。
* 尽管 Dart 是强类型语言，但是类型标注是可选的，因为 Dart 可以进行类型推断。比如，数字可以推断为 `Int` 类型，当你想明确地说没有类型时，使用特殊类型 `dynamic`。
* Dart 支持泛型，比如 `List<Int>`(一个整数列表) 或 `List<dynamic>`(一个可以是任何类型对象的列表)。
* Dart 支持顶层函数，例如 `main()`，以及与类或对象相关的函数，分别是静态函数和实例函数。*顶层函数是指不属于任何类的函数*。
* Dart 支持顶层变量，以及与类和对象相关的变量，分别是静态变量和实例变量。实例变量有时候也称为字段或属性。
* Dart 没有 `public，protected，private` 等关键字，如果标志符以下划线 `_` 开头，那么对于它的 library，它是 `private`的。
* 标志符可以以小写字母或下划线开头，然后是这些字符加数字的任意组合。
* Dart 同时拥有表达式（有运行时值）和语句（没有运行时值）。

## 关键字

下面的表列出了 Dart 中的主要关键字：

|            |          |            |         |
| :--------: | :------: | :--------: | :-----: |
|  abstract  | dynamic  | implements |  show   |
|     as     |   else   |   import   | static  |
|   assert   |   enum   |     in     |  super  |
|   async    |  export  | interface  | switch  |
|   await    | extends  |     is     |  sync   |
|   break    | external |  library   |  this   |
|    case    | factory  |   mixin    |  throw  |
|   catch    |  false   |    new     |  true   |
|   class    |  final   |    null    |   try   |
|   const    | finally  |     on     | typedef |
|  continue  |   for    |  operator  |   var   |
| convariant | Function |    part    |  void   |
|  default   |   get    |  rethrow   |  while  |
|  deferred  |   hide   |   return   |  with   |
|     do     |    if    |    set     |  yield  |

避免使用以上关键字作为标识符。如果有必要的，下面这些关键字可以称为标识符：

* `show`, `async`, `sync`, `on`, `hide` 等这些为**上下文关键字**，仅在特定位置才有意义。所以它们在任何位置都是有效的标识符。
* `abstract`, `dynamic`, `implements`, `as`, `import`, `static`, `export`, `interface`, `external`, `library`, `factory`, `mixin`, `typedef`, `operator`, `covariant`, `Function`, `part`,  `get`, `deferred`, `set` 等是**内置标识符**，为了简化 Javascript 代码转换为 Dart 代码的任务。这些关键字在大多数地方是有效的，但它们不能被用于类名、类型名或 import 前缀。
* `await`, `yield` 是 Dart 1.0 版本之后添加的与异步支持相关的更新的有限保留字，不能再任何标有 `async`, `async*` 或 `sync*` 的函数体中使用它们作为标识符。

表中的其他关键字为保留字，不能作为标识符。

## 变量

下面是一个创建和初始化变量的例子：

```dart
var name = 'CC';
```

变量存储引用，名为 `name` 的变量包含了对值为 `CC` 的 `String`对象的引用。

`name` 变量的类型推断为 `String`，但可以通过指定其类型来改变。如果对象不限于单一类型，可以指定为 `Object` 或 `dynamic` 类型。

```dart
dynamic name = 'CC';
```

另一个选择是显式地声明类型：

```dart
String name = 'CC';
```

### 默认值

未初始化的变量有一个初始值为 `null`。尽管变量为数值类型，其初始也为 null，因为所有东西都是对象。

### final 和 const

如果从未想改变变量，那么使用 `final` 或 `const` 代替 `var`。一个 final 变量只能被 set 一次，一个 const 变量是一个编译期常量。一个 final 顶层变量或类变量在首次使用时被初始化。

> 实例变量可以为 final 但不能为 const，final 实例变量必须在构造体开始之前初始化。

对于想成为**编译时常量**的变量使用 `const`，如果 const 变量是类及的，使用 `static const`。

`const` 关键字不仅用于声明常量变量，还可以用于创建常量值，以及声明创建常量的构造函数。任何变量都可以用于常量值。

```dart
var foo = const [];
final bar = const [];
const baz = [];
```

可以改变非 final、非 const 变量的值，甚至它拥有 const 值：

```dart
foo = [1, 2, 3];
```

不能改变 const 变量的值：

```dart
baz = [42];
```

## 内置类型

Dart 语言支持以下类型：

* numbers
* strings
* booleans
* lists
* sets
* maps
* runes（用于在字符串中表示 Unicode 字符）
* symbols

因为 Dart 中所有的变量引用了一个对象——类的实例，所以经常可以使用构造函数初始化变量。一些内置类型有它们自己的构造函数。

### Numbers

Dart 中的 number 有两种形式：

**int**

整数值不超过 64 位，取决于所基于的平台。在 Dart VM 中，值可以从 $-2^{63}$ 到 $2^{63}-1$。编译为 Javascript 的 Dart 使用 Javascript numbers，取值范围从 $-2^{53}$ 到 $2^{53}-1$。

**double**

64 位的浮点数，IEEE 754 标准中所规定的。

`int` 和 `double` 都是 `num` 的子类型。num 类型包括基本操作，例如 +, -, / 和 *，在其他方法中，也可以找到 `abs()`, `ceil()` 和 `floor`。如果 num 和它的子类型没有你想要的方法，`dart:math` 库中可能有。

string 与 number 互转：

```dart
// String -> int
var one = int.parse('1');

// String -> double
var onePointOne = double.parse('1.1');

// int -> String
String oneAsString = 1.toString();

// double -> String
String piAsString = 3.14.toStringAsFixed(2);
```

int 类型有传统的按位位移、&、｜操作：

```dart
(3 << 1) == 6 // 0011 << 1 == 0110
(3 >> 1) == 1 // 0011 >> 1 == 0001
(3 | 4) == 7 // 0011 || 0100 = 0111
```

### Strings

Dart  中的 string 是 UTF-16 码元的序列，可以用单引号或者双引号创建一个字符串：

```dart
var s1 = 'string1';
var s2 = "string2";
```

可以用 `${表达式} `将表达式的值放在字符串中，如果表达式是一个标识符，可以省略 {}。为了获取与对象相应的字符串，Dart 调用对象的 `toString()` 方法。

```dart
var s = 'string expression';
var s1 = 'Dart has $s';
var s2 = 's.upper = ${s.toUpperCase()}';
```

可以使用 + 将两个字符串串联起来

```dart
var s = 'The operator + ' + 'is fine';
```

### Lists

在 Dart 中，数组是个 List 对象，所以大多数人称它为 lists。

```dart
var list = [1, 2, 3];
```

创建一个编译期常量 list：

```dart
var constantList = const [1, 2, 3];
// constantList[1] = 1;  // error
```

Dart 2.3 介绍了**展开操作符** `…` 和**可空的展开操作符** `…?`，为将多个元素插入到集合中提供了简洁的方式。

比如可以使用 `...` 将一个 list 中的所有元素插入到另一个 list 中：

```dart
var list = [1, 2, 3];
var list2 = [0, ...list];
// list2 == [0, 1, 2, 3];
```

如果展开操作符右边的表达式可能为 null，为了避免异常，可以使用可空的展开操作符 `...?`：

```dart
var list;
var list2 = [0, ...?list];
// list2 == [0];
```

Dart 2.3 也介绍了**集合 if** 和**集合 for**，可以通过 `if` 和 `for` 来构建集合。

下面是一个使用**集合 if** 创建有三个或四个元素的 list 的例子：

```dart
var list = [
	'Home',
	'Furniture',
	'Plants',
	if (condition is true) 'Outlet'
];
```

下面是使用**集合 for** 将列表中元素添加到另一个元素之前对其进行操作：

```dart
var listOfInts = [1, 2, 3];
var listOfStrings = [
	'#0',
	for (var i in listOfInts) '#$i'
];
// listOfStrings = ['#0', '#1', '#2', '#3']
```

### Sets

Dart 中的 set 是一个无序的每个元素都是独一无二的集合。

```dart
var names = {'Alice', 'Bob', "Celina"};
```

在类型参数前使用 {}，或将 {} 分配给 Set 类型的变量，用于创建空集合：

```dart
var names = <String>{};
Set<String> names = {};
// var names = {}; 用于创建 map 而非 set
```

使用 `add()` 或 `addAll()` 方法将元素添加到 set 中，用 `length` 获取 set 中元素的数量：

```dart
var elements = <String>{};
elements.add('Elia');
elements.addAll(names);
elements.length == 4;
```

Dart  2.3 之后，set 也支持展开操作符和可空的展开操作符。

### Maps

map 是一个键值对对象，key 和 value 都可以是任意类型。key 只能出现一次，value 可以多次使用。

使用 map 字面量创建 map：

```dart
var fruits = {
	'first': 'banana',
	'second': 'apple',
	'fifth': 'orange'
};

var months = {
	2: 'Feb',
	10: 'Oct',
	12: 'Dec'
};
```

使用 Map 构造函数创建 map：

```dart
var fruits = Map();
fruits['first'] = 'banana';
fruits['second'] = 'apple';
fruits['fifth'] = 'orange';

var months = Map();
months[2] = 'Feb';
months[10] = 'Oct';
months[12] = 'Dec';
```

Dart 2.3 之后，map 也支持展开操作符和可空的展开操作符。

## Functions

Dart 是一门真面向对象语言，所以连函数都是一个对象，而且拥有类型——Function。这也就意味着函数可以分配给一个变量或者在另一个函数中作为参数传递。

下面是一个函数实现的例子：

```dart
bool haveFruit(String index) {
	return _fruits[index] != null;
}
```

省略返回类型也是可行的：

```dart
haveFruit(String index) {
	return _fruits[index] != null;
}
```

如果函数只包含一个表达式，可以使用简写方式：

```dart
bool haveFruit(String index) => _fruits[index] != null;
```

`=> 表达式` 是 `{return 表达式; }` 的简写，`=>` 符号有时也称为箭头语法。

函数可以有两种类型的参数：必要的和可选的。首先列出必要的参数，然后列出所有可选参数。可选参数可以是命名参数或 位置参数。

### 可选参数

可选参数可以是命名参数或位置参数，都不能同时是。

#### 命名参数

当调用一个函数时，可以 `paramName: value` 的形式指定命名参数：

```dart
enableFlags(bold: true, hidden: false);
```

当定义函数时，使用 `{param1, param2, ...}` 的形式指定命名参数：

```dart
void enableFlags({bool bold, bool hidden}) {...}
```

虽然命名参数是可选参数的一种，但仍可以使用 `@required` 来标注它们，表示该参数是强制性的，即用户必须为这个参数提供值。

#### 位置参数

使用 `[]` 包裹函数的一组参数，以标记它们是可选位置参数：

```dart
String say(String from, String msg, [String device]) {
	var result = '$from says $msg';
	if (device != null) {
		result = '$result with a $device';
	}
	return result;
}
```

### 默认参数值

函数可以使用 `=` 来为命名参数和位置参数定义默认值，默认值必须为编译期常量。如果没有默认值提供，那么默认值为 `null`。

下面是一个为命名参数设置默认值的例子：

```dart
void enableFlags({bool bold = false, bool hidden = false}) {...}

// bold 为 true，hidden 为 false
enableFlags(bold: true)
```

下面是一个为位置参数设置默认值的例子：

```dart
String say(String from, String msg, [String device = 'iPhone', String mood]) {
	var result = '$from says $msg';
	if (device != null) {
		result = '$result with a $device';
	}
	if (mod != null) {
		result = '$result (in a $mod mod)';
	}
	return result;
}
```

也可以将 lists 或 maps 作为默认值传递：

```dart
void doStuff({List<int> list = const [1, 2, 3], 
							Map<String, String> gifts = const {
								'first': 'paper',
								'second': 'cotton',
								'third': 'leather'
							}}) {
	print('list: $list');
	print('gifts: $gifts');
}
```

### main() 函数

每个 app 必须要有顶层 `main()` 函数，用作 app 的入口点。`main()` 函数的返回值为 `void` 并且有一个可选 `List<String>` 参数作为参数。

### 函数作为第一类对象

可以将函数作为参数传递给另一个函数：

```dart
void printElement(int element) {
	print(element);
}

var list = [1, 2, 3];
list.forEach(printElement);
```

### 匿名函数

大多数函数都有名字，例如 `main()` 或 `printElement()`。也可以创建一个没有名字的函数，称为**匿名函数**，或者有时是 **lambda** 或**闭包**。

匿名函数跟有名字的函数看起来差不多，没有或多个参数，用逗号分隔，可选类型标注。

下面的代码块包含着函数主体：

```dart
([[Type] params1[, ...]]) {
	codeBlock;
};
```

下面的例子定义了一个有一个无类型参数 `item` 的匿名函数：

```dart
var list = ['apples', 'bananas', 'oranges'];
list.forEach((item)) {
	print('${list.indexOf(item)}: $item');
}
```

如果函数只包含了一条语句，那么可以使用箭头符号简化：

```dart
list.forEach((item) => print('${list.indexOf(item)}: $item'));
```

## 异常

Dart 代码可以抛出和捕获异常，与 Java 相反，Dart 中所有的异常都是未检查异常。方法不声明它们可能引发什么异常，并且不需要捕获任何异常。

Dart 提供了 `Exception` 和  `Error` 类型，以及许多预定义的子类型，也可以自定义自己的异常。Dart 程序可以捕获任何 non-null 对象作为异常，而不仅仅是 Exception 和 Error 对象。

### Throw

下面是一个抛出或引发异常的例子：

```dart
throw FormatException('Expected at least 1 section');
```

也可以抛出任意对象：

```dart
throw 'Out of llamas!';
```

因为抛出异常是一个表达式，所以可以使用 => 语句，以及允许表达式的其他任何地方：

```dart
 void distanceTo(Point other) => throw UnimplementedError();
```

### Catch

捕获异常会阻止该异常传播，除非再次抛出该异常，捕获异常给了用户一个处理它的机会：

```dart
try {
	breedMoreLlamas();
}on OutOfLlamasException {
	buyMoreLlamas();
}
```

为了处理可能引发一种以上类型的异常的代码，可以指定多个 catch 子句。第一个与抛出的对象类型匹配的 catch 子句处理异常，如果 catch 子句未指定类型，则该子句可以处理任何类型的抛出对象：

```dart
try {
	breedMoreLlamas();
}on OutOfLlamasException {
	// 一个指定的异常
  buyMoreLlamas();
}on Exception catch (e) {
  // 其他任何例外异常
  print('Unknown exception $e');
}catch (e) {
  // 未指定类型，处理所有
 	print('Something really unknow: $e');
}
```

在上面的代码中，可以使用 `on`、 `catch` 或者同时使用。当需要指定异常类型时，使用 `on` ；当异常处理需要异常对象时，使用 `catch`。

可以给 `catch()` 指定一个或两个参数。第一个参数是被抛出的异常，第二个参数是堆栈跟踪。

为了部分地处理异常，同时允许其传播，使用 `rethrow` 关键字：

```dart
void misbehave() {
  try {
    dynamic foo = true;
    print(foo++); // error
  } catch (e) {
    print('misbehave() partially handled ${e.runttimeType}');
    rethrow;
  }
}

void main() {
  try {
    misbehave();
  } catch (e) {
    print('main() finished handling ${e.runtimeType}');
  }
}
```

### finally

为了确保无论是否有异常抛出，一些代码都会执行，使用 `finally` 子句。如果没有 catch 子句与异常匹配，那么该异常会在 `finally` 子句执行完之后传播。

```dart
try {
  breedMoreLlamas();
} finally {
  // 总是会被执行，即使有异常抛出
  cleanLlamaStalls();
}
```

finally 子句会在任意 catch 子句之后执行：

```dart
try {
  breedMoreLlamas();
} catch (e) {
  print('Error: $e'); // 先处理异常
} finally {
  cleanLlamStalls(); // 再执行
}
```

## 类

Dart 是一门具有类和混合继承的面向对象语言。所有的对象都是一个类的一个实例，并且所有的类都来自 `Object`。混合继承意味着即使每一个类都有明确的父类，一个类主体可以在多个类层次结构中重用。`Extension`方法 是一种不需要改变类或创建子类就能给类添加功能的方式。

### 使用类成员

对象拥有成员，包括函数和数据。当调用一个方法时，是在对象上调用它，该方法可以访问该对象的函数和数据。

使用 `.` 来引用一个实例变量或方法：

```dart
var p = Point(2, 2);

p.y = 3; // 给实例变量 y 设置值
num distance = p.distanceTo(Point(4, 4)); // 调用 distanceTo() 方法
```

当最左边的操作数为 null 时，使用 `?.` 代替 `.`  来避免异常：

```dart
p?.y = 4; //如果 p 不为 null，那么设置它的 y 为 4
```

### 使用构造函数

可以使用构造函数创建对象，构造函数的名字可以是 `ClassName` 或 `ClassName.identifier`。

例如下面的代码，使用了 `Point()` 和 `Point.fromJson()` 构造函数创建 `Point` 对象：

```dart
var p1 = Point(2, 2);
var p2 = Point.fromJson({'x': 1, 'y': 2});
```

下面的代码有着同样的效果，但在构造函数名字前使用了可选的 `new` 关键字，在 Dart 2 之后，new 关键字变成了可选的：

```dart
var p1 = new Point(2, 2);
var p2 = new Point.fromJson({'x': 1, 'y': 2});
```

一些类提供了**常量构造函数**，在构造函数名字前加上 `const` 关键字，就可以使用常量构造函数创建编译期常量：

```dart
var p = const ImmutablePoint(2, 2);
```

在常量上下文中，可以在构造函数或字面量前面省略 `const`。下面的代码创建了一个 const map：

```dart
const pointAndLine = const {
	'point': const [const ImmutablePoint(0, 0)],
	'line': const [const ImmutablePoint(1, 10), const ImmutablePoint(-2, 11)],
};
```

也可以省略除了第一个 `const` 关键字之外所有其他的 const：

```dart
const pointAndLine = {
	'point': [ImmutablePoint(0, 0)],
	'line': [ImmutablePoint(1, 10), ImmutablePoint(-2, 11)],
};
```

### 获取一个对象的类型

可以使用 Object 的  `runtimeType` 属性来获取一个对象的运行时类型，这个属性返回一个 `Type` 对象：

```dart
print('The type of a is ${a.runtimeType}');
```

### 实例变量

下面的代码展示了如何声明一个实例变量：

```dart
class Point {
	num x;  // 声明了一个实例变量 x，初始化为 null
	num y; // 声明 y，初始化为 null
	num z = 0; // 声明 z，初始化为 0
}
```

所有的实例变量都会生成一个隐式的 getter 方法，非 final 的实例变量也会生成一个隐式的 setter 方法。

如果在一个实例变量声明的时候就对其进行了初始化，那么它的值会在实例创建的时候设置，在构造函数及其初始化列表执行之前。

### 构造函数

通过创建一个与类名相同的函数声明一个构造函数：

```dart
class Point {
	num x, y;
	
	Point(num x, num y) {
		this.x = x;
		this.y = y;
	}
}
```

`this` 关键字引用了当前实例。

#### 默认构造函数

如果没有声明构造函数，Dart 会有一个默认构造函数。默认构造函数没有参数并且会调用父类的无参数构造函数。

#### 构造函数不能继承

子类不能继承父类的构造函数，如果子类没有声明构造函数，那么它只有一个默认构造函数。

#### 命名构造函数

使用一个命名函数为类实现了多个构造函数：

```dart
class Point {
	num x, y;
	
	Point(this.x, this.y);	
	Point.origin() {
		x = 0;
		y = 0;
	}
}
```

#### 调用父类的非默认构造函数

一般地，子类会调用父类的无名字、无参数构造函数，父类的构造函数会在构造函数体的开头被调用。如果使用了初始化列表，它会在父类被调用之前执行。它们的执行顺序如下：

1. 初始化列表
2. 父类的无参构造函数
3. 主类的无参构造函数

如果父类没有一个无名字、无参数的构造函数，那么必须手动调用父类的一个构造函数。

#### 初始化列表

除了调用父类的构造函数，也可以在构造函数体运行之前初始化实例变量。使用逗号分隔初始化程序

```dart
// 初始化列表在构造函数体运行之前设置实例变量
Point.fromjson(Map<String, num> json)
	: x = json['x'],
	  y = json['y'] {
	print('In Point.fromJson(): ($x, $y)');	  
}
```

#### 重定向构造函数

有时候一个构造函数的主要目的是为了重定向到同一个类中的另一个构造函数。重定向构造函数的函数体为空，构造函数调用在冒号 `:` 后面。

```dart
class Point {
	num x, y;
	
	Point(this.x, this.y);
	Point.alongXAxis(num x) : this(x, 0);
}
```

#### 常量构造函数

如果一个类产生的对象永远不会改变，可以使这些对象为编译期常量。定义一个 `const` 构造函数并且确保所有的实例变量为 `final`，可以做到如此：

```dart
class ImmutablePoint {
	static final ImmutablePoint origin = const ImmutablePoint(0, 0);
	
	final num x, y;
	const ImmutablePoint(this.x, this.y);
}
```

#### 工厂构造函数

当一个构造函数并不总是创建这个类的一个新实例时，使用 `factory` 关键字来实现它。一个工厂构造函数可能会返回一个从缓存中的实例，或者返回一个子类的实例。

下面一个从缓存中返回实例的工厂构造函数：

```dart
class Logger {
	final String name;
  bool mute = false;
  
  static final Map<String, Logger> _cache = <String, Logger>{};
  
  factory Logger(String name) {
    return _cache.putIfAbsent{name, ()=>Logger._internal(name)};
  }
  
  Logger._internal(this.name);
}
```

### 方法

#### 实例方法

一个对象的实例方法可以访问实例变量和 `this`。

#### getters 和 setters

getters 和 Setters 是提供了对一个对象属性读写访问的特殊方法。可以使用 `get` 和 `set` 关键字实现 getters 和 setters 来创建额外的属性：

```dart
class Rectangle {
	num left, top, width, height;
  
  Rectangle(this.left, this.top, this.width, this.height);
  
  num get right => left + width;
  set right(num value) => left = value - width;
  num get botom => top + height;
  set bottom(num value) => top = value - height;
}

void main() {
  var rect = Rectangle(3, 4, 20, 15);
	rect.right = 12;
}
```

#### 抽象方法

实例方法、getter 和 setter 方法可以为抽象的，定义一个接口，但把具体的实现留给其他类。抽象方法只能存在于抽象类中。

```dart
abstract class Doer {
  void doSomething();
}

class EffectiveDoer extends Doer {
  void doSomethind() {
    // 提供具体的实现
  }
}
```

### 抽象类

使用 `abstract` 修饰符定义一个抽象类——一个不能被实例化的类。抽象类对于定义接口非常有用，通常会带有一些实现。如果想让抽象类看起来是可以被实例化的，定义一个工厂构造函数。

### 隐式接口

所有的类都隐式地定义了一个接口，包含了这个类所有的实例成员和任何它实现了的接口。如果想创建一个类 A 支持 B 的 API，但是不通过继承 B 来实现，类 A 应该实现 B 的接口。

一个类通过 `implements` 子句声明接口并且提供接口要求的 API 来实现一个或多个接口：

```dart
class Person {
	final _name;

  Person(this._name);
  
  String greet(String who) => 'Hello, $who. I am $_name';
}

class Impostor implements Person {
  get _name => '';  
  String greet(String who) => 'Hi $who. Do you knwo who I am?';
}

String greetBob(Person person) => person.greet('Bob');

void main() {
  print(greetBob(Person('Kathy')));
  print(greetBob(Impostor()));
}

```

### 拓展类

使用 `extends` 来创建子类，其 `super` 引用了父类：

```dart
class Television {
	void turnOn() {
		_illuminateDisplay();
    _activateIrSensor();
	}
}

class SmartTelevision extends Television {
  void turnOn() {
    super.turnOn();
    _bootNetworkInterface();
    _initializeMemory();
    _upgradeApps();
  }
}
```

#### 覆写成员

子类可以覆写实例方法、getter 和 setter，使用 `@override` 注解来表示覆写一个成员：

```dart
class SmartTelevision extends Television {
	@override
	void turnOn() {
	}
}
```

#### noSuchMethod()

当代码试图使用一个不存在的方法或实例变量时，可以通过覆写 `noSuchMethod()` 方法来查明或作出反应：

```dart
class A {
	@override
  void noSuchMethod(Invocation invocation) {
    print('tried to use a non-existent memeber : ${invocation.memberbName}');
  }
}
```

不能调用一个未实现的方法，除非下面有一种情况为真：

* 接收方有一个静态类型 `dynamic`。
* 接收方有一个静态类型，它定义了这个未实现的方法，并且接收方的动态类型具有 `noSuchMethod()` 的实现，该实现与来自 `Object` 的不同。

### 枚举类型

#### 使用枚举

使用 `enum` 关键字声明一个枚举类型：

```dart
enum Color { red, green, blue }
```

枚举中的每一个值都有一个 `index` getter，返回枚举中声明的值的位置，位置从 0 开始。例如，第一个值的 index 为 0，第二个值的 index 为 1。

使用枚举的 `values` 常量，可以获得一个枚举中所有值的列表：

```dart
List<Color> colors = Color.valuse;
colors[2] == Color.blue;
```

枚举类型有以下限制：

* 不能继承、mix in 或实现枚举。
* 无法显式实例化枚举。

### 给类添加功能：mixins

mixins 是一种在多个类层次结构中重用类代码的一种方式。

使用 `with`  关键字，后面接一个或多个 mixin 名字来使用 mixin。下面是一个两个类使用 mixin 的例子：

```dart
class Musician extends Performer with Musical {
  // ...
}

class Maestro extends Person with Musical, Aggressive, Demented {
  // ...
}
```

为了实现 mixin，创建一个 extend Object 的类并且声明为没有构造函数。除非想 mixin 成为一个 regular class，使用 `mixin` 关键字代替 `class`：

```dart
mixin Musical {
  bool canPalyPiano = false;
  bool canCompose = false;
}
```

为了指定只有确定的类才能使用该 mixin，用  `on` 来制定要求的父类：

```dart
mixin MusicalPerformer on Musician {
	// ...
}
```

### 类变量和方法

使用 `static` 关键字实现类范围的变量和方法。

#### 静态变量

静态变量对于类范围的状态和常量很有用：

```dart
class Queue {
	static const initialCapacity = 16;
}
```

静态变量直到使用的时候才被初始化。

#### 静态方法

静态方法不在一个实例上进行操作，因此也不能访问 `this`。

```dart
class Point {
  num x, y;
  Point(this.x, this.y);
  
  static num distanceBetween(Point a, Point b) {
    var dx = a.x - b.x;
    var dy = a.y - b.y;
    return sqrt(dx * dx + dy * dy);
  }
}
```

## 泛型

