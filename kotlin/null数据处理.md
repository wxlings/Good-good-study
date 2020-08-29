Kotlin中空值判断相对Java代码非常简洁,逻辑稍稍需要理解

在Kotlin中'null'并不是引用数据类型的默认值

```kotlin

    fun main(){
        val name:String
        name = null             // 编译报错
        
        log("hello,world")      // 没有问题
        log(null)               // 编译报错,因为log()方法指定必须传入String类型数据
    }

    fun log(msg:String){
        print(msg)
    }
   
```

###### 使用`?`标记变量可以为`null`值

```kotlin
    fun main(){
        var name:String?
        name = null             // 正常
        
        lot(null)               // 正常
    }
    fun log(msg:String?){
        if(msg != null){		// 如果msg为null了,就要增加逻辑判断
            print("length:" + msg.length)
        }
    }
```

##### 辅助函数 `?.`进行空值判断
辅助函数的作用:只有`?.`验证通过的'值'才会去执行后面的逻辑

```kotlin
    fun main(){
        var name:String?
        var result = name?.length?.and(10)  // 计算name长度+10的值
        log(null)               // 正常
    }
    fun log(msg:String?){
        print("Msg length:" + msg?.length )
    }
```

理解:多个连续的`?.`用Java表示:

```java
    String name;
    int result;
    if(name != null && name.lenght != null){
        result = name.length + 10
    }
```

##### `标准函数let {}`
逻辑: 只有`?.`验证通过的'值'才会执行表达式中的代码块
Lambda表达式中可以是任何逻辑

> let{} 函数没有返回值,也就是说可以做一些逻辑,但不会返回新的值

```kotlin
    fun main(){
        log(null)
    }

     fun log(msg:String?){
        msg?.let { 
            print(msg.length)
        }
    }

```