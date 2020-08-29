### 概念

This class provides thread-local variables.  These variables differ from their normal counterparts in that each thread that accesses one (via its method) has its own, independently initialized copy of the variable. ThreadLocal instances are typically private static fields in classes that wish to associate state with a thread (e.g., a user ID or Transaction ID).

The Java ThreadLocal class enables you to create variables that can only be read and written by the same thread. Thus, even if two threads are executing the same code, and the code has a reference to the same ThreadLocal variable, the two threads cannot see each other's ThreadLocal variables. Thus, the Java ThreadLocal class provides a simple way to make code thread safe that would not otherwise be so.

简要说明: 我们可以创建线程local的变量,这些变量有自己的`set()`和`get()`访问方法,这个变量时线程私有的,每个线程只能访问自己内部的value

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

### ThreadLocal的原理:

ThreadLocalMap is a customized hash map suitable only for maintaining thread local values.

```java
     void createMap(Thread t, T firstValue) {
        t.threadLocals = new ThreadLocalMap(this, firstValue);
    }
```

如果需要使用ThreadLocal,就会创建一个以当前Thread的hash为key的ThreadLocalMap,然后把value发到弱引用entry中

```java
     public void set(T value) {
        Thread t = Thread.currentThread();
        ThreadLocalMap map = getMap(t);
        if (map != null)
            map.set(this, value);
        else
            createMap(t, value);
    }
```