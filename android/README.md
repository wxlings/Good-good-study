Android 系统架构:

1. Linux内核层:
2. 系统运行库层:
3. 应用FrameWork层:
4. application层:

版本:
L5,M6,N7,O8,P9

四大组件:
Activity,Service,BroadcastReceiver,ContentProvider

AndroidX的目的主要是取代过去的Android Support Library

gradlew / gradlew.bat: 用于在命令行界面执行gradle命令的,在Linux/Mac使用gradle文件,在windows下使用gradlew.bat
注意:通常在当前目录使用: `./gradlew <command>`

`.xml`用于标识项目是InteliJ idea,默认不需要理会

`local.properties`指定sdk的位置

当点击应用图标时,应用冷启动时会打开intent-filter中指定action=main/category=LAUNCHER的Activity

`res`目录下的同类型多资源包的设计在于兼容更多类型的设备

Gradle 是非常好的项目构建工具

Android 使用任务Task来管理Activity,一个Task就是一组放在栈里的Activity的集合,这个栈也称返回栈back stack
栈是一种后进先出的数据结构

Menu菜单的操作:
onCreateOptionsMenu() 用于加载菜单选项,默认加载到屏幕的右上角
onOptionsItemSelected() 用于菜单按钮点击回调的处理逻辑

Activity的声明周期方法:

onCreate() -> onStart() -> onResume() -> onPause() -> onStop() -> onDestroy(),还有一个是onRestart()

打开其他页面:
1. context.startActivity(Intent()) / finish()
2. context.startActivityForResalt(Intent(),code) -> context2.setResult(code) -> onActivityForResult()

Activity中数据的临时保存与获取状态:
onSaveInstanceState(Bundle())   // 通常在Activity进入后台或者面临内存紧张的时候就会调用,正常操作:把一些重要的数据保存在Bundle对象中,然后在onCreate()或者onRestoreInstanceState()中重新获取
onRestoreInstanceState(Bundle())  // 当Activity实例被修复后会被调用

Activity的启动模式: 在AndroidManifest.xml文件中Activity标签中是使用 `android:launchMode="..."`来标记当前Activity的启动模式
1. standard : 默认启动模式,每开启一个Activity就会创建一个其实例并处于栈顶
2. singleTop: 栈顶模式,即开启Activity时先检查当前回退栈顶是否是它的实例,如果是则不再新建,而是复用栈顶实例调用`onNewIntent(Intent)`方法,如果不是则新建实例然后入栈,这种模式的适合有其他方式能够打开的情款,例如: 当前在个人中心页,点击通知栏再次进入个人中心这种情款就可以不需要再次创建实例,可以解决重复创建栈顶实例
3. singleTask : 栈内模式,即开启Activity时先检查当前回退栈内是否它的实例,如果有则清退该实例上面所有其他实例,同样调用`onNewIntent(Intent)`方法,如果不是则新建实例然后入栈,这种模式适合主页面
4. singleInstance : 这个模式是比较复杂的,被标记的Activity启动后会创建一个新的回退栈来管理该Activity,注意在新的sdk中需要接口`Intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)`,使用场景: 如果页面需要和其他应用共享那么这种模式就非常有用了 (`singleTask`模式如果设置了`taskAffinity`可以实现)

如果A和C是普通模式,B是singleInstance:
开启顺序:a->b->c,那么返回显示则是,c->a->b(a和c在同一个栈,c在栈顶,b在独立的栈)

结束当前进程:
`android.os.Process.killProcess(android.os.Process.myPid())`

取消系统ui组件转大写:给对应UI组件声明
`android:textAllCaps="false"`

布局说明:
LinearLayout: 线性布局,使用`android:orientation="horizontal|vertical"`,子组件中使用`android:gravity="top|left|center|bottom|right"`定位,可以使用`android:layout_weight="2"`进行权重设置,同时要设置该方向上的宽度或者高度为0dp

```java
    <LinearLayout 
        android:layout_width="match_parent"
        android:layout_height="200dp">
        <TextView
            android:layout_width="0dp"
            android:layout_height="30dp"
            android:layout_weight="2"
        />
        <TextView
            android:layout_width="0dp"
            android:layout_height="30dp"
            android:layout_weight="8"
        />
    </LinearLayout>
```


RelativeLayout : 相对布局

主要参数有: 子组件的使用参数有 
`android:layout_alignParent...="true"`系列,就是相对于父组件RelativeLayout的位置,以父组件为参考
`android:layout_align[left|top|right|bottom|end|start|center]="@id/**"` 指子组件的与其他组件的对应`left|top|right|bottom`对齐,
```java
    android:layout_toStartOf="@+id/"  // 以其他组件的相对应的位置对齐
    android:layout_toLeftOf="@+id/"
    android:layout_toRightOf="@+id/"
    android:layout_toEndOf="@+id/"
````

FrameLayout: 帧布局,布局中越是靠后的后面的文件层级越高


`android:gravity="center"`和`android:layout_gravity="center"`的区别
前者 是控制当前组件内部布局方式,后者是当前组件相对于父组件的位置

引入布局:`include` 当然也可以在尖括号内声明一些属性

```java

<include layout="@layout/***">

```

一个简单的listView的适配器

```kotlin
    
    listView?.adapter = Adapter(this, R.layout.list_item_layout,list)
    listView.setOnItemClickListener { _, _, i, _ ->
        Toast.makeText(this, list[i], Toast.LENGTH_SHORT).show()
    }

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

Fragment 的声明周期:


创建使用Fragment的两种方式: 
1. 在布局文件中静态引入Fragment
```java
    // 在Activity布局文件中直接声明
    <fragment
        android:id="@+id/left_fragment"
        android:name="com.test.LeftFragment"
        .../>
    // 使用
    val fragment = supportFragmentManager.findFragmentById(R.id.fragment) as LeftFragment
```
2. 动态加入
```kotlin
    var transaction = supportFragmentManager.beginTransaction()
    var fragment = SettingsFragment()
    // add 有两个参数容器id,和Fragment实例
    transaction.add(R.layout.container,fragment,"settings")
    // 替换指定实例
    var f = MineFragment()
    transaction.replace(R.layout.container,f,"mine")
    // 移除指定Fragment实例
    transaction.remove(f)
    // 显示指定Fragment
    transaction.show(fra)
    // 隐藏指定fragment
    transaction.hide(fra)
    // 把frament加入回退栈,这样返回的时候就不会直接退出
    transaction.addToBackStack(null)
    // 所有操作完成后都要调用commit()方法
    transaction.commit()

```

资源限定符,用于资源适配
screen:small,normal,large,xlarge
dpi:ldpi,mdpi,hdpi,xhdpi,xxhpi
oritation:land,port
smallest-width: sw-600,sw-800..(自定义)


BroadcastReceiver 广播有两种:
正常广播: 异步发送,理论上所有的接收器同时接收到,效率高,不能拦截 
```java
    sendBroadcast()
```
有序广播/粘性广播:同步执行,同一时刻只有一个接收器能够接受,处理完成后再传给下一接收器,在这个过程可以拦截处理
```java
    sendOrderedBroadcast()
    onReceiver(){
        abortBroadcast() // 拦截不再继续向下传递
    }
```
注意,有序广播的接受顺序受属性`Android:priority="10"`的影响

静态注册和动态注册:
静态注册需要在AndroidManifest.xml中声明,伴随app的整个声明周期
动态注册直接在代码中注册,灵活性高
```java
    registerReceiver()
    unregisterReceiver()
```