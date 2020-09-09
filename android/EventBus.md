

添加依赖:`implementation 'org.greenrobot:eventbus:3.2.0'`

如果需要 ProGuard: 

```java

    -keepattributes *Annotation*
    -keepclassmembers class * {
        @org.greenrobot.eventbus.Subscribe <methods>;
    }
    -keep enum org.greenrobot.eventbus.ThreadMode { *; }
    
    # And if you use AsyncExecutor:
    -keepclassmembers class * extends org.greenrobot.eventbus.util.ThrowableFailureEvent {
        <init>(java.lang.Throwable);
    }

```

基本使用:


1. 先创建消息类:

```java

    public class Person {

        public String name;
        public int age;

        public void setInfo(String name, int age) {
            this.name = name;
            this.age = age;
        }

        @Override
        public String toString() {
            return "Person{" +
                    "name='" + name + '\'' +
                    ", age=" + age +
                    '}';
        }
    }

```

2. 实现

```java

    // 有订阅
    @Override
    protected void onStart() {
        super.onStart();
        EventBus.getDefault().register(this);
    }
    // 有取消订阅
    @Override
    protected void onStop() {
        super.onStop();
        EventBus.getDefault().unregister(this);
    }

    // 消息接受处理
   @Subscribe(sticky = true,priority =  = 10,threadMode = ThreadMode.MAIN)
    public void handleEvent(Person person){
        Log.e(TAG, "handleEvent: " + person.toString() );
        Log.e(TAG, "handleEvent: " + Thread.currentThread().getName() );
    }


    // 可以是任意地方
     new Thread(new Runnable() {
            @Override
            public void run() {
                Person p = new Person();
                p.setInfo("wxlings",24);
                EventBus.getDefault().post(p);
            }
    }).start();

```


分析:
1. 需要在使用接收消息的组件进行订阅
2. 实现订阅方法: 并用`@Subscribe`注解进行标记
3. 注意反注册

对于`Subscribe`有几个参数:
sticky:是否是粘性,如果是粘性,即使消息在组件订阅之前发出,组件也能够接收到消息
priority: 优先级别
threadMode: 在哪个一个线程处理消息,`MAIN`在主线程,`POSTING`在发送线程,`BACKGROUND`子线程,`MAIN_ORDERED`主线程无阻塞


先看一下注册逻辑:

```java
    private static final Map<Class<?>, List<SubscriberMethod>> METHOD_CACHE = new ConcurrentHashMap<>();

    // 通过反射找找出当前观察者的所有的subscriberMethods(List)信息
     public void register(Object subscriber) {
        Class<?> subscriberClass = subscriber.getClass();
        List<SubscriberMethod> subscriberMethods = subscriberMethodFinder.findSubscriberMethods(subscriberClass);
        synchronized (this) {
            for (SubscriberMethod subscriberMethod : subscriberMethods) {
                subscribe(subscriber, subscriberMethod);
            }
        }
    }

     List<SubscriberMethod> findSubscriberMethods(Class<?> subscriberClass) {
        List<SubscriberMethod> subscriberMethods = METHOD_CACHE.get(subscriberClass);
        if (subscriberMethods != null) {
            return subscriberMethods;
        }

        if (ignoreGeneratedIndex) {
            subscriberMethods = findUsingReflection(subscriberClass);
        } else {
            subscriberMethods = findUsingInfo(subscriberClass);
        }
        if (subscriberMethods.isEmpty()) {
            throw new EventBusException("Subscriber " + subscriberClass
                    + " and its super classes have no public methods with the @Subscribe annotation");
        } else {
            METHOD_CACHE.put(subscriberClass, subscriberMethods);  // 把观察者和回调的信息都放在Map中
            return subscriberMethods;
        }
    }

```


```java

      private void postToSubscription(Subscription subscription, Object event, boolean isMainThread) {
        switch (subscription.subscriberMethod.threadMode) {
            case POSTING:
                invokeSubscriber(subscription, event);
                break;
            case MAIN:
                if (isMainThread) {
                    invokeSubscriber(subscription, event);
                } else {
                    mainThreadPoster.enqueue(subscription, event);
                }
                break;
            case MAIN_ORDERED:
                if (mainThreadPoster != null) {
                    mainThreadPoster.enqueue(subscription, event);
                } else {
                    // temporary: technically not correct as poster not decoupled from subscriber
                    invokeSubscriber(subscription, event);
                }
                break;
            case BACKGROUND:
                if (isMainThread) {
                    backgroundPoster.enqueue(subscription, event);
                } else {
                    invokeSubscriber(subscription, event);
                }
                break;
            case ASYNC:
                asyncPoster.enqueue(subscription, event);
                break;
            default:
                throw new IllegalStateException("Unknown thread mode: " + subscription.subscriberMethod.threadMode);
        }
    }

```


一个订阅载体: PendingPost

也是一个单链表的数据结构

```java
PendingPost next;
private final static List<PendingPost> pendingPostPool = new ArrayList<PendingPost>();

// 获取PendingPost对象,先去池子中拿,然后池子数量-1,如果没有了就新建
 static PendingPost obtainPendingPost(Subscription subscription, Object event) {
    synchronized (pendingPostPool) {
        int size = pendingPostPool.size();
        if (size > 0) {
            PendingPost pendingPost = pendingPostPool.remove(size - 1);
            pendingPost.event = event;
            pendingPost.subscription = subscription;
            pendingPost.next = null;
            return pendingPost;
        }
    }
    return new PendingPost(event, subscription);
}

// 如果用完了也就是在unregister方法调用后,在加入到池子中
 static void releasePendingPost(PendingPost pendingPost) {
    pendingPost.event = null;
    pendingPost.subscription = null;
    pendingPost.next = null;
    synchronized (pendingPostPool) {
        // Don't let the pool grow indefinitely
        if (pendingPostPool.size() < 10000) {
            pendingPostPool.add(pendingPost);
        }
    }
}
````

订阅队列: PendingPostQueue

```

```