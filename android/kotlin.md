在Kotlin中代码真的很简洁:

1. 启动另外一个Activity

```kotlin
     startActivity(Intent(this,LoginActivity::class.java))
```
这里的写法有点特殊,需要注意

2. 给Button设置点击事件
```kotlin
    button.setOnClickListener {
       Toast.makeText(this,"View id: " + it.id,Toast.LENGTH_SHORT).show()
    }

    // 这里我们就不再需要findViewById来获取view的实例引用
    // 这样就可以了,如果需要使用参数直接使用`it`即可

```

3. 写一个类:如果需要被继承必须使用`open`关键字来修饰这个类
```kotlin
    // 声明一个基类
    open class BaseActivity:AppCompatActivity(){
        // todo 
    }
    // 声明一个子类来继承基类
    class MainActivity : BaseActivity(){
        
        override fun onCreate(bundle:Bundle){
            // todo
        }
    }
```

4. `repeat(n)` 重复次数
```kotlin
    var list = ArrayList<Integer>500dp()
    fun initData(){
        repeat(5){
            list.add(1)
        }
    }

```

5. 结束当前进程: 这里包路径必须全部敲出
    这里`killProcess()`只能结束掉当前进程,普通app没有权限结束其他进程

```kotlin
    android.os.Process.killProcess(android.os.Process.myPid())
```

6. 构造函数:
kotlin的构造函数有两种,主构造函数和次构造函数

主构造函数就是在类名后面跟随的,
次构造函数需要重写

```kotlin
    open class Person(name: String, gender: Char, age: Int = 18) {
        private val TAG = Person::class.simpleName
    
        init {
            // todo 做一些初始化工作
            Log.e(TAG, "Name: ${name}" )
        }
        // 声明次构造器
        constructor(name: String) : this(name,'男')
        
        init {
            Log.e(TAG, toString(), )
        }

        final override fun toString(): String {
            return "Person(TAG=$TAG)"
        }
}

// 继承时必须指定使用父类的某一个构造方法
class Student(name: String, stuNum:Int) : Person(name) {
     var stuNum:Int = 0

    init {
        this.stuNum = stuNum
    }
}
```

7. 单例类: 使用`object`来修饰
单例类,没有构造方法,类似java中单例模式,使用`object`修饰

```kotlin

    object ActivityController {
        val list = ArrayList<Activity>
        fun add (activity:Activity){
            list.add(actvity)
        }
    }

    // 调用
    ActivityController.add()

```

7. 普通类中创建伪静态方法池:

```kotlin
    class Utils(){
        companion object{
            fun print(msg:String){
                // todo
            }
            fun toast(context: Context, msg:String){
                Toast.makeText(context,msg,Toast.LENGTH_SHORT).show()
            }
        }
    }

    // 使用
    Common.print("Hello,world!!!")

 ```

>  主语区分: `object`放在类的位置为单例类,放在代码块的位置结合`companion`是为静态方法块,块内所有方法都可以直接使用类名.

8. `@JvmStatic` kotlin中静态修饰
> `@JvmStatic` 只能用于修饰单例类或者`companion object`,其他报错,经过修饰后无论在Java还是kotlin中都可以直接调用了 

```kotlin
    companion object{
        @JvmStatic
        fun toast(context: Context, msg:String){
            Toast.makeText(context,msg,Toast.LENGTH_SHORT).show()
        }
    }
    
```

9. ListView 适配器的优化(建议使用ArrayAdapter)
- 复用convertView: 检查当前返回convertView是否为null,如果为null需要使用LayoutInflate重新inflate布局文件,否则直接使用convertView作为新item的布局view
- 创建ViewHolder保存当前itemd的子view的引用,避免findViewById()的耗时,存储的是布局文件中需要修改数据的子view引用,创建完成后使用convertView.tag与item view进行绑定

```kotlin
     class Adapter(context: Context, private val layoutId:Int, data:List<String>) :ArrayAdapter<String>(context,layoutId,data){

        inner class ViewHolder(val textView: TextView)

        override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
            val view:View
            val holder:ViewHolder
            if (convertView == null){
                view = LayoutInflater.from(context).inflate(layoutId,parent,false)
                holder = ViewHolder(view.findViewById(R.id.item))
                view.tag = holder
            } else {
                view = convertView
                holder = view.tag as ViewHolder
            }
            holder.textView.text = getItem(position)
            return view
        }
    }

```
对于ListView的点击事件可以通过`listView.setOnItemClickListener`,如果子view比较复杂可以在getView中设置监听(不推荐)
```kotlin
    listView.setOnItemClickListener { _, _, i, _ ->
        Toast.makeText(this, list[i], Toast.LENGTH_SHORT).show()
    }

```


10. RecylerView 的适配
Recycler需要重写`onCreateViewHolder`创建ViewHolder,`onBindViewHolder`进行数据bind,`getItemCount`计算item数量 三个方法
这里的ViewHolder是持有的整个item view,在bind时通过findViewById找到需要修改数据子view

```kotlin
    class RecyclerAdapter (private val list:List<String>): RecyclerView.Adapter<RecyclerAdapter.ViewHolder>(){
        inner class ViewHolder(val view: View) :RecyclerView.ViewHolder(view)

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
            val view = LayoutInflater.from(parent.context).inflate(R.layout.list_item_layout,parent,false)
            return ViewHolder(view)
        }

        override fun onBindViewHolder(holder: ViewHolder, position: Int) {
            holder.view.findViewById<TextView>(R.id.item).text = list[position]
        }

        override fun getItemCount(): Int = list.size
    }

    RecyclerView 的显示必须设置一个LayoutMannger

    LinearLayoutManager 是一个线性布局,它有个属性`orientation`属性可以设置Recycler的滚动方向(`HORIZONTAL|VERTICAL`)
    GridLayoutManager 实现网格布局,创建实例时需要传入一个参数列数
    StaggeredGridLayoutManager 实现瀑布流样式,创建实例需要传入两个参数1. 列数 2. 流的方向
```

对于RecyclerView的点击事件系统并没有提供api,需要在创建ViewHolder实例的时候进行设置
```kotlin
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.list_item_layout,parent,false)
        val viewHolder = ViewHolder(view)
        view.setOnClickListener {
            Toast.makeText(parent.context,list[viewHolder.bindingAdapterPosition],Toast.LENGTH_SHORT).show()
        }
        return viewHolder
    }
```

11. `lazyinit` 懒初始化

```kotlin
    private lazyinit var list:ArrayList<String>
    fun onCreate(...){
        if (!::list.isInitialized){   // ::variable.inInitialized 检查变量是否已经初始化
            list = ArrayList()
        }
    }
```



