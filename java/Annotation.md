Java 注解（Annotation）又称 Java 标注，是 JDK5.0 引入的一种注释机制。

java 内置的注解
Java 定义了一套注解，共有 7 个，3 个在 java.lang 中，剩下 4 个在 java.lang.annotation 中。

常用修饰代码注解:
- `@Override` - 检查该方法是否是重写方法。如果发现其父类，或者是引用的接口中并没有该方法时，会报编译错误。
- `@Deprecated` - 标记过时方法。如果使用该方法，会报编译警告。
- `@SuppressWarnings` - 指示编译器去忽略注解中声明的警告。

作用在其他注解的注解(或者说 元注解)是:
- `@Retention` - 标识这个注解怎么保存，是只在代码中，还是编入class文件中，或者是在运行时可以通过反射访问。(标记注解的声明周期)
-` @Documented` - 标记这些注解是否包含在用户文档中。
- `@Target` - 标记这个注解应该是哪种 Java 成员。
- `@Inherited` - 标记这个注解是继承于哪个注解类(默认 注解并没有继承于任何子类)
![annotation](https://www.runoob.com/wp-content/uploads/2019/08/28123151-d471f82eb2bc4812b46cc5ff3e9e6b82.jpg)


Target 取值枚举 ElementType 声明值;

```java
    package java.lang.annotation;
    public enum ElementType {
        TYPE,               /* 类、接口（包括注释类型）或枚举声明  */
        FIELD,              /* 字段声明（包括枚举常量）  */
        METHOD,             /* 方法声明  */
        PARAMETER,          /* 参数声明  */
        CONSTRUCTOR,        /* 构造方法声明  */
        LOCAL_VARIABLE,     /* 局部变量声明  */
        ANNOTATION_TYPE,    /* 注释类型声明  */
        PACKAGE             /* 包声明  */
    }
```

Retention 取值枚举 RetentionPolicy 值;

```java
    package java.lang.annotation;
    public enum RetentionPolicy {
        SOURCE,            /* Annotation信息仅存在于编译器处理期间，编译器处理完之后就没有该Annotation信息了  */
        CLASS,             /* 编译器将Annotation存储于类对应的.class文件中。默认行为  */
        RUNTIME            /* 编译器将Annotation存储于class文件中，并且可由JVM读入 */
    }
```

自定义注解:

```java

@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface MyAnnotation {
    String value() default  "hello,world !!" ;
    String bind();
}

```