 Handy class for starting a new thread that has a looper. The looper can then be  used to create handler classes. Note that start() must still be called.
 这个类是Thread的子类,先创建一个线程,让线程跑起来,再获取当前线程的Looper对象,用于与Handler通信

> IntentService 就是 HandlerThread 的 典型案例

基本使用:

```java

    val handlerThread = HandlerThread("ThreadName")
    handlerThread.start() // 这里要先开启线程,让线程的Looper()跑一会,(本质是loop()的阻塞等待)

    val handler = object:Handler(handlerThread.looper){
        override fun handleMessage(msg: Message?) {
            super.handleMessage(msg)
            // TODO: do something
        }
    }

    // 开始让Handler()进行发消息
    handler.post()
    handler.send()
    ....

```

HandlerThread 的本质就是创建一个线程;它直接继承了Thread;使用HandlerThread的本质核心就是让在子线程的Looper()不断的在子线程执行任务

 ```java 
    public class HandlerThread extends Thread { 

    @Override
    public void run() {
        mTid = Process.myTid();
        Looper.prepare();       // 先创建当前线程的Looper()
        synchronized (this) {
            mLooper = Looper.myLooper();
            notifyAll();
        }
        Process.setThreadPriority(mPriority);
        onLooperPrepared();
        Looper.loop();
        mTid = -1;
    }

     /**
     * This method returns the Looper associated with this thread. If this thread not been started
     * or for any reason isAlive() returns false, this method will return null. If this thread
     * has been started, this method will block until the looper has been initialized.  
     * @return The looper.
     */
    public Looper getLooper() {
        if (!isAlive()) {
            return null;
        }
        
        // If the thread has been started, wait until the looper has been created.
        synchronized (this) {
            while (isAlive() && mLooper == null) {
                try {
                    wait();
                } catch (InterruptedException e) {
                }
            }
        }
        return mLooper;
    }

    // Looper类的代码
    private static void prepare(boolean quitAllowed) {
        if (sThreadLocal.get() != null) {
            throw new RuntimeException("Only one Looper may be created per thread");
        }
        sThreadLocal.set(new Looper(quitAllowed));
    }
    

    // 就是要让Looper停止loop(),释放当前线程Looper()相关联的MessageQueue的Message
    public boolean quit() {
        Looper looper = getLooper();
        if (looper != null) {
            looper.quit();
            return true;
        }
        return false;
    }
```