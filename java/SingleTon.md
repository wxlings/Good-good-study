

```java

public class SingleTon {

    public static void main(String[] args) {
        Dog dog = Dog.getInstance();
        Cat cat = Cat.getInstance();
        Horse horse = Horse.getInstance();
        Sheep sheep = Sheep.getInstance();
        Pig pig = Pig.getInstance();
    }
}


// 饿汉式 : 直接先创建实例;
// 缺点: 如果对象比较大或者使用频率低,浪费资源
class Dog {

    private Dog() {
    }

    private static Dog dog = new Dog();

    public static Dog getInstance() {
        return dog;
    }
}

// 懒汉式: 需要用到的时候在创建实例
// 缺点: 方法使用了 synchronized ,多线程下如果已经实例化了还会执行同步逻辑,不合理;
class Cat {
    private Cat() {
    }

    private static Cat cat = null;

    public synchronized static Cat getInstance() {
        if (cat == null) {
            cat = new Cat();
        }
        return cat;
    }
}

// 懒汉式式: 双检查锁机制
class Horse {

    private Horse() {
    }

    private static Horse horse = null;

    public static Horse getInstance() {
        if (horse == null) {
            synchronized (Horse.class) {
                if (horse == null) {
                    horse = new Horse();
                }
            }
        }
        return horse;
    }
}

// 静态内部类的方式
// 静态内部类: 默认不会加载执行,只有当外部类被ClassLoader加载时才会执行加载执行类中的static变量及方法(详情在类加载过程中的`链接`->`准备`中
// 可以通过反射进行获取实例
class Sheep {
    private Sheep() {
        if (Holder.LAZY != null) {
            throw new RuntimeException("不能反射...");
        }
    }

    public static Sheep getInstance() {
        return Holder.LAZY;
    }

    private static final class Holder {
        private static Sheep LAZY = new Sheep();
    }
}


// 饿汉式单例的实现
enum Pig {

    INSTANCE;

    public static Pig getInstance() {
        return INSTANCE;
    }
}

```

学了kotlin之后,java真的是...


```kotlin

object Singleton{
    // todo 
} 

```