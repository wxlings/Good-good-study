常用的数据格式有`xml`和 `json`两种: 
`xml` 多用于用于本地文件数据存储,例如SharePreferens...
`json` 多用于网络数据传输

##### 对于Xml 文件的解析有很多种方式:

`PULL`解析:  

```java
    val xmlPullParser = XmlPullParserFactory.newInstance().newPullParser()
    xmlPullParser.setInput(StringReader("xml-string"))
    val eventType = xmlPullParser.eventType
    while (eventType != XmlPullParser.END_DOCUMENT){
        ...
    }

```

`SAX`解析:

Sax 解析需要继承`DefaultHandler`去实现一些回调进行解析


##### 对于Json 格式的数据解析也有很多种:

`JSONObject` 解析; 该方式的Api已经集成到sdk,可以直接使用;

`gson` 解析:需要进行扩展依赖: `implementation 'com.google.code.gson:gson:2.*.*`