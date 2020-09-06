startActivity() -> startActivityForResult()

#####  Android是如何通过Activity进行交互的?

1. `taskAffinity` 

通过设置不同的启动模式可以实现调配不同的 Task。但是 taskAffinity 在一定程度上也会影响任务栈的调配流程。

每一个 Activity 都有一个 `Affinity` 属性，如果不在清单文件中指定，默认为当前应用的包名。

使用命令行执行: `adb shell dumpsys activity activities` 查看当前Activity及任务栈的详情

>> 结论：单纯使用 taskAffinity 不能导致 Activity 被创建在新的任务栈中，需要配合 singleTask 或者 singleInstance！

2. `taskAffinity + allowTaskReparenting`

`allowTaskReparenting` 赋予 Activity 在各个 Task 中间转移的特性。一个在后台任务栈中的 Activity A，当有其他任务进入前台，并且 taskAffinity 与 A 相同，则会自动将 A 添加到当前启动的任务栈中。

案例:
1. 在某外卖 App 中下好订单后，跳转到支付宝进行支付。当在支付宝中支付成功之后，页面停留在支付宝支付成功页面。
2. 按 Home 键，在主页面重新打开支付宝，页面上显示的并不是支付宝主页面，而是之前的支付成功页面。
3. 再次进入外卖 App，可以发现支付宝成功页面已经消失。


##### 通过 Binder 传递数据的限制

原因是 Android 系统对使用 Binder 传数据进行了限制。通常情况为 1M-8k，如果是异步的情款下还需要减半;但是根据不同版本、不同厂商，这个值会有区别。

解决办法：
1. 减少通过 Intent 传递的数据，将非必须字段使用 transient 关键字修饰。
2. 将对象转化为 JSON 字符串，减少数据体积。


##### process 造成多个 Application
一直以来，我们经常会在自定义的 Application 中做一些初始化的操作。比如 App 分包、推送初始化、图片加载库的全局配置等;当我们在`AndroidManifest.xml`中组件属性添加:`android:process=":remote"`,该组件就会在新的线程中创建实例

针对这个问题，目前有两种比较好的处理方式：

1. onCreate 方法中判断进程的名称，只有在符合要求的进程里，才执行初始化操作；
2. 抽象出一个与 Application 生命周期同步的类，并根据不同的进程创建相应的 Application 实例。


##### 后台启动 Activity 失效

如果我们正在玩着游戏，此时手机后台可能有个下载某 App 的任务在执行。当 App 下载完之后突然弹出安装界面，中断了游戏界面的交互，这种情况会造成用户体验极差，而最终用户的吐槽对象都会转移到 Android 手机或者 Android 系统本身。
为了避免这种情况的发生，从 Android10（API 29）开始，Android 系统对后台进程启动 Activity 做了一定的限制。
主要目的就是尽可能的避免当前前台用户的交互被打断，保证当前屏幕上展示的内容不受影响。

解决办法：
Android 官方建议我们使用通知来替代直接启动 Activity 操作：


#### startActivity()

![拉钩教育](https://s0.lgstatic.com/i/image/M00/11/F8/CgqCHl7M0DeAQyu5AAC-zBQ1yGY981.png)

整个 startActivity 的流程分为 3 大部分，也涉及 3 个进程之间的交互：

1. ActivityA --> ActivityManagerService（简称 AMS）
2. ActivityManagerService --> ApplicationThread
3. ApplicationThread --> ActivityB

###### `ActivityA --> ActivityManagerService` 阶段

这一过程并不复杂，用一张图表示具体过程如下：

![过程1](https://s0.lgstatic.com/i/image/M00/11/F9/CgqCHl7M0D6APUSnAACBNzm-sQM664.png)

在调用`startActivity()`最终调用到了Activity 的 `startActivityForResult(intent,-1)`传入的 -1 表示不需要获取 startActivity 的结果;
`tartActivityForResult` 也很简单，调用 Instrumentation.execStartActivity 方法。剩下的交给 Instrumentation 类去处理。

解释说明：

- Instrumentation 类主要用来监控应用程序与系统交互。
- ActivityThread 可以理解为一个进程，即当前应用的主进程,在这就是 A 所在的进程。
- ApplicationThread ，这个引用就是用来实现进程间通信的，具体来说就是 AMS 所在系统进程通知应用程序进程进行的一系列操作

Instrumentation 的 execStartActivity;
![manager](https://s0.lgstatic.com/i/image/M00/11/EE/Ciqc1F7M0QSAHomcAAIQnVgFPtE390.png)
在 Instrumentation 中，会通过 ActivityManger.getService 获取 AMS 的实例，然后调用其 startActivity 方法，实际上这里就是通过 AIDL 来调用 AMS 的 startActivity 方法，至此，startActivity 的工作重心成功地从进程 A 转移到了系统进程 AMS 中。

###### `ActivityManagerService --> ApplicationThread` 阶段

接下来就看下在 AMS 中是如何一步一步执行到 B 进程的;实际上这里面就干了 2 件事：

1. 综合处理 launchMode 和 Intent 中的 Flag 标志位，并根据处理结果生成一个目标 Activity B 的对象（ActivityRecord）。
2. 判断是否需要为目标 Activity B 创建一个新的进程（ProcessRecord）、新的任务栈（TaskRecord）。

> ApplicationThread 类，这个类是负责进程间通信的，这里 AMS 最终其实就是调用了 B 进程中的一个 ApplicationThread 引用，从而间接地通知 B 进程进行相应操作。

![starter](https://s0.lgstatic.com/i/image/M00/11/EE/Ciqc1F7M0Q6AMyfdAARpsDnCyTE397.png)

从上图可以看出，经过多个方法的调用，最终通过 obtainStarter 方法获取了 ActivityStarter 类型的对象，然后调用其 execute 方法。在 execute 方法中，会再次调用其内部的 startActivityMayWait 方法。

`ActivityStarter 的 startActivityMayWait`

ActivityStarter 这个类看名字就知道它专门负责一个 Activity 的启动操作。它的主要作用包括解析 Intent、创建 ActivityRecord、如果有可能还要创建 TaskRecord。
在 startActivityMayWait 方法中调用了一个重载的 startActivity 方法，而最终会调用的 ActivityStarter 中的 startActivityUnchecked 方法来获取启动 Activity 的结果。

....


#### `ApplicationThread -> Activity`

 AMS 将启动 Activity 的任务作为一个事务 ClientTransaction 去完成，在 ClientLifecycleManager 中会调用 ClientTransaction的schedule() 方法，是调用了ActivityThread 的 scheduleTransaction 方法。但是这个方法实际上是在 ActivityThread 的父类 ClientTransactionHandler 中实现调用 sendMessage 方法，向 Handler 中发送了一个 EXECUTE_TRANSACTION 的消息，并且 Message 中的 obj 就是启动 Activity 的事务对象。而这个 Handler 的具体实现是 ActivityThread 中的 mH 对象。具体如下：

 ![handler](https://s0.lgstatic.com/i/image/M00/11/FA/CgqCHl7M0XuAMKd9AAEjo1qJnfI037.png)


 ActivityThread 的 handleLaunchActivity

 这是一个比较重要的方法，Activity 的生命周期方法就是在这个方法中有序执行，具体如下：

 ![launch](https://s0.lgstatic.com/i/image/M00/11/FB/CgqCHl7M0ZyAPWYRAAdkYWgxWUQ790.png)

 1. 图中 1 处初始化 Activity 的 WindowManager，每一个 Activity 都会对应一个“窗口”
 2. 图中 2 处调用 performLaunchActivity 创建并显示 Activity。
 3. 图中 3 处通过反射创建目标 Activity 对象。
 4. 图中 4 处调用 attach 方法建立 Activity 与 Context 之间的联系，创建 PhoneWindow 对象，并与 Activity 进行关联操作
 5. 图中 5 处通过 Instrumentation 最终调用 Activity 的 onCreate 方法。



 ### 结论

 1. 首先进程 A 通过 Binder 调用 AMS 的 startActivity 方法。
 2. 然后 AMS 通过一系列的计算构造目标 Intent，然后在 ActivityStack 与 ActivityStackSupervisor 中处理 Task 和 Activity 的入栈操作。
 3. 最后 AMS 通过 Binder 机制，调用目标进程中 ApplicationThread 的方法来创建并执行 Activity 生命周期方法，实际上 ApplicationThread 是 ActivityThread 的一个内部类，它的执行最终都调用到了 ActivityThread 中的相应方法。