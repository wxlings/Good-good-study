Vue (读音 /vjuː/，类似于 view) 是一套用于构建用户界面的渐进式框架。与其它大型框架不同的是，Vue 被设计为可以自底向上逐层应用。Vue 的核心库只关注视图层，不仅易于上手，还便于与第三方库或既有项目整合。

#### [安装](https://cn.vuejs.org/v2/guide/installation.html)：

创建一个 .html 文件，然后通过如下方式引入 Vue：

```html
    <!-- 开发环境版本，包含了有帮助的命令行警告 -->
    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>

    <!-- 生产环境版本，优化了尺寸和速度 -->
    <script src="https://cdn.jsdelivr.net/npm/vue"></script>

```

#### 声明式绑定

```js
    let context = new Vue({
        el:'#id',
        data:{
            id:344600,...
        }
    })
```
 #### 指令

 ###### 条件 v-if

 `v-if`可以指定变量也可以是表达式

```html
    <p id='app' v-if="show">Hello,world<p>
    <p v-if="language == 'js'">JS<p>
    <script>
        new vue({
            el:'#app',
            data:{
                language:'js'
            }
        })
    </script>
```

 ###### 条件 v-for

 `v-for` 遍历列表，需要使用`:key`

```html
    <p v-for="(item,index) in list" :key="index">{{item}}<p>
    <script>
        new vue({
            el:'#app',
            data:{
                list:['java','php','js']
            }
        })
    </script>
```

 ###### 事件 v-on / @

 `v-on`绑定事件，建议使用`@`
 1. 可以直接传递参数给函数
 2. 调用的函数如果直接取代函数

 事件修饰符： 在事件处理程序中调用 event.preventDefault() 或 event.stopPropagation() 是非常常见的需求
 `.stop` 阻止事件继续传播
 `.once` 事件只会被执行一次
 `.prevent` 提交事件不在重载页面

 还可以监听键盘

```html
    <p @click.stop ="click">点我<p>
    <p @click ="click('随便说了点什么')">点我<p>
    <p @click.once ="click('这句话我只说一次')">再点我<p>
    <p @click ="list=[]">再点我<p>
    <script>
        new vue({
            el:'#app',
            data:{
                list:['java','php','js']
            },
            methods:{
                click(msg='hello,world'){
                    console.log(msg)
                }
            }
        })
    </script>
```