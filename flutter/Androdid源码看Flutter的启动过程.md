### 我们先看下启动代码



先创建flutter入口主文件`main.dart`

```dart

void main() =>
    runApp(const Text('Hello,world', textDirection: TextDirection.ltr));

```

如果我们直接打包成`Apk`，或者作为web项目运行，那么程序启动后将直接展示`Hello,world`文本.

如果我们把它嵌入到原生应用作为依赖`module`，那么打开flutter 页面有两种方式：

>  (需要在`AndroidManifest.xml`清单文件中注册`FlutterActivity`)

1. **创建新的`FlutterEngine`的方式打开页面：**

   ```kot
   
   // 使用默认新建引擎的方式打开FlutterActivity
   startActivity(FlutterActivity.createDefaultIntent(context))
   // 自定义配置，创建新的引擎实例
   startActivity( 	
          FlutterActivity.withNewEngine().initialRoute("/").build(currentActivity));
   
   ```

   

2. **使用缓存引擎打开flutter页面：**

   ```ko
   
   // 创建引擎实例
   val flutterEngine = FlutterEngine(this)
   // 配置引擎及开始执行Dart代码
   flutterEngine.getNavigationChannel().setInitialRoute("/	");
   flutterEngine.dartExecutor.executeDartEntrypoint(
   						 DartExecutor.DartEntrypoint.createDefault())
//并缓存到FlutterEngineCache单例中
   FlutterEngineCache.getInstance().put("engine_cache_id",flutterEngine)
   
   // 指定对应的引擎id，启动FlutterActivity
   startActivity(FlutterActivity.withCachedEngine("engine_cache_id").build(context))
   
   ```
   
   > 在创建引擎时还可以指定一些参数，这里暂时忽略。
   
   > 无论是通过哪种方式启动，最终都是通过对应的建造者的`**IntentBuilder.build()`来创建`Intent`意图对象来启动`FlutterActivity`
   >
   > ```java
   > 
   > @NonNull
   > public static Intent createDefaultIntent(@NonNull Context launchContext) {
   >     return withNewEngine().build(launchContext);
   > }
   > 
   > // 创建Intent传递数据
   > @NonNull
   > public Intent build(@NonNull Context context) {
   >     return new Intent(context, activityClass)
   >         .putExtra(EXTRA_INITIAL_ROUTE, initialRoute)  // 初始路由
   >         .putExtra(EXTRA_BACKGROUND_MODE, backgroundMode) // 背景是否透明
   >         .putExtra(EXTRA_DESTROY_ENGINE_WITH_ACTIVITY, true);
   > }
   > 
   > ```
   >



简单理解：使用内部`*IntentBuilder`类内部方法创建意图`Intent`对象然后打开`FlutterActivity`，注意：如果需要继承`FlutterActivity`实现自有业务，那么需要重新创建`*IntentBuilder`指定`activityClass`值；

**注意：如果使用缓存引擎的方式，在初始时就已经开始执行Dart代码了，而默认创建的话是在生命周期`Activity.onStart()`开始执行的。**




### `FlutterActivity`

在分析源码之前先看下`FlutterActvity`的介绍：

> `Activity which displays a fullscreen Flutter UI.`
>
> `FlutterActivity is the simplest and most direct way to integrate Flutter within an Android app.`
>
> `Displays an Android launch screen.`
> `Displays a Flutter splash screen.`
> `Configures the status bar appearance.`
> `Chooses the Dart execution app bundle path and entrypoint.`
> `Chooses Flutter's initial route.
> Renders Activity transparently, if desired.
> Offers hooks for subclasses to provide and configure a FlutterEngine.`
> 
>更多信息可以查阅`FlutterActivity.class`源码注释

```java
public class FlutterActivity extends Activity
    implements FlutterActivityAndFragmentDelegate.Host {

    protected FlutterActivityAndFragmentDelegate delegate;
	 
    @Override  // 这里onCreate()使用`protected`进行修饰，不建议在子类复写该方法
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        switchLaunchThemeForNormalTheme(); // 切换主题
        super.onCreate(savedInstanceState);
        delegate = new FlutterActivityAndFragmentDelegate(this); // 创建代理实例并关联
        delegate.onAttach(this);
        configureWindowForTransparency(); // 根据Intent的`backgroundMode`参数设置背景是否透明
        setContentView(createFlutterView()); // 创建FlutterView并设置给DecorView.
        ...
    }
}
    
```

> `FlutterActivity`为`Flutter`应用提供原生容器。

> * 在`FlutterActivity`的各个声明周期都回调了`Delegate`的对应函数。
>
> * 容器层所作的一级业务都在`onCreate（）`中，详细我们在看`Delegate`逻辑。

 

在`FlutterActivity.java`文件中做的逻辑并不多，主要逻辑实现在代理类对象中，继续看 ：



### `FlutterActivityAndFragmentDelegate`

> `Delegate that implements all Flutter logic that is the same between a FlutterActivity and a FlutterFragment. `

> `ExclusiveAppComponent: An Android App Component exclusively attached to a FlutterEngine.`它可能是`Activity`也可能是`Fragment`.

```java

class FlutterActivityAndFragmentDelegate implements ExclusiveAppComponent<Activity> {
      @NonNull  private Host host;
      @Nullable private FlutterEngine flutterEngine;  // Flutter engine
      @Nullable private FlutterView flutterView;      // FlutterView
      @Nullable private PlatformPlugin platformPlugin;
    
   FlutterActivityAndFragmentDelegate(@NonNull Host host) {
    this.host = host;
   }
   
    // 1. Initializes the Flutter system.
    // 2. Obtains or creates a FlutterEngine.
    // 3. Creates and configures a PlatformPlugin.
    // 4. Attaches the FlutterEngine to the surrounding Activity, if desired.
    // 5. Configures the FlutterEngine via 
    // 6. FlutterActivityAndFragmentDelegate.Host.configureFlutterEngine.
  void onAttach(@NonNull Context context) {
    // 1 - 创建FlutterEngine
    if (flutterEngine == null) {
        String cachedEngineId = host.getCachedEngineId();
    	if (cachedEngineId != null) { 
            // 如果给出cachedId则去Map<String,FlutterEngine>找对应的实例。
      		flutterEngine = FlutterEngineCache.getInstance().get(cachedEngineId);
            ...
      		return;
    	}
        // 否则使用自定义的逻辑（可以继承FlutterActivity重写方法自定义FlutterEngine）
        flutterEngine = host.provideFlutterEngine(host.getContext());
        if (flutterEngine != null) {
          isFlutterEngineFromHost = true;
          return;
    	}
        // 如果没有自定义则使用新建，即调用`createDefaultIntent()`时的逻辑
        flutterEngine = new FlutterEngine( host.getContext(),
            						host.getFlutterShellArgs().toArray(),false,
                   					host.shouldRestoreAndSaveState());
         isFlutterEngineFromHost = false;
    }
    ...
    // 2 - 获取关联FlutterEngine的平台插件(由FlutterActivity创建实例)
    platformPlugin = host.providePlatformPlugin(host.getActivity(), flutterEngine);
	// 3 - bind flutter engine to host
    host.configureFlutterEngine(flutterEngine);
  }
    
```



从`onAttach()`方法我们可以看出，此时已经创建了`FlutterEngine`及`PlateformPlugin`并关联到`host`。

当然这里的**`host`可以是`Activity`也可以是`Fragment`**,这就意味着，一个运行时`Host` <=> `FlutterEngine` .

------



按照`FlutterAcitvity`的`onCreate()`流程，代理类的对象的`attach`已经完成，主要是初始化`FlutterEnige`。

接下来是`onCreate()->setContentView(createFlutterView())`，这里在创建View时，同样是直接调用代理对象的`delegate.createView()`函数，看其具体函数的源码：

```java

  View onCreateView( LayoutInflater inflater,@Nullable ViewGroup container,
                    @Nullable Bundle savedInstanceState,int flutterViewId, 
                    boolean shouldDelayFirstAndroidViewDraw){
       // 如果指定了渲染模式为`surface`那么使用`SurfaceView`,否则使用`TextureView`.
       // 然后bind 到FlutterView.
       if (host.getRenderMode() == RenderMode.surface) {
      	  FlutterSurfaceView flutterSurfaceView = new FlutterSurfaceView(
              host.getContext(), 
              host.getTransparencyMode() == TransparencyMode.transparent);
	  	  	 
          flutterView = new FlutterView(host.getContext(), flutterSurfaceView);
 	   } else {
         FlutterTextureView flutterTextureView = 
             new FlutterTextureView(host.getContext());
           
      	 flutterView = new FlutterView(host.getContext(), flutterTextureView);
       }
      ...
      // 注意，这里有把FlutterEngine传递给FutterView.内部执行是通过FlutterEngine获取FlutterRenderder引用给到FlutterSuface.
      flutterView.attachToFlutterEngine(flutterEngine);
      ...
      return flutterView;
  }

```

> 问 ： 为什么要使用`SurfaceView/TextureView`呢？
>
> 它们支持非`UI`线程渲染，同时支持流内容进行绘制渲染，例如连接相机时画面预览等。



对于`FlutterView`稍后再看

根据上面的结论可以得出，一个`Host` & `FlutterEngine`  & `FlutterView`



这样`FlutterActivity`的`onCreate()`方法就执行完了, 接下来我们看`Activity`的`onStart()`方法,其实在`Activity`层只做了一件事，就是通过`delegate`去执行其代理的`onStart()`,来看源码：

```java
  /**
    Invoke this from {@code Activity#onStart()} or {@code Fragment#onStart()}.
    Begins executing Dart code, if it is not already executing.
  */
  void onStart() {
    doInitialFlutterViewRun();
  }
  /**
     Starts running Dart within the FlutterView for the first time.
  */
  private void doInitialFlutterviewRun(){
      // 如果DartExecutor.isApplicationRunning == true return；
      // 当使用缓存Engine时这里会条件成立
      if (flutterEngine.getDartExecutor().isExecutingDart()) { return; }
      String initialRoute = host.getInitialRoute();
      ... 
      flutterEngine.getNavigationChannel().setInitialRoute(initialRoute);
      ...
     // Configure the Dart entrypoint and execute it.
      DartExecutor.DartEntrypoint entrypoint =new DartExecutor.DartEntrypoint(
            appBundlePathOverride, host.getDartEntrypointFunctionName());
      // 最后调用native方法：native void nativeRunBundleAndSnapshotFromLibrary()
      flutterEngine.getDartExecutor().executeDartEntrypoint(entrypoint);
  }

```



### `FlutterView`

在Android设备上使用`FlutterView`进行显示`Flutter UI`，其具体的绘制由关联的`FlutterEngine`进行控制。
其本质是继承了`FramLayout`,并根据不同的参数配置使用`FlutterSurfaceView`/`FlutterTextureView`.

> `Displays a Flutter UI on an Android device.`
> `A FlutterView's UI is painted by a corresponding FlutterEngine.`
>
> `A FlutterView can operate in 2 different RenderModes: `
> `RenderMode.surface : This mode has the best performance`
>
> ` RenderMode.texture: This mode is not as performant as RenderMode.surface, but a FlutterView in this mode can be animated and transformed, as well as positioned in the z-index between 2+ other Android Views.`
>

```java

public class FlutterView extends FrameLayout{
    
	RenderSurface renderSurface;
	private FlutterEngine flutterEngine;
    private FlutterSurfaceView flutterSurfaceView;
    private FlutterTextureView flutterTextureView;
	
     private void init() {
         if (flutterSurfaceView != null) {
             addView(flutterSurfaceView);
         }else if (flutterTextureView != null) {
             addView(flutterTextureView);
         }
        ...
     }
    
    // Connects this FlutterView to the given FlutterEngine.
	// This FlutterView will begin rendering the UI painted by the given FlutterEngine. This FlutterView will also begin forwarding interaction events from this FlutterView to the given FlutterEngine
    public void attachToFlutterEngine(FlutterEngine flutterEngie){
		...
        this.flutterEngine = flutterEngine;
		FlutterRenderer flutterRenderer = this.flutterEngine.getRenderer();
		// 同时FlutterSurfaceView/FlutterTextureView进行创建Surface
		renderSurface.attachToRenderer(flutterRenderer);
        // flutterUiDisplayListener 进行UI开始渲染回调
		flutterRenderer.addIsDisplayingFlutterUiListener(flutterUiDisplayListener);
		// 一路向下，bind KeyboardManager等
		... 
		// 再上一层的回掉是由FlutterJNI设置给回调确认是否完成
		flutterUiDisplayListener.onFlutterUiDisplayed();
    }
}

// FlutterSurfaceView 和 FlutterTextureView 都实现了RenderSurface，同时都传入了FlutterRender
public class FlutterSurfaceView extends SurfaceView implements RenderSurface {...}
public class FlutterTextureView extends TextureView implements RenderSurface {
    
	private FlutterRenderer flutterRenderer;
    /**
    Invoked by the owner of this FlutterSurfaceView when it wants to begin rendering a Flutter UI to this FlutterSurfaceView.
    */
    public void attachToRenderer(@NonNull FlutterRenderer flutterRenderer) {
		 this.flutterRenderer = flutterRenderer;
		 flutterRenderer.startRenderingToSurface(getHolder().getSurface());
    }
    /*
    Notifies Flutter that the given surface was created and is available for Flutter rendering.最终通知native进行绘制页面，而FlutterView只是创建Surface传递给native。
	*/
	public void FlutterRender.startRenderingToSurface(Surface surface){
        flutterJNI.onSurfaceCreated(surface);
    }
}

class FlutterJNI {
	// 把Surface传递给antive.
     private native void nativeSurfaceCreated(long nativeShellHolderId, Surface surface);
}

```



`FlutterSurfaceView`和`FlutterTexttureView`都实现了接口都实现了`RenderSurface`，同时都定义了一个方法`attachToRenderer()`,传入一个`FlutterRenderer`对象 ，`FlutterRenderer`内部绑定了`FlutterJNI`实例，进行与底层数据进行通信从而实现`FlutterUI`渲染。

> 对于渲染：`FlutterView`负责提供`Surface`给到native，具体绘制过程由native处理。



### `FlutterEngine`

> `A single Flutter execution environment.`
> `The FlutterEngine is the container through which Dart code can be run in an Android application.`
> `Dart code in a FlutterEngine can execute in the background, or it can be render to the screen by using the accompanying FlutterRenderer and Dart code using the Flutter framework on the Dart side. Rendering can be started and stopped, thus allowing a FlutterEngine to move from UI interaction to data-only processing and then back to UI interaction.`

```java
public class FlutterEngine {
  // Interface between Flutter embedding's Java code and Flutter engine's C/C++ code.
 private final FlutterJNI flutterJNI;
    
  // Represents the rendering responsibilities of a FlutterEngine.FlutterRenderer works in tandem with a provided RenderSurface to paint Flutter pixels to an Android View hierarchy.
 private final FlutterRenderer renderer;
    
  // Configures, bootstraps, and starts executing Dart code.
 private final DartExecutor dartExecutor;
    
 // This class is owned by the FlutterEngine and its role is to managed its connections with Android App Components and Flutter plugins.
 private final FlutterEngineConnectionRegistry pluginRegistry;
    
  // AccessibilityChannel，KeyEventChannel，LifecycleChannel，TextInputChannel，SystemChannel，SettingsChannel，PlatformChannel...
 private final system channels; // 一系列的系统组件通信对象
  ...

  // 构造方法:
  // 1. 初始化运行时 需要的实例assetsManager,flutterJNI,dartExecutor,flutterLoad,channels...
  // 2. 通过FlutterLoader加载native
  // 3. 关联flutterJNI到native
  // 4. 创建FlutterRender并attach FlutterJNI,初始化FlutterPlugin
  public FlutterEngine(Context context,FlutterJNI flutterJNI,...){
     AssetManager assetManager = ...; 
      
     FlutterInjector injector = FlutterInjector.instance();
    if (flutterJNI == null) {
      // 默认通过工厂方法实现：return new FlutterJNI() ；
      flutterJNI = injector.getFlutterJNIFactory().provideFlutterJNI();
    }
    this.flutterJNI = flutterJNI;
    // 创建DartExecutor实例，并attach FlutterJNI及AssetsManager
    this.dartExecutor = new DartExecutor(flutterJNI, assetManager);
    //  设置DartMessager Handler.
    this.dartExecutor.onAttachedToJNI();
    ...
    keyEventChannel = new KeyEventChannel(dartExecutor);
	platformChannel = new PlatformChannel(dartExecutor);
    textInputChannel = new TextInputChannel(dartExecutor);
	systemChannel = new SystemChannel(dartExecutor);
    ... 
	attachToJni(); ->  flutterJNI.attachToNative();
    // 创建并关联render到flutterJNI
	this.renderer = new FlutterRenderer(flutterJNI);
    // 注册插件
this.pluginRegistry =
        new FlutterEngineConnectionRegistry(context.getApplicationContext(), this, flutterLoader);
 if (automaticallyRegisterPlugins && flutterLoader.automaticallyRegisterPlugins()) {
      GeneratedPluginRegister.registerGeneratedPlugins(this);
    }
  }
  ...
}

```




通过源码可以看出，其实就是开始执行`Dart`进程。

![]( https://qncdn.wanshifu.com/148b2ef51c7eca206720662f975490eb )

![new](https://qncdn.wanshifu.com/8f283a8bd4a797d8c9f932f24a155da9)


按照官方给出的启动方式，我们了解了主要的核心流程了。

**那么，问题来了?** 我们如果想要实现`N1` -> `F1` ->` N2` -> `F2` -> ...  ,或者`N1` -> `F1` -> `N2` -> `F2` -> `N3 `-> `F1`等一些与原生交互比较复杂场景要怎样实现呢？通过启动流程我们可以看到，每一个`FlutterActivity`对应着一个`FlutterEngine` ，同时对应一个`FlutterView`等等一套内部关联关系及流程...,当然`Flutter`管理是支持多引擎，可以通过引擎缓存进行管理，但是如果非闭环业务比较多，是不是意味着需要创建很多个缓存`FlutterEngine`，如果这样的话一旦处理不好就会造成高度内存问题，导致应用异常. 

当然，这里还有一种思路，我们是不是可以使用一个`FlutterEngine`,然后通过原生与Dart进行通信，每次打开在页面`Flutter`展示前 都通过事件提前指定目标路由，当然可以...但是如果单纯的这样处理会引起一个非常严重的问题，这样会改变Flutter层路由栈顺序，也许当我们返回时页面就不是我们打开时的顺序了...



这样，`flutter_boost`,`flutter_thiro`等一些框架就来了。这里我们仅参考`flutter_boost`，进行分析，看下它是怎样实现与原生混合交互的。



关于事件通信内容不多，通过给`FlutterEngine.dartExcutor`设置`MessageChannel`进行消息回调实现暂不详细查看；



### FLUTTER BOOST 

 `FlutterBoost`是一个Flutter插件，它可以轻松地为现有原生应用程序提供Flutter混合集成方案。`FlutterBoost`的理念是将Flutter像`Webview`那样来使用。在现有应用程序中同时管理Native页面和Flutter页面并非易事。` FlutterBoost`帮你处理页面的映射和跳转，你只需关心页面的名字和参数即可（通常可以是URL）。 



**[flutter_boost集成](https://github.com/alibaba/flutter_boost/blob/master/docs/install.md)**  不再进行描述，可以直接参考官链



划重点：我们还是优先看`FlutterBoostActivity`的实现逻辑：



#### `配置及使用`

```java

/**
需要在Application初始化FlutterBoost单例信息，从而创建FlutterEngine并执行Dart.runApp();
*/
class App extends Application{
   public void onCreate(){
       FlutterBoost.instance().setup(this, new FlutterBoostDelegate() {
           @Override
           public void pushNativeRoute(FlutterBoostRouteOptions options) {
                // Flutter 打开原生页面
           }
           @Override
           public void pushFlutterRoute(FlutterBoostRouteOptions options) {
           		// 原生打开 Flutter 页面
           }
       },engine -> { 
       		// flutter_boost默认使用单缓存引擎
       }
   }
}
    
/**
FlutterBoost 是单例，用于管理原生Api ,包括路由跳转，事件发送，原生生命周期发送等，最终通过FlutterBoostPlugin实现与Flutter通信。
主要创建一个FlutterEngine,然后放在Map<String,FlutterEngine>中，作为缓存使用。
*/
public void FlutterBoost.setup(...){
    ...
    FlutterEngine engine = getEngine();
     if (engine == null) {
         // First, get engine from option.flutterEngineProvider
         if (options.flutterEngineProvider() != null) {
             FlutterEngineProvider provider = options.flutterEngineProvider();
             engine = provider.provideFlutterEngine(application);
         }

         if (engine == null) {
             // Second, when the engine from option.flutterEngineProvider is null,
             // we should create a new engine
             engine = new FlutterEngine(application, options.shellArgs());
         }

         // Cache the created FlutterEngine in the FlutterEngineCache.
         FlutterEngineCache.getInstance().put(ENGINE_ID, engine);
        }
}              

public class FlutterBoostPlugin implements FlutterPlugin, NativeRouterApi, ActivityAware{
    
    private FlutterEngine engine;
    // 路由及生命周期to Flutter管理类，由BinaryMessenger通信；
    private FlutterRouterApi channel;
    // 代理，抽象类，在Application初始化时实现并传入实例
    private FlutterBoostDelegate delegate;
    // 栈信息，这个有意思了；
    private StackInfo dartStack;
	// 这两个也很关键
    public void onContainerShow(String uniqueId) {}
	public void onContainerHide(String uniqueId) {}
    
}

                 
```

``FlutterBoost`在`Application`主要做了初始化`FlutterEngine`及配置`FlutterBoostDelegate`路由代理。可以看出整个`FlutterBoost`使用的的单缓存引擎。再看下`FlutterBoostActivity`的代码：



### `FlutterBoostActivity`


```
                                     
/**
FlutterBoost 继承FlutterAcitivty
*/
class FlutterBoostActivity extends FlutterActivity implements FlutterViewContainer {
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        final FlutterContainerManager containerManager = 																					FlutterContainerManager.instance();
        // 如果顶层Container ！= this，则 dettach Engine.
        FlutterViewContainer top = containerManager.getTopContainer();
        if (top != null && top != this) top.detachFromEngineIfNeeded();
        super.onCreate(savedInstanceState);
        // 找到父类中createFlutterView()创建的FlutterView实例。
        flutterView = FlutterBoostUtils.findFlutterView(getWindow().getDecorView());
        // detach其与FlutterActivityAndFragmentDelegate生成的FlutterEngine;
        flutterView.detachFromFlutterEngine();
        // 把当前Container通过plugin保存到FlutterContainerManager管理器中
        FlutterBoost.instance().getPlugin().onContainerCreated(this);
    }
    
    @Override
    public void onResume() {
        super.onResume();
        final FlutterContainerManager containerManager =
            									FlutterContainerManager.instance();
        ...

        // 检查是否需要dettach engine，如果管理器顶部的容器实例不是当前则detach engine.
        FlutterViewContainer top = containerManager.getTopContainer();
        if (top != null && top != this) top.detachFromEngineIfNeeded();
        
		// 在把当前FlutterView 及 FlutterBootPlugin attach engine；
        performAttach();
    
        # 通过FlutterBoostPlugin通知Dart原生的声明周期变化
        # FlutterBoostActivity的每一个声生命周期函数都有该行为
        FlutterBoost.instance().getPlugin().onContainerAppeared(this);
    }
    
    @Override
    public void onPause(){
       // 通过plugin对生命周期函数回调
    }
    
    
   // attach engine
   private void performAttach() {
        if (!isAttached) { 
            getFlutterEngine().getActivityControlSurface().attachToActivity(delegate, getLifecycle());

            if (platformPlugin == null) {
                platformPlugin = new PlatformPlugin(getActivity(), getFlutterEngine().getPlatformChannel());
            }
			// 重新attach flutterView and engine
            flutterView.attachToFlutterEngine(getFlutterEngine());
        }
    }
}

   @Override
   public RenderMode getRenderMode() {
        // 在FlutterBoost中默认使用|FlutterTextureView|.
        return RenderMode.texture;
   }

```



1. 在`FlutterBoostActivity`中增加了view容器的概念，所有的View容器统一使用`FlutterContainerManager`单例进行管理，其内部使用`Hash<String,FlutterViewContainer>`进行维护，同时提供了对元素的`add(),remove(),find(),getTap()`等操作方法。每个`FlutterActivity`都实现了`FlutterViewContainer`,也就是说每个`Activity`都是一个容器实例。

2. 核心逻辑：通过View树遍历，找到父类初始化的`FlutterView`，然后把`FlutterView`在父类中绑定的`Engine`进行`dettach`.然后通过`FlutterBoostPlugin`把当前`Acitivity`增加到`FlutterContinerManager`容器管理器中。

3. **`FlutterBoostPlugin`**标准的flutter插件，继承`FlutterPlugin`。用于原生与Dart进行通信。我们稍后在看它。
4. 在`onResume()`时,检查顶层`FlutterViewContainer`是否为当前实例，如果不是则进行`detach`，然后对当前的`attach`状态进行检查，如果还没有`attach`的话则调用`performAttach（）`进行`engine`重新attach.
   1. 通过`FlutterEngie`获取当前环境的平台插件`platformPlugin`实例。
   2. 重新bind`FlutterEngine` 到当前页面的`FlutterView`
6.  容器管理器内部使用`Map<String, FlutterViewContainer> allContainers`对所有的Activity进行记录，key为唯一索引。而唯一id如果调用者没有指定，那么则使用默认生成的`UUID`,独立而唯一。这个唯一id主要的目的是原生页控制flutter页的显示与关闭逻辑。

> 注意：这里是在Activity的`onResume（）`进行再`attach`行为，如果页面的内容比较复杂，这里不排除界面白屏现象。



总结：原生端通过`FlutterContainerManager`管理`FlutterContainer`,

2. 当`FlutterBoostActivity`创建时当前的`FlutterView`   detach `FlutterEngine`
3. 当`FlutterBoostActivity`可见时比对是否需要重新attach（引擎是一份可能存在），如需重新关联那么创建当前Acitivity的PlatformPlugin，绑定当前Activity的FlutterView to engine,
4. 通知Dart部分查找展示BoostContainer，









#### 扩展：

[SurfaceView](https://developer.android.google.cn/reference/kotlin/android/view/SurfaceView?hl=en#summary)：  `SurfaceView `就是在 Window 上挖一个洞，它就是显示在这个洞里，其他的View是显示在Window上，所以View可以显式在 `SurfaceView之`上，  表面是Z轴排列的，这样它就在窗口后面，保持着它的`SurfaceView`;   传统View及其派生类的更新只能在`UI`线程，然而`UI`线程还同时处理其他交互逻辑，这就无法保证view更新的速度和帧率了，而`SurfaceView`可以用独立的线程来进行绘制。 

[TextureView](https://developer.android.google.cn/reference/kotlin/android/view/TextureView?hl=en) :  `TextureView`用于显示流内容，比如预览相机，预览视频等。 `TextureView`只能在硬件加速窗口中使用。 当在软件中渲染时，`TextureView`将不会绘制任何东西。 

**[SurfaceView与TextureView详解](https://cloud.tencent.com/developer/article/1771629)**

