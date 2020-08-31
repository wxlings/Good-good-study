##### Handler
Handler(消息的发送与回调处理),Looper(无限循环队列,把消息重MessageQueue中loop()出来给到Handler),Message(消息实体),MessageQueue(消息队列)

##### Message

概念: Defines a message containing a description and arbitrary data object that can be sent to a Handler.
一个可以携带任意数据并可以发送给`Handler`的消息对象

While the constructor of Message is public, the best way to get one of these is to call {Message.obtain()} or one of the {Handler.obtainMessage()} methods, which will pull them from a pool of recycled objects.
获取其实例的最好办法是是使用Message的静态方法`Message.obtain()`或者使用Handler实例`Handler().obtainMessage()`来获取,因为这样会把这些Message对象放进回收池便于再复用

###### 获取Massage的实例:

```java
    /** 
    * Constructor (but the preferred way to get a Message is to call {@link #obtain() Message.obtain()}).
    */
    public Message() {
    }

    /**
     * Return a new Message instance from the global pool. Allows us to avoid allocating new objects in many cases.
     */
    public static Message obtain() {
        synchronized (sPoolSync) {
            if (sPool != null) {
                Message m = sPool;
                sPool = m.next;
                m.next = null;
                m.flags = 0; // clear in-use flag
                sPoolSize--;
                return m;
            }
        }
        return new Message();
    }
```

> Notes: 虽然我们可以直接通过`new Massage()`的方式创建实例,但是更应该使用`Message.obtain()`的形式获取缓存对象;


###### Message可以装载那些类型数据呢 ?

```java
    /**
     * User-defined message code so that the recipient can identify
     * what this message is about. Each {@link Handler} has its own name-space
     * for message codes, so you do not need to worry about yours conflicting
     * with other handlers.
     */
     public int what;
     /**
     * arg1 and arg2 are lower-cost alternatives to using
     * {@link #setData(Bundle) setData()} if you only need to store a
     * few integer values.
     */
     public int arg1;
     public int arg2;

    /**
     * An arbitrary object to send to the recipient.  When using
     * {@link Messenger} to send the message across processes this can only
     * be non-null if it contains a Parcelable of a framework class (not one
     * implemented by the application).   For other data transfer use
     * {@link #setData}. 
     */
     public Object obj;

    /**
     * 可以通过使用setData()传入一个Bundle对象
     */
     /*package*/ Bundle data;

    /**
     * Recycles a Message that may be in-use.
     * Used internally by the MessageQueue and Looper when disposing of queued Messages.
     */
     void recycleUnchecked() {
        // Mark the message as in use while it remains in the recycled object pool.
        // Clear out all other details.
        flags = FLAG_IN_USE;
        what = 0;
        arg1 = 0;
        arg2 = 0;
        obj = null;
        replyTo = null;
        sendingUid = -1;
        when = 0;
        target = null;
        callback = null;
        data = null;

        synchronized (sPoolSync) {
            if (sPoolSize < MAX_POOL_SIZE) {
                next = sPool;
                sPool = this;
                sPoolSize++;
            }
        }
    }
```


###### 如果使用Handler时,需要向当前实例传入一个target,即handler对象

```java
    /*package*/ Handler target;
    
    public void setTarget(Handler target) {
        this.target = target;
    }

    /**
     * Sends this Message to the Handler specified by {@link #getTarget}.
     * Throws a null pointer exception if this field has not been set.
     */
    public void sendToTarget() {
        target.sendMessage(this);       // 这样就能够回调Handler.handlerMessage()方法了;
    }

```

###### Message对象缓存是怎么实现的呢?
 
这里是重点,本身是一个链表结构,有对象了就会通过`next`指向到下一个对象

```java

    private static Message sPool;

    // sometimes we store linked lists of these things
    /*package*/ Message next;  

    public static Message obtain() {
        synchronized (sPoolSync) {
            if (sPool != null) {
                Message m = sPool;
                sPool = m.next;
                m.next = null;
                m.flags = 0; // clear in-use flag
                sPoolSize--;
                return m;
            }
        }
        return new Message();
    }
```

Message本身就是单列表的数据结构,next指向了下一对象;在消息入队列的时候用了这个逻辑,当回收以后也用了这个逻辑


##### MessageQueue

概念: Low-level class holding the list of messages to be dispatched by a {Looper}.  Messages are not added directly to a MessageQueue,but rather through { Handler} objects associated with the Looper.

You can retrieve the MessageQueue for the current thread with {Looper#myQueue() Looper.myQueue()}.
我们可以通过使用`Looper.myQueue()`来获取消息队列

> 注意这里说是MessageQueue,其实并不是我们常见的`queue`,而是Message本身就是链表结构,就是一种类似队列的链表数据结构

几个关键方法:

```java

    Message mMessages;
    
    /**
    * Message 加入队列
    */
    boolean enqueueMessage(Message msg, long when) {

        // 这里先检查target的值,如果没有Handler对象就不能处理消息
        if (msg.target == null) {
            throw new IllegalArgumentException("Message must have a target.");
        }
        ... 
        synchronized (this) {
            ...
             boolean needWake;
            if (p == null || when == 0 || when < p.when) {
                // New head, wake up the event queue if blocked.
                msg.next = p;
                mMessages = msg;
                needWake = mBlocked;
            } else {
                needWake = mBlocked && p.target == null && msg.isAsynchronous();
                Message prev;
                for (;;) {
                    prev = p;
                    p = p.next;
                    if (p == null || when < p.when) {
                        break;
                    }
                    if (needWake && p.isAsynchronous()) {
                        needWake = false;
                    }
                }
                msg.next = p; // invariant: p == prev.next  这里是重点,把
                prev.next = msg;
            }
            return true;
        }
    }

    // 
    void removeMessages(Handler h, int what, Object object) {
        ...
        p.recycleUnchecked();
        ...
    }

    // 获取下一Message对象
     Message next() {
         ...
        for (;;) {
            nativePollOnce(ptr, nextPollTimeoutMillis);
            ...
    
        }
     }
```

##### Looper

概念: Class used to run a message loop for a thread.  Threads by default do not have a message loop associated with them; to create one, call      prepare() in the thread that is to run the loop, and then loop to have it process messages until the loop is stopped.
用于线程消息循环,默认子线程没有与之关联的Looper对象.需要创建一个调用Looper.prepare()方法,然后再通过`Looper.loop()`进行循环消息

Most interaction with a message loop is through the Handler class.

Looper 每个线程都对应一个ThreadLoacl来保存Looper对象,在创建对象的同时也确定了MessageQueue

```java
     /**
     * Return the Looper object associated with the current thread.  Returns
     * null if the calling thread is not associated with a Looper.
     */
    public static @Nullable Looper myLooper() {
        return sThreadLocal.get();
    }

    /** Initialize the current thread as a looper.
      * This gives you a chance to create handlers that then reference
      * this looper, before actually starting the loop. Be sure to call
      * {@link #loop()} after calling this method, and end it by calling
      * {@link #quit()}.
    */
    private static void prepare(boolean quitAllowed) {
        if (sThreadLocal.get() != null) {
            throw new RuntimeException("Only one Looper may be created per thread");
        }
        sThreadLocal.set(new Looper(quitAllowed));
    }
```



##### Handler

概念: A Handler allows you to send and process { Message } and Runnable objects associated with a thread's { MessageQueue }. When you create a new Handler, it is bound to the thread message queue of the thread that is creating it -- from that point on, it will deliver messages and runnables to that message queue and execute them as they come out of the message queue.
Handler 可以发送和处理当前线程所关联的MessageQueue的Message消息或者Runnable消息;

There are two main uses for a Handler: (1) to schedule messages and runnables to be executed as some point in the future; and (2) to enqueue an action to be performed on a different thread than your own.
使用有两种情况:1. 使用定时和延时的策略调度Message/Runnabe消息 2. 将要在与您自己的线程不同的线程上执行的操作排队

When a process is created for your application, its main thread is dedicated to running a message queue that takes care of managing the top-level application objects (activities, broadcast receivers, etc) and any windows they create.

###### 基本使用

1. 在主线程中创建,在主线程中回调:

```kotlin
    // 在主线程中先创建一个Handler对象,这里重写了handleMassage()方法
    val handler = object : Handler(callback) {
        override fun handleMessage(msg: Message?) {
            super.handleMessage(msg)
            // todo 消息接受处理逻辑
            Log.e(TAG, "Msg.what : ${msg?.what}")
        }
    }

    // 在Handler的构造器中可以传入一个Handler.Callback()回调,重写handleMessage进行消息接收
    // 这里方法需要返回一个Boolean值,确认是否要执行次回调中的逻辑
    val callback =  object: Handler.Callback {
        override fun handleMessage(msg: Message?): Boolean {
            Log.e(TAG, "callback.what : ${msg?.what}")
            return false
        }
    }

    // 发送一个简单的消息
    handler.sendEmptyMessage(100)
    handler.sendEmptyMessageDelayed(1000,1000*3)
    handler.sendEmptyMessageAtTime(10000,SystemClock.currentThreadTimeMillis() + 1000*5)

    // 发送Runnbale任务
    handler.post { Log.e(TAG, "这是一个即时Runnable任务") }
    handler.postDelayed({Log.e(TAG, "这是一个延时时Runnable任务")}, 1000)
    handler.postAtTime({ Log.e(TAG, "这是一个定时Runnable任务")},SystemClock.currentThreadTimeMillis() + 1000*5)

    // 子线程中调用主线程Handler实例发送任务
    Thread(Runnable {
            val m = Message.obtain()
            m.what = 10000
            handler.sendMessage(m)
    }).start()
    
```

打印结果:

>>>Thread.name = main + Thread.id = 1

2. 在子线程中创建,在子线程中使用,在主线程中回调:

```kotlin
     
    // 子线程中调用主线程Handler实例发送任务
    Thread(Runnable {
        val handler = object : Handler(Looper.getMainLooper()) {
            override fun handleMessage(msg: Message?) {
                super.handleMessage(msg)
                // todo 消息接受处理逻辑
                Log.e(TAG, "Msg.what : ${msg?.what}")
                Log.e(TAG, "Thread.name = ${Thread.currentThread().name} + Thread.id = ${Thread.currentThread().id}" )
            }
        }
        val m = Message.obtain()
        m.what = 999
        handler.sendMessage(m)
    }).start()

```

这里我们给Handler 传入了一个Main Looper,同样也可以在主线程回调,具体原因看构造器section

打印结果:

>>>Thread.name = main + Thread.id = 1


3. 在子线程中创建,在子线程中使用,在子线程中回调:

```kotlin
    Looper.prepare()
    val handler = object : Handler() {  // 这里ye
        override fun handleMessage(msg: Message?) {
            super.handleMessage(msg)
            // todo 消息接受处理逻辑
            Log.e(TAG, "Msg.what : ${msg?.what}")
            Log.e(TAG, "Thread.name = ${Thread.currentThread().name} + Thread.id = ${Thread.currentThread().id}" )
        }
    }
    // 子线程中调用主线程Handler实例发送任务
    Thread(Runnable {
            val m = Message.obtain()
            m.what = 999
            handler.sendMessage(m)
    }).start()
```

打印结果:

>>>Thread.name = Thread-1 + Thread.id = 25912

##### 总结: Looper对象在哪个线程创建,那么`handleMessage()`方法就在哪个线程执行

###### 构造器

先看一下Handler的构造器:

```java

    /**
     * Default constructor associates this handler with the {@link Looper} for the
     * current thread.
     *
     * If this thread does not have a looper, this handler won't be able to receive messages
     * so an exception is thrown.
     */
    public Handler() {
        this(null, false);
    }
    public Handler(Callback callback, boolean async) {
        ...
        mLooper = Looper.myLooper();            // 获取默认Looper对象
        if (mLooper == null) {
            throw new RuntimeException(
                "Can't create handler inside thread " + Thread.currentThread()
                        + " that has not called Looper.prepare()");
        }
        mQueue = mLooper.mQueue;
        mCallback = callback;
        mAsynchronous = async;
    }

    /**
    * Use the provided {Looper} instead of the default one.
    * looper The looper, must not be null.
    */
    public Handler(Looper looper) {
        this(looper, null, false);
    }
    public Handler(Looper looper, Callback callback, boolean async) {
        mLooper = looper;
        mQueue = looper.mQueue;
        mCallback = callback;
        mAsynchronous = async;
    }
```

由构造器看出在初始化Handler时必须要持有一个与当前线程关联Looper对象.如果在子线程中我们由传入MainLooper就需要在调用`Looper.prepare()`来创建当前线程中的Looper对象
为什么在主线程中没有创建Looper对象呢? 是因为在ActivityThread初始化的时候就创建了Main Looper对象

```java
    
    public static void main(String[] args) {
        Looper.prepareMainLooper();//创建Looper和MessageQueue对象，用于处理主线程的消息
    
        ActivityThread thread = new ActivityThread();
        thread.attach(false);//建立Binder通道 (创建新线程)
    
        if (sMainThreadHandler == null) {
            sMainThreadHandler = thread.getHandler();
        }
    
        Trace.traceEnd(Trace.TRACE_TAG_ACTIVITY_MANAGER);
        Looper.loop();
    
        //如果能执行下面方法，说明应用崩溃或者是退出了...
        throw new RuntimeException("Main thread loop unexpectedly exited");
        ...

```

###### 消息入队

当我们调用了`sendMessage()`或者`postMessage()`发生了些什么?
**_sendMessageAtTime()_**
所有的发送行为最终都走到了这里.无论是`send**()`还是`post**()`都被包装成了Message对象
> send系列参数直接赋值给了`Message.obain().what`参数
> post系列参数直接赋值给了`Message.obain().callback`参数

```java
     public boolean sendMessageAtTime(Message msg, long uptimeMillis) {
        MessageQueue queue = mQueue;
        ...
        return enqueueMessage(queue, msg, uptimeMillis);
    }
    
     private boolean enqueueMessage(MessageQueue queue, Message msg, long uptimeMillis) {
        msg.target = this;  // 这一步很关键,把当前Handler对象赋值了Message.target,用于后面的消息处理
        if (mAsynchronous) {
            msg.setAsynchronous(true);
        }
        return queue.enqueueMessage(msg, uptimeMillis);  // 这里的enqueueMessage就是把参数Massage添加到链表中进行存储
    }
```

###### 消息出队与回调

好的 ,上面片段我们仅仅是创建了Handler对象,也发送了消息,消息是怎么出队列的呢? 这就看`Looper.loop()`

```java

  /**
     * Run the message queue in this thread. Be sure to call
     * {@link #quit()} to end the loop.
     */
    public static void loop() {
        final Looper me = myLooper();   
        final MessageQueue queue = me.mQueue;
        for (;;) {
            Message msg = queue.next(); // might block
            if (msg == null) {
                // No message indicates that the message queue is quitting.
                return;
            }
            ...
            try {
                msg.target.dispatchMessage(msg);   // 这里Looper循环后进行消息发送,经过上文看出msg.target就是关联的Handler对象
                dispatchEnd = needEndTime ? SystemClock.uptimeMillis() : 0;
            }
            ...
            msg.recycleUnchecked();         // 回调后进行对列清除,及回收Message对象到Message pool中
        }
    }
```
![Handler](https://github.com/wxlings/Good-good-study/blob/master/static/img/handler.jpg)


##### todo Handler中有Loop死循环，为什么没有阻塞主线程，原理是什么？ 
https://blog.csdn.net/jdsjlzx/article/details/108222678



### 面试题系列


- Handler 会内存泄漏么? 为什么? 怎样避免?

Handler 会引起内存泄漏,在Handler对象发送消息时最终会调用`enqueueMessage()`把新的消息加入到MessageQueue中,这个时候需要把当前Handler对象赋值给Messages.target,如果Handler使用不当比如在执行定时任务或者延时任务的时候就会造成Handler不能被回收,这就有可能造成当前Activity不能回收,造成内存泄漏;

解决: 在合适的声明周期调用`Handler().removeCallbacksAndMessages(null)`进行资源移除,这个方法最终会调用`Message.recycleUnchecked()`进行释放Message的所有引用,包括target;还有如果在子线程中创建Handler-Looper模型,当任务执行结束时还要调用`Looper.quit()`结束loop()中的死循环;



- Message 了解多少? 为什么要用Message.obtain()?

Message 可以包装多类型的数据,用作于数据的承载者;Message本身是单列表的数据结构
特点是:非线性,非连续物理内存,随机存储,但是按顺序查找,通过next指向下一个对象的引用
由于Handler 在Android系统中非常频发的使用,特别是在线程切换,UI处理等方面,对于Message对象进行了缓存复用的处理逻辑,做到了优化内存及性能;
如果使用Array的数据结构,可能面临数据量增加时数组需要扩容及内存复制的问题或者数据量较小而浪费内存的问题



` Looper 和线程的关系?

一个线程中只可以有一个Looper对象,但是Handler可以有多个;主线程中在ActivityThread创建的时候就通过`Looper.getMainLooper()`获取了Looper对象;而如果在子线程中需要调用`Looper.prepare()`进行获取Looper对象,比较典型的类是HandlerThread,在开启线程执行任务的时候获取了线程的Looper 对象,然后把Looper对象传递给了对应的Handler,要注意,当任务执行完毕后要调用`HandlerThread().quit()`    



- Handler/Looper.loop()的死循环为什么不会导致ANR? 会持有cpu资源么?

在Looper.loop()方法中有个for无限循环来获取队列中的Message对象, `Message msg = queue.next(); // might block` `next()`可能是阻塞的,意思就是没有消息就会阻塞,这里阻塞和我们正常接触的线程阻塞是不一样的,在这个方法中会调用Native 方法`nativePollOnce()`,这里就涉及Linux的epoll机制，是一种IO多路复用机制,以同时监控多个描述符，当某个描述符就绪(读或写就绪)，则立刻通知相应程序进行读或写操作，本质同步I/O，即读写是阻塞的。此时主线程会释放CPU资源进入休眠状态，所以说，主线程大多数时候都是处于休眠状态，并不会消耗大量CPU资源。


