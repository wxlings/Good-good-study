ListView 和 RecyclerView都用于列表展示


#### ListView 的优化机简单使用

> 优化1: 对滚出屏幕的view item 进行复用,避免无意义的`InflateLayout.from(context).inflate()`
> 优化2: 对的view item中子view的引用进行缓存,避免每次都要`findViewById()`

```kotlin

    private lateinit val adapter:ListViewAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val list = listOf("JAVA","Andoid","Kotlin",...)
        
        if (!::adapter.isInitialized){
            adapter = ListViewAdapter(this,list)
        }
        listView.adapter = adapter
        listView.setOnItemClickListener { _, _, i, _ ->
            Toast.makeText(this, list[i], Toast.LENGTH_SHORT).show()
        }
    }

    fun changeList(language:Stirng){
        list.add(language)
        adapter.notifyDataSetChanged()
    }

    class ListViewAdapter(context: Context, data: List<String>) :
        ArrayAdapter<String>(context, R.id.list_item_layout, data) {

        inner class ViewHolder(val textView: TextView)

        override fun getView(position: Int, 
                             	convertView: View?, parent: ViewGroup): View {
            val view: View
            val holder: ViewHolder
            if (convertView == null) {
                view = LayoutInflater.from(context).inflate(
                    	R.id.list_item_layout, parent, false)
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

    class User(name:String,age:Int,gender:Char='男')
```

#### RecyclerView 的基本使用

RecyclerView 简称 RV， 是作为 ListView 和 GridView 的加强版出现的， RecyclerView 的复用机制的实现是它的一个核心部分。

> RecyclerView的显示需要显示设定一个`LayoutManager`
    1. 线性布局:LinearLayoutManager
    2. 网格布局:GridLayoutManager
    3. 瀑布流布局:StaggeredGridLayoutManager

> RecyclerView 没有直接提供点击事件,需要在Adapter中自行实现

常用的方法
    
```java    
    view.setAdapter(); // * 设置适配器 
    view.setLayoutManager();  // * 设置布局管理器
    view.setItemAnimator();   // 设置item animator
    view.addItemDecoration();  // 添加item 装饰器
```


```kotlin

    private lateinit val adapter:RecyclerViewAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val list = listOf("JAVA","Andoid","Kotlin",...)
        
        // 线性布局: 需要指定方向
        // val manager = LinearLayoutManager(this)
        // manager.orientation = LinearLayoutManager.VERTICAL

        // 网格布局: 需要指定网格的列数
        // val manager = GridLayoutManager(this,5)

        // 瀑布流布局: 同样需要指定流的列数以及流的方向
         val manager = StaggeredGridLayoutManager(2,
            StaggeredGridLayoutManager.VERTICAL)

        recyclerView.layoutManager = manager

        if (!::adapter.isInitialized){
            adapter = RecyclerViewAdapter(list)
        }
        recyclerView.adapter = adapter
    }

    fun changeList(language:Stirng){
        list.add(language)
        adapter.notifyDataSetChanged()
    }


    class RecyclerViewAdapter (private val list:List<String>):
         RecyclerView.Adapter<RecyclerViewAdapter.ViewHolder>(){

        inner class ViewHolder(val view: View) :RecyclerView.ViewHolder(view){
            val textView: TextView = view.findViewById(R.id.item)
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
            val view = LayoutInflater.from(parent.context).
                inflate(R.layout.list_item_layout,parent,false)
            val viewHolder = ViewHolder(view)
            view.setOnClickListener {
                Toast.makeText(parent.context,
                    list[viewHolder.bindingAdapterPosition],
                        Toast.LENGTH_SHORT).show()
            }
        return viewHolder
    }

        override fun onBindViewHolder(holder: ViewHolder, position: Int) {
            holder.textView.text = list[position]
        }

        override fun getItemCount(): Int = list.size
    }

```
RV 本质上也是一个自定义控件，所以也符合自定义控件的规则。因此我们也可以沿着分析其 onMeasure -> onLayout -> onDraw 过程;
RV 会将测量 onMeasure 和布局 onLayout 的工作委托给 LayoutManager 来执行，不同的 LayoutManager 会有不同风格的布局显示，这是一种策略模式。用一张图来描述这段过程如下：
![recyclerview](https://s0.lgstatic.com/i/image/M00/09/9D/Ciqc1F68ujuAJSpLAACb76c7LSA053.png)


#### 缓存复用原理 Recycler

缓存复用是 RV 中另一个非常重要的机制，这套机制主要实现了 ViewHolder 的缓存以及复用。

```java
    /**
     * A Recycler is responsible for managing scrapped or detached item views for reuse.
     *
     * <p>A "scrapped" view is a view that is still attached to its parent RecyclerView but
     * that has been marked for removal or reuse.</p>
     *
     * <p>Typical use of a Recycler by a {@link LayoutManager} will be to obtain views for
     * an adapter's data set representing the data at a given position or item ID.
     * If the view to be reused is considered "dirty" the adapter will be asked to rebind it.
     * If not, the view can be quickly reused by the LayoutManager with no further work.
     * Clean views that have not {@link android.view.View#isLayoutRequested() requested layout}
     * may be repositioned by a LayoutManager without remeasurement.</p>
     */
     public final class Recycler {
        final ArrayList<ViewHolder> mAttachedScrap = new ArrayList<>();
        ArrayList<ViewHolder> mChangedScrap = null;
        final ArrayList<ViewHolder> mCachedViews = new ArrayList<ViewHolder>();
        RecycledViewPool mRecyclerPool;
        static final int DEFAULT_CACHE_SIZE = 2;
        private ViewCacheExtension mViewCacheExtension;

        /**
         * Set the maximum number of detached, valid views we should retain for later use.
         */
        public void setViewCacheSize(int viewCount) {
            mRequestedCacheMax = viewCount;
            updateViewCacheSize();
        }

```

Recycler 的缓存也是分级处理的，根据访问优先级从上到下可以分为 4 级:
第一级缓存: `mAttachedScrap`,`mChangedScrap`
第二级缓存: `mCachedViews`
第三级缓存: `mViewCacheExtension`
第四级缓存: `mRecyclerPool`

第一级缓存 mAttachedScrap&mChangedScrap,是两个名为 Scrap 的 ArrayList，这两者主要用来缓存屏幕内的 ViewHolder。为什么屏幕内的 ViewHolder 需要缓存呢？通过下拉刷新列表中的内容，当刷新被触发时，只需要在原有的 ViewHolder 基础上进行重新绑定新的数据 data 即可，而这些旧的 ViewHolder 就是被保存在 mAttachedScrap 和 mChangedScrap 中。实际上当我们调用 RV 的 notifyXXX 方法时，就会向这两个列表进行填充，将旧 ViewHolder 缓存起来。mChangedScrap 和 mAttachedScrap 只在布局阶段使用。其他时候它们是空的。布局完成之后，这两个缓存中的 viewHolder，会移到 mCacheView 或者 RecyclerViewPool 中。

第二级缓存 mCachedViews 它用来缓存移除屏幕之外的 ViewHolder，默认情况下缓存个数是 2，不过可以通过 setViewCacheSize 方法来改变缓存的容量大小。如果 mCachedViews 的容量已满，则会根据 FIFO 的规则将旧 ViewHolder 抛弃，然后添加新的 ViewHolder.通常情况下刚被移出屏幕的 ViewHolder 有可能接下来马上就会使用到，所以 RV 不会立即将其设置为无效 ViewHolder，而是会将它们保存到 cache 中，但又不能将所有移除屏幕的 ViewHolder 都视为有效 ViewHolder，所以它的默认容量只有 2 个。

第三级缓存 ViewCacheExtension 这是 RV 预留给开发人员的一个抽象类，开发人员可以通过继承 ViewCacheExtension，并复写抽象方法 getViewForPositionAndType 来实现自己的缓存机制。只是一般情况下我们不会自己实现也不建议自己去添加缓存逻辑，因为这个类的使用门槛较高，需要开发人员对 RV 的源码非常熟悉。

第四级缓存 RecycledViewPool RecycledViewPool 同样是用来缓存屏幕外的 ViewHolder，当 mCachedViews 中的个数已满（默认为 2），则从 mCachedViews 中淘汰出来的 ViewHolder 会先缓存到 RecycledViewPool 中。ViewHolder 在被缓存到 RecycledViewPool 时，会将内部的数据清理，因此从 RecycledViewPool 中取出来的 ViewHolder 需要重新调用 onBindViewHolder 绑定数据。这就同最早的 ListView 中的使用 ViewHolder 复用 convertView 的道理是一致的，因此 RV 也算是将 ListView 的优点完美的继承过来。


#### ListView 和 RecydlerView 的区别:

使用上:
ListView 继承重写BaseAdapter类；自定义ViewHolder与convertView的优化；
RecyclerView 继承重写RecyclerView.Adapter与RecyclerView.ViewHolder,设置LayoutManager，以及layout的布局效果


布局效果: 
ListView 的布局比较单一，只有一个纵向效果；
RecyclerView 的布局效果丰富， 可以在LayoutMananger中设置：线性布局（纵向，横向），表格布局，瀑布流布局,以在LayoutManager的API中自定义Layout：

HeaderView 与 FooterView: 
ListView中可以通过addHeaderView() 与 addFooterView()来添加头部item与底部item,而且这两个API不会影响Adapter的编写；
RecyclerView中并没有这两个API，所以当我们需要在RecyclerView添加头部item或者底部item的时候，我们可以在Adapter中自己编写，根据ViewHolder的Type与View来实现自己的Header，Footter与普通的item，但是这样就会影响到Adapter的数据

局部刷新: 
在ListView中通常刷新数据是用notifyDataSetChanged() ，但是这种刷新数据是全局刷新的（每个item的数据都会重新加载一遍），这样一来就会非常消耗资源；
RecyclerView中可以实现局部刷新

动画效果：
ListView并没有实现动画效果，但我们可以在Adapter自己实现item的动画效果； 
在RecyclerView中，已经封装好API来实现自己的动画效果；有许多动画API，

Item点击事件：
在ListView中有onItemClickListener(), onItemLongClickListener(), onItemSelectedListener(),
在RecyclerView中，提供了唯一一个API：addOnItemTouchListener()，监听item的触摸事件