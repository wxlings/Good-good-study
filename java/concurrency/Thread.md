
### 概念:

在java中线程有两种: 守护线程(daemon) 和 用户线程(非守护线程)

### 创建线程的两种方式:

1. ###### 继承Thread类,重写run()方法:

```java
    public class ImplThread extends Thread{
        @Override
        public void run() {
            super.run();
            System.out.println(Thread.currentThread().getId());
        }
    }

    public static void main(String[] args){
        ImplThread thread = new ImplThread();
        thread.start();
    }
```

2. ###### 实现Runnable接口,然后把实例作为参数传递给Thread;

```java
    class  ImplRunnable implements Runnable{
        @Override
        public void run() {
            System.out.println(Thread.currentThread().getId());
        }
    }

    public static void main(String[] args){
        ImplRunnable runnable = new ImplRunnable();
        Thread thread = new Thread(runnable);
        thread.start();

        // 有很多时候我们都习惯使用匿名的方式创建Runnable
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println(Thread.currentThread().getId());
            }
        });
        thread.start();
    }
```
> Notes: 对于线程的执行必须调用`Thread.start()`方法;

##### Difference between Runnable vs Thread 

1. 实现Runnable接口是一种比较好的方式, you’re not really specializing or modifying the thread’s behavior(并没有真正专门化或修改线程的行为),只是把执行的东西给到线程;
2. java中是单继承,而接口却可以多实现;
3. Instantiating an interface gives a cleaner separation between your code and the implementation of threads.意思是说实例化接口的方式代码分离更清晰
4. 实现Runnable更加灵活,可以把Runnable传递个Thread ,可以传递给线程池;如果使用extends Thread 就必须在指定的Thread中做一些事情

### 线程的生命周期

在java中使用枚举类State标记了Thread的状态,包括:
`NEW` : Thread state for a thread which has not yet started.
`RUNNABLE` : Thread state for a runnable thread.  A thread in the runnable  state is executing in the Java virtual machine but it may be waiting for other resources from the operating system such as processor.
`BLOCKED` : Thread state for a thread blocked waiting for a monitor lock. A thread in the blocked state is waiting for a monitor lock to enter a synchronized block/method or reenter a synchronized block/method after calling Object.wait.
`WAITING` : Thread state for a waiting thread.
`TIMED_WAITING` : Thread state for a waiting thread with a specified waiting time.
`TERMINATED` : Thread state for a terminated thread.The thread has completed execution.


### Thread API ANG PROPERTIES

###### Thread 优先机属性: 取值范围1-10

> Every thread has a priority. Threads with higher priority are executed in preference to threads with lower priority.  属性级别高的优先执行

```java
    Thread thread = new Thread(...);
    thread.setPriority(10);
    thread.start();
```

###### Thread 守护线程:

> Marks this thread as either a daemon thread  or a user thread. The Java Virtual Machine exits when the only threads running are all daemon threads.

```java
    Thread thread = new Thread(...);
    thread.setDaemon(true);
    thread.start();
```

Notes: 对于垃圾回收机制的实现就是守护线程;

###### JOIN
The join() method of a Thread instance can be used to “join” the start of a thread’s execution to the end of another thread’s execution so that a thread will not start running until another thread has ended. If join() is called on a Thread instance, the currently running thread will block until the Thread instance has finished executing.
线程实例的join()方法可用于将一个线程的执行开始“连接”到另一个线程的执行结束，这样一个线程在另一个线程结束之前不会开始运行。如果在线程实例上调用join()，当前运行的线程将阻塞，直到线程实例完成执行。

```java
    public static void main(String[] args) {
		
		Thread t = new Thread(new Runnable() {
			@Override
			public void run() {
				System.out.println(Thread.currentThread().getName());
				Thread.sleep(3*1000);
				System.out.println(Thread.currentThread().getName());
			}
			
		});
		
		Thread t1 = new Thread(new Runnable() {
			@Override
			public void run() {
				System.out.println(Thread.currentThread().getName());
			}
		});
		
		t.start();
		t.join();
		t1.start();
	}
```

结果:

```java
    Thread-0
    Thread-0
    Thread-1
```


```java
    Thread thread = new Thread(...);
    Thread thread = Thread.currentThread();             // 也可以使用native方法获取当前Thread
    thread.setDaemon(true);                     // 设置该Thread是否为守护线程
    thread.setPriority(1);                      // 设置该Thread的执行优先级别
    thread.setName("custom");                   // 设置该Thread的名称
    thread.setUncaughtExceptionHandler(new Thread.UncaughtExceptionHandler() {  // 设置该Thread的异常捕获监听器
        @Override
        public void uncaughtException(Thread t, Throwable e) {
            // todo 做一些 代码没有捕获的异常的处理
        }
    });

    thread.isDaemon();                          // 是否是守护线程
    thread.getId();                             // 获取线程ID
    thread.getName();                           // 获取线程名称
    thread.getPriority();                       // 获取线程执行优先级别
    thread.getState();                          // 获取线程状态
    thread.getUncaughtExceptionHandler();       // 获取线程异常捕获器
    thread.interrupt();                         // 线程是否已经中断
    thread.isAlive();                           // 线程是否激活状态
    thread.join([millis,[nanos]]);              // 线程等待销毁(指定的时间后)

    Thread.
```

Thread 的静态方法:
```java
    Thread.currentThread();             // 获取当前线程实例
    Thread.activeCount();               // 线程激活数量
    Thread.interrupted();               // 当前线程是否中断
    Thread.sleep(millis[,nanos]);       // 当前线程休眠                 
    Thread.yield();                     // 当前线程暂停让其他线程优先执行,这时无关priority值的设置
```

扩展: 

`Thread.yield()`和`Thead.currentThread.join()`的区别:

`Thread.yield()`:  Theoretically, to ‘yield’ means to let go, to give up, to surrender. A yielding thread tells the virtual machine that it’s willing to let other threads be scheduled in its place. This indicates that it’s not doing something too critical. Note that it’s only a hint, though, and not guaranteed to have any effect at all.
理论上，“yield”意味着放手，放弃，投降。一个`yield`线程告诉虚拟机，它愿意让其他线程在它的位置上调度。这表明它并不是在做一些非常重要的事情。请注意，这只是一个提示，并不能保证有任何效果。
简单的理解就是:忽略自己的`priority`属性,暂停自己,优先其他线程执行

`Thead.currentThread.join()` : The join() method of a Thread instance can be used to “join” the start of a thread’s execution to the end of another thread’s execution so that a thread will not start running until another thread has ended. If join() is called on a Thread instance, the currently running thread will block until the Thread instance has finished executing.线程实例的join()方法可用于将一个线程的执行开始“连接”到另一个线程的执行结束，这样一个线程在另一个线程结束之前不会开始运行。如果在线程实例上调用join()，当前运行的线程将阻塞，直到线程实例完成执行。 
简单理解就是优先并保持自己执行,在自己执行完成后再开始执行其他线程