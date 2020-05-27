Kotlin 仍然有‘一切皆对象'的思想,因为jvm的思想没有改变...

### 基本语法：
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

**变量声明：`var`与`val`**

> `var` 声明变量：声明后可以改变其值,支持再赋值
> `val` 声明常量：不可改变,一旦赋值后就不支持再赋值
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

String:

```kotlin
    var str:String = "My name is Hello!"
    for(item in str){
        println(item)
    }
```

*字符串模板*

> 使用 `$var` 或者 `${fun}` 进行引用,注意要使用双引号

```kotlin
    var name="Jesson"
    var str = "My name is $name,and I`m ${getAge(1996)} years old;"
    println("$name.length is ${name.length} !")
    var msg = """
        hello,
        world!
    """
    
```
Array: 数组

默认提供了`get`,`set`,`size`属性
创建数组：`arrayOf`/`arrayOfNull` 或者 工厂函数：`Array(size,{i})`
```kotlin
    var arr = arrayOf("H","e","l","o")
    arr.set(2,"name")
    var value = arr.get(2)
    var length = arr.size
    arr = arraryOfNulls<Int>(20) // 创建size为20,内容都为null的数组
    arr = Array(10,{i -> i+2}) // 2,4,6,8,10,...工厂函数默认创建Int类型数组,默认由0开始

    arr fl = FloatArray(3) // 0.0
    arr do = DoubleArray(10) 
    arr bo = BooleanArray(2) // false false
```
系统还对基本数据类型进行扩展,`ByteArray`,`ShortArray`,`IntArray`,`LongArray`,`FloatArray`,`DoubleArray`,`CharArray`,`BooleanArray`,经过扩展后的数组不在需要初始化



`fun` 声明函数

#### 条件控制

`if-else` 支持基本用法：

```kotlin
    var a = 10
    var b = 15
    var max:Int
    if (a > b){
        max = a
    } else {
        max = b
    }

    // 也可以写作 ：
    max = if (a > b) a else b

    // 也可以写作：
    max = if (a > b){
        println("a>b")
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

`when-else` 类似`swich`,把参数和所有条件进行比较,直到满足条件,`else` 等同于`default`

```kotlin
    var x = 10
    when (x) {
        1 -> println("x=1")
        in 2..5 -> println("x in 2..5")
        !in 5..7 -> println("!in 5..7")
        8,9,10 -> println("8,9,10")
        else->{
            println("Not in 1-10")
        }
    }
```

#### 循环

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
    for (i in array.indices){
        println("$i -> ${array[i]}")
    }
    for ((index,item) in array.withIndex()){
        println("$index -> $item")
    }
```

`while`与`do-while` 用法与java完全相同,不在描述

> 注意： `do-while` 先执行一次再进行条件判断

`break` 与 `continue` 作用与用法与java完全相同,

> 在 Kotlin 中任何表达式都可以用标签（label）来标记。 标签的格式为标识符后跟 @ 符号


### 类与对象
   
Kotlin 类可以包含：构造函数和初始化代码块、函数、属性、内部类、对象声明。
Kotlin 中使用关键字 `class` 声明类
在 Kotlin 中的一个类可以有一个主构造函数以及一个或多个次构造函数。主构造函数是类头的一部分：它跟在类名（与可选的类型参数）后。
如果想要重写默认构造方法还是比较麻烦的，尤其是次构造方法

```kotlin

    class Person(var name:String,var age:Int,var gender:Char){

        constructor(name:String):this(name,0,'M') // 声明了次级构造函数，必须要指定到主构造方法参数

        var phone:String = ""
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