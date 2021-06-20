 ### 变量声明

 `var` 类似于JavaScript中的var，它可以接收任何类型的变量，但最大的不同是Dart中var变量一旦赋值，类型便会确定，则不能再改变其类型,因为Dart本身是一个强类型语言

 `dynamic`和`Object` Object 是Dart所有对象的根基类，也就是说所有类型都是Object的子类(包括Function和Null)，所以任何类型的数据都可以赋值给Object声明的对象. dynamic与var一样都是关键词,声明的变量可以赋值任意对象。 而dynamic与Object相同之处在于,他们声明的变量可以在后期改变赋值类型。

 `final`和`const` 如果您从未打算更改一个变量，那么使用 final 或 const，不是var，也不是一个类型。 一个 final 变量只能被设置一次，两者区别在于：const 变量是一个编译时常量，final变量在第一次使用时被初始化。

 `函数` Dart是一种真正的面向对象的语言，所以即使是函数也是对象，并且有一个类型Function。这意味着函数可以赋值给变量或作为参数传递给其他函数，这是函数式编程的典型特征。