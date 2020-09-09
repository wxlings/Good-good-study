#### 概念

Creating a thread in java is a very expensive process which includes memory overhead also. So, it’s a good idea if we can re-use these threads once created, to run our future runnables. 创建线程是非常昂贵的过程,包括内存开销,建议服用用这些线程

![Excutors](https://s0.lgstatic.com/i/image3/M01/0A/64/CgoCgV6n12mAEC_6AADOWskIa4c204.png)

####  Creating ExecutorService instances

ExecutorService is an interface and it’s implementations can execute a Runnable or Callable class in an asynchronous way. 

创建ExecutorService有两种方式: 本质上两种方式相同;

1. 使用 `Exetutors`工厂方法进行创建

```java
    ExecutorService service =  Executors.newFixedThreadPool(5);     // 创建一个线程数量固定的线程池
    ExecutorService service = Executors.newSingleThreadExecutor();  // 创建一个单线程的线程池
    ExecutorService service = Executors.newCachedThreadPool();      // 创建可缓存的线程池
    ExecutorService service = Executors.newScheduledThreadPool(2);  // 创建一个可执行周期任务的线程池
    ExecutorService service = Executors.newSingleThreadScheduledExecutor();  // 单线程可执行调度的线程池服务
```

2. 自定义线程池;

```java
      /**
     * Creates a new {@code ThreadPoolExecutor} with the given initial
     * parameters and default thread factory and rejected execution handler.
     * It may be more convenient to use one of the {@link Executors} factory
     * methods instead of this general purpose constructor.
     *
     * @param corePoolSize the number of threads to keep in the pool, even
     *        if they are idle, unless {@code allowCoreThreadTimeOut} is set
     * @param maximumPoolSize the maximum number of threads to allow in the
     *        pool
     * @param keepAliveTime when the number of threads is greater than
     *        the core, this is the maximum time that excess idle threads
     *        will wait for new tasks before terminating.
     * @param unit the time unit for the {@code keepAliveTime} argument
     * @param workQueue the queue to use for holding tasks before they are
     *        executed.  This queue will hold only the {@code Runnable}
     *        tasks submitted by the {@code execute} method.
     * @throws IllegalArgumentException if one of the following holds:<br>
     *         {@code corePoolSize < 0}<br>
     *         {@code keepAliveTime < 0}<br>
     *         {@code maximumPoolSize <= 0}<br>
     *         {@code maximumPoolSize < corePoolSize}
     * @throws NullPointerException if {@code workQueue} is null
     */
    public ThreadPoolExecutor(int corePoolSize,
                              int maximumPoolSize,
                              long keepAliveTime,
                              TimeUnit unit,
                              BlockingQueue<Runnable> workQueue) {
        this(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue,
             Executors.defaultThreadFactory(), defaultHandler);
    }
```

构造参数说明。

corePoolSize：表示核心线程数量。

maximumPoolSize：表示线程池最大能够容纳同时执行的线程数，必须大于或等于 1。如果和 corePoolSize 相等即是固定大小线程池。

keepAliveTime：表示线程池中的线程空闲时间，当空闲时间达到此值时，线程会被销毁直到剩下 corePoolSize 个线程。

unit：用来指定 keepAliveTime 的时间单位，有 MILLISECONDS、SECONDS、MINUTES、HOURS 等。

workQueue：等待队列，BlockingQueue 类型。当请求任务数大于 corePoolSize 时，任务将被缓存在此 BlockingQueue 中。

threadFactory：线程工厂，线程池中使用它来创建线程，如果传入的是 null，则使用默认工厂类 DefaultThreadFactory。

handler：执行拒绝策略的对象。当 workQueue 满了之后并且活动线程数大于 maximumPoolSize 的时候，线程池通过该策略处理请求。

注意：当 ThreadPoolExecutor 的 allowCoreThreadTimeOut 设置为 true 时，核心线程超时后也会被销毁。

![core](https://s0.lgstatic.com/i/image3/M01/17/96/Ciqah16n2kaAO4ocAAE8gZsl0_8253.png)

池子?

每一个线程都封装成了`Worker`对象,然后保存在HashSet中;

```java
    /**
     * Set containing all worker threads in pool. Accessed only when
     * holding mainLock.
     */
    // Android-added: @ReachabilitySensitive
    @ReachabilitySensitive
    private final HashSet<Worker> workers = new HashSet<>();

    // ctl：是一个 AtomicInteger 类型，二进制高 3 位用来标识线程池的状态，低 29 位用来记录池中线程的数量。
    private final AtomicInteger ctl = new AtomicInteger(ctlOf(RUNNING, 0));
```


### 题外话

阿里 Java 开发手册中严禁使用 Executors 工具类来创建线程池。尤其是 newFixedThreadPool 和 newCachedThreadPool 这两个方法。

```java
     public static ExecutorService newFixedThreadPool(int nThreads) {
        return new ThreadPoolExecutor(nThreads, nThreads,
                                      0L, TimeUnit.MILLISECONDS,
                                      new LinkedBlockingQueue<Runnable>());
    }

    /**
     * Creates a {@code LinkedBlockingQueue} with a capacity of
     * {@link Integer#MAX_VALUE}.
     */
    public LinkedBlockingQueue() {
        this(Integer.MAX_VALUE);  // 看这里;如果任务过多,内存会溢出
    }

     public static ExecutorService newCachedThreadPool() {
        return new ThreadPoolExecutor(0, Integer.MAX_VALUE,  // 最大线程是无穷大 ,受不了
                                      60L, TimeUnit.SECONDS,
                                      new SynchronousQueue<Runnable>());
    }

```