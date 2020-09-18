Js与原生端的交互:

原生调用Js:
1. ` Webview.load("javascript:jsMethod()");`  会有重定向的可能; 
2. `webView.evaluateJavascript("name",null);` 安卓4.4以后可以实现安卓调用js，安卓可以传数据给js，并且可以获取js方法的返回值。

JS调用原生:
1. 在原生端给webview实例添加一个回调对象供Js调用,`zWebView.addJavascriptInterface(Object,"name");`
2. 在js直接发起请求,在原生端进行拦截`shouldOverrideUrlLoading()`：通过这个方法拦截url，并解析url携带的参数;