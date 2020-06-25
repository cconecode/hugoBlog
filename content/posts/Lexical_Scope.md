---
title: "Lexical Scope"
date: 2020-06-25T23:20:35+08:00
tags: ["web", "JS"]
slug: lexical_scope
type: post
summary: 最近在学习 JS，在看《JavaScript 权威指南》的时候看到 `JavaScript uses lexical scoping`，当时只以为是 JS 的一个语言特性而已，就没太注意。但看到后面却发现，这个特性与 JS 的 `Closure` 也就是闭包大有关联。于是，就想弄懂究竟什么是 `lexical scoping`。
---

最近在学习 JS，在看《JavaScript 权威指南》的时候看到 `JavaScript uses lexical scoping`，当时只以为是 JS 的一个语言特性而已，就没太注意。但看到后面却发现，这个特性与 JS 的 `Closure` 也就是闭包大有关联。于是，就想弄懂究竟什么是 `lexical scoping`，在 [Stackoverflow](https://stackoverflow.com/questions/1047454/what-is-lexical-scope) 上我找到了答案。

`lexical scoping`还有另一个名字，叫做 `static scoping`，也就是**静态作用域**。如给出以下代码：

```c
void test() {
    int x = 10;
    
    void test2() {
        print(x);
    }
}
```

对于上面的代码，其结果输出为 10。根据这段代码，可以给出 `lexical scoping` 的定义为：**每一个内部函数都可以访问其外部函数的内容。**

与 `lexical scoping` 相对应的就有 `dynamic scoping` ，即**动态作用域**。同样地，给出如下代码：

```c
void test() {
    print(x);
}

void dynamic1() {
    int x = 5;
    test();
}

void dynamic2() {
    int x = 10;
    test();
}
```

在上面代码中，`test()` 可以分别从 `dynamic1` 或 `dynamic2` 中访问 `x`。即当调用 `dynamic1()` 时，会输出 5；当调用 `dynamic2()` 时，会输出 10。

在第一个例子中，其结果在编译期间就可以推断出，所以称为 `static`。而在第二个例子中，其结果则取决于调用链，而调用链取决于运行时条件，所以称为 `dynamic`。

通过`lexical scoping ` ，也可以比较好的去理解 `Closure` ：**内部函数包含了外部函数的作用域，即使外部函数已经 return**。