 Handy class for starting a new thread that has a looper. The looper can then be  used to create handler classes. Note that start() must still be called.
 这个类是Thread的子类,特点是执行逻辑时先创建一个Looper对象,主要用于与Handler通信

> IntentService 就是 HandlerThread 的 典型案例

 ```java 
    public class HandlerThread extends Thread { 
        ...
    }
```

```java
    @Override
    public void run() {
        mTid = Process.myTid();
        Looper.prepare();
        synchronized (this) {
            mLooper = Looper.myLooper();
            notifyAll();
        }
        Process.setThreadPriority(mPriority);
        onLooperPrepared();
        Looper.loop();
        mTid = -1;
    }

    // 执行
    private static void prepare(boolean quitAllowed) {
        if (sThreadLocal.get() != null) {
            throw new RuntimeException("Only one Looper may be created per thread");
        }
        sThreadLocal.set(new Looper(quitAllowed));
    }
```