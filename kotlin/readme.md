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
