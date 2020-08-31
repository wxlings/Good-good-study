#### 概念


#### Object life cycle
A java’s object life cycle can be seen in 3 stages:
Object creation,Object in use,Object destruction(摧毁,破坏)

#### Garbage collection algorithms
Object creation is done by code you write; and frameworks you use to use their provided features. As a java developer, we are not required to deallocate the memory or dereference the objects. It’s done automatically at JVM level by gargabe collector. Since java’s inception, there have been many updates on algorithms which run behind the scene to free the memory. Let’s see how they work?(对象创建以后,就可以使用对象的属性了.对于开发者,不需要接触分配其所占内存引用,jvm的GC会自动做)

###### Mark and sweep(标记和清除)
这种算法有两个阶段:
1. Marking live objects - 取出所有仍然活着的对象。
  To start with, GC defines some specific objects as Garbage Collection Roots.  Now GC traverses the whole object graph in your memory, starting from those roots and following references from the roots to other objects. Every object the GC visits is marked as alive.   C遍历内存中的整个对象图，从这些根开始，并遵循根对其他对象的引用。GC访问的每个对象都被标记为活动的。
  
2. Removing unreachable objects - 放弃那些已经die 或者不可用的对象


##### 复制算法
将可用内存一份为二,即原有100M,
优点:解决内存碎片的问题
缺点:触发Gc比较频繁

###### 标记压缩算法


###### 分代搜集算法