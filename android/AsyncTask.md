AsyncTask enables proper and easy use of the UI thread. This class allows you to perform background operations and publish results on the UI thread without having to manipulate threads and/or handlers.

 An asynchronous task is defined by a computation that runs on a background thread and whose result is published on the UI thread. An asynchronous task is defined by 3 generic types, called Params, Progress and Result, and 4 steps, called onPreExecute, doInBackground, onProgressUpdate and onPostExecute.
AsyncTask 可以在后台子线程执行耗时任务,然后在UI线程返回结果;它不适合长周期性保持线程激活,如果这样请使用Executor;有四个步骤:onPreExecute, doInBackground, onProgressUpdate and onPostExecute.

##### 基本使用以及方法说明:

```java

    class DownLoadTask:AsyncTask<Unit,Int,Boolean>(){
        /**
        * Runs on the UI thread before {@link #doInBackground}.
        */
        override fun onPreExecute() {
            super.onPreExecute()
        }

        /**
        * <p>Runs on the UI thread after {@link #doInBackground}. The
        * specified result is the value returned by {@link #doInBackground}.</p>
        * 
        * <p>This method won't be invoked if the task was cancelled.</p>
        *
        */ @param result The result of the operation computed by {@link #doInBackground}.`
        override fun onPostExecute(result: Boolean?) {
            super.onPostExecute(result)
        }

        /**
        * Runs on the UI thread after {@link #publishProgress} is invoked.
        * The specified values are the values passed to {@link #publishProgress}.
        */
        override fun onProgressUpdate(vararg values: Int?) {
            super.onProgressUpdate(*values)
        }

         /**
        * Override this method to perform a computation on a background thread. The
        * specified parameters are the parameters passed to {@link #execute}
        * by the caller of this task.
        *
        * This method can call {@link #publishProgress} to publish updates
        */ on the UI thread.
        override fun doInBackground(vararg params: Unit?): Boolean {
            TODO("Not yet implemented")
        }
    }

```

##### 构造器需要指定三个参数: 先后分别是参数,进度,和结果;

```java
    public abstract class AsyncTask<Params, Progress, Result>{
        ...
    }
```

Params: 需要传入的参数如果参数不需要出入请指定`Unit`
Progess: 任务执行进度,通常`Int`类型
Result: 执行结构,通常是Boolean


##### 什么是  `Unit` ? 就是Java的 `Void`

```java

    /**
    * The type with only one value: the `Unit` object. This type corresponds to the `void` type in Java.
    */
    public object Unit {
        override fun toString() = "kotlin.Unit"
    }

```
这里就对应java中的Void,也可以看是 void 的包装类;本意是'无效的,空的',所以它不能被实例化,只做占位类用

##### 是怎样执行任务的?

    AsyncTask 是 Executor典型的实例,内部就是狗造了一个线程池进行多任务管理的,看代码:

```java
    private static final int CPU_COUNT = Runtime.getRuntime().availableProcessors();
    // We want at least 2 threads and at most 4 threads in the core pool,
    // preferring to have 1 less than the CPU count to avoid saturating
    // the CPU with background work
    private static final int CORE_POOL_SIZE = Math.max(2, Math.min(CPU_COUNT - 1, 4));
    // 实例化ThreadFactory
    private static final ThreadFactory sThreadFactory = new ThreadFactory() {
        private final AtomicInteger mCount = new AtomicInteger(1);

        public Thread newThread(Runnable r) {
            return new Thread(r, "AsyncTask #" + mCount.getAndIncrement());
        }
    };

    // 创建阻塞队列
    private static final BlockingQueue<Runnable> sPoolWorkQueue =
            new LinkedBlockingQueue<Runnable>(128);

    /**
     * An {@link Executor} that can be used to execute tasks in parallel.
     */
    public static final Executor THREAD_POOL_EXECUTOR;

    static {
        ThreadPoolExecutor threadPoolExecutor = new ThreadPoolExecutor(
                CORE_POOL_SIZE, MAXIMUM_POOL_SIZE, KEEP_ALIVE_SECONDS, TimeUnit.SECONDS,
                sPoolWorkQueue, sThreadFactory);
        threadPoolExecutor.allowCoreThreadTimeOut(true);
        THREAD_POOL_EXECUTOR = threadPoolExecutor;
    }

    /*
    * Executes the task with the specified parameters. The task returns
    * /itself (this) so that the caller can keep a reference to it.
    */
    @MainThread
    public final AsyncTask<Params, Progress, Result> execute(Params... params) {
        return executeOnExecutor(sDefaultExecutor, params);
    }
```

这里使用了静态就行修饰;所以我有的异步耗时的业务很有必要使用`AsyncTask`

##### 是怎样实现在UI线程返回进度即结果的?

Handler? 又是Handler,怎么又是Handler,没错只有涉及跨线程通信的几乎都要涉及Handler;

```java

    /**
     * Creates a new asynchronous task. This constructor must be invoked on the UI thread.
     */
    public AsyncTask() {
        this((Looper) null);
    }

    /**
     * Creates a new asynchronous task. This constructor must be invoked on the UI thread.
     *
     * @hide
     */
    public AsyncTask(@Nullable Handler handler) {
        this(handler != null ? handler.getLooper() : null);
    }

    private final Handler mHandler;

    private static Handler getMainHandler() {
        synchronized (AsyncTask.class) {
            if (sHandler == null) {
                sHandler = new InternalHandler(Looper.getMainLooper());
            }
            return sHandler;
        }
    }
```

AsyncTask 的构造要么传入Handler 要么传入Looper,这是必须的参数;Handler的讲解这里不多说
