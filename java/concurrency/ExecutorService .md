#### 概念

Creating a thread in java is a very expensive process which includes memory overhead also. So, it’s a good idea if we can re-use these threads once created, to run our future runnables. 创建线程是非常昂贵的过程,包括内存开销,建议服用用这些线程

####  Creating ExecutorService instances

ExecutorService is an interface and it’s implementations can execute a Runnable or Callable class in an asynchronous way. 
创建ExecutorService有两种方式:
1. 使用 `Exetutors`工具类进行
```java
    ExecutorService service =  Executors.newFixedThreadPool(5);     // 创建一个线程数量固定的线程池
    ExecutorService service = Executors.newSingleThreadExecutor();  // 创建一个单线程的线程池
    ExecutorService service = Executors.newCachedThreadPool();      // 创建
    ExecutorService service = 
```