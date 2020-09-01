Kotlin 开发工具集提供了标准函数,标准函数是指`Standard.kt`中的函数

### let 依赖数据对象,没有返回值

let 是内置函数:提供了函数式Api接口编程,会将原始调用对象传递给Lambda表达式中

`let`函数 通常 结合 `?.`进行辅助非空逻辑判断

```kotlin

    class Person(){
        fun eat(){
            Log.e(TAG, "eat()" )
        }
        fun drink(){
            Log.e(TAG, "drink() " )
        }
    }

    // java
    Person person = ...
    if(person !== null){
        person.drink()
        person.eat()
    }

    // kotlin
    val person = ...  
    person?.let {   // 当person != null 调用内部方法
        it.drink()
        it.eat()
    }

```

### with 独立函数,需要传入数据对象,有返回值
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

### run 依赖数据对象,有返回值

特点: 代码块内最后一行将作为数据返回,无论什么类型的数据

```kotlin

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

### apply 依赖数据对象,没有返回值

特点: 可以扩展操作数据对象,直接使用对象数据的方法

```kotlin

    val fruits = mutableListOf<String>("apple","banana","pear")
    fruits.apply { 
        add("orange")
        remove("apple")
    }

    // 
     val intent = Intent().apply {
            putExtra("key","values")
    }
    startActivity(intent)

``