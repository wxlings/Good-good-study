#### synchronized
synchronized 用于修饰方法和代码块;
1. 修饰实例方法;   使用当前实例对象作为锁对象,保证多线程访问时互斥
2. 修饰静态(类)方法;  使用类作为锁的对象,保证多线程访问互斥
3. 修饰代码块; 使用传入对象作为锁的对象(可以使用this或者new Object()),保证多线程访问互斥

特点: synchronized 对锁的释放有两种情况 1. 方法或者代码块执行完毕释放锁; 2. 出现异常后释放锁;


锁信息:

![synchronized](https://s0.lgstatic.com/i/image3/M01/89/8E/Cgq2xl6X-COAEskYAABd1Qkprak432.png)

锁计数器默认为0，当执行monitorenter指令时，如锁计数器值为0 说明这把锁并没有被其它线程持有。那么这个线程会将计数器加1，并将锁中的指针指向自己。当执行monitorexit指令时，会将计数器减1


#### ReentrantLock

可以保持事件同步;但是异常不会释放锁;这就需要使用`try-finally`逻辑;

```java
    ReentrantLock  lock = ...;

    try{
        lock.lock();
        // 同步事件
    }finally{
        lock.unlock()
    }

```

#### 公平锁

默认情况下，synchronized 和 ReentrantLock 都是非公平锁。但是 ReentrantLock 可以通过传入 true 来创建一个公平锁。

所谓公平锁就是通过同步队列来实现多个线程按照申请锁的顺序获取锁。

```java

     /**
     * Creates an instance of {@code ReentrantLock} with the
     * given fairness policy.
     *
     * @param fair {@code true} if this lock should use a fair ordering policy
     */
    public ReentrantLock(boolean fair) {
        sync = fair ? new FairSync() : new NonfairSync();
    }

```

> 网上对公平锁有一段例子很经典：假设有一口水井，有管理员看守，管理员有一把锁，只有拿到锁的人才能够打水，打完水要把锁还给管理员。每个过来打水的人都要得到管理员的允许并拿到锁之后才能去打水，如果前面有人正在打水，那么这个想要打水的人就必须排队。管理员会查看下一个要去打水的人是不是队伍里排最前面的人，如果是的话，才会给你锁让你去打水；如果你不是排第一的人，就必须去队尾排队，这就是公平锁。


#### 读写锁（ReentrantReadWriteLock）

在常见的开发中，我们经常会定义一个线程间共享的用作缓存的数据结构，比如一个较大的 Map。缓存中保存了全部的城市 Id 和城市 name 对应关系。这个大 Map 绝大部分时间提供读服务（根据城市 Id 查询城市名称等）。而写操作占有的时间很少，通常是在服务启动时初始化，然后可以每隔一定时间再刷新缓存的数据。但是写操作开始到结束之间，不能再有其他读操作进来，并且写操作完成之后的更新数据需要对后续的读操作可见。

在没有读写锁支持的时候，如果想要完成上述工作就需要使用 Java 的等待通知机制，就是当写操作开始时，所有晚于写操作的读操作均会进入等待状态，只有写操作完成并进行通知之后，所有等待的读操作才能继续执行。这样做的目的是使读操作能读取到正确的数据，不会出现脏读。


总结:  Java 中两个实现同步的方式 synchronized 和 ReentrantLock。其中 synchronized 使用更简单，加锁和释放锁都是由虚拟机自动完成，而 ReentrantLock 需要开发者手动去完成。但是很显然 ReentrantLock 的使用场景更多，公平锁还有读写锁都可以在复杂场景中发挥重要作用。


