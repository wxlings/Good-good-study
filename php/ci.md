CI是基于MVC模式的php框架:
`M`即`model`主要与数据的读写相关,所有的`model`子类都要继承`CodeIgniter\Model`,文件需要卸载`App\Models\`目录下
`V`即`view`主要与界面内容显示相关,所有文件都要写在`App\Views\`目录下
`C`即`Controller`核心控制器,无论是接口查数据还是显示页面都需要控制器进行处理,所有的`controller`都要继承`CodeIgniter\Controller`或者`App\BaseController`,文件都要卸载`App\Controller`目录下


在`Base_Controller`的构造器中获取了`$this->params = array_merge($request->getPost(),$request->getGet());`所有的接口传参数都在`$this->params`数组中;

首页: 通过`Welcome.php/__construct()` -> `site_model.php/getAdminschame()` 获取 `adminscame.php`中的配置设置到`_data`中,然后在把该值赋值给`Welcome.php/index()`,return `Views/welcome/index.php`进行页面渲染view;

整个后台用到的样式都是`MetronicApp`


>>  在写页面的时如果php和html混合时.php代码块一定要有`end`结束符
```php
  <?php if (condition): ?>
  <li>hello</li>
  <?php endif; ?>

  <?=view('welcome/helo')?> // 插入指定的view


#### 数据库

- 数据库配置,

> 配置文件:`App/Config/Database.php`
> 在对应模块设置数据库的hostname,username,password,database,dbdriver等参数的值

```php
    // App/config/Database.php
    $default = [
        'hostname'='localhost',
        'username'='root',
        'password'='root',
        'database'='orders'
    ]
```

- 初始化数据库

> 对与数据库的连接通常是持久的,建议使用单例的方式

```php
    $db = \Config\Database::connect(); // 连接
    // 扩展
    $db = \Config\Database::connect('db_name',name); // 如果有多个数据库可以指定数据库名称
    $db = dbSelect('db_name');
    $db->reconnect(); // 重连
    $db->close() // 关闭连接
```

- 数据查询

> 对于数据的查询有两种方式,使用`$this->db->query()`更适合联查,而`model`更适合单个表查询

1. 直接使用`$db` 或者`$this->db`句柄引用进行`query()`查询完整sql语句;

  > 当语句为‘插入’数据时结果为'TRUE' OR 'FALSE',当语句为‘读取’数据时结果为读取的内容；

  ```php
    $query = $this->db->query('command');
    # 适用于获取多条数据：标准，返回格式：对象数组（关联数组）常用
    $result = $query->getResult();
    foreach ( $result as $row){
        echo $row->name,$row->age,$row->gender;
    }
    echo $result[0]->name,$result[1]->age;

    # 适用于获取多条数据：标准，返回格式：数组数组（二维数组）
    $result_arr = $query->getResultArray();
    foreach ( $result_arr as $row){
        echo $row['name'],$row['age'],$row['gender'];
    }
    echo $result[0]['name'],$result[1]['age'];

    # 适用于单条数据：对象形式,可以指定第n条数据.如果没有指定index默认为0即第一条数据
    $result = $query->getRow([index]);
    echo $result->name,$result->age,$result->gender;

    # 适用于单条数据：数组形式，可以指定第n条数据.如果没有指定index默认为0即第一条数据
    $result = $query->getRowArray([index]);
    echo $result['name'],$result['age'];
  
  ```

  > Bind query:

    Bindings enable you to simplify your query syntax by letting the system put the queries together for you

  ```php
    $sql = 'SELECT * FROM t_table  WHERE id IN ?  AND status = ? AND author = ?';
    $result = $db->query($sql,[[12,100],1,'wxling']);
  ```

  > SimpleQuery:
    The simpleQuery method is a simplified version of the $db->query() method. It DOES NOT return a database result set;
    That typically is TRUE/FALSE on success or failure for write type queries such as INSERT, DELETE or UPDATE statements (which is what it really should be used for) and a resource/object on success for queries with fetchable results.

  ```php
    if ($db->simpleQuery('YOUR QUERY')){
        echo "Success!";
    }else{
        echo "Query failed!";
    }
  ```

  > Named Binding:
    Instead of using the question mark to mark the location of the bound values, you can name the bindings, allowing the keys of the values passed in to match placeholders in the query:

  ```php
    $sql = 'SELECT * FROM t_name WHERE id = :id AND status = :status AND author = :author';
    $result = $db->query($sql,('id'=>12,'status'=>1,'author'=>'wxling'));
  ```

2. 继承`CodeIgniter\Model`,使用CI提供的方法进行查询

> 在`CodeIgniter\Model`中提供对数据库的增删改查的方法,

```php
    // 全局变量:
    $table = 'user'; // 声明表的名字
    $allowedFields = ['name','age','gender']; // 声明允许insert/update的字段名
    $primaryKey = 'id'; // 声明主键id
    $returnType = 'array' // 声明返回类型
    $useTimestamps = true // set created_at, and updated_at values during insert and update routines.

    $this->asArray()->findAll(); // 返回表的所有数据没有过滤
    $this->find($id); // 返回表中的指定主键id的数据
    $this->findColum('name'); // 返回表中所有的name字段的值
    $this->where([ 'name' => 'Jeck','age' > 20])->first();  // 指定条件,后返回第一条数据
    $this->save($data); // 根据设定的数据进行选择性的insert/updata 如果数据中有pirmaryKey则updata,否则insert
    $this->insert($data); // insert
    $this->update($primaryId,$data); // update
    $this->delete($primaryId); // delete
    ... // 详情看源码
```
