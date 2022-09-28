条件：须对`HTML` 和 `JavaScript`都比较熟悉 . [复习](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/A_re-introduction_to_JavaScript)

### 描述

 React 是一个声明式，高效且灵活的用于构建用户界面的 JavaScript 库。  使用 React 可以将一些简短、独立的代码片段组合成复杂的` UI` 界面，这些代码片段被称作“组件”。 

 React 是一个工具库，帮你以组件的方式拆解并组织` UI `代码。 

 React 不负责路由（routing）或数据管理。对于这些功能，你需要使用第三方工具库或实现你自己的解决方案。 

### 环境及安装

1. 使用[命令行模式](https://create-react-app.dev/docs/getting-started)创建并启动单页面应用

   ```rea
   
   npx create-react-app my-react-app  // npx comes with npm 5.2+ and higher
   // 或者 npm init react-app my-react-app
   // 或者 yarn create react-app my-react-app
   
   cd my-react
   
   npm start
   // 或者 yarn start
   
   ```

   > 使用命令行方式需要安装[`Node.js`](http://nodejs.cn/learn)
   >
   >  `Node.js` 是一个基于 `Chrome V8` 引擎的 JavaScript 运行时。 
   >
   >  `Node.js`应用程序在单个进程中运行，无需为每个请求创建新的线程。 `Node.js` 在其标准库中提供了一组异步的 I/O 原语，以防止 JavaScript 代码阻塞，通常，`Node.js `中的库是使用非阻塞范式编写的，使得阻塞行为成为异常而不是常态。 
   >
   > [`npm`](https://www.npmjs.cn/getting-started/what-is-npm/) (Node Package Manager) 是随同`Node.js`一起安装的包管理工具 

   

2. [在已有项目中添加`React`](https://reactjs.bootcss.com/learn/add-react-to-a-website)

   > 1. 在页面添加对应的HTML元素
   > 2. 添加对应的`script`标签 
   > 3. 创建`React`组件并开始使用

   

3. 使用其他框架`Next.js`,`Vite`,`Parcel`等[框架及工具链](https://reactjs.bootcss.com/learn/start-a-new-react-project#building-with-react-and-a-framework)



### 基础：

看一下在react中的`Hello,word`:

```reac

<div id="root"/>

const element = <div>Hello,world!</div>;
ReactDom.render(element,document.getElementById('root'));

```

把element渲染到指定的`id`的`H5元素`上；这样在页面就可以看到`Hello,world！`字样了...

> 命令结束时需要使用`;`进行标记结束



####  `JSX`简述

```react

const element = <h1>Hello, world!</h1>;
element = <img src={user.avatarUrl}/>
    
```

- 它被称为 `JSX`，是一个 JavaScript 的语法扩展。
- `JSX`可以生成 React “元素”。

- 建议在 React 中配合使用 `JSX`，它可以很好地描述 `UI` 应该呈现出它应有交互的本质形式。

- 在编译之后，`JSX` 表达式会被转为普通 JavaScript 函数调用，并且对其取值后得到 JavaScript 对象。 

- `JSX`声明的子元素支持使用闭合标签。

- 在 `JSX` 语法中, 引用变量时使用大括号`{}`对变量进行包裹就可以了，当然也可以放置任何有效的 [JavaScript 表达式](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Expressions_and_Operators#Expressions) 。注意：这里不是`${}`写法；

- `JSX`里的 `class` 变成了 [`className`](https://developer.mozilla.org/en-US/docs/Web/API/Element/className)，而 `tabindex` 则变为 [`tabIndex`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/tabIndex)。 

- `JSX`最终会被转译]成`React.creatElement()`的函数对象，这些对象称为[React元素](https://react.docschina.org/docs/introducing-jsx.html#jsx-represents-objects)。

  

**变量引用：**

```rea

const str = "Hello,world !!!";

function getName(name){
	return "你好，{name}";
}

const element = <h1>{getName("Json")},请阅读：{str} </h1;
ReactDom.render(element,document.getElementById('root'));

```

 

#### 元素渲染

元素是构成React的最小砖块。

 与浏览器的 DOM 元素不同，React 元素是创建开销极小的普通对象。React DOM 会负责更新 DOM 与 React 元素保持一致。 

想要将一个 React 元素渲染到根 DOM 节点中，只需把它们一起传入 [`ReactDOM.render()`](https://react.docschina.org/docs/react-dom.html#render)： 



```rea

const element = <h1>Hello,world</h1>;
const domNode = document.getElementById("dom_id");
ReactDom.render(element,domNode);

```



React 元素是不可变对象。一旦被创建，你就无法更改它的子元素或者属性。 

 一个元素就像电影的单帧：它代表了某个特定时刻的 `UI`。 

更新 `UI` 唯一的方式是创建一个全新的元素，并将其传入 [`ReactDOM.render()`](https://react.docschina.org/docs/react-dom.html#render)。 

*举个栗子： 创建一个时间展示器*

```rea

function tick(){
	let date = new Date();
	const str = <div>
		当前时间：{date.getHours()}时{date.getMinutes()}分{date.getSeconds()}秒
	</div>;
	ReactDom.render(time,document.getElementById("root"))
}

setInterval(tick,1000); // 开启定时器

```

> 逻辑：创建一个定时器，周期性调用`ReactDom.render()`来渲染函数最新逻辑后的`React元素`;



React DOM 会将元素和它的子元素与它们之前的状态进行比较，并只会进行必要的更新来使 DOM 达到预期的状态。 



####  组件& props

 组件，从概念上类似于 JavaScript 函数。它接受任意的入参（即 “props”），并返回用于描述页面展示内容的 React 元素。 

定义组件的两种方式：`函数组件` & `class组件`

- 函数组件： 它本质上就是 JavaScript 函数。

  ```rea
  
  function Avatar(url){
  	return <img width={100} height={100} src={url}/>;
  }
  
  ```

  

- `class`组件：

  ```react
  
  class Avatar extends React.Component{
    render(){
      return <img width={100} height={100} src={this.props.url}/>;
    };
  }
  
  ```

  调用：

  ```rea
  
  const element = <Avatar url="https://picb9.photophoto.cn/39/863/39863719_1.jpg"/>
  ReactDom.render(element,document.getElementById("root"));
  
  ```

   当 React 元素为用户自定义组件时，它会将 `JSX`所接收的属性（attributes）以及子组件（children）转换为单个对象传递给组件，这个对象被称之为 “props”。 



**组件组合：**

自定义组件可以向HTML标签一样可以组合使用：

注意`className`的使用，class的命名方式使用中线进行拼接

```rea

class MultiAvatar extends React.Component{
  render(){
    return <div>
      <Avatar className="user-image-link" url={this.props.url}/>
      <Avatar className="user-photo" url={this.props.photo}/>
    </div>;
  };
}

```

**`props`只读**

 组件无论是使用[函数声明还是通过 class 声明](https://react.docschina.org/docs/components-and-props.html#function-and-class-components)，都决不能修改自身的 props。 

 **React 组件都必须像纯函数一样保护它们的 props 不被更改** 



### State