` Flutter是谷歌的移动UI框架，可以快速在iOS和Android上构建高质量的原生用户界面。`

> Flutter 可以通过 `热重载（hot reload）` 实现快速的开发周期，热重载就是无需重启应用程序就能实时加载修改后码，并且不会丢失状态,如果是一个web开发者，那么可以认为这和webpack的热重载是一样的

> Flutter包含了许多核心的widget，它们可以在iOS和Android上达到原生应用一样的性能。

> Flutter内置美丽的Material Design和Cupertino（iOS风格）widget.Material是一种标准的移动端和web端的视觉设计语言。 Flutter提供了一套丰富的Material widgets。

> `pub.dev` dart包仓库
Scaffold 是 Material library 中提供的一个widget, 它提供了默认的导航栏、标题和包含主屏幕widget树的body属性。widget树可以很复杂。

> 在JVM运行的是.class文件，而DVM是.dex文件

<br>
<br>
<br>

    


Dart的设计目标应该是同时借鉴了Java和JavaScript。
Dart是一种真正的面向对象的语言，所以即使是函数也是对象，并且有一个类型Function。这意味着函数可以赋值给变量或作为参数传递给其他函数，这是函数式编程的典型特征。


Flutter 启动一个透明背景的页面 

```dart
 FlutterActivity
    .withCachedEngine("my_engine_id")
    .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.transparent)
    .build(context)
```