















#### **开篇：**

1. **说说你理解的`Get`**？
2. **我们为什么要引入`Get`？或者说它帮我们解决了哪些问题？**
3. **`Get`有哪些特性及特性的使用场景是怎样的？**



























![GetX](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)



**传送：[pub.dev](https://pub.dev/packages/get)  [github](https://chornthorn.github.io/getx-docs/)**



### 关于`GetX`    

**`GetX` 是 Flutter 上的一个轻量且强大的解决方案：高性能的状态管理、智能的依赖注入和便捷的路由管理。**

-  `GetX`是一个超轻和强大的Flutter解决方案。 它结合了高性能状态管理、智能依赖注入和快速实用的路由管理。  
-  `GetX`有3个基本原则。 这意味着这些是库中所有资源的优先级:生产力、性能和组织。  
-  `GetX`并不臃肿。 它有许多特性，可以让您在开始编程时不用担心任何事情，但每个特性都在单独的容器中，只有在使用后才会启动。 如果只使用状态管理，则只编译状态管理。 如果只使用路由，则不会编译状态管理中的任何内容。  

-  `GetX`拥有庞大的生态系统、庞大的社区、大量的合作者，只要Flutter存在，它就会一直维持下去。 `GetX`也能够在Android、Ios、Web、Mac、Linux、Windows和服务器上运行相同的代码。 在后台使用Get Server完全重用前端代码是可能的。  



### Install依赖

在项目的` pubspec.yaml `依赖配置文件中声明：

```dar

dependencies:
  get:^4.3.8

```

 使用时需要引入包文件

```dart

import 'package:get/get.dart';

```

> 这里需要注意，很多同学在使用时会引入其他文件`get_main`,`get_core`等文件...





### 三大功能：

#### 1. 状态管理

Flutter 也有利用 BLoc 、Provider 衍生的 MVC、MVVM 等架构模式，但是这几种方案的状态管理均使用了上下文（context），需要上下文来寻找`InheritedWidget`，这种解决方案限制了状态管理必须在父子代的 widget 树中，业务逻辑也会对 View 产生较强依赖。

 GetX does not use Streams or ChangeNotifier like other state managers. 

  为了提高响应时间和减少RAM消耗，我们创建了GetValue和GetStream，这是低延迟的解决方案，以较低的运行成本提供了大量的性能。 

  In order to improve response time and reduce RAM consumption, we created GetValue and GetStream, which are low latency solutions that deliver a lot of performance, at a low operating cost. 



Get有两个不同的状态管理器：`简单的状态管理器（GetBuilder）`和`响应式状态管理器（GetX/Obx）`。 

##### 响应式状态管理器（`Obx`）:  ---- 适用于精细化更新

> `Obx`需要与`Rx`变量联合使用

 Reactive programming with Get is as easy as using setState. 

例如： 我们定义一个变脸 `name`，如何在`Get`里面做的响应式，只需在末位增加`.obs`就可以了 ，这样就可以使变量`name`成为` observable `，这样当`name`产生变化时`widget`就会自动更新了。

```dart

var name = 'Jonatas';
// releace
var name = 'Jonatas'.obs;

// use it
Obx(() => Text(name.value));

```

它是怎么做到的呢 ？ 在`Get`内部创建了一个关于`String`的流，并给出了初始值`Jonatas`, 当`Rx`值变化时会通知所有引用`name`的widget, 引用值有变更。

  `Widget` can only be changed if it is inside a function, because static classes do not have the power to "auto-change". 

这样，我们就需要创建一个` StreamBuilder `, 订阅这个`Rx`变量的变化监听，那么至此，`Obx`内部就帮我们实现了这样的逻辑：

```dart

// 同一组件可以同时绑定多个响应变量
var name = "Jack".obs;
var gender = "male".obs;
var age = "18".obs;
// 使用Obx进行声明
Obx(() => Text("姓名：${name.value}，性别：${gender.value}，年龄：${age.value}"));
// 使用GetX进行声明
GetX<Controller>(
  builder: (controller) {
    return Text('${name.value}');
  },
),

```

>  注意： 只有当`name.value`的值变化时才会触发Widget重建。

那么`Obx`是什么呢？ 我们看下源码

```dart
/// The simplest reactive widget in GetX.
class Obx extends ObxWidget {
  final WidgetCallback builder;

  const Obx(this.builder);

  @override
  Widget build() => builder();
}

/// The [ObxWidget] is the base for all GetX reactive widgets
abstract class ObxWidget extends StatefulWidget { ... }

class _ObxState extends State<ObxWidget> {
  final _observer = RxNotifier();
  late StreamSubscription subs;

  @override
  void initState() {
    super.initState();
    subs = _observer.listen(_updateTree, cancelOnError: false);
  }

  void _updateTree(_) {
    if (mounted) {
      setState(() {});
    }
  }
  ...
      
  @override
  Widget build(BuildContext context) =>
      RxInterface.notifyChildren(_observer, widget.build);
}
```

通过源码可以看出，`Obx`是最终继承了`StatefulWidget`，本身是一个有状态组件，这个有状态组件内部声明了`RxNotifier`观察者`_observer`，通过订阅`StreamSubscription`来实现触发`Widget.build()`更新UI.



**响应式变量：**

主要包括：`RxString`,`RxInt`,`RxDouble`,`RxBool`,`RxList`,`RxMap`,`RxSet`...

响应式变量除了给出的以上几种基础类型，我们还可以自定义，例如：

```dart

class RxUser {
  final name = "Camila".obs;
  final age = 18.obs;
}
// 或者
class User {
  User({String name, int age});
  var name;
  var age;
}
final user = User(name: "Camila", age: 18).obs;
user.update( (user) { // this parameter is the class itself that you want to update
user.name = 'Jonny';
user.age = 18;
});

```



`ObxValue`

Similar to Obx, but manages a local state.Pass the initial data in constructor.Useful for simple local states, like toggles, visibility, themes...

它和`Obx`相似，用于管理本地状态。通过构造函数初始化数据，用于简单的状态管理。

示例：暂无(待补全)

**总结：**  `Obx`本身继承`StatefulWidget`，状态实例初始化时会创建一个观察者RxNotifier对象，然后订阅对应的	`GetStream`时间，条件：`Obx`的子组件必须`使用`一个响应式变量，当响应式变量值发生改变时触发`观察者`的订阅事件，从而实现更新Widget;



##### 简单的状态管理(`GetBuilder`) :  ----- 已块为单位，适用于块/全局更新

> `GetBuilder`需要与`GetXController`联合使用

 Get has a state manager that is extremely light and easy, which does not use ChangeNotifier, will meet the need especially for those new to Flutter, and will not cause problems for large applications. 

特点：

1. Update only the required widgets. 
2. Does not use changeNotifier, it is the state manager that uses less memory (close to 0mb).
3.  Forget StatefulWidget! 
4. Organize your project for real! Controllers must not be in your UI, place your TextEditController, or any controller you use within your Controller class. 

```dart

/// 使用后Getbuilder声明UI
GetBuilder<Controller>(
  init: Controller(), // INIT IT ONLY THE FIRST TIME
  builder: (_) => Text('${_.counter}',
)
 
 /// 在控制器中进行更新
 class Controller extends GetxController {
  int counter = 0;
  void increment() {
    counter++;
    update(); // use update() to update counter variable on UI when increment be called
  }
}

```

那么`GetBuilder`又是个啥？会不会和`Obx`一样呢？是一个组件同样通过注册观察者来实现`Widget.build()`呢? 再看源码实现：

     ```dart
/// 这里可以看出 Getbuilder也是一个StatefelWidget.
class GetBuilder<T extends GetxController> extends StatefulWidget {
  @override
  GetBuilderState<T> createState() => GetBuilderState<T>();
}

class GetBuilderState<T extends GetxController> extends State<GetBuilder<T>>
    with GetStateUpdaterMixin {
    
    T? controller;
    VoidCallback? _remove;
    Object? _filter;
    
    @override
  	void initState() {
        super.initState();
        // 先执行initState()回调
    	widget.initState?.call(this);
        // 根据泛型及tag查找该GetController是否已经put();
        var isRegistered = GetInstance().isRegistered<T>(tag: widget.tag);

        if (widget.global) {
            /// 默认是全局，global = true;
              if (isRegistered) {
                 /// 如果已经binding该Controller，直接find引用；
                ...
                controller = GetInstance().find<T>(tag: widget.tag);
              } else {
                /// 如果没有找到则使用传入实例，同时put到全局
                controller = widget.init;
                GetInstance().put<T>(controller!, tag: widget.tag);
              }
        } else {
          controller = widget.init;
          controller?.onStart();
    	}
        if (widget.filter != null) {
            _filter = widget.filter!(controller!);
        }
		// 初始完成后开始订阅
   		 _subscribeToController();
	}
    
    /// Register to listen Controller's events.
    void _subscribeToController() {
        _remove?.call();
        _remove = (widget.id == null)
            ? controller?.addListener(
                _filter != null ? _filterUpdate : getUpdate,
              )
            : controller?.addListenerId(
                widget.id,
                _filter != null ? _filterUpdate : getUpdate,
       );
  	}
     ```

**总结：** `GetBuilder`本身继承`StatefulWidget`，在构造实例时可以指定一个`GetxController`的实例，或者`GetxController`在全局的ID（tag）,在`GetBuilder`初始化时会通过ID进行全局查找，如果找到直接使用，如果找不到把传入的`GetxController`实例加入全局，（条件：`GetxController`实例存在或者ID有效），然后给这个`GetxController`增加监听，这是如果指定参数`id`，将id与`builder`进行绑定。

这样在通过调用该`GetxController.update()`时就可以执行`GetBuilder.setState()`进行`Widget.build()`了，当然这样会式该`GetxController`关联的所有`GetBuilder`进行更新，显然是不合理的，我们在使用时需要指定其具体id,也就是`GetxController.update(['user_info','user_order'])`进行精细化更新Widget.

```dart
    /// 如果已知确定存在控制实例，请优先使用该实例，避免重新创建，除非一定要新的实例
    var _controller = Get.find<UserController>();

    /// 强烈建议指定id属性
    GetBuilder<Controller>(
      id:'user_info',
      init: _controller, 
      builder: (_) => Text('${_.name}',
    )
	/// 只要有该实例就可以调用update(),尽量指定具体的GetBuilder.id
    _controller.update(['user_info']);

```





#### 2. 路由管理

> `Getx`的路由管理需要`App`指定`MaterialApp`类型,其内部重新实现了路由管理策略,这里涉及`Flutter`路由知识，请参考另外一份总结；

> 因为我们的项目使用`FlutterBoost`,已经重新定义了路由管理策略，它与`Getx`不能完全相互兼容，所有这里我们不再详细介绍各个`Api`及实现。

```dart

// 打开指定路由
// 效果等同`Navigator.push()`
Get.to(NextScreen());
Get.toNamed("/NextScreen");

// 关闭当前，可以是page,snackbars,dialog,bottomsheets;
// 效果等同`Navigator.pop(context)`
Get.back();

// 打开新的路由并关闭当前，如果启动页跳转到其他页面...
// 效果等同于`Navigator.pushReplacement`
Get.off(NextScreen());
Get.offNamed("/NextScreen");

// 打开新的路由并关闭当前站内所有，如果打开主页...
// 效果等同于`Navigator.pushAndRemoveUntil()`
Get.offAll(NextScreen());
Get.offAllNamed("/NextScreen");	

// 命名路由还支持参数传递
Get.offAllNamed("/NextScreen?device=phone&id=354&name=Enzo");
Get.parameters['id']

// 打开新的路由并在页面返回时接收数据
// 效果等同于`var data = await  Navigator.push()` 
// `Navigator.pop(context, 'success');`
var data = await Get.to(Payment());
Get.back(result: 'success');

// 打开SnackBar
Get.snackbar('Hi', 'i am a modern snackbar');

// 打开dialog
Get.dialog(DialogWidget());

// 打开bottomSheet
Get.bottomSheet(BottomSheetWidget());

```

##### 中间件

 在跳转前做些事情，比如判断是否登录，可以使用`routingCallback`来实现： 

```dart

GetMaterialApp(
  ...
  routingCallback: (routing) {
    // 在页面跳转前做拦截行为...
  }
)
    
```



#### 3. 依赖管理

Get有一个简单而强大的依赖管理器，它允许你检索与你的Bloc或Controller相同的类，只需要1行代码，没有`Provider`上下文，没有`InheritedWidget`:  

```dar
Controller controller = Get.put(Controller());
```

>  Get依赖管理是与包的其他部分解耦的，所以如果你的应用已经在使用一个状态管理器(任何一个，都没关系)，你不需要改变它，你可以使用这个依赖注入管理器完全没有问题  

  

>  这里的依赖管理是指注入的全局实例的管理



   **3.1  实例方法： `Get.put()`**

Injects an instance `<S>` in memory to be globally accessible.

```dart
 
/// Injects an `Instance<S>` in memory.
///
/// [dependency] 需注入的实例
/// - [permanent] 如果为true保持该实例在内存常驻，不受Get.smartManagement的管理规则影响，
/// 可以通过Get.delete()或者etInstance.reset()进行实例移除。
/// - [builder] If defined, the [dependency] must be returned from here
S put<S>(S dependency,{String? tag,bool permanent = false,
          InstanceBuilderCallback<S>? builder}) =>
      GetInstance().put<S>(dependency, tag: tag, permanent: permanent);

/// 使用
SomeClass _some = Get.put(SomeClass());
LoginController _controller1 = Get.put(LoginController());
LoginController _controller2 = Get.put(LoginController(), permanent: true);
LoginController _controller3 =Get.put(LoginController, tag: "user_info");

// 此时 _controller1 == _controller2, _controller1 != _controller3
  
```



注意：虽然`Get.put() `语义是创建实例加入到依赖管理，但它也具有`Get.find()`的逻辑

如果同一个逻辑执行多次例如代码示例中`_controller1 `及`_controller2`实际是同一个引用，只要`tag`保持一致那么就会是同一个实例引用，为什么呢 ？我们来看源码:

```dart
 
/// 先执行_insert(),然后再find
 S put<S>(S dependency, {String? tag,bool permanent = false,
    @deprecated InstanceBuilderCallback<S>? builder}) {
    _insert(
        isSingleton: true, name: tag,permanent: permanent,
        builder: builder ?? (() => dependency));
    return find<S>(tag: tag);
  }
 
  /// Holds references to every registered Instance when using `Get.put()`
  /// 创建一个static Map,来装载实例，已tag作为key； 
  static final Map<String, _InstanceBuilderFactory> _singl = {};

 /// Injects the Instance [S] builder into the `_singleton` HashMap.
 /// 1. 根据key查找是否存在实例引用
 /// 2. 如果存在判断是否isDirty
 /// 3. 如果为空或者不为空但是isDirty，那么创建新的实例，否则不做处理忽略`dependency`
 /// 4. 只要tag不存在那么就会保存该实例，不区分实例类型是否存在
  void _insert<S>({bool? isSingleton,String? name,bool permanent = false,
    required InstanceBuilderCallback<S> builder, bool fenix = false }) {
    final key = _getKey(S, name);

    if (_singl.containsKey(key)) {
      final dep = _singl[key];
      if (dep != null && dep.isDirty) {
        _singl[key] = _InstanceBuilderFactory<S>(isSingleton,builder,permanent,
          false,fenix,name,lateRemove: dep as _InstanceBuilderFactory<S> );
      }
    } else {
      _singl[key] = _InstanceBuilderFactory<S>(isSingleton,builder,false,fenix,name,);
    }
  }
```

​     **3.2 实例方法 `Get.lazyPut()`**

​	Creates a new Instance<S> lazily from the `<S>builder()` callback.

​    The first time you call `Get.find()`, the `builder()` callback will create the Instance and persisted as a Singleton

​	基本逻辑和`Get.put()`一致，区别在于``lazyPut()`是在调用`Get.find()`时才把实例注入到`_singl`中，当然这里对于`GetController`子类的声明周期是有影响的；



  ```dart
 
 void lazyPut<S>(InstanceBuilderCallback<S> builder, {String? tag, bool fenix = false}) {
    GetInstance().lazyPut<S>(builder, tag: tag, fenix: fenix);
 }
 /// 最终还是调用了`_insert()`,把数据保存在 _singl 中；
 void lazyPut<S>(
   InstanceBuilderCallback<S> builder,{String? tag,bool? fenix,bool permanent = false}) {
   _insert(isSingleton: true,name: tag,permanent: permanent,builder: builder,
        fenix: fenix ?? Get.smartManagement == SmartManagement.keepFactory);
  }

  ```

   **3.3  实例方法`Get.putAsync()`**

Async version of `Get.put()`.

```dart

/// 示例，通过GetX对全局对象进行管理SharedPreferences
Get.putAsync<SharedPreferences>(() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('counter', 12345);
  return prefs;
});

int count = Get.find<SharedPreferences>().getInt('counter');

```



  **3.4  示例方法`Get.create()`**

Creates a new Class Instance [S] from the builder callback[S].

Every time `find<S>()` is used, it calls the builder method to generate a new Instance [S].

```dart

/// 通过创建的方式生命
 void create<S>(InstanceBuilderCallback<S> builder,
          {String? tag, bool permanent = true}) =>
      GetInstance().create<S>(builder, tag: tag, permanent: permanent);
/// 使用      
Get.create<SomeClass>(() => SomeClass());
Get.create<LoginController>(() => LoginController());

LoginController _controller1 = Get.find<LoginController>();
LoginController _controller2 = Get.find<LoginController>();

print(_controller1 == _controller2);  // false

```



  3.4 **查找方法 `Get.find()`**

由全局注册的实例Map中查找指定的实例，需要指定泛型，或者tag参数，如果没有找到会报

```dart

 /// Finds a Instance of the required Class `<S>`(or [tag])
 S find<S>({String? tag}) => GetInstance().find<S>(tag: tag);

 /// 使用
 LoginController _controller1 = Get.find<LoginController>();
 LoginController _controller2 = Get.find<LoginController>();
 LoginController _controller3 = Get.find<LoginController>(tag:"user_info");
 
  ///注意： _controller1 == _controller2 , _controller2 != _controller3 逻辑与Get.put()同；
  
```

使用起来相对比较简单，但`find()`时有个重点逻辑: 对于`GetController`类型的实例，首次查找时需要执行初始化行为，例如，会在第一次`find()`时执行`GetController.onInit()`的生命周期函数，同时如果需要遵循`Get.smartManagement`会把该实例加入到路由观察队列，我们来看源码实现：

```dart

  /// 源码实现
  S find<S>({String? tag}) {
    final key = _getKey(S, tag);
    if (isRegistered<S>(tag: tag)) {
      final dep = _singl[key];
      /// although dirty solution, the lifecycle starts inside
      /// `initDependencies`, so we have to return the instance from there
      /// to make it compatible with `Get.create()`.
      final i = _initDependencies<S>(name: tag);
      return i ?? dep.getDependency() as S;
    } 
  }
  /// Initializes the dependencies for a Class Instance [S] (or tag),
  /// If its a Controller, it starts the lifecycle process.
  S? _initDependencies<S>({String? name}) {
    final key = _getKey(S, name);
    final isInit = _singl[key]!.isInit;
    S? i;
    if (!isInit) {
      i = _startController<S>(tag: name);
      if (_singl[key]!.isSingleton!) {
        _singl[key]!.isInit = true;
        if (Get.smartManagement != SmartManagement.onlyBuilder) {
          RouterReportManager.reportDependencyLinkedToRoute(_getKey(S, name));
        }
      }
    }
    return i;
  }

```



**3.5 移除实例`Get.delete()`**

```dart

/// Deletes the Instance<[S]>, cleaning the memory and closes any open controllers.
Get.delete<Controller>()
    
```

这里也有一个关键逻辑：当实例是`GetLifeCycleBase`,会回调`GetxControler.onDelete()`生命周期；

> 对于`Flutter GetMaterialApp`项目我们无需关注实例的销毁，只需要创建和使用，因为`Get`定义了 一套管理策略`Get.SmartManagement`,主要用于管理状态和依赖需要跟随生命周期进行回收逻辑；
>
>  When a route is removed from the Stack, all controllers, variables, and instances of objects related to it are removed from memory.  
>
> 对于自动回收的条件：
>
> 1. 使用静态路由`getPages` + `Get.toNamed()`;
>
> 2. 使用`Get.to()`;
>
>    同时属于`GetLifeCycleBase`并且在实例化时指定参数`permanent`为false;

因为我们使用`FlutterBoot`（它定义自己的路由管理策略），所以我们就不能使用`GetX`的路由管理，所以对于`Get`的依赖实例，需要我们主动在代码中进行`Get.delete()`操作；



### [`注入Binding`可以提前做全局实例注入的业务]( When a route is removed from the Stack, all controllers, variables, and instances of objects related to it are removed from memory.  )

例如：

```dart

class HomeBinding implements Bindings {
    @override
    void dependencies() {
        Get.put<Service>(()=> Api());
        Get.lazyPut<HomeController>(() => HomeController());
        Get.lazyPut<DetailsController>(() => DetailsController());
    }
}

```

> 这里会有比较好的优化策略，及较大优化空间。



Getx还有较多的工具类可用...



​																																						未完，待续...