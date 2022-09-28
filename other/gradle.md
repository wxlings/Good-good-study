**插件的引入：**AGP7.0变化较大前后字段不一致，以此为节点

7.0之前：

```gr

apply plugin: 'com.android.application'
apply plugin: 'com.android.library'
apply plugin: 'kotlin-android'
apply from: '../custom.gradle'

// `apply plugin:` 引用系统插件  `apply from:` 引用本地自定义的插件

```

7.0之后：

```groo

plugins{
	id 'com.adroid.application'
	id 'com.android.library'
    id 'kotlin-android'
}
apply from: '../custom.gradle'

// 注意：系统插件的引用统一使用`plugin{ id *}`block的方式，本地插件引用方式保持不变

```

本地插件的定义：

```groo

void log(){
	print '\n'
}

```

