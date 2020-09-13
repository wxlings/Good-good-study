什么是Binder?
1. 从机制的角度看binder是实现IPC(跨进程通信)的方式
2. 从驱动的角度看binder是虚拟的设备驱动
3. 从Android代码的角度binder是一个java类,实现了IBinder接口

![借用](https://upload-images.jianshu.io/upload_images/944365-b47008a09265b9c6.png?imageMogr2/auto-orient/strip|imageView2/2/format/webp)

Linux知识:

其他ipc: 管道（Pipe）、信号（Signal）和跟踪（Trace）报文队列（Message）、共享内存（Share Memory）和信号量（Semaphore）,插口（Socket）


*  进程空间划分

一个进程分为`用户空间`和`内核空间`;它们是相对对立的,不能直接相互访问数据
用户空间: 进程间,用户空间是的数据是不可共享的
内核空间: 进程间,内核空间的数据是可共享的

> 所有进程公用一个内核空间

进程内: 用户空间和内核空间需要系统调用才可以相互访问数据;主要通过函数:`copy_from_user()`和`copy_to_user()` 两个函数来copy数据

![借用](https://upload-images.jianshu.io/upload_images/944365-13d59058d4e0cba1.png?imageMogr2/auto-orient/strip|imageView2/2/w/678/format/webp)

* 进程隔离 & ipc(跨进程通信)

1. 进程隔离 为了保证 安全性 & 独立性，一个进程 不能直接操作或者访问另一个进程，即Android的进程是相互独立、隔离的

2. 跨进程通信（ IPC ） 即进程间需进行数据交互、通信

> 普通ipc 通信需要两次copy,即 用户进程A ---copy_from_user() ---> 内核空间缓存区 ---copy_to_user() ---> 用户进程B 
> 而Binder的作用: 连接 两个进程，实现了mmap()系统调用，主要负责 创建数据接收的缓存空间 & 管理数据接收缓存

>>   传统的跨进程通信需拷贝数据2次，但Binder机制只需1次，主要是使用到了内存映射


#### 跨进程原理

Binder : 一种虚拟设备驱动
作用: 连接Service进程,Client进程,ServiceMannager的桥梁
原理: 物理内存映射,内部调用了mmap()函数
实现: 1. 创建接收数据的缓存空间; 2. 映射管理


#### AIDL
为了让远程Service与多个应用程序的组件（四大组件）进行跨进程通信（IPC），需要使用AIDL

实现idle:

1. 创建server module , 创建idle文件,声明方法;文件及编写代码完成后需要重新构建一下module,让系统生成新的构建文件

```java

    interface IAidlInterface {
        // 加法
        int addition (int a,int b);
        // 减法
        int subtraction(int a,int b);
    }

```


2. 创建server端seivice,创建文件的Stub对象,实现接口方法逻辑,然后在onBind()中返回该实例对象

```java
    class RemoteService : Service() {

        private var binder = object : IAidlInterface.Stub() {
            override fun addition(a: Int, b: Int): Int = (a + b)
            override fun subtraction(a: Int, b: Int): Int = (a - b)
        }
        
        override fun onBind(intent: Intent): IBinder {
            return binder
        }
    }

``` 

3. 在server module中声明IntentFiler
这里我们增加属性`Android:process=":remote"`让这个service在子进程中运行
同时给这个service添加action ,这里的Action是包名+idle文件名,必须这样

```xml
    <service
        android:name=".RemoteService"
        android:enabled="true"
        android:exported="true"
        android:process=":remote">
        <intent-filter>
            <action android:name="com.wxlings.server.IAidlInterface"/>
        </intent-filter>
    </service>

```

4. 创建client module,同时把server module中生成的aidl文件原样复制到client module 的 main 目录下

5. 创建ServiceConnection实例,同时创建Intent;注意这里要给Intent()设置`package`属性,值就是server module 的包名;

```java
    val intent = Intent("com.wxlings.server.IAidlInterface")
    intent.package = "com.wxlings.server"
    bindService(intent, connection, Context.BIND_AUTO_CREATE)


    private val connection = object : ServiceConnection {
        override fun onServiceConnected(p0: ComponentName?, p1: IBinder?) {
            val binder = IAidlInterface.Stub.asInterface(p1)
            val addition = binder?.addition(10,20)
            val subtraction = binder?.subtraction(56,12)
            Log.e(TAG, "onServiceConnected: $addition $subtraction" )
        }

        override fun onServiceDisconnected(p0: ComponentName?) {
            // todo
        }
    }
```

到这里就完成了

描述一下aidl的java文件内容:

```java
    // 根据aidl文件创建了接口文件 继承了IInterface
    public interface IAidlInterface extends android.os.IInterface{


        // 创建了abstract 类Stub,来继承Binder,实现了我们接口类;服务端会调用这里
        public static abstract class Stub extends android.os.Binder implements com.wxlings.server.IAidlInterface{

        
            public Stub(){
                this.attachInterface(this, DESCRIPTOR);  // 构造对象时把自己和Binder进行关联
            } 

             public static com.wxlings.server.IAidlInterface asInterface(android.os.IBinder obj){
                ...
                 return new com.wxlings.server.IAidlInterface.Stub.Proxy(obj);      // 把当前把IBinder对象传给Stub.Proxy()
             }

             public boolean onTransact(int code, android.os.Parcel data, android.os.Parcel reply, int flags){
                 // 拿到出入数据和 通过使用Stub的实现进行处理返回数据
        
             }

            // 客户端会调用
             private static class Proxy implements com.wxlings.server.IAidlInterface {
                 private android.os.IBinder mRemote;

                Proxy(android.os.IBinder remote) {
                    mRemote = remote;
                }

                android.os.Parcel _data = android.os.Parcel.obtain();  // 用于保存发送方的数据
                android.os.Parcel _reply = android.os.Parcel.obtain(); // 用于保存server返回的数据
                ...
                boolean _status = mRemote.transact(Stub.TRANSACTION_addition, _data, _reply, 0);     // 像server发情请求,这个时候会挂起等待 1,需要调用的方法 2.发送方数据,3,..
                ...
             }
            
            // 为所有 方法设置标识
            static final int TRANSACTION_addition = (android.os.IBinder.FIRST_CALL_TRANSACTION + 0);
            static final int TRANSACTION_subtraction = (android.os.IBinder.FIRST_CALL_TRANSACTION + 1);
        }

        // 会生成aidl文件中的方法
        public int addition(int a, int b) throws android.os.RemoteException;
        public int subtraction(int a, int b) throws android.os.RemoteException;

    }

```


##### 面试题 

1. Intent 可以传递多大的数据?

在Android中Intent可以传递数据的大小取决mmap所映射的物理内存(匿名共享内存)空间的大小,系统默认设置  `BINDER_VM_SIZE = (1M-8k)`, 不同的机型和系统版本，这个上限值也可能会不同。

2. Binder ?
