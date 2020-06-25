---
title: 从Heapsort与Mergesort看排序算法
date: 2019-12-03 10:28:26
tags: ["数据结构", "算法"]
permalink: fromHeapsortAndMergesortThinkSortAlgorithm
slug: sort-algorithm-heapsort-mergesort
type: post
summary: 排序是最基本也是最广泛的一种算法，很多非常高效的算法都需要经过排序预处理。如果有了排好序的数据，那么许多问题的解决将会变得非常简单。
---

排序是最基本也是最广泛的一种算法，很多非常高效的算法都需要经过排序预处理。如果有了排好序的数据，那么许多问题的解决将会变得非常简单，例如：

1. **搜索**。采用二分搜索算法会使得搜索非常快速，其时间复杂度是 $O(logn)$
2. **最近点对**。当数据是排好序时，最近点对必须按排序顺序彼此相邻，此时只要扫描列表就可以解决这个问题
3. **选择**。比如要确定数组中第 k 大的数据，如果数组是排好序的，只要确定第 k 个位置的数据。

## 算法设计之前

不过，在设计一个排序算法之前，以下问题是我们需要考虑的：

1. 数据是升序的还是降序的？
2. 对于复杂的数据记录，是否只针对某个 key 还是整个记录进行排序？
3. 当 key 相等时，应该怎么做？
4. 对于非数值数据怎么处理？

数据的升序降序要依据具体的需求进行设计，其中涉及到排序算法中的 compare 操作。对于复杂数据记录，也需要根据实际需求进行设计，比如一个用户列表，有 username、email、phone numbers，是只根据其中一个字段进行排序，还是对所有字段进行排序呢？所有字段排序的话以哪个为主呢？在设计排序算法之前，是需要非常明确的。

对于相等 key 的处理会涉及到排序算法的稳定性。排序算法的稳定性是指，可以保证排序前两个相等的 key 在序列中的前后位置顺序，和排序后它们两个的前后位置顺序相同。稳定性的好处是：如果排序算法是稳定的，那么从一个 key 上排序，然后再从另一个 key 上排序，第一个 key 排序结果可以为第二个所用。这里需要说明的是，这种好处有且只有用在一个复杂的数据记录上，且第一个 key 排序顺序存在意义，需要在第二次排序的基础保持这种意义。比较常见的，比如我们首先通过价格由高到低筛选商品，再由销量从高到低筛选商品，这个时候排序的稳定性才是有意义的。如果只是简单的数字排序，或者复杂数据中的某一个数字排序，排序的稳定性将变得可有可无。算法的稳定性由具体的算法决定，不稳定的算法在某种条件下可以变成稳定的。对于不稳定的算法，只需举出一个实例，就可证明它的不稳定性。而对于稳定的算法，则必须要经过分析才能得到稳定的特性。

对于非数值的数据，比如单词字母的排序，则需要一个严格的定义，关于大小写，关于标点符号的。同时也要求我们需要设计一个良好的 compare 函数。

## 排序算法的分类

常见的算法有：冒泡排序、选择排序、插入排序、希尔排序、快速排序、归并排序、堆排序。

冒泡排序、选择排序和插入排序都是非常直观的排序算法，直接将我们最直接的想法写成程序，这种程序也叫蛮力法。不需要过多的设计，把所有可能都列出来，然后一一比较。这种算法通常是有效的，但是不是高效的，其时间复杂度一般是 $O(n^2)$。一般写算法，我们可以先写出关于问题的蛮力算法，证明了问题是可解的，然后再分析需要优化的地方。

希尔排序则是插入排序的一种更高效的改进版本算法。是基于插入排序的以下两点特性而提出改进方法的：

1. 插入排序在对几乎已经排好序的数据操作时，效率很高，几乎可以达到线性时间。
2. 但插入排序一般来说是低效的，因为插入排序每次只能将数据移动以为。

希尔排序通过将比较的全部元素分为几个区域来提升插入排序的性能。这样可以让一个元素可以一次性朝最终位置前进一大步，然后再取越来越小的步长进行排序，算法的最后一步就是普通的插入排序，不过此时数据几乎已经是排好序的了，所以插入效率非常高。希尔排序主要的一点就是如何设计步长，步长的初始值以及递减的程度。关于这点网上有许多严密的论述，读者可以自行搜索阅读了解，这里不再做过多赘述。

快速排序、归并排序和堆排序都是非常高效的算法，也是使用比较多的排序算法。快速排序和归并排序采用的都是分治法的策略，把序列分为更小的序列进行处理。堆排序则是从数据结构的角度入手，通过优化存储的数据结构来构成一个高效算法。

下面我们将分别介绍堆排序和归并排序，看如何从数据结构以及算法设计策略两种不同的角度来改进算法，使其高效。数据结构是算法的基础，良好的数据结构可以使我们的算法设计事半功倍。分治法则是一种非常重要的算法思想策略，其核心思想，将实例分减成相同性质的更小规模的实例，然后处理小实例，最终把结果合并起来。与递归思想十分的相像。

## 堆排序

### 堆

我们一般讨论的堆是指二叉堆（下面统一由堆指称），其性质是：父节点的键值总是保持固定的关系于任何一个字节点的键值，且每个节点的左子树和右子树都是一个堆。二叉堆是完全二叉树或是近似完全二叉树。

> 完全二叉树：二叉树是每个节点最多只有两个子节点的树结构。在一棵二叉树中，除最后一层外，若其他层都是满的，并且最后一层是满的，或者最后一层的叶子结点都靠左排列，则此二叉树为完全二叉树。为什么是靠左排列呢？因为如果树是按顺序存储的，那么可以通过下标计算其左子节点和右子节点的位置，如果根用 1 表示，那么一个节点的左子节点可以通过 $2i$ 计算，右子节点则可以通过 $2i+1$ 计算。如果是放在右节点的话，则会造成存储空间的浪费。

#### 最大堆和最小堆

当父节点的键值总是大于或等于任何一个子节点的键值时，为最大堆。

当父节点的键值总是小于或等于任何一个子节点的键值时，为最小堆。

#### 堆的存储

堆一般用数组来表示，通过下标的计算来确定子节点或者父节点的位置。如果根节点在数组中的位置是 1，那么第 $n$ 个节点的左子节点的下标为 $2n$，右子节点的下标为 $2n+1$，其父节点的位置为 $n/2$。如果根是从 0 开始，那么左子节点和右子节点的位置分别是 $2n+1$ 和 $2n+2$，父节点的下标则是 $(n-1)/2$。

#### 插入新节点

在数组的最末尾插入新节点，然后自下而上调整子节点与父节点：比较当前节点与父节点，如果不满足堆性质则交换，从而使得当前子树满足堆的性质。

#### 删除根节点

对于最大堆，删除根节点就是删除最大值；对于最小堆，是删除最小值。然后把堆存储的最后那个节点移到根节点处。再从上而下调整父节点与它的子节点：比较当前节点与子节点，如果不满足堆性质，则交换二者，直至当前节点与它的子节点满足堆性质为止。

插入节点和删除根节点其实就是两个相反的操作。插入是在末尾插入，然后由下至上调整堆；删除根节点则是移除第一个节点，然后由上至下调整堆。

#### 构造堆

构造堆有两种方法：一种是从单节点的堆开始，依次插入新的节点。另一种是从节点任意放置的堆开始，自下而上对每一个子树执行堆的调整方法，使得当前子树成为一个满足堆性质的堆。

### 堆排序

堆排序其实就是利用删除根节点的操作原理来实现的。堆排序的第一步是将数组堆化（最小堆还是最大堆依据需求而定，降序采用最大堆，升序采用最小堆），第二步是对堆化数据排序，每次都是将根节点也就是数组第一个元素与尾部节点调换位置，同时将遍历的数组长度减 1，重新调整被换到根节点的元素，使当前堆满足堆性质。直到没有未排序的堆长度为 0。

上面的一些概念性定义比较抽象，下面我们通过代码来实现一个堆、堆的相关操作以及堆排序。语言采用的是 Swift：

```swift
struct Heap<Element> {
    var elements: [Element]
    let priorityFunction: (Element, Element) -> Bool
    var count: Int {
        return elements.count
    }
    
    init(elements: [Element] = [], priorityFunction: @escaping (Element, Element) -> Bool) {
        self.elements = elements
        self.priorityFunction = priorityFunction
        constructHeap()
    }
    
    mutating func constructHeap() {
        for index in (0 ..< count / 2).reversed() {
            siftDown(elementAtIndex: index)
        }
    }
    
  	// 自上而下调整堆
    mutating func siftDown(elementAtIndex index: Int) {
        let childIndex = highestPriorityIndex(for: index)
        if index == childIndex {
            return
        }
        swapElement(at: index, with: childIndex)
        siftDown(elementAtIndex: childIndex)
    }

  	// 自下而上调整堆
    mutating func siftUp(elementAtIndex index: Int) {
        let parent = parentIndex(of: index)
        guard !isRoot(index), isHigherPriority(at: index, than: parent) else {
            return
        }
        swapElement(at: index, with: parent)
        siftUp(elementAtIndex: parent)
    }
    
    // 父节点先与左子节点对比，再将结果与右子节点对比
    func highestPriorityIndex(for parent: Int) -> Int {
        return highestPriorityIndex(of: highestPriorityIndex(of: parent, and: leftChild(of: parent)), and: rightChild(of: parent))
    }
    
    // 父节点与子节点的大小比对
    func highestPriorityIndex(of parentIndex: Int, and childIndex: Int) -> Int {
        guard childIndex < count && isHigherPriority(at: childIndex, than: parentIndex) else {
            return parentIndex
        }
        return childIndex
    }
    
    // 两个节点是否满足堆性质
    func isHigherPriority(at firstIndex: Int, than secondIndex: Int) -> Bool {
        return priorityFunction(elements[firstIndex], elements[secondIndex])
    }
    
    // 交换两个元素
    mutating func swapElement(at firstIndex: Int, with secondIndex: Int) {
        guard firstIndex != secondIndex else {
            return
        }
        elements.swapAt(firstIndex, secondIndex)
    }
    
    func isRoot(_ index: Int) -> Bool {
        return index == 0
    }
    
    func leftChild(of index: Int) -> Int {
        return 2 * index + 1
    }
    
    func rightChild(of index: Int) -> Int {
        return 2 * index + 2
    }
    
    func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }
}
```

## 归并排序

归并排序则是一个采用分治法的典型算法，分治法是把一个复杂的问题分成两个或更多个性质相同的子问题，直到最后的子问题可以简单的直接求解，原问题的解即子问题的解的合并。体现在归并排序上则是分为两个步骤：

1. 分割：递归地把当前序列平均分割成两半
2. 合并：在保持元素顺序的同时将上一步得到的子序列合并到一起，即将两个已经排好序的序列合并成一个序列的操作

在实际实现上，我们也需要分成这两步进行求解。第一步递归地将数组平均分割，直到不能分割，即只有一个元素的序列。第二步则是如何将两个序列合并到一起，通过比较第一个和第二个序列中元素的大小，插入到结果序列中，如果其中一个序列中的元素已经取完了，则直接将另外一个序列中的所有元素拼接到结果序列中。代码实现如下：

```swift
func mergesort(nums: [Int]) -> [Int] {
		// base case：序列中的元素小于等于1		
  	if nums.count <= 1 { 
        return nums
    }
  	// 递归的将序列分割
    let m = nums.count / 2
    let left = Array(nums[0...m-1])
    let right = Array(nums[m...nums.count-1])
    var subLeft = mergesort(nums: left)
    var subRight = mergesort(nums: right)
  	// 将两个序列合并
    let result = merge(left: &subLeft, right: &subRight)
    return result
}

func merge(left: inout [Int], right: inout [Int]) -> [Int] {
    var result:[Int] = []
    while !left.isEmpty && !right.isEmpty {
      	// 如果左序列中的元素小于右序列中的元素，则把其加入到结果序列中，否则将右序列中的元素加入，如果是递减排序，则取相反操作
        if left[0] < right[0] {
            result.append(left[0])
            left.remove(at: 0)
        }else {
            result.append(right[0])
            right.remove(at: 0)
        }
      	// 如果一个序列中的元素取完了，则直接将另一个序列中的元素拼接到结果序列中
        if left.isEmpty {
            result += right
        }else if right.isEmpty {
            result += left
        }
    }
    return result
}
```

归并排序的重点在于对递归对理解，因为其思想跟递归的一样。归并排序高效的原因在于，其各层分治递归可以同时进行，即其每次处理的规模较大，同蛮力法每次只能处理一个规模的数据相比，速度自然要快得很多。

结语：对于同一个问题的处理，有着许多非常不同的高效的算法。我们可以通过构建更合理的数据结构，使得问题的处理变得更高效；也可以通过对问题的建模与分解，将复杂问题变成简单问题求解。堆排序和归并排序给我们分别提供了这两种处理问题的方式。对于同一问题的不同处理，也要求了我们对于数据结构与问题建模的有一定的理解，才能更灵活多变的解决问题，不拘泥于一种解决方案。对于问题的求解，如果没有类似的经验或者找不到处理的入口，则可以通过蛮力法先求解问题，再优化算法中处理较慢的那一部分。