### 概念

This class provides thread-local variables.  These variables differ from their normal counterparts in that each thread that accesses one (via its method) has its own, independently initialized copy of the variable. ThreadLocal instances are typically private static fields in classes that wish to associate state with a thread (e.g., a user ID or Transaction ID).
这个类提供了线程的local variables,这些变量不同于普通的变量;我们可以使用`set()`和`get()`来设置/获取初始值;这个实例是典型的关联当前线程 Private static 变量

The Java ThreadLocal class enables you to create variables that can only be read and written by the same thread. Thus, even if two threads are executing the same code, and the code has a reference to the same ThreadLocal variable, the two threads cannot see each  other's ThreadLocal variables. Thus, the Java ThreadLocal class provides a simple way to make code thread safe that would not otherwise be so.

简要说明: 我们可以创建线程local的变量,这些变量有自己的`set()`和`get()`访问方法,这个变量是线程私有的,每个线程只能访问自己内部的value

__通常用这个类实例来保存一些在当前线程需要保证数据唯一性的数据,因为一个ThreadLocal对象这提供了存储一个数据,并且是当前线程仅能获取当前线程存储的数据 (例如:Looper对象的实现就是这样的)__

### 创建ThreadLocal

```java

    // 方式一: 直接new 实例
    private ThreadLocal threadLocal = new ThreadLocal();
    threadLocal.set(object);
    Object obj = threadLocal.get();

    // 方式二: 重写initialValue()
    private ThreadLocal<String> threadLocal = new ThreadLocal<String>(){
            @Nullable
            @Override
            protected String initialValue() {
                return String.valueOf(System.currentTimeMillis());
            }
        };
    String label = threadLocal.get();

    // 方式三: 需要新的api才支持
    private ThreadLocal<String> threadLocal = ThreadLocal.withInitial(new Supplier<String>() {
        @Override
        public String get() {
            return String.valueOf(System.currentTimeMillis());
        }
    });
    // 或者直接使用LAMDA
    private ThreadLocal<String> threadLocal = ThreadLocal.withInitial(
        () -> String.valueOf(System.currentTimeMillis());
    )
```

这里有一个例子:

```java 

    class MyRunnable :Runnable{

        private var threadLocal: ThreadLocal<String> = ThreadLocal()

        override fun run() {
            threadLocal.set(Thread.currentThread().name)
            Log.e(TAG, Thread.currentThread().name + " ::" + threadLocal.get())
            
            // 画线重点考 : 这里可以避免内存泄漏
            threadLocal.remove()
        }
    }

    fun main(){

        Thread(MyRunnable()).start()
        Thread(MyRunnable()).start()
        Thread(MyRunnable()).start()
    }

```

打印结果:

> E/ThreadLocal: Thread-4 ::Thread-4
> E/ThreadLocal: Thread-4 ::Thread-4
> E/ThreadLocal: Thread-4 ::Thread-4

结论: **_在主线程创建的ThreadLocal实例,然后在三个线程去`set`,分别在各自线程内仅能看到自己线程设置的结果_**

分析: 来看一下源码,因为只有知道了原理我们才能合理的使用

```java

     public void set(T value) {
        Thread t = Thread.currentThread();
        ThreadLocalMap map = getMap(t); // 获取当前Thread关联的ThreadLocalMap
        if (map != null)
            map.set(this, value);   // 以当前ThreadLoacl 为key,存储value
        else
            createMap(t, value);
    }

```

__以当前ThreadLoacl 为key,也就是说一个线程可以有多个ThreadLocal实例,但是每个实例只能存储一个value;__ 
那么这样看来我们需要存储的数据并没有存到ThreadLocal对象里面,而是存到了ThreadLocalMap里面,来看一下这个ThreadLocalMap:

```java

    /**
     * Get the map associated with a ThreadLocal. Overridden in InheritableThreadLocal.
     * 这里返回当前线程关联的ThreadLocalMap
     */
    ThreadLocalMap getMap(Thread t) {
        return t.threadLocals;
    }

    /* ThreadLocal values pertaining to this thread. This map is maintained
     * by the ThreadLocal class. 
     * 这个实在线程Thread类中代码
     */
    ThreadLocal.ThreadLocalMap threadLocals = null;

    /**
     * ThreadLocalMap is a customized hash map suitable only for
     * maintaining thread local values. No operations are exported
     * outside of the ThreadLocal class. The class is package private to
     * allow declaration of fields in class Thread.  To help deal with
     * very large and long-lived usages, the hash table entries use
     * WeakReferences for keys. However, since reference queues are not
     * used, stale entries are guaranteed to be removed only when
     * the table starts running out of space.
     * ThreadLocalMap是一个定制的哈希映射，只适用于维护线程本地值。没有操作被导出到ThreadLocal类之外。这个类是包私有的，允许在类线程中声明字段。为了帮助处理非常大的和长期存在的使用，哈希表条目对键使用WeakReferences。但是，由于不使用引用队列，因此只有当表空间开始耗尽时，才保证删除陈旧的条目。
     * 所以这里使用时需要注意: 会存在内存泄漏风险
     */
    static class ThreadLocalMap {}

```

看ThreadLocalMap的说明: **它并没有使用引用队列,默认存入的值会一直存在,直到表空间耗尽,记得使用`remove()`方法**


### ThreadLocal 使用场景

1. 在每个线程中存储一个变量的副本，这样在每个线程对该变量进行使用的使用，使用的即是该线程的局部变量，从而保证了线程的安全性以及高效性。
2. 在并发编程中时常有这样一种需求：每条线程都需要存取一个同名变量，但每条线程中该变量的值均不相同。

###### 例如: 
    我们的线程中逻辑比较复杂,有很多方法,并且都会涉及需要一个数据对象data,通常的做法是在调用方法时把data作为参数传来传去;这样就比较麻烦,造成代码不够优雅,这时我们就可以使用
ThreadLocal类了,作为Thread内全局数据,就会很方便了;


### ThreadLocal 系统提供的一些方法:

```java
    private ThreadLocal threadLocal = new ThreadLocal();
    threadLocal.set(params);    // 主动设置当前Thread变量
    threadLocal.get();          // 获取自定义的变量
    threadLocal.remove();       // 移除保存的value,实际是ThreadLocalMap中当前Thread关联的entry;避免内存泄漏
```
