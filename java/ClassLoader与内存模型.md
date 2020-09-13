文章内容整理于`姜新星`老师的课程



。一个完整的 Java 程序是由多个 .class 文件组成的，在程序运行过程中，需要将这些 .class 文件加载到 JVM 中才可以使用。而负责加载这些 .class 文件的就是本课时要讲的类加载器（ClassLoader）。


Java 中的类何时被加载器加载

在 Java 程序启动的时候，并不会一次性加载程序中所有的 .class 文件，而是在程序的运行过程中，动态地加载相应的类到内存中。



###### 通常情况下,Java 程序中的 .class 文件会在以下 2 种情况下被 ClassLoader 主动加载到内存中：

1. 调用类构造器
2. 调用类中的静态（static）变量或者静态方法

##### Java 中 ClassLoader

JVM 中自带 3 个类加载器：
1. 启动类加载器 BootstrapClassLoader --- 加载jre/lib下的文件
2. 扩展类加载器 ExtClassLoader （JDK 1.9 之后，改名为 PlatformClassLoader）---- 加载jre/ext下的文件
3. 系统加载器 APPClassLoader  ----  加载当前应用及jar包下的文件
它们JVM 中有各自分工，但是又互相有依赖。

##### 双亲委派模式（Parents Delegation Model）

既然 JVM 中已经有了这 3 种 ClassLoader，那么 JVM 又是如何知道该使用哪一个类加载器去加载相应的类呢？答案就是：双亲委派模式。
所谓双亲委派模式就是，当类加载器收到加载类或资源的请求时，通常都是先委托给父类加载器加载，也就是说，只有当父类加载器找不到指定类或资源时，自身才会执行实际的类加载过程。
![](https://s0.lgstatic.com/i/image3/M01/84/1D/Cgq2xl6MQCeAQezSAAQYyFDklrg999.png)

解释说明：

1. 判断该 Class 是否已加载，如果已加载，则直接将该 Class 返回。
2. 如果该 Class 没有被加载过，则判断 parent 是否为空，如果不为空则将加载的任务委托给parent。
3. 如果 parent == null，则直接调用 BootstrapClassLoader 加载该类。
4. 如果 parent 或者 BootstrapClassLoader 都没有加载成功，则调用当前 ClassLoader 的 findClass 方法继续尝试加载。

在每一个 ClassLoader 中都有一个 CLassLoader 类型的 parent 引用，并且在构造器中传入值。如果我们继续查看源码，可以看到 AppClassLoader 传入的 parent 就是 ExtClassLoader，而 ExtClassLoader 并没有传入任何 parent，也就是 null。

注意：“双亲委派”机制只是 Java 推荐的机制，并不是强制的机制。我们可以继承 java.lang.ClassLoader 类，实现自己的类加载器。如果想保持双亲委派模型，就应该重写 findClass(name) 方法；如果想破坏双亲委派模型，可以重写 loadClass(name) 方法。

##### 自定义 ClassLoader
JVM 中预置的 3 种 ClassLoader 只能加载特定目录下的 .class 文件，如果我们想加载其他特殊位置下的 jar 包或类时（比如，我要加载网络或者磁盘上的一个 .class 文件），默认的 ClassLoader 就不能满足我们的需求了，所以需要定义自己的 Classloader 来加载特定目录下的 .class 文件。

###### 自定义 ClassLoader 步骤

1. 自定义一个类继承抽象类 ClassLoader。
2. 重写 findClass 方法。
3. 在 findClass 中，调用 defineClass 方法将字节码转换成 Class 对象，并返回。

![custom-classloader](https://s0.lgstatic.com/i/image3/M01/84/1D/Cgq2xl6MQCeABoqPAACWzrHjS54889.png)


###### Android 中的 ClassLoader
本质上，Android 和传统的 JVM 是一样的，也需要通过 ClassLoader 将目标类加载到内存，类加载器之间也符合双亲委派模型。但是在 Android 中， ClassLoader 的加载细节有略微的差别。

在 Android 虚拟机里是无法直接运行 .class 文件的，Android 会将所有的 .class 文件转换成一个 .dex 文件，并且 Android 将加载 .dex 文件的实现封装在 BaseDexClassLoader 中，而我们一般只使用它的两个子类：PathClassLoader 和 DexClassLoader。

PathClassLoader: PathClassLoader 用来加载系统 apk 和被安装到手机中的 apk 内的 dex 文件。当一个 App 被安装到手机后，apk 里面的 class.dex 中的 class 均是通过 PathClassLoader 来加载的它的 2 个构造函数如下：
![pathclassloader](https://s0.lgstatic.com/i/image3/M01/84/1D/Cgq2xl6MQCiAV6lJAACs0LXqQVg644.png)

DexClassLoader: 很明显，对比 PathClassLoader 只能加载已经安装应用的 dex 或 apk 文件，DexClassLoader 则没有此限制，可以从 SD 卡上加载包含 class.dex 的 .jar 和 .apk 文件，这也是插件化和热修复的基础，在不需要安装应用的情况下，完成需要使用的 dex 的加载。
![dexclassloader](https://s0.lgstatic.com/i/image3/M01/0B/07/Ciqah16MQCiAP86KAABzADT7Fyw585.png)




内存模型:

工作内存:主要指cpu寄存和cpu高速缓存,主内存:物理内存即ram

缓存一致性: 由于多cpu访问并设置同一数据时,会在缓存中工作内存中,而访问却是物理内存,这就造成了缓存不一致问题;

指令重排: 为了使 CPU 内部的运算单元能够尽量被充分利用，处理器可能会对输入的字节码指令进行重排序处理，也就是处理器优化。除了 CPU 之外，很多编程语言的编译器也会有类似的优化，比如 Java虚拟机的即时编译器（JIT）也会做指令重排。
![指令重排](https://s0.lgstatic.com/i/image3/M01/88/72/Cgq2xl6VdnCAI0SsAAEI1td3ZTw250.png)

上面两小部分内容表明，如果我们任由 CPU 优化或者编译器指令重排，那我们编写的 Java 代码最终执行效果可能会极大的出乎意料。为了解决这个问题，让 Java 代码在不同硬件、不同操作系统中，输出的结果达到一致，Java 虚拟机规范提出了一套机制——Java 内存模型。

##### 什么是内存模型
内存模型是一套共享内存系统中多线程读写操作行为的规范，这套规范屏蔽了底层各种硬件和操作系统的内存访问差异，解决了 CPU 多级缓存、CPU 优化、指令重排等导致的内存访问问题，从而保证 Java 程序（尤其是多线程程序）在各种平台下对内存的访问效果一致。

在 Java 内存模型中，我们统一用工作内存（working memory）来当作 CPU 中寄存器或高速缓存的抽象。线程之间的共享变量存储在主内存（main memory）中，每个线程都有一个私有工作内存（类比 CPU 中的寄存器或者高速缓存），本地工作内存中存储了该线程读/写共享变量的副本。

在这套规范中，有一个非常重要的规则——happens-before。

##### happens-before 先行发生原则

那在 Java 中的两个操作如何就算符合 happens-before 规则了呢？ JMM 中定义了以下几种情况是自动符合 happens-before 规则的：
1. 程序次序规则: 在单线程内部，如果一段代码的字节码顺序也隐式符合 happens-before 原则，那么逻辑顺序靠前的字节码执行结果一定是对后续逻辑字节码可见，只是后续逻辑中不一定用到而已。
2. 锁定规则: 无论是在单线程环境还是多线程环境，一个锁如果处于被锁定状态，那么必须先执行 unlock 操作后才能进行 lock 操作
3. 变量规则: volatile 保证了线程可见性。通俗讲就是如果一个线程先写了一个 volatile 变量，然后另外一个线程去读这个变量，那么这个写操作一定是 happens-before 读操作的。
4. 线程启动规则:Thread 对象的 start() 方法先行发生于此线程的每一个动作。假定线程 A 在执行过程中，通过执行 ThreadB.start() 来启动线程 B，那么线程 A 对共享变量的修改在线程 B 开始执行后确保对线程 B 见
5. 线程中断规则:对线程 interrupt() 方法的调用先行发生于被中断线程的代码检测，直到中断事件的发生
6. 线程终结规则: 线程中所有的操作都发生在线程的终止检测之前，我们可以通过 Thread.join() 方法结束、Thread.isAlive() 的返回值等方法检测线程是否终止执行。假定线程 A 在执行的过程中，通过调用 ThreadB.join() 等待线程 B 终止，那么线程 B 在终止之前对共享变量的修改在线程 A 等待返回后可见。