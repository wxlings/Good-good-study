# Kotlin 仍然有‘一切皆对象'的思想,因为jvm的思想没有改变...

## 基本语法

> 还是有很多和java相似的地方，毕竟都要遵循jvm的规则

`package` 声明包信息
`import` 引入其他文件

```kotlin
    package com.pub.paiditem
    import com.pub.paiditem.utils.*
```

**程序入口**
`main`函数:程序的主入口,唯一;相对于Java的`main`更简洁

```kotlin
    fun main(){
        println("Hello,world")
    }
```

**相等性**
结构相等和引用相等
结构相等: 使用 `==` 或者 `!=`, 可以理解为是`equals()`的衍生
引用相等: 使用`===` 或者`!==` , 可以理解为java中的`==`

**变量声明：`var`与`val`**

> `var` 可变变量：声明后可以改变其值,支持再赋值
> `val` 不可变变量(并不是常量)：一旦赋值后就不支持再赋值
> `const` 声明常量,必须直接赋值,要在`object`
> 在Kotlin里面有个`lateinit`,字面意思'晚初始化'，可以修饰`var`

```kotlin
    var name:String
    name = "Jeck"
    // var age:Int = 20 // 如果直接赋值会自动推断类型,可以不用声明类型
    var age = 20
    var salary:Float
    salary = 2300.1f
    lateinit number:Long
    var pi=3.1415926 // 变量`pi`是`Double`类型,如果想要声明为`Float`必须使用`f`进行标识

    val property = "live"
    // property = "have" // 编译报错
```

> **字面量**： 16进制使用`0x`,二进制使用`0b`,浮点数默认`Double`

**基本数据类型**
与Java相同：`Char`,`Byte`,`Short`,`Int`,`Long`,`Float`,`Double`,`Boolean`

数值类型：

|`Byte`|`Short`|`Int`|`Long`|`Float`|`Double`|
|:-:|:-:|:-:|:-:|:-:|:-:|
|1 byte|2 byte|4 byte|8 byte|4 byte|8 byte|

> `Byte`的取值范围`-128-127`

装箱问题:

> 数字装箱不一定保留同一性,仅保留了相等性
> `==` 比较内容,`===` 内存地址引用

```kotlin
    var a:Int = 10000
    var b:Int = a
    var c:Int = a
    println(b === c) // false
    println(b == c) // true
```

数字类型支持如下的转换:
    `toByte(): Byte`
    `toShort(): Short`
    `toInt(): Int`
    `toLong(): Long`
    `toFloat(): Float`
    `toDouble(): Double`
    `toChar(): Char`

字符型：

`Char` 表示一个字符,使用单引号`''`进行包裹

Boolean类型：

值参：`true`/`false`
支持: `||`,`&&`,`!`

**引用数据类型**
_String:_

```kotlin
    var str:String = "My name is Hello!"
    for(item in str){
        println(item)
    }
```

> 字符串模板

使用 `$var` 或者 `${fun}` 进行引用,注意要使用双引号

```kotlin
    var name="Jesson"
    fun getAge(age:Int) = age + 1 
    var str = "My name is $name,and I`m ${getAge(1996)} years old;"
    println("$name.length is ${name.length} !")
    var msg = """
        hello,
        world!
    """
```

_Array: 数组_
数组初始化后是不可以扩容的;

默认提供了`get`,`set`,`size`属性
创建数组：`arrayOf`/`arrayOfNull` 或者 工厂函数：`Array(size,{i})`

```kotlin
    var arr = arrayOf("H","e","l","o") // 直接初始化数组内容
    arr.set(2,"name") // 不推荐直接使用arr[2]
    var value = arr.get(2) // 不推荐直接使用arr[2]
    var length = arr.size
    arr = arraryOfNulls<String>(20) // 创建size为20,内容都为null的数组
    arr = Array(10,{i -> i+2}) // 2,4,6,8,10,...工厂函数默认创建Int类型数组,默认由0开始

    arr fl = FloatArray(3) // 0.0
    arr dou = DoubleArray(10) 
    arr bo = BooleanArray(2) // false false

    // 创建数组时
```

系统还对基本数据类型进行扩展,`ByteArray`,`ShortArray`,`IntArray`,`LongArray`,`FloatArray`,`DoubleArray`,`CharArray`,`BooleanArray`,经过扩展后的数组不在需要初始化

_List: 集合_
List集合类

```kotlin
    // 不可扩容list
    val list = listOf("h","e","l","l","o")  //这种list是不可以扩容的,和数组一样,创建完只能更改内容
    val value = list[0]  //对于list的方法就有很多了
    // list.add(8)         // 没有方法

    // 可变list
    val mutableList = mutableListOf<Int>(1,2)
    mutableList.add(3)
    mutableList.add(4)

    // 返回一个空的ArrayList,等同于  mutableListOf<Int>()
    val arrayList = arrayListOf<Int>()
```

_Set : 集合_  
`interface Set<out E> : Collection<E>` 实现了Collection接口 和 list 属于一类

```kotlin
    // read-only 没有add()
    val set = setOf<Int>(0,1,2,3)
    val size = set.size 

    // 可扩容
    val mutableSet = mutableSetOf<Int>()
    mutableSet.add(10)

````

_Map : 键值对映射_
Map映射结构

```kotlin

    // Returns an empty read-only map.
    val map = mapOf<Int,String>(0 to "0",1 to "1")

    // 动态数据
    val mutableMap =  mutableMapOf<Int,String>()
    mutableMap[2] = "2"
```

**`fun` 声明函数**
使用`fun`进行函数声明

```kotlin
    fun eat{
        print("Eat it")
    }

    fun listen():Any{
        return "Something"
    }
```

### 条件控制

`if-else` 支持基本用法：
在 Kotlin 中，if是一个表达式，即它会返回一个值。

```kotlin
    var a = 10
    var b = 15
    var max:Int

    if (a > b){  // java写法
        max = a
    } else {
        max = b
    }

    // 也可以写作 ：if是一个表达式，即它会返回一个值。也就是不需要三元运算了
    max = if (a > b) a else b

    // 也可以写作：if 的分支可以是代码块，最后的表达式作为该块的值
    max = if (a > b){
        println("a>b")  // 也可以增加其他逻辑
        a
    } else {
        println("a<b")
        b
    }
```

`in` 区间 :判断 `target` 是否在指定的整数区间内,用`..`表示范围区间

```kotlin
    var a = 5
    if (a in 1..8){
        println("a in 1..8")
    }
```

`is`,`!is` 检测一个值是（is）或者不是（!is）一个特定类型的值。

```kotlin
    fun hasPrefix(value:Any) = when(value){
        is String -> value.startWith("http")
        is Int -> value > 0
        else -> false
    }
```

`when-else` 类似`swich`,把参数和所有条件进行比较,直到满足条件,`else` 等同于`default`

```kotlin
    var x = 10
    when (x) {
        1 -> println("x=1")
        in 2..5 -> println("x in 2..5")
        !in 5..7 -> println("!in 5..7")
        8,9,10 -> println("8,9,10")
        in numbers -> println("在数据集合numbers中")
        else->{
            println("Not in 1-10")
        }
    }
```

### 循环

`for` 循环可以对任何提供迭代器（iterator）的对象进行遍历

```kotlin
     for ( i in 1..10){
        println(i)
    }

    val str = "Hello,world"
    for (i in str){
        println(i)
    }

    val array = arrayOf("Hello",",","world","!!@")
    for (i in array){
        println(i)
    }
    // 通过索引遍历一个数组或者一个 list
    for (i in array.indices){
        println("$i -> ${array[i]}")
    }
    // 可以用库函数 withIndex：遍历数组的方式
    for ((index,item) in array.withIndex()){
        println("$index -> $item")
    }
```

`while`与`do-while` 用法与java完全相同,不在描述

> 注意： `do-while` 先执行一次再进行条件判断

`break` 与 `continue` 作用与用法与java完全相同,

> 在 Kotlin 中任何表达式都可以用标签（label）来标记。 标签的格式为标识符后跟 @ 符号

### 类与对象

Kotlin 类可以包含：构造函数（主构造函数和次构造函数）和初始化代码块、函数、属性、内部类、对象声明。
Kotlin 中使用关键字 `class` 声明类,类的继承性需要使用`open`关键字进行修饰，默认是 `final`不可继承；

在 Kotlin 中的一个类可以有一个主构造函数以及一个或多个次构造函数.主构造函数是类头的一部分：它跟在类名（与可选的类型参数）后。
主构造函数不能包含任何的代码。初始化的代码可以放到以 init 关键字作为前缀的初始化块（initializer blocks）中。

```kotlin
    open class Person(val name:String,val age:Int = 18){
        val temp = name.toUpperCase();  // 可以直接使用构造数据
        init {
            println("初始化...相当于构造方法执行")
        }
    }

    class Student(val name:String,val age:Int):Person(name,age){
        val age = age + 1
        init{
            print(age)
        }
    }
```

在 Kotlin 中的一个类可以有一个主构造函数以及一个或多个次构造函数。主构造函数是类头的一部分：它跟在类名（与可选的类型参数）后。
如果想要重写默认构造方法还是比较麻烦的，尤其是次构造方法

如果类有一个主构造函数，每个次构造函数需要委托给主构造函数， 可以直接委托或者通过别的次构造函数间接委托。委托到同一个类的另一个构造函数用 this 关键字即可：

```kotlin

    class Person(val name:String,val age:Int,val gender:Char){

        constructor(name:String):this(name,0,'M') // 声明了次级构造函数，必须要指定到主构造方法参数

        var phone:String = ""if

        get() {
            return if (field.length == 11) field else "null"
        }

        set(value) {
            if (value.length == 11){
                field = value
            }
        }

        init {
            println("初始化...相当于构造方法执行")
        }
    
        fun say(msg:Any){
            println("$name say: $msg")
        }

        fun getUserInfo():String{
            val other:Any = "Phone=>$phone"
            return "Name:${this.name},\nAge:${this.age},\nGender:${if (this.gender == 'M') "Male" else "Female"},\nOther:\n$other"
        }
    }

    // Kotlin 并没有 new 关键字
    var person = Person("Jeck",20,'F')
    person.say("Hello,world!")
    person = Person("Lanbo")
    person.phone = "1388888888"
    val info = person.getUserInfo()
    println(info)
```

#### Class与KClasss;

`Class`是java环境下的，`KClass`是kotlin环境下的
```kotlin

    fun main()}{

    }

    fun test(clazz Class<? extends Activity>){
        // todo 
    }

     fun test(clazz KClass<? : Activity>){
        // todo 
    }

```

嵌套函数： 通常不会使用嵌套函数