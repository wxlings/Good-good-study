在android 8.0之前app内所有多有发送通知事件系统会同一逻辑处理,有些app的业务非常遭人唾弃,用户只有全部接受或者全部屏蔽,在8.0之后提出了渠道的概念,在业务上可以设置不同类型的通知为多个渠道...用户可以自主选择接受哪些屏蔽哪些

##### NotificationChannyel

每个app可以创建多个不同重要级别的渠道
`val channal = NotificationChannel("channelId","channelName","improtance")`
channelId: 作为该channel的标识,用于给当前channel发送通知使用,
channelName: 用于向用户展示channel的类目名称
improtance: 用于声明该渠道的重要性 
(`IMPORTANCE_MAX | NotificationManager.IMPORTANCE_HIGH | IMPORTANCE_DEFAULT | IMPORTANCE_LOW | IMPORTANCE_MIN | IMPORTANCE_NONE`属性级别由高到低5-0)

```kotlin
    val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    // 这里需要做版本检查,低于8.0的不支持设置NotificationChanproductnel
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
        val channel =  NotificationChannel("product","商品",NotificationManager.IMPORTANCE_HIGH)
        manager.createNotificationChannel(channel)
    }
```
这样一个Channel就建了完成了 

##### NotificationCompat

创建通知需要使用NotificationCompat类来进行兼容,它使用建造者模式,使用Builder来构建各个版本的Notification实例,Builder粗要一渠道id参数,指定当前通知发送给哪个渠道

```kotlin
    val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
        val channel =  NotificationChannel("channelId","channelName","improtance")
        manager.createNotificationChannel(channel)
    }
    val notification = NotificationCompat.Builder(context,"order")
        .setContentText("title")
        .setContentText("content")
        .setSmallIcon(R.drawable.ic_launcher_background)
        .build()
    // 注意这里notify(id,...) 需要指定一个唯一id,多channel不能重复
    manager.notify(10,notification)
```

##### PendingIntent

当系统下拉菜单显示通知后通常我们点击后会有一个意图,可以打开一个页面,也可以做一些其他的行为
设置意图的思想: 创建一个PenddingIntent对象,把行为设置给他,然后把这个对象通过`setContentIntent()`方法传个notification即可

PenddingIntent: 使用该类的静态方法来启动目标并发送数据

```kotlin
    PendingIntent.getActivity(context,requestCode,intent,flag)
    PendingIntent.getActivities(context,requestCode,ArrayList<Intent>,flag)
    PendingIntent.getBroadcast(context,requestCode,intent,flag)
    PendingIntent.getService(context,requestCode,intent,flag)
```

```kotlin
    val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
        val channel =  NotificationChannel("channelId","channelName","improtance")
        manager.createNotificationChannel(channel)
    }
    val intet = Intent(context,MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(this,100,intent,PendingIntent.FLAG_UPDATE_CURRENT)
    val notification = NotificationCompat.Builder(this,"dev")
        .setContentText("title")
        .setContentText("content")
        .setSmallIcon(R.drawable.ic_launcher_background)
        .build()
    
    manager.notify(10,notification)
```

##### 点击后取消

通常我们点击通知后当前通知会取消这就需要通过api进行设置了 

```kotlin
    // 方法一: 通过Notification构建器进行设置
     val notification = NotificationCompat.Builder(this,"dev")
        .setContentText("title")
        .setContentText("content")
        .setSmallIcon(R.drawable.ic_launcher_background)
        .setAutoCancel(true)
        .build()

    // 方法二: 通过NotificationManager 进行取消,这个需要传入参数,即调用`notify(10,notification)`的参数id
    notificationManager.cancel(10)
```

##### 进阶

通常我们看到的都是正常模式下的Notification,其实还可以通过构建器进行内容的样式设置`setStyle()`...当然兼容性问题没有测试(更过内容查看API)