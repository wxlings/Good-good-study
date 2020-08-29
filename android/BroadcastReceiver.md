BroadcastReceiver 广播,消息传递的一种形式
### 按照发送类型分为两种: 正常广播,有序广播

##### 1. 正常广播

> 是一种完全异步的广播,在广播发出后,理论上所有的BroadcastReceiver(接收器)会同时接收到消息,它们之间没有先后顺序;

> 特点:效率高,无法拦截

```java
    sendBroadcast(Intent("Action").putExtra("key","value"))
```

##### 2. 有序广播
> 也叫粘性广播,是一种同步执行的广播;在广播发出后,同一时刻只会有一个BroadcastReceiver能够接收到消息,当这个接受器处理完消息后可以选择把该广播继续传递也可以进行拦截不再传递,拦截后其他的BroadcastReceiver将不能够接受该广播;
> 接受广播的顺序由广播的优先级属性决定:`Android:priority="10"`,

```java
    // 发送粘性广播
    sendOrderedBroadcast(Intent("Action").putExtra("key","value"))

    override fun onReceiver(intent:Intent){
        // todo do something
        abortBroadcast()
    }
```
### 广播的注册方式有两种: 静态注册和动态注册

##### 1. 静态注册:
> 静态注册需要在`AndroidManifest.xml`清单文件中声明该BroadcastReceiver,并指定action
> 静态注册相对比较消耗系统资源,伴随app的整个声明周期

```xml
     <receiver
        android:name=".example.BootReceiver"
        android:enabled="true"
        android:exported="true">
        <intent-filter>
            <action android:name="android.intent.action.BOOT_COMPLETED"/>
        </intent-filter>
    </receiver>
```

##### 2. 动态注册

> 在代码中注册,同时也要伴随反注册
> 动态灵活,节省资源

```java
    private lazyinit val receiver:BroadcastReceiver
    val filter = IntentFilter(Intent.ACTION_BOOT_COMPLETED)
    // 注册:通常在onCreate()或者在onStart()方法中
    registerReceiver(receiver, filter)
    // 反注册: 通常在onDestroy()或者onStop()方法中,与注册的时机相对应
    unregisterReceiver(receiver)
```


### 创建一个BroadcastReceiver的子类
```java
    class Receiver():BroadcastReceiver(){

        override fun onReceive(p0: Context?, p1: Intent?) {
            TODO("do something")
        }

    }
```

### LocalBroadcastManager更高效的app沙盒广播

> LocalBroadcastManager能够进行App沙盒内的广播事件处理,包括注册,发送,反注册...
> 内部实现使用HashMap保存了所有的Receiver,和 Actions...
> 支持子线程事件的处理

```java
    // 注册
    LocalBroadcastManager.getInstance(context)
        .registerReceiver(BroadcastReceiver())
    // 发送
    LocalBroadcastManager.getInstance(context)
        .sendBroadcast(Intent())
    // 发送同步消息
    LocalBroadcastManager.getInstance(context)
        .sendBroadcastSync(Intent())
    // 反注册
    LocalBroadcastManager.getInstance(context)
        .unregisterReceiver(BroadcastReceiver())
```