锁提供了两种主要特性：互斥（mutual exclusion） 和可见性（visibility）。

[英文说明](http://tutorials.jenkov.com/java-concurrency/volatile.html),[翻译](https://www.jianshu.com/p/3893fb35240f)

### 概念

 The Java volatile keyword is used to mark a Java variable as "being stored in main memory".More precisely that means, that every read of a volatile variable will be read from the computer's main memory, and not from the CPU cache, and that every write to a volatile variable will be written to main memory, and not just to the CPU cache.
 Java volatile关键字用于将Java变量标记为“存储在主内存中”。更准确地说，这意味着对易失性变量的每次读取都将从计算机的主存中读取，而不是从CPU缓存中读取，而且对易失性变量的每次写入都将写入主存，而不仅仅是写入CPU缓存中。

 Actually, since Java 5 the volatile keyword guarantees more than just that volatile variables are written to and read from main memory. I will explain that in the following sections.

 ##### Variable Visibility Problems

 The Java volatile keyword guarantees visibility of changes to variables across threads. This may sound a bit abstract, so let me elaborate.

In a multithreaded application where the threads operate on non-volatile variables, each thread may copy variables from main memory into a CPU cache while working on them, for performance reasons. If your computer contains more than one CPU, each thread may run on a different CPU. That means, that each thread may copy the variables into the CPU cache of different CPUs. This is illustrated here:
意思就是说程序为了提高性能会把non-volatile变量放到cpu cache中,这样就引发一个问题,如果机器有多个cpu就会存在多个cache,这就存在多线程对应多个cpu cache,就不能保证变量的唯一性可见性

![多线程](http://tutorials.jenkov.com/images/java-concurrency/java-volatile-1.png)

With non-volatile variables there are no guarantees about when the Java Virtual Machine (JVM) reads data from main memory into CPU caches, or writes data from CPU caches to main memory. This can cause several problems which I will explain in the following sections.


*__volatile的作用就是保证了写操作对其他线程的可见性,对其进行的所有写操作都会马上回写至主存中。同时，所有 counter 的读操作也将直接在主存中进行__*

```java
    class Test{
        public volatile int number = 0;
    }
```
Declaring a variable volatile thus guarantees the visibility for other threads of writes to that variable.
当一个线程t1去修改number时,线程t2去读取(不做修改),是能够保证读取正确的值,如果需要做多线程修改操作还需要使用`synchronized`配合

#### Full volatile Visibility Guarantee

Actually, the visibility guarantee of Java volatile goes beyond the volatile variable itself. The visibility guarantee is as follows:

+ If Thread A writes to a volatile variable and Thread B subsequently reads the same volatile variable, then all variables visible to Thread A before writing the volatile variable, will also be visible to Thread B after it has read the volatile variable.
+ If Thread A reads a volatile variable, then all all variables visible to Thread A when reading the volatile variable will also be re-read from main memory.



#### The Java volatile Happens-Before Guarantee

自 Java 5 之后，关键字 volatile 不仅仅保证变量写入主存和从主存中的读取。实际上，volatile 保证了以下几点：

如果线程A写 volatile 变量（下文用 volatile 简称 volatile 变量）， 然后线程B 读取这个 volatile ，那么在写 volatile 之前对线程A可见的变量也将在线程B 读取这个 volatile 之后可见。
对 volatile 变量的读取和写入指令不能被 JVM 重排序（只要 JVM 识别出程序的行为在重排序后不会改变，它就会对指令进行重排序以提高性能）。操作volatile 之前和之后的指令可以重排序，但是不能将其和这些指令混在一起重排序。任何发生在 volatile 的读写操作之后的指令一定发生在读写操作之后。（具体的可以看本文底部的 “正确使用volatile” 里的说明）


# Instruction Reordering

#### When is volatile Enough?
即使关键字 volatile 能保证对它的所有读操作都是直接从主存中读取，所有写操作也都是直接写入主存中，还是有些仅将变量声明为 volatile 不能满足的场景。
当多线程同时依赖volatile变量的值进行重新赋值时,或者多个线程都对volatile变量进行读写时 就会出现问题,这样就要使用synchronized来保证变量的原子性了;

*原子性是指一个操作是不可中断的。即使是在多个线程一起执行的时候，一个操作一旦开始，就不会被其它线程干扰。*

##### Performance Considerations of volatile
Reading and writing of volatile variables causes the variable to be read or written to main memory. Reading from and writing to main memory is more expensive than accessing the CPU cache. Accessing volatile variables also prevent instruction reordering which is a normal performance enhancement technique. Thus, you should only use volatile variables when you really need to enforce visibility of variables.
意识是说: 因为volatile修饰的变量会直接的写入/读取主内存,相对与普通变量的读写到cpu cache肯定是性能会降低的,同时jvm指令重排时也会保证其volatile顺序不变,也会消耗一些性能,建议只有真正需要的时候在用volatile


总结:Volatile 变量具有 synchronized 的可见性特性，但是不具备原子特性。这就是说线程能够自动发现 volatile 变量的最新值。Volatile 变量可用于提供线程安全，但是只能应用于非常有限的一组用例：多个变量之间或者某个变量的当前值与修改后值之间没有约束。因此，单独使用 volatile 还不足以实现计数器、互斥锁或任何具有与多个变量相关的不变式（Invariants）的类（例如 “start <=end”）。


扩展: 

> 可见性：一个线程对共享变量做了修改之后，其他的线程立即能够看到（感知到）该变量这种修改（变化）。Java内存模型是通过将在工作内存(cpu cache)中的变量修改后的值同步到主内存，在读取变量前从主内存刷新最新值到工作内存中，这种依赖主内存的方式来实现可见性的。

volatile关键字：通过volatile关键字修饰内存中的变量，该变量在线程之间共享

> 原子性：一个操作不能被打断，要么全部执行完毕，要么不执行。基本数据类型的访问都是原子性的（默认64位，32位的机器对long、double这种占8个字节的是非原子性的），而针对非原子性的数据，多线程的访问则是不安全的。

java.util.concurrent.atomic  

> 有序性：在本线程内观察，操作都是有序的；如果在一个线程中观察另外一个线程，所有的操作都是无序的。java内存模型所保证的是，同线程内，所有的操作都是由上到下的，但是多个线程并行的情况下，则不能保证其操作的有序性。

当使用synchronized关键字时，只能有一个线程执行直到执行完成后或异常，才会释放锁。所以可以保证synchronized代码块或方法只会有一个线程执行，保障了程序的有序性。