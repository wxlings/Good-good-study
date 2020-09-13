
#### 概念:

In Java, a synchronized block of code can only be executed by one thread at a time.

Java synchronized keyword marks a block or method a critical section. A critical section is where one and only one thread is executing at a time, and the thread holds the lock for the synchronized section.
Java synchronized关键字将一个块或方法标记为临界区。临界区是指在同一时间只有一个线程在执行，并且该线程持有同步区的锁。

synchronized keyword helps in writing concurrent parts of the applications, to protect shared resources within this block.
synchronized关键字有助于编写应用程序的并发部分，以保护此块中的共享资源。

`synchronized` 可以被用于修饰block(代码块)或者method(方法)

> Notes : When a thread enters a synchronized block, all variables visible to the thread are refreshed from main memory. synchrinized 也是能够保证便量的可见性

- 修饰block:

##### Syntax:

```java
    synchronized( lockObject ) {
        // synchronized statements
    }
```

##### example

```java
    class Test{
	
        private int number;
        
        public void print() {
            synchronized(this){
                this.number++;
                System.out.println(Thread.currentThread().getName() + " ==> "  + this.number);
            }
        }
        public static void print_f(long time){
            sychronized(Test.class){
                System.out.println(Thread.currentThread().getName() + " ==> "  + time);
            }
        }
    }

    public static void main(String[] args) {
		final Test test = new Test();
		Runnable runnable = new Runnable() {

			@Override
			public void run() {
				test.print();
                Test.print_f(System.currentTimeMillis())
			}
			
		};
		for(int i=0;i<10;i++) {
			new Thread(runnable).start();
		}

	}
```

---

##### Internal working

When a thread wants to execute synchronized statements inside the synchronized block, it MUST acquire the lock on lockObject‘s monitor. At a time, only one thread can acquire the monitor of a lock object. So all other threads must wait till this thread, currently acquired the lock, finish it’s execution.
当线程想要在同步块中执行同步语句时，它必须获得lockObject监视器上的锁。在同一时间，只有一个线程可以获得一个锁对象的监视器。因此，所有其他线程必须等待，直到这个当前获得锁的线程完成它的执行。

In this way, synchronized keyword guarantees that only one thread will be executing the synchronized block statements at a time, and thus prevent multiple threads from corrupting the shared data inside the block.
这样，synchronized关键字就保证了一次只有一个线程执行synchronized块语句，从而防止多个线程破坏块内的共享数据。


- 修饰 method

##### Syntax

```java
    <access modifier> synchronized method( parameters ) {
        // synchronized code
    }
```

##### Internal working

Similar to synchronized block, a thread MUST acquire the lock on the associated monitor object with synchronized method. In case of synchronized method,, the lock object is –
`.class` object – if the method is static.
`this` object – if the method is not static. ‘this’ refer to reference to current object in which synchronized method is invoked.
原理与block是一样,被锁对象的使用要注意:如果方法是static那么就要用`*.class`,如果不是static那么就要用`this`

Java synchronized keyword is re-entrant in nature it means if a synchronized method calls another synchronized method which requires same lock then current thread which is holding lock can enter into that method without acquiring lock.
Java synchronized关键字本质上是可重入的，这意味着如果一个同步方法调用另一个同步方法，该方法需要相同的锁，那么持有锁的当前线程可以进入该方法而不获取锁。

##### example

多线程去执行没有sychronized修饰方法时:

```java
    class Test{
	
        private int number;
        
        public void print() {
            this.number++;
            System.out.println(Thread.currentThread().getName() + " ==> "  + this.number);
        }
    }

    public static void main(String[] args) {
		final Test test = new Test();
		Runnable runnable = new Runnable() {

			@Override
			public void run() {
				test.print();
			}
			
		};
		for(int i=0;i<10;i++) {
			new Thread(runnable).start();
		}

	}
```

打印结果:

```java
    Thread-0 ==> 1
    Thread-3 ==> 4
    Thread-2 ==> 3
    Thread-1 ==> 2
    Thread-4 ==> 5
    Thread-8 ==> 6
    Thread-9 ==> 8
    Thread-7 ==> 10
    Thread-5 ==> 9
    Thread-6 ==> 7
```

接下来使用sychonized就行修饰:

```java
    public synchronized void print() {
		this.number++;
		System.out.println(Thread.currentThread().getName() + " ==> "  + this.number);
	}
```

打印结果:

```java
    Thread-0 ==> 1
    Thread-4 ==> 2
    Thread-5 ==> 3
    Thread-3 ==> 4
    Thread-2 ==> 5
    Thread-1 ==> 6
    Thread-7 ==> 7
    Thread-8 ==> 8
    Thread-6 ==> 9
    Thread-9 ==> 10
```

扩展: 

1. Synchronization in Java guarantees that no two threads can execute a synchronized method, which requires same lock, simultaneously or concurrently. Java中的同步可以保证两个线程不能同时或并发地执行一个同步的方法，因为该方法需要相同的锁。
2. `synchronized`只能用于method 或者 block,它们可以是static或者non-static;
3. When ever a thread enters into Java synchronized method or block it acquires a lock and whenever it leaves synchronized method or block it releases the lock.
4. Java synchronization will throw NullPointerException if object used in synchronized block is null.
5. Synchronized methods in Java put a performance cost on your application. So use synchronization when it is absolutely required. Also, consider using synchronized code blocks for synchronizing only critical section of your code. 使用synchronized是有性能影响的,适度使用
6. It’s possible that both static synchronized and non static synchronized method can run simultaneously or concurrently because they lock on different object.静态和非静态方法或者代码块有可能同时执行,因为它们的锁的对象不同



##### synchronized 实现原理:

要了解 synchronized 的原理需要先理清楚两件事情：对象头和 Monitor。
 
 Java 对象在内存中的布局分为 3 部分：对象头、实例数据、对齐填充,当我们在 Java 代码中，使用 new 创建一个对象的时候，JVM 会在堆中创建一个 instanceOopDesc 对象，这个对象中包含了对象头以及实例数据。

对象头:  