Service 是Android系统实现后台任务的解决方案,通常不需要与用户有UI交互
> 注意: 这里的后台的意识是说不可见的,要知道它是在主线程中执行的

Service的实现需要继承Service,并在AndroidMamifest.xml清单文件中声明

###### 声明一个Service子类

```kotlin

    class TaskService : Service(){
        
        private lateinit val binder:DownloadBinder;

        override fun onCreate(){
            binder = DownloadBinder()
        }

        override fun onStartCommand(intent:Intent):INt{
            return super.onStartCommand(intent, flags, startId)
        }

        override fun onBind(intent: Intent?): IBinder? {
            return binder
        }

        override fun onUnbind(intent: Intent?): Boolean {
            return super.onUnbind(intent)
        }

        override fun onDestroy(){}

        inner class DownloadBinder:Binder(){
            fun start(){
                Log.e(TAG,"start download ...")
            }
            fun getProgress():Int{
                return 56
            }
        }

    }
```

###### 启动Service有两张方式:

1. Context.startService(context,Intent())
> 这方方式可以通过调用`Context.stopServstice(Intent())`或者在Service内部调用`stopSelf()`进行结束掉Service的运行,

```kotlin

    // start service
    context.startService(context,TaskService::class.java)
    // stop service
    context.stopServstice(context,TaskService::class.java)
    
```

对于这种方式启动时:`onStartCommad()`需要返回一个Int值:

```java
    /**
     * Constant to return from {@link #onStartCommand}: compatibility
     * version of {@link #START_STICKY} that does not guarantee that
     * {@link #onStartCommand} will be called again after being killed.
     */
    public static final int START_STICKY_COMPATIBILITY = 0;
    
    /**
     * Constant to return from {@link #onStartCommand}: if this service's
     * process is killed while it is started (after returning from
     * {@link #onStartCommand}), then leave it in the started state but
     * don't retain this delivered intent.  Later the system will try to
     * re-create the service.  Because it is in the started state, it will
     * guarantee to call {@link #onStartCommand} after creating the new
     * service instance; if there are not any pending start commands to be
     * delivered to the service, it will be called with a null intent
     * object, so you must take care to check for this.
     * 
     * <p>This mode makes sense for things that will be explicitly started
     * and stopped to run for arbitrary periods of time, such as a service
     * performing background music playback.
     */
    public static final int START_STICKY = 1;
    
    /**
     * Constant to return from {@link #onStartCommand}: if this service's
     * process is killed while it is started (after returning from
     * {@link #onStartCommand}), and there are no new start intents to
     * deliver to it, then take the service out of the started state and
     * don't recreate until a future explicit call to
     * {@link Context#startService Context.startService(Intent)}.  The
     * service will not receive a {@link #onStartCommand(Intent, int, int)}
     * call with a null Intent because it will not be re-started if there
     * are no pending Intents to deliver.
     * 
     * <p>This mode makes sense for things that want to do some work as a
     * result of being started, but can be stopped when under memory pressure
     * and will explicit start themselves again later to do more work.  An
     * example of such a service would be one that polls for data from
     * a server: it could schedule an alarm to poll every N minutes by having
     * the alarm start its service.  When its {@link #onStartCommand} is
     * called from the alarm, it schedules a new alarm for N minutes later,
     * and spawns a thread to do its networking.  If its process is killed
     * while doing that check, the service will not be restarted until the
     * alarm goes off.
     */
    public static final int START_NOT_STICKY = 2;
    
    /**
     * Constant to return from {@link #onStartCommand}: if this service's
     * process is killed while it is started (after returning from
     * {@link #onStartCommand}), then it will be scheduled for a restart
     * and the last delivered Intent re-delivered to it again via
     * {@link #onStartCommand}.  This Intent will remain scheduled for
     * redelivery until the service calls {@link #stopSelf(int)} with the
     * start ID provided to {@link #onStartCommand}.  The
     * service will not receive a {@link #onStartCommand(Intent, int, int)}
     * call with a null Intent because it will will only be re-started if
     * it is not finished processing all Intents sent to it (and any such
     * pending events will be delivered at the point of restart).
     */
     // 当进程被kill时,如果重新启动会携带Intent的数据
    public static final int START_REDELIVER_INTENT = 3;
```

2. 通过`bind`的形式启动

```kotlin

    val serviceConnection = object:ServiceConnection{
        override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
            val binder =  service as TaskService.DownloadBinder
            binder.start()
            var progress = binder.getProgress()
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            Log.e(TAG, "onServiceDisconnected: " )
        }
    }
    // bind service
    context.bindService(Intent(context,TaskService::class.java),serviceConnecttion)
    // unbind service
    context.unbindService(Intent(context,TaskService::class.java))

```

##### 声明周期

Service 的声明周期取决于它的启动方式:

`startService` : onCreate() -> onStartCommad() -> onDestory()

`bindService` : onCreate() -> onBind() -> onUnbind() -> onDestroy() 


##### 前台Service

启动前台Service 可以使用`Context.startForegroundService(Intent())`也可以在Service 的 onCreate()方法中使用`startForeground(10, Notification())`发送一个通知
在Android 9.0 后如果需要前台Service需要申请权限
```java
     <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
```

##### App保活辅助

对于Service有很多应用用做APP保活
1. 开启前台服务`startForeground()`
2. 在onDestroy()中重新调用`startService()`