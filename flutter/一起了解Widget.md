



### Widget



> `Describes the configuration for an [Element].`

> `Widgets can be inflated into elements, which manage the underlying render tree.`

> 

```dart
@immutable
abstract class Widget extends DiagnosticableTree {
    
}
```





> ```
> A handle to the location of a widget in the widget tree. 
> ```

> 

> [BuildContext] objects are actually [Element] objects. The [BuildContext] interface is used to discourage direct manipulation of [Element] objects.
> [BuildContext]对象实际上是[Element]对象。 [BuildContext]接口用于阻止直接操作[Element]对象。

```dar
abstract class BuildContext {}
```

