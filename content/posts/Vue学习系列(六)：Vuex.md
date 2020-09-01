---
title: "Vue学习系列(六)：Vuex"
date: 2020-07-20T22:39:13+08:00
type: post
slug: vue-vuex
tags: ["Web", "Vue"]
summary: Vue 文档学习第六篇——关于 Vue 中的状态管理模式：Vuex
---

Vuex 是 Vue 下的一个状态管理模式，采用集中式存储管理应用所有组件的状态。所谓集中式就是所有的状态都包含在一个“文件”中，而这个文件就是 Vuex 的核心——store。

Vuex 的核心思想就是把组件的共享状态抽取出来，通过一个全局单例进行管理。这种模式类似于数据结构里面的树，这样既可以维持状态间的独立，也可以访问树中任一位置，即可以在任一位置获取状态或触发行为。

状态管理的核心在于**状态**、**视图**、**行为**。首先我们有一个用户界面，就是状态管理中的视图。当用户在界面上有所操作，即触发了一个行为时，视图后面的数据将得到更新，即状态的更新，状态的更新也会导致视图的变化。三者之间的行为构成了状态的管理。其中的问题在于：一、当有多个视图依赖于同一状态的时候如何处理。二、来自不同视图的行为需要变更同一状态时的处理。而 Vuex 状态树的思想则可以解决上面的这两个问题。

Vuex 的核心概念主要是：**State**、**Getter**、**Mutation**、**Action**、**Module**。

## Vuex 思路

正如上面所提到的，Vuex 应用的核心就是 store。store 基本上是一个容器，里面包含着应用中大部分的状态。它和全局对象的主要不同之处有两点：

1. Vuex 的状态存储是响应式的。即若 store 中的状态发生变化，所对应的组件也会相应地立即更新。
2. 不能直接改变 store 中的状态。改变 store 中状态的唯一方法就是显式地**提交 (commit) mutation**。这样做的目的是方便跟踪每一个状态的变化。

Vuex 使用`new Vuex.Store({})`的方式声明一个 store，store 中管理着 state、mutation、module 等。state 中主要存储的是数据，mutation 中主要是对数据源更新的实现。在创建 store 之前，需要先声明`Vue.use(Vuex)` 。下面是一个简单的例子：

```js
const store = new Vuex.Store({
	state: {
		count: 0
	},
	mutation: {
		increment (state) {
			state.count++
		}
	}
})
```

创建完 store 之后，就可以通过`store.state`来获取状态对象，通过`store.commit`方法触发状态更新：

```js
store.commit('increment')
store.state.count
```

Vuex 还提供了一个从根组件向所有子组件，以`store`选项的方式注入一个 store。这样，所有的子组件都可以方便地访问`this.$store`：

```js
new Vue({
	store: store
})
```

## State

state 的作用是存储状态的，也就是所谓的数据。每个 Vuex 应用都只包含了一个 store 实例，也就是说所有的状态都存储在一个对象中。这样做的目的是为了能够直接地定位任一特定的状态片段，在调试的过程中也能轻易地获取整个当前应用状态快照。

### 状态读取

因为 Vue 的状态存储是响应式的，所以从 store 实例中读取状态的最佳方法是：在组件的 computed 中返回想要的状态：

```js
export default {
	computed: {
		count () {
			return store.state.count
		}
	}
}
```

在根组件以 store 选项注入 store 实例的时候，子组件可以通过`this.$store`访问到 store 实例。

### mapState 辅助函数

Vuex 提供了一个`mapState`辅助函数帮助我们生成计算属性，在一个组件需要读取多个状态时非常有用。因为可以简化 computed 中的重复和冗余：

```js
import { mapState } from 'vuex'

export default {
  computed: mapState({
    // 箭头函数简练代码
    count: state => state.count,
    // 传字符串参数 'count' 等同于 `state => state.count`
    countAlias: 'count',
    // 为了能够用 `this` 获取局部状态，必须使用常规函数
    countPlusLocalState (state) {
      return state.count + this.localCount
    }
  })
}
```

当计算属性的名称和 state 子节点的名称相同时，还可以给`mapState`传一个字符串数组：

```js
computed: mapState([
	'count'
])
```

### mapState 与对象展开运算符的结合

`mapState`函数返回的是一个对象，如果需要在局部计算属性中使用的话，会遇到一些麻烦。使用对象展开运算符则可以很方便地解决这个问题。

首先来说一说对象展开运算符，它比较常见的是用在数组当中，对数组中的元素进行展开。假设一个函数需要传递三个参数，可以把这三个参数放进一个数组中，然后在函数调用的时候，对数组进行展开：

```js
functio func(x, y, z) {
	//...
}
var args = [1, 2, 3]
func(...args) // ...args 将数组展开成 1, 2, 3，恰好对应到函数的三个参数
```

又或者可以将一个数组混合到另一个数组中：

```js
var a = [1, 2, 3]
var b = [0, ...a, 4, 5] // b = [0, 1, 2, 3, 4, 5]
```

同样地，也可以用在一个对象上：

```js
var x = {c: 3, d: 4}
var y = {a: 1, b: 2, ...x} // y = {a: 1, b: 2, c: 3, d: 4}
```

对象展开运算符可以将一个对象混入到另一个对象中。将对象运算符应用到`mapState`上，就可以和局部对象混合使用了。在没有使用对象展开运算符时，我们的局部对象也需要写在`mapState`中，有了对象展开运算符之后，局部对象和`mapState`就可以各自维护自己的数据了。

```js
computed: {
	localComputed { //... },
	...mapState({
		//...
	})
}
```

## Getter

Vuex 中的 getter 跟 Vue 中的 computed 类似，都可以允许我们对数据进行额外的操作。getter 的返回值也会根据依赖缓存起来，只有当它的依赖发生改变时才会被重新计算。

getter 接受 state 为它的第一个参数：

```js
new Vuex.Store({
  state: { //... }
  getters: {
    someTodo: state => {
      //...
    }
  }
})
```

getter 也可以接受其他 getter 作为它的第二个参数：

```js
getters: {
	//...
	otherTogo: (state, getters) => {
		// ...
	}
}
```

可以通过`store.getters`访问 getter 对象，并以属性的形式访问其中的值：

```js
store.getters.someTodo
```

除此之外，还可以通过让 getter 返回一个函数，来实现给 getter 传参。在对 store 里的数组进行查询时非常有用：

```js
getters: {
	getTodoById: (state) => (id) => {
		return state.todos.find(todo => todo.id === id)
	}
}
```

需要注意的是，**通过方法访问 getter 时，每次都会进行调用，而不会缓存结果**。

### mapGetters 辅助函数

同 state 一样，getter 也有一个辅助函数`mapGetters`。`mapGetters`辅助函数的作用仅仅是将 store 中的 getter 映射到局部计算属性：

```js
import { mapGetters } from 'vuex'

export default {
	computed: {
    ...mapGetters([
      'someTodo',
      'otherTodo'
    ])
  }
}
```

也可以给`mapGetters`传一个对象，将 getter 属性取一个子组件中的别名：

```js
...mapGetters({
	doneTodo: 'someTodo'
})
```

## Mutation

上面说到过，更改 store 中的状态的唯一方法就是显式地提交 mutation。而 mutation 本身是一个**事件类型（type）**和一个**回调函数（handler）**，回调函数就是状态更改的具体实现，这个回调函数接受 state 为它的第一个参数：

```js
new Vuex.Store({
	mutations: {
		increment (state) {
			//...
		}
	}
})
```

注意的是，不能直接调用一个 mutation 回调函数，而是需要触发一个 mutation type，调用此函数。而触发的方法就是用相应的 type 调用`store.commit`方法：

```js
store.commit('increment')
```

可以用 mutation 的 payload 当作额外的参数进行传入，这样 store.commit 的时候，就可以进行传参了：

```js
mutations: {
	increment (state, n) {
		//...
	}
}

store.commit('increment', 10)
```

在大多数情况下，payload 会是一个对象：

```js
mutations: {
	increment (state, payload) {
		// payload.property
	}
}

store.commit('increment', {count: 10})
```

还可以以对象风格提交 mutation，这时，对象中必须包含`type`属性，对象中的 type 对应 mutation 的 type：

```js
store.commit({
	type: 'increment',
	count: 10
})
```

### Mutation 需要遵守的规则

mutation 需要遵守以下注意事项：

1. 最好提前在 store 中初始化好所有属性

2. 当需要在对象上添加新属性时，应该

   * 使用`Vue.set(obj, 'newProp', 123)，或者

   * 以新对象替换老对象

   ```js
   state.obj = {...state.obj, newProp: 123} // 这里的对象展开运算符类似深拷贝
   ```

### Mutation 必须是同步函数

有一条重要的原则就是 **mutation 必须是同步函数**。如果是异步的，那么回调函数中的状态变更是不可追踪的，不知道回调函数将会在什么时候被调用。

### 使用常量类型替代 mutation 事件类型

将 mutation 的事件类型用常量进行替代，并且放在同一文件中进行管理。这样做可以使得对整个应用中的 mutation 一目了然，更好地组织项目结构，同时也有利于 linter 之类的工具发挥作用：

```js
// mutation-type.js 用来存放 mutation 事件类型
export const MUTATION_A = 'MUTATION_A'
```

```js
import { MUTATION_A } from './mutation-type.js'

new Vuex.Store({
	mutations: {
		[MUTATION_A] (state) {
			//...
		}
	}
})
```

### mapMutations 辅助函数

mutation 也有一个辅助函数——`mapMutations`。它的作用是将组件中的`this.$store.commit('xxx')` 映射成组件中的 methods：

```js
import { mapMutations } from 'vuex'

export default {
  methods: {
    ...mapMutations([
      'increment' // 将 `this.increment` 映射为 `this.$store.commit('increment')`
    ])
  }
}
```

## Action

Action 类似于 mutation，不同的点在于：

* Action 提交的是 mutation，而不是直接变更状态
* Action 可以包含任意异步操作

下面是一个简单的 action：

```js
new Vuex.Store({
	mutations: {
    increment (state) {
      //...
    }
  },
  actions: {
    increment (context) {
      context.commit('increment')
    }
  }
})
```

action 函数接受一个与 stoer 实例具有相同属性和方法的 context 对象，所以可以通过`context.commit`提交一个 mutation，或者通过`context.state`来获取状态。

此外，在实践中，会经常用到[参数解构](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)来简化代码：

```js
actions: {
	increment({ commit }) {
		commit('increment')
	}
}
```

### 分发 Action

Action 通过`store.dispatch`方法触发：

```js
store.dispatch('increment')
```

表面看上去与 mutation 没有什么区别，主要是 action 内部可以执行异步操作，而 mutation 必须是同步的：

```js
actions: {
	incrementAsync({ commit }) {
		setTimeout( () => {
			//...
		}, 1000)
	}
}
```

Action 同样支持 payload 和对象方式进行分发：

```js
// 以 payload 方式分发
store.dispatch('increment', {count : 10}) 

// 以对象方式进行分发
store.dispatch({
	type: 'increment',
	count: 10
})
```

### 在组件中分发 Action

可以在组件中使用`this.$store.dispatch('xxx')`分发 action，也可以使用辅助函数`mapActions`将组件中的 methods 映射为`store.dispatch`调用：

```js
import { mapActions } from 'vuex'

export default {
  methods: {
    ...mapActions([
      'increment' // 将 `this.increment` 映射为 `this.$store.dispatch('increment')`
    ])
  }
}
```

## Module

当应用变得庞大，状态越来越多时，将所有状态放到一个 store 对象中，就会显得非常臃肿且难以管理。为了解决这个问题，Vuex 提供了 modules 选项，可以将 store 划分成多个细小的 module，每个 module 都拥有自己的 state、mutation、action、getter：

```js
const moduleA = {
	state: () => ({ ... }),
	mutations: { ... },
	actions: { ... },
	getters: { ... }
}

const store = new Vuex.Store({
	modules: {
		a: moduleA
	}
})

store.state.a // 模块 A 的状态
```



### 模块的状态

对于模块内部的 mutation 和 getter，回调函数接收的第一个参数是模块的**局部状态对象**。

```js
const moduleA = {
	mutations: {
		increment (state) {
			// state 对象是模块的局部状态
		}
	}
}
```

对于模块内部的 action，局部状态通过`context.state`暴露，根节点状态则为`context.rootState`：

```js
const moduleA = {
	actions: {
    increment({ state, commit, rootState}) {
      //...
    }
  }
}
```

对于模块内部的 getter，根节点状态会作为第三个参数传进来：

```js
const moduleA = {
	getters: {
		increment(state, getters, rootState) {
			//...
		}
	}
}
```

### 命名空间

默认情况下，模块内部的 action、getter 和 mutation 是注册全局命名空间的，这样可以使得多个模块能够对同一 mutation 或 action 作出相应。

通过添加`namespaces: true`，可以使一个模块称为带命名空间的模块。当模块注册后，它的 getter、mutation 和 action 都会自动根据模块注册的路径调整命名：

```js
const store = new Vuex.Store({
	modules: {
		account: {
			namespaced: true
      
      mutations: {
      	addAcount() { ... } // 通过 commit('account/addAcount') 提交
    	}
		}
	}
})
```

模块内部会收到局部化的 getter、dispatch 和 commit，不需要在同一模块内部额外添加命名空间。

#### 在带命名空间的模块内访问全局内容

在模块内的 getter 中，全局的 state 和 getter 将通过函数的第三个和第四个参数以`rootState`和`rootGetters`参数名进行传递。

如果需要在模块内分发全局 action 或提交全局 mutation，将`{root: true}`作为第三个参数传递给 dispatch 或 commit 即可。

```js
modules: {
	foo: {
    namespaced: true,
    getters: {
      someGetter (state, getters, rootState, rootGetters) {
        //...
      }
    },
    actions: {
      someAction ({ dispatch, commit, getters, rootGetters }) {
        dispatch('someGlobalAction', null, { root: true }) // 分发全局 action
        commit('globalMutation', null, { root: true }) // 提交全局 mutation
      }
    }
  }
}
```

#### 带命名空间的辅助函数

当在组件中使用带命名空间模块的`mapState`、`mapGetters`、`mapActions`和`mapMutations`时，写起来可能会比较繁琐：

```js
computed: {
	...mapState({
    a: state => state.some.nested.module.a,
    b: state => state.some.nested.module.b
  })
},
methods: {
  ...mapActions([
    'some/nested/module/foo',
    'some/nested/module/bar'
  ])
}
```

对于这种情况，可以将模块的路径字符串作为第一个参数传递给这些辅助函数，这样自动将该模块作为上下文，简化代码：

```js
computed: {
  ...mapState('some/mested/module', {
    a: state => state.a,
    b: state => state.b
  })
},
methods: {
  ...mapActions('some/nested/module', [
    'foo',
    'bar'
  ])
}
```

或者，可以通过使用`createNamespacedHelpers`创建基于某个带有命名空间模块的特定辅助函数，函数的返回值是一个将模块作为上下文的绑定辅助函数：

```js
improt { createNamespcedHelpers } from 'vuex'

cons { mapState, mapActions } = createNamespacedHlepers('some/nested/module')

export default {
	computed: {
    ...mapState({
      // 在 `some/nested/module` 中查找
      a: state => state.a,
      b: state => state.b
    })
  },
  methods: {
    ...mapActions([
      // 在 `some/nested/module` 中查找
      'foo',
      'bar'
    ])
  }
}
```

### 动态注册模块

在 store 创建之后，可以使用`store.registerModule`方法动态注册模块：

```js
const store= new Vuex.Store({ //...})

  // 注册模块 `myModule`
store.registerModule('myModule', {
  //...
})

// 注册模块 'nested/myModule'
store.registerModule(['nested', 'myModule'], {
  //...
})
```

也可以通过`store.unregisterModule()`方法来动态卸载模块。此方法只能卸载动态模块，而不能卸载静态模块。

通过`store.hasModule()`方法检查该模块是否已经被注册到 store 中。