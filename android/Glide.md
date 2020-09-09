Glide 图片加载库;

基本用法:

```java
    Glide.with(this).load("url").into(ImageView);

    @NonNull
    public RequestManager get(@NonNull Context context) {
        if (context == null) {
        throw new IllegalArgumentException("You cannot start a load on a null Context");
        } else if (Util.isOnMainThread() && !(context instanceof Application)) {
        if (context instanceof FragmentActivity) {
            return get((FragmentActivity) context);
        } else if (context instanceof Activity) {
            return get((Activity) context);
        } else if (context instanceof ContextWrapper) {
            return get(((ContextWrapper) context).getBaseContext());
        }
        }

        return getApplicationManager(context);
    }

     /**
    * Equivalent to calling {@link #asDrawable()} and then {@link RequestBuilder#load(String)}.
    *
    * @return A new request builder for loading a {@link Drawable} using the given model.
    */
    @NonNull
    @CheckResult
    @Override
    public RequestBuilder<Drawable> load(@Nullable String string) {
        return asDrawable().load(string);
    }

    //对于Bitmap和Drawable不进行缓存
    public RequestBuilder<TranscodeType> load(@Nullable Bitmap bitmap) {
      return loadGeneric(bitmap)
        .apply(diskCacheStrategyOf(DiskCacheStrategy.NONE));
    }
    private RequestBuilder<TranscodeType> loadGeneric(@Nullable Object model) {
    this.model = model;
    isModelSet = true;
    return this;
    }

    public RequestBuilder<Drawable> asDrawable() {
        return as(Drawable.class);
    }

    public <ResourceType> RequestBuilder<ResourceType> as(
        @NonNull Class<ResourceType> resourceClass) {
    return new RequestBuilder<>(glide, this, resourceClass, context);
}
```

源码分析: 

`Glide.with('context|view')`获取一个RequestManager
这里的区别主要是将glide和不同的上下文的声明周期绑定，如果是Application或者不在主线程调用，那requetmanager的生命周期和Application相关，否则则会和当前页面的fragmentManager的声明周期相关。因为Activity下fragmentManager的生命周期和Activity相同。所以不管是Activity还是fragment，最后都会委托给fragmentManager做生命周期的管理。

在getSupportRequestManagerFragment方法中可以看到如果activity下的fragmentmanager没有找到tag为FRAGMENT_TAG的fragment，就会创建一个隐藏的fragment，然后添加到fragmentmanager内。

总结来说with方法的作用就是获得当前上下文，构造出和上下文生命周期绑定的requestmanager，自动管理glide的加载开始和停止。

`load('url')` 获取一个RequestBuilder
load方法也是一组重载方法，定义在interface ModelTypes<T>接口里，这是一个泛型接口，规定了load想要返回的数据类型，RequestManager类实现了该接口，泛型为Drawable类。
总结一下load作用，构造一个RequestBuilder实例，同时传入需要加载的数据源类型。

`into(view)` 

```java
// 这个Manager实现了LifecycleListener
public class RequestManager implements LifecycleListener{

}

```