## 说在前面

有时候，用 Flutter 一次性重写整个已有的应用是不切实际的。对于这些情况，**Flutter 可以作为一个库或模块，集成进现有的应用当中。模块引入到您的 Android 或 iOS 应用（当前支持的平台）中，以使用 Flutter 来渲染一部分的 UI，或者仅运行多平台共享的 Dart 代码逻辑。**

Flutter是一个由C++实现的Flutter Engine和由Dart实现的Framework组成的跨平台技术框架。其中，**Flutter Engine负责线程管理、Dart VM状态管理以及Dart代码加载等工作，而Dart代码所实现的Framework则负责上层业务开发**，如Flutter提供的组件等概念就是Framework的范畴。<br/>

##### Flutter开发模式主要分为两种:

-  一种是独立App的模式, 以Flutter项目为主,原生工程会包含在Flutter工程目录下, 

- 另一种是让Flutter以模块的的形式存在,分别被集成/依赖在已有的ios和Android原生应用下,原生工程可以在任何目录结构下,和Futter工程地址不产生关联.

  > (但是建议与原生工程同一级别目录,部分构建脚本文件需要被git跟踪)



#### [集成到Android应用](https://flutter.cn/docs/development/add-to-app)

- 在 Gradle 脚本中添加一个自动构建并引入 Flutter 模块的 Flutter SDK 钩子。

- 将 Flutter 模块构建为通用的 Android Archive (AAR) 以便集成到您自己的构建系统中，并提高 Jetifier 与 AndroidX 的互操作性；

- FlutterEngine API 用于启动并持续地为挂载 FlutterActivity 或 FlutterFragment 提供独立的 Flutter 环境；

- Android Studio 的 Android 与 Flutter 同时编辑，以及 Flutter module 创建与导入向导；

- 支持了 Java 和 Kotlin 为宿主的应用程序；

- Flutter 模块可以通过使用 Flutter plugins 与平台进行交互。

- 支持通过从 IDE 或命令行中使用 flutter attach 来实现 Flutter 调试与有状态的热重载。




#### [集成到IOS应用](https://flutter.cn/docs/development/add-to-app#add-to-android-applications)

- 在 Xcode 的 Build Phase 以及 CocoaPods 中，添加一个自动构建并引入 Flutter 模块的 Flutter SDK 钩子。
- 将 Flutter 模块构建为通用的 iOS Framework 以便集成到您自己的构建系统中；
- [`FlutterEngine`](https://api.flutter-io.cn/objcdoc/Classes/FlutterEngine.html) API 用于启动并持续地为挂载 [`FlutterViewController`](https://api.flutter-io.cn/objcdoc/Classes/FlutterViewController.html) 以提供独立的 Flutter 环境；
- 支持了 Objective-C 和 Swift 为宿主的应用程序；
- Flutter 模块可以通过使用 [Flutter plugins](https://pub.flutter-io.cn/flutter) 与平台进行交互；
- 支持通过从 IDE 或命令行中使用 `flutter attach` 来实现 Flutter 调试与有状态的热重载。




### 对已有Android项目进行集成 :

Flutter 可以作为 Gradle 子项目源码或者 AAR 嵌入到现有的 Android 应用程序中。也就是**将Flutter module作为依赖项, 通过原生项目对其依赖.**

#### **两种集成方式:** 

1.  通过gradle子项目 ( Android module ) 的方式进行依赖.
    **优点:**  对于Flutter module开发者便于开发 调试, 相对灵活. 
    **缺点:**  项目开发者都要下载Flutter SDK,  每次构建时都要重新编译该模块, 打包时间较长.

2.  把Flutter业务代码打包成AAR ( Android Archive ) 包, 对AAR包进行依赖.

   **优点:**  非Flutter module开发者无需安装Flutter SDK, 构建编译应用速度快, 异常率低.
   
   

> [注意:](https://flutter.cn/docs/development/add-to-app/android/project-setup)
> 
> Flutter 当前仅支持 为 x86_64，armeabi-v7a 和 arm64-v8a 构建预编（AOT）的库。
> Flutter 引擎支持 x86 和 x86_64 的版本，在模拟器以 debug 即时编译 (JIT) 模式运行时， Flutter 模块仍可以正常运行。
> `abiFilters`中不可有`x86`标识.不然在对应的设备上运行会崩溃.



#### 对AAR文件进行依赖:

1. 在flutter module目录下执行命令:

```gradle

	flutter build aar

```

命令执行完成后会在module目录生成相关文件目录`flutter_debug`,`flutter_profile`,`flutter_release`,

2. 修改项目主module目录下的`build.gradle`文件

```gradle
   
   android {
     // ...
   }
   
   repositories {
     maven {
       url 'some/path/my_flutter/build/host/outputs/repo'
       // This is relative to the location of the build.gradle file
       // if using a relative path.
     }
     maven {
       url 'https://storage.googleapis.com/download.flutter.io'
     }
   }
   
   dependencies {
     // ...
     debugImplementation 'com.example.flutter_module:flutter_debug:1.0'
     profileImplementation 'com.example.flutter_module:flutter_profile:1.0'
     releaseImplementation 'com.example.flutter_module:flutter_release:1.0'
   }
   
```
> url 只需要指定aar包的具体位置即可.

<br/>

#### 通过Module的方式依赖:



1. 创建Flutter Module.<!--(如果已有module可以省略此步骤)-->

- 通过Android Studio 创建flutter module. ( 如果是简单的Demo项目可以自动完成下面的集成步骤,但是比较庞大的已有项目大部分情况不能够自动完成下面的步骤 )

- 通过命令创建

```dart
  
  flutter create -t module -org [com.wshifu.app.flutter_module] [flutter_module]
  
```

创建的module中包含`.android`目录, 可以最为独立应用运行.做一些测试使用.

> 这里建议把flutter module项目建立在与已有项目目录级别.方便项目管理.

<br/>

2. 将 Flutter 模块作为子项目添加到宿主应用的 `settings.gradle` 中：

```dart
    
	include ':app'
    setBinding(new Binding([gradle: this])) 
    evaluate(new File(
        settingsDir.parentFile,
        'my_flutter/.android/include_flutter.groovy'
    )) 
        
```

`binding` 和 `evaluation` 脚本可以使 Flutter 模块将其自身（如 :flutter）和该模块使用的所有 Flutter 插件（如 :package_info，:video_player 等）都包含在 settings.gradle 的评估的上下文中。

` 默认情况下，宿主应用程序已经提供了 Gradle 项目 :app。要更改该项目的名称，可以在 Flutter 模块的 gradle.properties 文件中设置 flutter.hostAppProjectName。最后，将该项目添加到下面提到的宿主应用的 settings.gradle 文件中。`

> 这里有个坑, 如果当前的应用default module已经进行项目自定义, 会报异常:
> ```
> Caused by: java.lang.AssertionError: Project :app doesn't exist. To custom the host app project name, set `org.gradle.project.flutter.hostAppProjectName=<project-name>` in gradle.properties.. Expression: (appProject != null). Values: appProject = null
> ```
> **官方给出的方案是无效的. 须在已有项目的`gradle.properties`中增加: `flutter.hostAppProjectName=WshifuAppAndroid`**

设置完成后点击`sync`, 进行项目同步, 同步完成后会在`setting.gradle`文件中自动插入新的脚本内容:

```dart

    include ':flutter_module'
    project(':flutter_module').projectDir = new File('../flutter_module')

```

<br/>

3. 添加依赖,对Flutter module进行项目依赖

```dart
    
	dependencies {
        implementation project(':flutter')
  }

```

> 注意: 这里为什么依赖的是`:flutter`呢?  整个过程并没有设定Flutter module的名称为`flutter`, 其实它是`../.android/include_flutter.groovy`脚本中设定的.

```gradle

  gradle.include ":flutter"
  gradle.project(":flutter").projectDir = new File(flutterProjectRoot,".android/Flutter")

```

<br/>

4. 在 `AndroidManifest.xml` 中添加 FlutterActivity

Flutter 提供了 FlutterActivity，用于在 Android 应用内部展示一个 Flutter 的交互界面。和其他的 Activity 一样，FlutterActivity 必须在项目的 AndroidManifest.xml 文件中注册。

```xml
    <activity
        android:name="io.flutter.embedding.android.FlutterActivity"
        android:theme="@style/ActivityTheme"
        android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
        android:hardwareAccelerated="true"
        android:windowSoftInputMode="adjustResize"
    />
```

> 通常我们需要在原生端创建新的子类去继承FlutterActivity,重写或者实现相关的其他业务, 那么要注意了: 
- 对于完成的Flutter项目, 直接在AndroidManifest.xml中声明系类的文件名,替换掉上文的`io.flutter.embedding.android.FlutterActivity`即可.
- 对于依赖flutter module的情况是行不通的, 因为无论怎么重写及声明,FlutterEngine都会实现FlutterActivity的实例,并不会实例化我们重写的子类. 

```java

  @NonNull
    public static Intent createDefaultIntent(@NonNull Context launchContext) {
      return withNewEngine().build(launchContext);
    }

    @NonNull
    public static NewEngineIntentBuilder withNewEngine() {
      return new NewEngineIntentBuilder(FlutterActivity.class);
    }

```
通过源码可以看出, 在创建Intent启动FlutterActivity的时候指定了`FlutterActivity.class`类类型, 所以只会闯将FlutterActivity的实例,而不会使用其子类.

解决:  `withNewEngine()`是FlutterActivity的方法, 我们只要重写该方法既可

```kotlin

   startActivity(new FlutterActivity.CachedEngineIntentBuilder(
                    MethodChannelActivity.class,
                    "flutter_engine_id")
                    .build(context);

```

<br/>

5. 加载 FlutterActivity

   每一个 `FlutterActivity` 默认会创建它自己的 `FlutterEngine`。

```java

    import io.flutter.embedding.android.FlutterActivity;

    // 执行默认的初始路由入口, 需要在MaterialApp()节点配置`initialRoute`及`home`,否则异常
    startActivity(
      FlutterActivity.createDefaultIntent(currentActivity)
    );

    // 使用新的FlutterEngine创建新的FlutterActivity实例,指定新的路由入口, 
    startActivity(
        FlutterActivity
            .withNewEngine()
            .initialRoute("/my_route")
            .build(currentActivity)
    );

```

工厂方法 withNewEngine() 可以用于配置一个 FlutterActivity，它会在内部创建一个属于自己的 FlutterEngine 实例，这**会有一个明显的初始化时间**。另外一种可选的做法是让 FlutterActivity 使用一个预热且缓存的 FlutterEngine，这可以最小化 Flutter 初始化的时间。

<br/>

6.  使用缓存的 FlutterEngine

每一个 FlutterActivity 默认会创建它自己的 FlutterEngine。每一个 FlutterEngine 会有一个明显的预热时间。这意味着加载一个标准的 FlutterActivity 时，在你的 Flutter 交互页面可见之前会有一个短暂的延迟。想要最小化这个延迟
要预热一个 FlutterEngine，可以在你的应用中找一个合理的地方实例化一个 FlutterEngine。

```kotlin

    class MyApplication : Application() {
        lateinit var flutterEngine : FlutterEngine

        override fun onCreate() {
            super.onCreate()

            // Instantiate a FlutterEngine.
            flutterEngine = FlutterEngine(this)
            flutterEngine.getNavigationChannel().setInitialRoute("your/route/here");

            // Start executing Dart code to pre-warm the FlutterEngine.
            flutterEngine.dartExecutor.executeDartEntrypoint(
            	DartExecutor.DartEntrypoint.createDefault())
            // 后续就开始执行'runApp()'

            // Cache the FlutterEngine to be used by FlutterActivity.
            FlutterEngineCache.getInstance().put("my_engine_id", flutterEngine)
        }
    }

      // 使用一个缓存FlutterEngine
    startActivity(
        FlutterActivity
            .withCachedEngine("flutter_engine_unique_id")
            .build(this)
    );

```

要预热一个 FlutterEngine，必须执行一个 Dart 入口。**切记当 executeDartEntrypoint() 方法调用时， Dart 入口方法就会开始执行。**如果你的 Dart 入口调用了 runApp() 来运行一个 Flutter 应用，那么你的 **Flutter 应用会像是运行在一个大小为零的窗口中**，直至 FlutterEngine 附属到一个 FlutterActivity，FlutterFragment 或 FlutterView。

当使用一个缓存的 FlutterEngine 时， FlutterEngine 会比展示它的 FlutterActivity 或 FlutterFragment 存活得更久。切记，Dart 代码会在你预热 FlutterEngine 时就开始执行，并且在你的 FlutterActivity 或 FlutterFragment 销毁后继续运行。要停止代码运行和清理相关资源，可以**从 FlutterEngineCache 中获取你的 FlutterEngine，然后使用 FlutterEngine.destroy() 来销毁 FlutterEngine**。

在 runApp() 的首次执行之后，**修改导航通道中的初始路由属性是不会生效的**。想要在不同的 Activity 和 Fragment 之间使用同一个 FlutterEngine，并且在其展示时切换不同的路由，开发者需要设置一个方法通道，来显式地通知他们的 Dart 代码切换 Navigator 路由。



## [对已有IOS项目进行集成 :](https://flutter.cn/docs/development/add-to-app/ios/project-setup#embed-the-flutter-module-in-your-existing-application)



这里有两种方式可以将 Flutter 集成到你的既有应用中。

1. **使用 CocoaPods 依赖管理和已安装的 Flutter SDK 。（推荐）**
2. 把 Flutter engine 、你的 dart 代码和所有 Flutter plugin 编译成 framework 。用 Xcode 手动集成到你的应用中，并更新编译设置。


> 你的应用将不能在模拟器上运行 Release 模式，因为 Flutter 还不支持将 Dart 代码编译成 x86/x86_64 ahead-of-time (AOT) 模式的二进制文件。你可以在模拟机和真机上运行 Debug 模式，在真机上运行 Release 模式。



***对于已有项目集成Flutter SDK的方式需要结合实际情况而视.***



参考: 
https://flutter.cn/docs/development/add-to-app/android/project-setup
https://blog.csdn.net/xiangzhihong8/article/details/104092670