### 学习不刻苦,将来买红薯

VS.code 插件安装：
1. Chinese (Simplified) Language Pack for Visual Studio Code 汉化包
2. HTML Snippets html标签高亮及支持
3. Vetur Vue语法及标签高亮支持
4. Prettier - Code formatter 代码格式化


设置终端：使用`bash.ext`替换默认`cmd`
`terminal.integrated.shell.windows ：'../../bin/bash.exe'`

Code review : 代码审查,目的:改善和保证代码质量.还有更能促进团队沟通及学习

App开发类型:

Native App: 原生开发
    > 跨平台方案: 
    1. React Native: 通过js调用native
    2. Wexx : 使用v8(js引擎)调用c++,然后在调用java到原生组件
    3. Flutter : Google UI组件
Hybrid App: 混合开发,Cordova,Ionic...
Web App: web页面.可以原生的webkit内核,可以使用腾讯x5内核 ,也可以使用xwalk

vuex: Vuex 是一个专为 Vue.js 应用程序开发的状态管理模式。它采用集中式存储管理应用的所有组件的状态
核心概念: state,getter,mutation,action,mudole

vue.js : 渐进式框架
![vue](https://cn.vuejs.org/images/lifecycle.png)
生命周期: `beforeCreate()` -> `created()` -> `beforerMount()` -> `mounted()` -> `beforeUpdated()` -> `update()` -> `beforeDestroy()` -> `destoryed()`

二进制：
向左移动一位：`<<` 相当于*2,向又移动一位：`>>>` 相当于/2

```java
    void binary(){
        64 << 2    // 等同于 64*4
        64 >>> 3   // 等同于64/8
    }
```

FastJson: 相关
JSONObject 的实现是Map(HashMap/LinkedMap); JSONArray 的实现是List(ArrayList);