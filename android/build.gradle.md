在Android项目中构架脚本有两个:
项目的构建脚本`build.gradle`(位于项目的根目录下)和module的构建脚本`build.gradle`(位于每一个module的根目录下)

---

#### 项目脚本:

基本结构说明:

```gradle

apply from : 'config.gradle'  # 引入其他gradle文件

buildscript {
    
    // 指定使用kotlin的版本,如果是纯java项目不需要声明
    ext {
        kotlin_version = '1.3.72'
    }

    // 指定项目依赖的远程仓库,构建时会涉及一些支持库,google()和jcenter()是默认,也是必备
    repositories {          
        google()    
        jcenter()
    }

    // 项目基础依赖
    dependencies {
        // 构建Android应用时需要gradle插件,这里进行依赖,没有gradle插件是不能使用gradle进行构建应用,这个依赖是默认也是必备
        classpath "com.android.tools.build:gradle:4.0.1"   
        // 指定使用kotlin的版本,如果是纯java项目不需要声明.变量引用即上方声明的kotlin_version
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"  
    }
}

allprojects {
    repositories {
        google()
        jcenter()
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}

// 创建项目全局变量,当然这里的数据也可以放在上面引入的文件里面,也可以放在`gradle.properties`中,见下方说明
ext{
    compileSdkVersion: 28,
    buildToolsVersion: "28.0.3"
    adroid = [
        is_app:false,
        id:123456,
        token:"hello,world"
        ...
    ]
    dependencies = [
            publicImplamentation: [
                    'androidx.appcompat:appcompat:1.2.0',
                    'androidx.constraintlayout:constraintlayout:2.0.0'
            ],
            testImplamentation  : [
                    'androidx.test.ext:junit:1.1.1',
                    'androidx.test.espresso:espresso-core:3.2.0'
            ],
            basicLibrary        : [
                    ':common',
                    ':basic',
                    ':router',
                    ':annotation'
            ]
            ...
    ]
}

```

在module中引用使用:

```gradle
    
    compileSdkVersion rootProject.ext.compileSdkVersion
    buildToolsVersion rootProject.ext.buildtoolsVersion

     if( rootProject.ext.android.is_app ){
        // todo 条件成立的逻辑
    }
    ...

    dependencies {
        implementation fileTree(dir: "libs", include: ["*.jar"])

        testImplementation 'junit:junit:4.12'

        // each是数组遍历,it则是每一个item
        rootProject.ext.dependencies.publicImplamentation.each {
            implementation it
        }
        
        rootProject.ext.dependencies.testImplamentation.each {
            androidTestImplementation it
        }
        ...
    }
```

###### 在项目目录下的`gradle.properties`中声明项目全局变量
```gradle
org.gradle.jvmargs=-Xmx2048m

mini_sdk_version=16
is_app=true

```

在module下的`build.gradle`中使用:
> notes : 读取的变脸值全部为字符串,注意数据转型

```gradle

    miniSdkVersion MINI_SDK_VERSION.toInteger()     // 需要转型
    if(is_app as boolean){
        // todo 条件成立的逻辑
    }

```

--- 

#### Module 脚本:
