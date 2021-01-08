# Kotlin 开发工具集提供了[标准函数](https://kotlinlang.org/docs/reference/scope-functions.html#functions),标准函数是指`Standard.kt`中的函数

## T.let() (T表示调用对象)

let 是内置函数:提供了函数式Api接口编程,会将原始调用对象传递给Lambda表达式中

源码实现是将block()返回而代码会返回R类型,也就是支持数据返回

`let`函数 通常 结合 `?.`进行辅助非空逻辑判断

```kotlin

    /**
    * Calls the specified function [block] with `this` value as its argument and returns its result.
    */
    @kotlin.internal.InlineOnly
    public inline fun <T, R> T.let(block: (T) -> R): R {
        contract {
            callsInPlace(block, InvocationKind.EXACTLY_ONCE)
        }
        return block(this)
    }

    // 测试
    open class Person(val name:String){
        fun eat(){
            println("eat() ...")
        }    
    }
   
    fun main(){
        val person = Person("张三")
        val name = person?.let {   // 当person != null 调用内部方法
            it.eat()
            it.name
        }
        println(name)
    }
```

## T.apply() (T表示调用对象)

特点: 可以扩展操作数据对象,直接使用对象数据的方法

先看源码实现: 调用者T调用该函数后传入lamba其实就是block(),然后在返回调用对象this,相当于builder模式,所以apply()函数没有外部返回值

```kotlin
    
    /**
    * Calls the specified function [block] with `this` value as its receiver and returns `this` value.
    */
    @kotlin.internal.InlineOnly
    public inline fun <T> T.apply(block: T.() -> Unit): T {
        contract {
            callsInPlace(block, InvocationKind.EXACTLY_ONCE)
        }
        block()
        return this
    }

    // 测试:
    val fruits = mutableListOf<String>("apple","banana","pear")
    fruits.apply { 
        this.add("orange")  
        remove("apple")     // 当前对象是fruits,可以省略this
    }
    println(fruits.size)

    val intent = Intent().apply {
            putExtra("key","values")
            putExtra("key","value")
    }
    startActivity(intent)

    // 因为是返回this,所以下面的写法是正常运行的
    val content = "Hello,world !!"
    content.apply { println("first") }.apply { println("second") }.apply { println("third") }
    println("${content.length}")
```

## T.also() (T表示调用对象)

> 原则上`also()`函数和`apply()`的用法与作用完全相同,只不过是在表达式内部引用单前对象的方式有差异

看源码的差异在于`apply`直接调block代码块,在实现业务表达式直接使用当前`this`,而`also`是调block代码块的同时把`this`传递给了block,在实现业务表达式需要使用`it`

```kotlin
    
    /**
    * Calls the specified function [block] with `this` value as its argument and returns `this` value.
    */
    @kotlin.internal.InlineOnly
    @SinceKotlin("1.1")
    public inline fun <T> T.also(block: (T) -> Unit): T {
        contract {
            callsInPlace(block, InvocationKind.EXACTLY_ONCE)
        }
        block(this)
        return this
    }
```

## with 独立函数,需要传入数据对象,有返回值

`with` 通常作为对立的载体,需要两个参数
参数1: 一个任意对象
参数2: Lambda表达式

特点: 代码块内最后一行将作为数据返回,无论什么类型的数据

```kotlin
    val fruits = listOf("apple","banana","pear")
    val result = with(fruits,{
        val builder = StringBuilder("Fruits:")
        for (it in fruits){
            builder.append(it)
        }
        builder.toString() // result = Fruits:applebananapear

        "hello,world"      // result = "hello,world" 
        Person()           // result = Person() 
    })
```

## run()

特点: 代码块内最后一行将作为数据返回

> 注意区分 `run()`和`T.run()`,两者不一样,一个独立的代码块,一个是依赖调用对象

这里是简单的代码块,可以有返回值,最终`return block()`

```kotlin

    /**
    * Calls the specified function [block] and returns its result.
    */
    @kotlin.internal.InlineOnly
    public inline fun <R> run(block: () -> R): R {
        contract {
            callsInPlace(block, InvocationKind.EXACTLY_ONCE)
        }
        return block()
    }

   fun main(){
       val content = "Hello,world !!"
       val length = run{
           val n = content.substring(5)
           n.length
       }
       println(length)
   }
```

## T.run()

```kotlin

    /**
    * Calls the specified function [block] with `this` value as its receiver and returns its result.
    */
    @kotlin.internal.InlineOnly
    public inline fun <T, R> T.run(block: T.() -> R): R {
        contract {
            callsInPlace(block, InvocationKind.EXACTLY_ONCE)
        }
        return block()
    }

    // 测试
    val fruits = listOf("apple","banana","pear")
    val result = fruits.run {
        val builder = StringBuilder("Fruits:")
        for (it in fruits){
            builder.append(it)
        }
        builder.toString() // result = Fruits:applebananapear

        "hello,world"      // result = "hello,world" 
        Person()           // result = Person() 
    }
```

## repeat()

重复执行: 内部使用for循环来执行lambad表达式中给出的Action逻辑,用于生成批量数据,多用于测试数据

> 函数没有返回,仅执行给出的逻辑

```kotlin
        
    /**
    * Executes the given function [action] specified number of [times].
    *
    * A zero-based index of current iteration is passed as a parameter to [action].
    *
    * @sample samples.misc.ControlFlow.repeat
    */
    @kotlin.internal.InlineOnly
    public inline fun repeat(times: Int, action: (Int) -> Unit) {
        contract { callsInPlace(action) }

        for (index in 0 until times) {  // 这里使用 until 
            action(index)
        }
    }

    // 测试
    fun test(times:Int = 1){
        val list = mutableListOf<String>()
        repeat(times){
            list.add("Hello,world !!")
        }
        println(list.size)
    }

    fun main(){
        test(199)
    }
```
