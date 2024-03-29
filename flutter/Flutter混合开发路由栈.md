# 说在前面

对于混合开发的应用而言，通常我们只会将应用的部分模块修改成 Flutter 开发，其他模块继续保留原生开发，因此应用内除了 Flutter 的页面之外，还会有原生 Android、iOS 的页面。在这种情况下，Flutter 页面有可能会需要跳转到原生页面，而原生页面也可能会需要跳转到 Flutter 页面。这就涉及到了一个新的问题：**如何统一管理原生页面和 Flutter 页面跳转交互的混合导航栈。**



## 1. [Android的任务和返回堆栈](https://developer.android.google.cn/guide/components/activities/tasks-and-back-stack)

**任务是用户在执行某项工作时与之互动的一系列 Activity 的集合。**这些 Activity 按照每个 Activity 打开的顺序排列在一个返回堆栈中。例如，电子邮件应用可能有一个 Activity 来显示新邮件列表。当用户选择一封邮件时，系统会打开一个新的 Activity 来显示该邮件。这个新的 Activity 会添加到返回堆栈中。如果用户按返回按钮，这个新的 Activity 即会完成并从堆栈中退出。
<br/>
大多数任务都从设备主屏幕上启动。当用户轻触应用启动器中的图标（或主屏幕上的快捷方式）时，该应用的任务就会转到前台运行。如果该应用没有任务存在（应用最近没有使用过），则会创建一个新的任务，并且该应用的“主”Activity 将会作为堆栈的根 Activity 打开。
<br/>
在当前 Activity 启动另一个 Activity 时，新的 Activity 将被推送到堆栈顶部并获得焦点。上一个 Activity 仍保留在堆栈中，但会停止。当 Activity 停止时，系统会保留其界面的当前状态。当用户按返回按钮时，当前 Activity 会从堆栈顶部退出（该 Activity 销毁），上一个 Activity 会恢复（界面会恢复到上一个状态）。堆栈中的 Activity 永远不会重新排列，只会被送入和退出，在当前 Activity 启动时被送入堆栈，在用户使用返回按钮离开时从堆栈中退出。因此，返回堆栈按照“后进先出”的对象结构运作。

<br/>

![栈](https://developer.android.google.cn/images/fundamentals/diagram_backstack.png)

如果用户继续按返回，则堆栈中的 Activity 会逐个退出，以显示前一个 Activity，直到用户返回到主屏幕（或任务开始时运行的 Activity）。移除堆栈中的所有 Activity 后，该任务将不复存在。

<br/>

## 2. **[ios 中的UINavigationController](https://developer.apple.com/documentation/uikit/uinavigationcontroller/)**

A navigation controller is a container view controller that manages one or more child view controllers in a navigation interface. **In this type of interface, only one child view controller is visible at a time.** 

<br/>

A navigation controller object manages its child view controllers using an **ordered array**, known as the **navigation stack**. The first view controller in the array is the root view controller and represents **the bottom of the stack.** **The last view controller in the array is the topmost item on the stack,** and represents the view controller currently being displayed. You add and remove view controllers from the stack using segues or using the methods of this class. The user can also remove the topmost view controller using the back button in the navigation bar or using a left-edge swipe gesture.

<br/>

<img src="https://docs-assets.developer.apple.com/published/83ef757907/nav_controllers_objects_a8447aef-d652-4ab9-85d1-1eb8e4876e12.jpg" alt="ios stack"  />

A navigation controller is a container view controller—that is, **it embeds the content of other view controllers inside of itself.** You access a navigation controller’s view from its [`view`](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621460-view) property.The navigation controller manages the creation, configuration, and display of the navigation bar and optional navigation toolbar.

>  可以看出在IOS的`UINavigationController`实现同样遵循栈模型.

<br/>

## 3. Flutter在原生应用层的呈现方式:

**Android :** **Flutter 提供了 [`FlutterActivity`](https://api.flutter-io.cn/javadoc/io/flutter/embedding/android/FlutterActivity.html)，用于在 Android 应用内部展示一个 Flutter 的交互界面。**和其他的 [`Activity`](https://developer.android.com/reference/android/app/Activity) 一样，`FlutterActivity` 必须在项目的 `AndroidManifest.xml` 文件中注册。

**Ios:**  **启动 [`FlutterEngine`](https://api.flutter-io.cn/objcdoc/Classes/FlutterEngine.html) 和 [`FlutterViewController`](https://api.flutter-io.cn/objcdoc/Classes/FlutterViewController.html)来展示 Flutter 页面. `FlutterEngine` 充当 Dart VM 和 Flutter 运行时的主机；** `FlutterViewController` 依附于 `FlutterEngine`，给 Flutter 传递 UIKit 的输入事件，并展示被 `FlutterEngine` 渲染的每一帧画面。

也就是说Flutter在移动端的运行需要至少一个Activity或者View Controller元素, 而Flutter也有自己的路由栈模型.

<br/>

在混合开发的应用中，原生Android、iOS与Flutter各自实现了一套互不相同的页面映射机制，原生平台采用的是单容器单页面，即一个ViewController或Activity对应一个原生页面；而Flutter采用单容器多页面的机制，即一个ViewController或Activity对应多个Flutter页面。Flutter在原生的导航栈之上又自建了一套Flutter导航栈，这使得原生页面与Flutter页面与之间进行页面切换时，需要处理跨引擎的页面切换问题。


<img src="https://img-blog.csdnimg.cn/20200127143237690.png" alt="hibird" style="zoom: 67%;" />

<br/>

### 混合导航栈:  指的是在混合开发中原生页面和Flutter页面相互掺杂，存在于用户视角的页面导航栈视图

1. 原生跳转Flutter页面
   - 实例化多`FlutterEngine`, 呈现多`FlutterAcitvity`实现多模块业务
   - 缓存一个`FlutterEngine`, 使用`MethodChannel`进行页面跳转
2. Flutter跳转原生页面
   - 使用`MethodChannel`与原生通信, 由原生端实现跳转逻辑
3. Flutter关闭当前及根页面
   - 使用`MethodChannel`与原生通信,由原生端实现跳转逻辑

<img src="https://img-blog.csdnimg.cn/20200127145101781.png" alt="skip" style="zoom: 50%;" />



<br/>

对于原生 Android、iOS 工程混编 Flutter 开发，由于应用中会同时存在 Android、iOS 和 Flutter 页面，所以**我们需要妥善处理跨渲染引擎的页面跳转，解决原生页面如何切换 Flutter 页面，以及 Flutter 页面如何切换到原生页面的问题**。
<br/>

在原生页面切换到 Flutter 页面时，我们通常会将 Flutter 容器封装成一个独立的 ViewController（iOS 端）或 Activity（Android 端），在为其设置好 Flutter 容器的页面初始化路由（即根视图）后，原生的代码就可以按照打开一个普通的原生页面的方式来打开 Flutter 页面了。
<br/>

如果我们想在 Flutter 页面跳转到原生页面，则需要同时处理好打开新的原生页面，以及关闭自身回退到老的原生页面两种场景。在这两种场景下，我们都需要利用方法通道来注册相应的处理方法，从而在原生代码宿主实现新页面的打开和 Flutter 容器的关闭。

<br/>

## [多引擎带来的问题](https://flutter.cn/docs/development/add-to-app/android/add-flutter-screen#step-3-optional-use-a-cached-flutterengine)

需要注意的是，与纯 Flutter 应用不同，原生应用混编 Flutter 由于涉及到原生页面与 Flutter 页面之间切换，因此导航栈内可能会出现多个 Flutter 容器的情况，即多个 Flutter 实例。<u>**Flutter 实例的初始化成本非常高昂，每启动一个 Flutter 实例，就会创建一套新的渲染机制，即 Flutter Engine，以及底层的 Isolate。而这些实例之间的内存是不互相共享的，会带来较大的系统资源消耗。**</u>

<br/>

在原生页面和Flutter页面共存的情况下，如何管理路由，以及原生页面与Flutter页面之间的切换和通信都是混合开发中需要解决的问题。然而，官方没有提供明确的解决方案，只是在混合开发时，官方建议开发者，应该使用同一个引擎支持多窗口绘制的能力，至少在逻辑上做到`FlutterViewController`是共享同一个引擎里面的资源。换句话说，官方希望所有的绘制窗口共享同一个主Isolate，而不是出现多个主Isolate的情况。不过，对于现在已经出现的多引擎模式问题，Flutter官方也没有提供好的解决方案。除了内存消耗严重外，多引擎模式还会带来如下一些问题。



- 冗余资源问题。多引擎模式下每个引擎的Isolate是相互独立的，虽然在逻辑上这并没有什么坏处，但是每个引擎底层都维护了一套图片缓存等比较消耗内存的对象，因此设备的内存消耗是非常严重的。

- 插件注册问题。在Flutter插件中，消息传递需要依赖Messenger，而Messenger是由FlutterViewController去实现的。如果一个应用中同时存在多个FlutterViewController，那么插件的注册和通信将会变得混乱且难以维护。
- 增加页面通信的复杂度。如果所有的Dart代码都运行在同一个引擎实例中，那么它们会共享同一个Isolate，可以用统一的框架完成组件之间的通信，但是如果存在多个引擎实例会让Isolate的管理变得更加复杂。
- Flutter组件和原生页面的差异化问题。通常，Flutter页面是由组件构成的，原生页面则是由ViewController或者Activity构成的。逻辑上来说，我们希望消除Flutter页面与原生页面的差异，否则在进行页面埋点和其它一些操作时增加一些额外的工作量。

<br/>

#### 应该尽量使用Flutter去开发一些闭环业务，减少原生页面与Flutter页面之间的交互，尽量避免Flutter页面跳转到原生页面，原生页面又启动一个新的Flutter实例的情况，并且保证应用内不要出现多个 Flutter 容器实例的情况。

<br/>

目前，对于原生工程混编Flutter工程出现的多引擎模式问题，国内主要有两种解决方案，一种是字节跳动的修改Flutter Engine源码方案，另一种是闲鱼开源的`FlutterBoost`。由于字节跳动的混合开发的方案没有开源，所以现在能使用的就剩下`FlutterBoost`方案。

<br/>

## **简单了解[flutter_boost](https://github.com/alibaba/flutter_boost/blob/master/README_CN.md)**

新一代Flutter-Native混合解决方案。 `FlutterBoost`是一个Flutter插件，它可以轻松地为现有原生应用程序提供Flutter混合集成方案。`FlutterBoost`的理念是将Flutter像Webview那样来使用。在现有应用程序中同时管理Native页面和Flutter页面并非易事。 `FlutterBoost`帮你处理页面的映射和跳转，你只需关心页面的名字和参数即可（通常可以是URL）。





> **通过Demo测试可以解决使用同一个`FlutterEngine`解决多循环跳转问题混合路由栈的问题**



参考 

https://flutter.cn/docs/development/add-to-app

https://segmentfault.com/a/1190000039760722

