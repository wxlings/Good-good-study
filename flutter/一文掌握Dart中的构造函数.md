









#### **什么是构造函数？**

#### **Dart的构造函数有几种写法？有什么区别？**























#### **什么是构造函数？**

 构造函数 ，是一种特殊的方法。**主要用来在创建对象时初始化对象， 即为对象成员变量赋初始值**，总与new运算符一起使用在创建对象的语句中。**特别的一个类可以有多个构造函数 ，可根据其参数个数的不同或参数类型的不同来区分它们** 即构造函数的***重载***。 



##### **构造函数的特点：**

1. **构造函数的命名必须和类名完全相同**。在Java中普通函数可以和构造函数同名，但是必须带有返回值；
2. **构造函数的功能主要用于在类的对象创建时定义初始化的状态。它没有返回值，也不能用void来修饰。**这就保证了它不仅什么也不用自动返回，而且根本不能有任何选择。而其他方法都有返回值，即使是void返回值。尽管方法体本身不会自动返回什么，但仍然可以让它返回一些东西，而这些东西可能是不安全的；
3. **构造函数不能被直接调用**，必须通过new运算符在创建对象时才会自动调用；而一般的方法是在程序执行到它的时候被调用的；
4. 当定义一个类的时候，通常情况下都会显示该类的构造函数，并在函数中指定初始化的工作也可省略，不过**Java,Dart编译器会提供一个默认的构造函数.此默认构造函数是不带参数的。**而一般的方法不存在这一特点；
5.  **构造函数有回滚的效果**，构造函数抛出异常时，构造的是一个不完整对象，会回滚，将此不完整对象的成员释放(c++) 
6. **当一个类只定义了私有的构造函数，将无法通过new关键字来创建其对象**，当一个类没有定义任何构造函数，C#编译器会为其自动生成一个默认的无参的构造函数。(私有构造函数，例如创建单例)
7. 在Python中构造函数必须通过重写`__init__`方法实现





#### **Dart的构造函数有几种写法？** 

宽泛来说Dart中有5中构造函数的写法，分别是`默认构造函数`，`命名式构造函数`，`重定向构造函数`，`常量构造函数`和`工厂构造函数`，当然不同的写法也具有不用的使用场景，我们分别来看一下：

1. **常规构造函数**

     声明一个与类名一样的函数即可声明一个构造函数 

   ```dart
   
   class Point {
       
     // 如果属性不会改变，可以直接使用final进行修饰
     double? x, y;
     
     // 支持这种写法，但不建议，ide会给出纠正警告.
     // Point(double x, double y) {
     //   this.x = x;
     //   this.y = y;
     // }
   
     // 终值初始化
     Point(this.x, this.y);
   }
   
   // 使用
   var point = Point(12, 24);
   print(point);
   
   ```

   > 常用：定义数据中转`model`模型等

   

   ###### 终值初始化

    Dart 则提供了一种特殊的语法糖来简化该步骤。

   构造中初始化的参数可以用于初始化非空或 `final` 修饰的变量，它们都必须被初始化或提供一个默认值。

   ######  默认构造函数：

    如果你没有声明构造函数，那么 Dart 会自动生成一个无参数的构造函数并且该构造函数会调用其父类的无参数构造方法。  

   ###### 构造函数不被继承

    子类不会继承父类的构造函数，如果子类没有声明构造函数，那么只会有一个默认无参数的构造函数。

   

2. **命名式构造函数**

   通过`类名.额外标识符`来声明有具体意义构造方法， 可以为一个类声明多个命名式构造函数来表达更明确的意图 

   ```dart
   const width = 375;
   const height = 640;
   
   class Point {
   
      final double x, y;
   
      /// 右上点    
      Point.topRight() : x = width, y = 0;
      /// 中心
      Point.center({this.x = 188, this.y = 320});
      /// 水平方向中心线上
      Point.horizontalCenter(double y) : this.center(y: y);
   }
   
   // 使用
   var topRight = Point.topRight();
   var center = Point.center();
   var point = Point.horizontalCenter(200);
   print(point);
           
   ```

   > 常用：Flutter Widget ，如果`Image.asset()`,`List.generate()`...

   

3. **重定向构造函数**

   有时候类中的构造函数仅用于调用类中其它的构造函数，此时该构造函数没有函数体，只需在函数签名后使用（:）指定需要重定向到的其它构造函数 (使用 `this` 而非类名)： 

   ```dart
   const double width = 375;
   const double height = 640;
   
   class Point {
   
      final double x, y;
   
      // 命名构造函数
      Point.topLine(this.x) : y = 0;
   
      // 重定向构造函数
      Point.start() : this.topLine(0);
      Point.topRight():this.top(width);
   }
   
   // 使用
   var point = Point.start();
   print(point);
   
   ```

   

4. **常量构造函数**

   `如果类生成的对象都是不变的，可以在生成这些对象时就将其变为编译时常量`。可以在类的构造函数前加上 `const` 关键字并确保所有实例变量均为 `final` 来实现该功能。 

   

   举例：我需要创建一个保存`MobilePhone`的信息的类实例，该类的属性初始化后是固定不变的。

   ```dart
   const double width = 375;
   const double height = 640;
   
   class ImmutablePoint {
     
      static const ImmutablePoint origin = ImmutablePoint(0, 0);
   
      // 常量构造函数，如果属性不为final修饰那么构造方法就不能用const修饰，否则编译报错。 
      final double x, y;
   
      const ImmutablePoint(this.x, this.y);
   
      const ImmutablePoint.topLeft()
          : x = 0,
            y = 0;
   
      const ImmutablePoint.center()
          : x = width / 2,
            y = height / 2;
    }
   
    // 使用
    var point1 = const ImmutablePoint(10, 20);
    var point2 = const ImmutablePoint(10, 20);
    var point3 = ImmutablePoint(10, 20);
    print(point1 == point2); // true 通过const修饰的构造函数如果入参一致那么它属于同一实例
    print(point1 == point3); // false
    print(point1 == ImmutablePoint.origin); // true
   
   ```

   > 类的所有属性都必须通过`final`修饰。
   >
   > 如果存在属性并且值一致，且都属于编译期产物，那么为同一实例。
   >
   > 用于对象变量不改变，在某下情况下做单例（需小心使用）

   

   

5. **工厂构造函数**

   使用 `factory` 关键字标识类的构造函数将会令该构造函数变为工厂构造函数，**这将意味着使用该构造函数构造类的实例时并非总是会返回新的实例对象。**例如，工厂构造函数可能会从缓存中返回一个实例，或者返回一个子类型的实例。

   

   举例：我们需要一个日志打印工具`Logger`，需要对不同模块有不同的实例实现，那么我们就可以使用工厂的方式来创建其具体实例：

   ```dart
   
   class Logger {
      final String name;
      final bool mute;
   
      static final Map<String, Logger> _cache = {};
   
      // 由缓存中读取，具有单例能力
      factory Logger(String name, {bool mute = false}) {
         return _cache.putIfAbsent(name, () => Logger._internal(name, mute));
      }
      // 每次都是新的实例，这种写法应该是很熟悉了...
      factory Logger.single(Map<String, dynamic> map, {bool mute = false}) {
          return Logger._internal(map['type'], mute);
      }
       
      Logger._internal(this.name, this.mute);
   
      void log(String msg) {
         if (!mute) print(msg);
      }
   }
   
   // 具体使用
   Logger("UI").log("交互");
   Logger("NETWORK").log("网络");
   Logger("LIBRARY").log("库");
   Logger.single({'type': "dynamic"}).log("Map detail");
   
   ```

   通过工厂的方式根据不同的参数来创建/获取缓存中对应的实例信息。

>  在工厂构造函数中无法访问 `this`.
>
> 工厂方法必须`return`一个该类的实例，支持调用其他方式的构造函数实现具体。
>
> 通常用于获取具有缓存的对象实例
>
> `factory`只能用于修饰/创建工厂构造函数，其思想参考了`工厂`设计模式。



#### **小结：**

我们可以看出，不同种类的写法可以混合使用，有时混用西效果更佳

1. 常规构造方法：

   ​	创建数据model实例基本操作。

2. 命名构造函数：

   ​	 创建model实例，同时更明确的表达实例的意图 

3. 重定向构造函数：

   ​    更方便的声明构造函数

4. 常量构造函数：

      实例的属性不可变，（可用于生成单例）

5. 工厂构造函数：

      并非总是会返回新的实例对象 ，结合其他写法用于单例。







通过我们上面的学习，我们一起来分析一下`Getx`中`GetInstance`的构造函数：

```dart

class GetInstance {
    
  factory GetInstance() => _getInstance ??= GetInstance._();

  const GetInstance._();

  static GetInstance? _getInstance;
    
  /// Injects an instance `<S>` in memory to be globally accessible.
  S put<S>( S dependency,...){ ... }
  ...
}

/// 具体使用
GetController _contoller = GetInstance().put(GetController()).

```



1. 创建静态实例引用 `_getInstance`，并保持访问权限私有。

2. 通过`const`关键字，创建无参常量构造函数，并保持访问权限私有。

3. 通过`factory`关键字，创建无参工厂构造函数，返回类的实例引用`_getInstance`，如果`_getInstance`没有初始化，那么通过调用常量构造函数来创建实例并赋值给`_getInstance`,这样就实现了`GetInstance`的单例了 .

   

   **使用很巧妙，也很简洁。**



#                             最后祝大家 **中秋快乐**







##### 参考： [官链](https://dart.cn/guides/language/language-tour#constructors)，[codelab](https://dart.cn/guides/language/language-tour#using-constructors),  百科](https://baike.baidu.com/item/%E6%9E%84%E9%80%A0%E5%87%BD%E6%95%B0/7478717)