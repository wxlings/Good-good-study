关于 APK Size 的优化有两个部分: 安装包监控和安装包体积优化;

#### 安装包监控

使用AndroidStudio提供的Analyser工具,通过它可以查看一个 APK 文件内部各项内容所占的大小，并且按照大小排序显示。因此我们很容易观察到 APK 中哪一部分内容占用了最大空间。APK Analyzer 的使用非常简单，只要将需要分析的 APK 文件拖入 Android Studio 中即可

> 实际上 APK Analyzer 的作用不光是查看 APK 大小，从它的名字也能看出它是用来分析 APK 的，因此可以使用它来分析一些优秀 APK 的目录结构、代码规范，甚至是使用了哪些动态库技术等。


#### 安装包优化实践

主要思路就是删减无用资源或者代码，并对资源文件进行相应的压缩优化。

1. 使用Lint进行文件检查,删除无用的文件: 使用 Lint 查看未引用资源。Lint 是一个静态扫描工具，它可以识别出项目中没有被任何代码所引用到的资源文件。
    
    * Analyze -> Inspect Code，然后选中整个项目即可 ,执行完成后`在Inspection Results中点击: Android - performance - Unused Resource`进行对为引用资源列表查看
    * Analyze -> Run Inspecttion By Name -> 弹框内输入 `Unuse Resource` -> 回车即可

2.  在编译阶段进行无用文件过滤: 使用` shrinkResources `在项目编译时期减少被打包到 APK 中的文件,使用 shrinkResources 能够在项目编译阶段，删除所有在项目中未被使用到的资源文件。但是需要将 minifyEnabled 选项设置为 true。如下示例代码

3. 停止使用语言国际化选项: 指定`resConfig = "zh"`参数, 减少其他支持库中的资源文件

```gradle

    android {
        compileSdkVersion 28
        buildToolsVersion '28.0.3'

        defaultConfig {
            ...
            resConfig "zh"      // 禁止使用语言国际化
        }

        buildTypes {
            release {
                minifyEnabled true          // 开启压缩
                shrinkResources true
                proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            }
        }
    }

```

4. 文件优化:

    * 静态图片文件 : 优先使用`VectorDrawable`资源或者`WebP`资源,如果都没有,我们可以通过Android Studio把png/jpg转换到webP格式(__强烈建议__)

5. 关于引入第三方库:

    对于第三方支持库组要谨慎,尤其是涉及音视频类的,需要考虑是否需要全部引入


关于Bundle : 当应用发布在Google应用市场就可以使用APP bundle,这是一种分包机制;可以减轻每个版本app 的 包体积;

#### 实际上，在开发过程中，良好的编程习惯和严格的 code review 也是非常重要的。

