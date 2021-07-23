### 布局类组件

布局类组件都会包含一个或多个子组件，不同的布局类组件对子组件排版(layout)方式不同。  
Element树才是最终的绘制树，Element树是通过Widget树来创建的，Widget其实就是Element的配置数据。在Flutter中，根据Widget是否需要包含子节点将Widget分为了三类，分别对应三种Element:

| Widget | Element | 说明 |
| :--:|:--:|:--:|
| LeafRenderObjectWidget | LeafRenderObjectElement | Widget树的叶子节点，用于没有子节点的widget，通常基础组件都属于这一类，如Image。|
| SingleChildRenderObjectWidget | SingleChildRenderObjectElement | 包含一个子Widget，如：ConstrainedBox、DecoratedBox等 |
| MultiChildRenderObjectWidget | MultiChildRenderObjectElement | 包含多个子Widget，一般都有一个children参数，接受一个Widget数组。如Row、Column、Stack等|

> 与Android比较: `LeafRenderObjectWidget` 类似 `View`, `SingleChildRenderObjectWidget` 与 `MultiChildRenderObjectWidget` 类似 `ViewGroup` , 而 `SingleChildRenderObjectWidget`类似于 `ScrollView`.

> 注意，Flutter中的很多Widget是直接继承自StatelessWidget或StatefulWidget，然后在build()方法中构建真正的RenderObjectWidget，如Text，它其实是继承自StatelessWidget，然后在build()方法中通过RichText来构建其子树，而RichText才是继承自MultiChildRenderObjectWidget。所以为了方便叙述，我们也可以直接说Text属于MultiChildRenderObjectWidget（其它widget也可以这么描述），这才是本质。读到这里我们也会发现，其实StatelessWidget和StatefulWidget就是两个用于组合Widget的基类，它们本身并不关联最终的渲染对象（RenderObjectWidget）。

布局类组件就是指直接或间接继承(包含)MultiChildRenderObjectWidget的Widget，它们一般都会有一个children属性用于接收子Widget。

RenderObjectWidget类中定义了创建、更新RenderObject的方法，子类必须实现他们，关于RenderObject我们现在只需要知道它是最终布局、渲染UI界面的对象即可，也就是说，对于布局类组件来说，其布局算法都是通过对应的RenderObject对象来实现的


#### 线性布局（Row和Column）
所谓线性布局，即指沿水平或垂直方向排布子组件。Flutter中通过 `Row` 和 `Column` 来实现线性布局，类似于Android中的LinearLayout控件。  `Row`和`Column`都继承自`Flex`;

##### 主轴和纵轴
对于线性布局，有主轴和纵轴之分，如果布局是沿水平方向，那么主轴就是指水平方向，而纵轴即垂直方向；如果布局沿垂直方向，那么主轴就是指垂直方向，而纵轴就是水平方向。在线性布局中，有两个定义对齐方式的枚举类MainAxisAlignment和CrossAxisAlignment，分别代表主轴对齐和纵轴对齐。

> 对与FlexBox几近相同

###### [Row](https://book.flutterchina.club/chapter4/row_and_column.html#row)

Row的默认构造函数:

```dart
    class Row extends Flex{
        ....
    }

    Row({
        Key? key,
        MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
        MainAxisSize mainAxisSize = MainAxisSize.max,
        CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
        TextDirection? textDirection,
        VerticalDirection verticalDirection = VerticalDirection.down,
        TextBaseline? textBaseline, // NO DEFAULT: we don't know what the text's baseline should be
        List<Widget> children = const <Widget>[]
    })
```

##### [Column](https://book.flutterchina.club/chapter4/row_and_column.html#column)

Column的默认构造函数:

```dart 
    class Column extends Flex{
        ....
    }

    Column({
        Key? key,
        MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
        MainAxisSize mainAxisSize = MainAxisSize.max,
        CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
        TextDirection? textDirection,
        VerticalDirection verticalDirection = VerticalDirection.down,
        TextBaseline? textBaseline,
        List<Widget> children = const <Widget>[],
    })
```

对于`Row/Column`两个组件,通过构造函数可以看出: 主轴方向对齐方式默认为`MainAxisAlignment.start`, 空间占用默认为`MainAxisSize.max`(使用父组件的最大空间); 纵轴方向对其方式默认为 `CrossAxisAlignment.center`, 空间占用不可设置默认为`CrossAxisAlignment.min`.

> 注意: 对于全屏居中需求时,存在纵轴方向整体不能居中的问题, 这里是因为所有子组件在纵轴方向上不能完全充满全屏宽度导致;
> 解决: 可以使用对应的尺寸组件进行空间填充;

例如:  在`Column`中使用`Row`/`Center` 进行包裹,  或者使用`ConstrainedBox`/`SizeBox`等Widget来强制更改宽度;

```dart
    Column(
        children: [
            Text("Hello"),
            Row(
                children: [
                     Text("Hello,world !"),
                ]
            )
            Text("Hello"),
        ]
    )

```

#### 弹性布局   

弹性布局允许子组件按照一定比例来分配父容器空间。弹性布局的概念在其它UI系统中也都存在，如H5中的弹性盒子布局，Android中的FlexboxLayout等。Flutter中的弹性布局主要通过Flex和Expanded来配合实现。

###### [Flex](https://book.flutterchina.club/chapter4/flex.html#flex)

Flex组件可以沿着水平或垂直方向排列子组件, `Row`和`Column`都继承自Flex，参数基本相同，所以能使用Flex的地方基本上都可以使用Row或Column。Flex本身功能是很强大的，它主要和Expanded组件配合实现弹性布局。

Flex的构造函数:

```dart
     Flex({
        Key? key,
        required this.direction,
        this.mainAxisAlignment = MainAxisAlignment.start,
        this.mainAxisSize = MainAxisSize.max,
        this.crossAxisAlignment = CrossAxisAlignment.center,
        this.textDirection,
        this.verticalDirection = VerticalDirection.down,
        this.textBaseline, // NO DEFAULT: we don't know what the text's baseline should be
        this.clipBehavior = Clip.none,
        List<Widget> children = const <Widget>[],
    })
```

由构造函数可以看出, 与`Row` , `Column`的参数基本相同,   必填参数`direction`确定后就是对应的`Row`/`Column`组件了 .

###### [Expanded](https://book.flutterchina.club/chapter4/flex.html#expanded)(扩冲的/展开的)
可以按比例 "扩伸" `Row`、`Column`和`Flex`子组件所占用的空间。

> `Expended`组件仅用于`Row`、`Column`和`Flex`有效.

```dart
    const Expanded({
        int flex = 1, 
        @required Widget child,
    })

```

flex参数为弹性系数，如果为0或null，则child是没有弹性的，即不会被扩伸占用的空间。如果大于0，所有的Expanded按照其flex的比例来分割主轴的全部空闲空间。

`Spacer` 是 `Expended`的包装类, 功能是占用指定比例的空间


#### 流式布局
把超出屏幕显示范围会自动折行的布局称为流式布局。Flutter中通过Wrap和Flow来支持流式布局，

##### [Wrap](https://book.flutterchina.club/chapter4/wrap_and_flow.html#_4-4-1-wrap)

Wrap的构造函数:

```dart
    Wrap({
        ...
        this.direction = Axis.horizontal,
        this.alignment = WrapAlignment.start,
        this.spacing = 0.0,
        this.runAlignment = WrapAlignment.start,
        this.runSpacing = 0.0,
        this.crossAxisAlignment = WrapCrossAlignment.start,
        this.textDirection,
        this.verticalDirection = VerticalDirection.down,
        List<Widget> children = const <Widget>[],
    })
```

可以看到Wrap的很多属性在Row（包括Flex和Column）中也有，参数意义是相同的，可以认为Wrap和Flex（包括Row和Column）除了超出显示范围后Wrap会折行外，其它行为基本相同。
特殊的参数: `spacing`：主轴方向子widget的间距, `runSpacing`：纵轴方向的间距, `runAlignment`：纵轴方向的对齐方式

###### [Flow](https://book.flutterchina.club/chapter4/wrap_and_flow.html#_4-4-2-flow)

一般很少会使用Flow，因为其过于复杂，需要自己实现子widget的位置转换，在很多场景下首先要考虑的是Wrap是否满足需求。Flow主要用于一些需要自定义布局策略或性能要求较高(如动画中)的场景。这里不再记录.

#### 层叠布局
层叠布局和Web中的绝对定位、Android中的Frame布局是相似的，子组件可以根据距父容器四个角的位置来确定自身的位置。绝对定位允许子组件堆叠起来（按照代码中声明的顺序）。Flutter中使用Stack和Positioned这两个组件来配合实现绝对定位。Stack允许子组件堆叠，而Positioned用于根据Stack的四个角来确定子组件的位置。

###### [Stack](https://book.flutterchina.club/chapter4/stack.html#stack)

先来看Stack的构造函数:

```dart
 Stack({
    Key? key,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.fit = StackFit.loose,
    @Deprecated(
      'Use clipBehavior instead. See the migration guide in flutter.dev/go/clip-behavior. '
      'This feature was deprecated after v1.22.0-12.0.pre.'
    )
    this.overflow = Overflow.clip,
    this.clipBehavior = Clip.hardEdge,
    List<Widget> children = const <Widget>[],
  })

```