Java 中异常（Exception）分两种：检查异常 checked Exception 和非检查异常 unchecked Exception。

所谓检查异常就是在代码编译时期，Android Studio 就会提示代码有错误，无法通过编译，比如 IOException。如果我们没有在代码中将这些异常 catch，而是直接抛出，最终也有可能导致程序崩溃。

非检查异常包括 error 和运行时异常（RuntimeException），AS 并不会在编译时期提示这些异常信息，而是在程序运行时期因为代码错误而直接导致程序崩溃，比如 OOM 或者空指针异常（NPE）。

对于上述两种异常我们都可以使用 UncaughtExceptionHandler 来进行捕获操作，它是 Thread 的一个内部接口，





自定义异常:

自行实现`Thread.UncaughtExceptionHandler `的接口并实现`uncaughtException()`,使用`Thread.setDefaultUncaughtExceptionHandler(this);`

```kotlin

    object MyThreadExceptionHandler:Thread.UncaughtExceptionHandler {

        private lateinit var defaultHandler: Thread.UncaughtExceptionHandler

        fun init(){
            if (!::defaultHandler.isInitialized){
                defaultHandler = Thread.getDefaultUncaughtExceptionHandler()
            }
            Thread.setDefaultUncaughtExceptionHandler(this)
        }

        override fun uncaughtException(t: Thread?, e: Throwable?) {
            // 自行实现异常处理逻辑
        }
    }

```