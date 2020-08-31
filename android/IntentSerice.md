IntentService is a base class for {@link Service}s that handle asynchronous requests (expressed as {@link Intent}s) on demand.  Clients send requests through {@link android.content.Context#startService(Intent)} calls; the service is started as needed, handles each Intent in turn using a worker thread, and stops itself when it runs out of work.
IntertService 是 Service 的子类,可以通过startService(Intent())开启,内部维护了一个子线程来做耗时任务

All requests are handled on a single worker thread -- they may take as long as necessary (and will not block the application's main loop), but only one request will be processed at a time.
内部只有一个线程,一个IntentService一次只能处理一个任务,如果api>28建议使用`JobIntentService`

##### 基本使用:;

对于IntentService的基础使用很简单只要重写`onHandleIntent()`即可

```kotlin
    class TaskIntentService : IntentService("TaskIntentService"){
        
        override fun onCreate() {
            super.onCreate()
        }

        override fun onHandleIntent(intent: Intent?) {
            // 做一些后台耗时任务
        }
    }
```

##### 声明周期

因为继承了Service,所以完全遵循Service的标准声明周期模式,但是它通常备用来做后台耗时任务,声明周期对我们来讲意义不到

##### 那么继承了Service是怎样做到在线程中执行的呢?

先看一IntentService的`onCreate()`方法

```java
    @Override
    public void onCreate() {
        // TODO: It would be nice to have an option to hold a partial wakelock
        // during processing, and to have a static startService(Context, Intent)
        // method that would launch the service & hand off a wakelock.

        super.onCreate();
        HandlerThread thread = new HandlerThread("IntentService[" + mName + "]");
        thread.start();

        mServiceLooper = thread.getLooper();
        mServiceHandler = new ServiceHandler(mServiceLooper);
    }
```

看到这里原来是在onCreate()方法中创建了一个HandlerThread线程来执行,因为HandlerThread的构造器需要一个参数name,所以在实现IntentService的时候我们也需要传入一个name参数;
 
 *** HandlerThread的最要作用就是创建一个子线程然后初始化一个当前线程的Looper对象,然后把这个Looper对象给到其他Handler是对象,这样Handler的回调就可以在子线程中执行; ****

然后又创建了一个ServiceHandler,来看一下:

```java

     private final class ServiceHandler extends Handler {
        public ServiceHandler(Looper looper) {
            super(looper);
        }

        @Override
        public void handleMessage(Message msg) {
            onHandleIntent((Intent)msg.obj);            // 子线程中执行任务
            stopSelf(msg.arg1);                         // 当前任务执行完成即stopSelf()
        }
    }

```

在`handleMessage()`的回调时又调用了`onHandleIntent()`,这样我们在`onHandleIntent()`写的逻辑就在子线程中执行了,这里还有一个要注意`stopSelf`,如果当前任务执行完成即停止自己

```java
    
    @Override
    public void onDestroy() {
        mServiceLooper.quit();
    }

```

**记住在子线程中使用Looper对象时一定要记得要将Looper对象进行`quit()`,否则会有内存泄漏**

 todo JonIntentService...