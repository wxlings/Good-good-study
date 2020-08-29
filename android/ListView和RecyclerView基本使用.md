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

> RecyclerView的显示需要显示设定一个`LayoutManager`
    1. 线性布局:LinearLayoutManager
    2. 网格布局:GridLayoutManager
    3. 瀑布流布局:StaggeredGridLayoutManager

> RecyclerView 没有直接提供点击事件,需要在Adapter中自行实现

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