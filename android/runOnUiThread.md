
`runOnUiThread` 是Activity类提供的一个方法;

`runOnUiThread`经常被用来在子线程中更新UI,我们知道在子线程中是不能更新UI的,是不安全的,但是它是怎么实现的呢 

使用:

```kotlin

    Thread({
        runOnUiThread({
            text.text = "Hello,world."
        })
    }).start()

```
为什么参数要以Runnable对象的形式呢 ,那么Runnable又联想到什么了呢 ? 就是Handler;

来看一下源码,其实很简单:

```java

final Handler mHandler = new Handler();

 /**
     * Runs the specified action on the UI thread. If the current thread is the UI
     * thread, then the action is executed immediately. If the current thread is
     * not the UI thread, the action is posted to the event queue of the UI thread.
     *
     * @param action the action to run on the UI thread
     */
    public final void runOnUiThread(Runnable action) {
        if (Thread.currentThread() != mUiThread) {
            mHandler.post(action);
        } else {
            action.run();
        }
    }

```

在Activity中初始化了一个全局Handler对象,如果在主线程中执行`runOnUiThread()`直接运行Runnable对象的`run()`方法,如果在子线程中执行`runOnUiThread()`则直接使用Handler进行`post()`