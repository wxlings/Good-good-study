### 创建/删除数据表

- 查看当前库中的数据表

  ```mysql
  SHOW TABLES [LIKE "t_name"];
  ```

- 创建数据表,命名为 `t_name`

  ```mysql
  CREATE TABLE [IF NOT EXISTS] t_name(
    -> column_name column_type[length] column_modifier1 column_modifer2 ...,
    -> column_name column_type[length] column_modifier1 column_modifer2 ...,
    -> modifer
    -> );
  ```

  例如:

  ```mysql
  CREATE TABLE [IF NOT EXISTS] t_name(
    -> uid INT(length) AUTO_INCREMENT COMMENT 'user`s unique id.',
    -> name VARCHAR(18) NOT NULL COMMENT 'user`s real name.',
    -> gender ENUM(0,1) DEFAULT 0 COMMENT 'user`s gender,and 0:male & 1:female.',
    -> age TINY UNSIGNED DEFAULT 18 COMMENT 'user`s age default 18.',
    -> salary FLOAT(8,2) DEFAULT 0.00 COMMENT 'user`s salary.',
    -> mobile CHAR(11) UNIQUE NOT NULL COMMENT 'user`s mobile phone.',;
    -> info TEXT COMMENT 'user`s info.',
    -> create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'create user time.',
    -> PRIMARY KEY(uid)
    -> );
  ```

  一些常用的修饰 keywords;
  `NULL | NOT NULL`, `PRIMARY`, `KEY`, `INDEX`, `UNIQUE`, `DEFAULT`, `AUTO_INCREMENT`, `UNSIGNED`, `COMMENT`

- 查看数据表结构

  ```mysql
  DESCRIBE / DESC t_name;
  SHOW COLUMNS FROM t_name;
  ```

- 查看创建表的语句;

  ```mysql
  SHOW CREATE TABLE t_name;
  ```

- 查看索引的结构

  ```mysql
  SHOW INDEX FROM t_name;
  ```

- 删除数据表

  ```mysql
  DROP TABLE t_name;
  ```

## <p>

### ALTER 修改表及表结构

- ADD 增加字段,即增加"列"

  ```mysql
  ALTER TABLE t_name
    -> ADD
    -> column_name column_type[length] column_midifier ...
    -> AFTER | FIRST exist_column
  ```

  > column_type 必须赋值
  > 可以使用`AFTER`和`FIRST`进行控制添加列的位置,注意该修饰只能在整个语句的最尾端

- DROP 删除字段,即删除"列"

  ```mysql
  ALTER TABLE t_name
    -> DROP [COLUMN]
  -> exist_column1,exist_column2,...;
  ```

  > COLUMN 关键字可以省略不写,为默认值

* MODIFY 修改列的属性

  ```mysql
  ALTER TABLE t_name
    -> MODIFY
    -> exist_column new_col_type[length] new_col_midifier ...;
  ```

  > 使用 ALTER MODIFY 后,该字段的所有的属性都会被重置,需要重新指定;同时必须指定该字段的类型;

* CHANGE 修改列名称或修改列的属性

  ```mysql
  ALTER TABLE t_name
    -> CHANGE
    -> exist_column new_col_name new_col_type new_col_midifier ...;
  ```

  > 使用 ALTER CHANGE 后,该字段的所有的属性都会被重置,需要重新指定;同时必须指定该字段的类型;
  > 与 MODIFY 区分,MODIFY 只可以修改列的属性,不能修改列名称,而 CHANGE 都可以

- DROP 移除表中指定字段

  ```mysql
  ALTER TABLE t_name DROP column_name;
  ```

- RENAME 重命名表的名字

  ```mysql
  ALTER TABLE t_name RENAME [TO] new_t_name;
  ```

- 取消数据表主键

  ```mysql
  ALTER TABLE t_name DROP PRIMARY KEY;
  ```

  > 移除其他键类似;

## <p>

### 插入数据

- 插入指定字段的数据

  ```mysql
  INSERT INTO t_name (
    -> exist_column1,exist_column2,exist_column3,...
    -> ) VALUES (
    -> column1_value,column2_value,column3_value,...
    -> );
  ```

* 插入全部字段的数据

  ```mysql
  INSERT INTO t_name VALUES (
    -> column_value,column_value,column_value,...
    -> );
  ```

  > VALUES 的数据顺序要与表中的字段顺序相同;
  > 如果有主键使用`AUTO_INCREMENT`修饰的键,可以使用 `NULL`;
  > 支持插入多条数据;

  例如:

  ```mysql
  INSERT INTO t_name VALUES (
     -> NULL,'Jack',0,22,8888.00,'Hello,world!',NOW()
     -> ),(
     -> NULL,'Leo',1,21,6666.00,'what!',NOW()
     -> );
  ```

## <p>

### 修改更新数据

- 更新数据

  ```mysql
  UPDATE t_name SET
    -> column1_name=value,column2_name=value,...
    -> WHERE clause;
  ```

  > `UPDATE` 也可以同时更新多个表

  ```mysql
  UPDATE
    -> t1_name [AS t1],t2_name [AS t2],t3_name [AS t3],...
    -> SET
    -> t1.column1_name=value,t1.column2_name=value,...
    -> t2.column1_name=value,t2.column2_name=value,...
    -> t3.column1_name=value,t3.column2_name=value,...
    -> ...
    -> WHERE clause;
  ```

  > AS 简名,WHERE 想看下方查询;

## <p>

### 删除数据

- 删除数据保留 cursor index

  ```mysql
  DELETE FROM t_name [WHERE clause];
  ```

  > WHERE 想看下方查询;

- 清除数据表所有信息

  ```mysql
  TRUNCATE t_name;
  ```

  > `TRUNCATE`会清除整个表信息,`DELETE`会删除数据中的条目;

## <p>

## 数据查询

##### SELECT

```mysql
SELECT column1,column2,... FROM t_name [WHERE claus];
```

> 可以使用`*`代替所有字段.

##### WHERE

> `WHERE` 设定查询的条件

`WHERE condition1 and condition2 or (condition3)`

> 语句中可以使用 `AND` 或 `&&` , `OR` 或 `||` , `IN` , `NOT IN` , `BETWEEN ...AND`条件逻辑
> 条件逻辑还支持: `>` , `<` , `>=` , `<=` , `=` , `!=` 或 `<>`

例如:

```mysql
SELECT * FROM t_name
  -> WHERE
  -> uid=12354 AND (name='Jack' OR age > 32 OR salary BETWEEN 5000.00 AND 6000.00) ;
```

##### DISTINCT

> 使用 `DISTINCT`进行重复数据进行过滤

例如:

```mysql
SELECT DISTINCT * FROM t_name;
```

##### LIKE

> `LIKE` 查询条件时,根据设定的过滤条件进行结果返回

`WHERE condition column_name LIKE 'expression'`

> LIKE 匹配/模糊匹配，会与 % 和 \_ 结合使用。
> `%` 代表零个或多个字符;如果没有使用 `%` 相当于 `=`;
> `_` 代表任意一个单一字符;
> `[]` 代表一个正则表达式;

|    %x     |  %x%   |    x%     |      \_x      |      \_x\_      |      x\_      |
| :-------: | :----: | :-------: | :-----------: | :-------------: | :-----------: |
| 以 x 结尾 | 包含 x | 以 x 开始 | 两位以 x 结束 | 三位以 x 为中心 | 两位以 x 开始 |

例如: 查询表中字段 name 长度为 5 且 以' pack' 为结尾,且 mobile 以'8607'为结尾

```mysql
SELECT * FROM t_name WHERE name LIKE '_pack' AND mobile LIKE '%8607';
```

##### ORDER BY

> `ORDER BY` 设定返回结果以某一字段的字典排序方式进行排序,默认`ASC`;

`WHERE condition ORDER BY column_name ASC|DESC`

> `ASC` 字典排序:升序;
> `DESC` 字典排序:降序;

##### LIMIT

> `LIMIT` 限制返回数据的数量;
> 参数可以直接指定返回数量,`... LIMIT 10;`默认从第一条符合条件的数据,还有可以是`...LIMIT 2,10;`从符合条件的第三条数据开始;

`WHERE condition LIMIT start,off`

例如:

```mysql
SELECT * FROM t_name WHERE id > 10 LIMIT 1,10;
```

##### GROUP BY

> `GROUP BY` 按照所有字段的值条件进行分组;

`GROUP BY column_name`

例如:查询数据库中所有 name 的个数

```mysql
SELECT name,count(*) FROM t_name GROUP BY name;
```

##### UNION

> `UNION`控制多个查询语句时返回结果是否可重复;默认`DISTINCH`不重复

`SELECT * FROM t_name WHERE clause UNION ALL SELECT * FROM t_name WHERE clause`

> 'ALL' :返回所有结果包括重复结果;
> 'DISTINCH':返回结果排除重复结果;

例如:

```mysql
SELECT name FROM t_name WHERE age >20
  -> UNION DISTINCH
  -> SELECT name FROM t2_name WHERE id<10;
```

##### JOIN

> `INNER JOIN` 内连查询
> `LEFT JOIN` 左连查询
> `RIGHT JOIN` 右连查询

内联： 参考两个表中满足条件有相同值的.

```mysql
SELECT
  -> t1.column1 AS key1,t1.column2 AS key2,t1.column3 AS key3,... ,
  -> t2.column1 AS key6,t2.column2 AS key7,t2.column3 AS key8...
  -> FROM
  -> t1_name t1
  -> [INNER] JOIN
  -> t2_name t2
  -> ON
  -> t1.id = t2.uid
  -> WHERE
  -> clause;
```

> 使用的 table JOIN table 时 用 `ON` 进行条件连接;

左连: 会读取左边数据表的全部数据，即便右边表无对应数据。

```mysql
SELECT
  -> t1.column1 AS key1,t1.column2 AS key2,t1.column3 AS key3,... ,
  -> t2.column1 AS key6,t2.column2 AS key7,t2.column3 AS key8...
  -> FROM
  -> t1_name t1
  -> LEFT JOIN
  -> t2_name t2
  -> ON
  -> t1.id = t2.uid
  -> WHERE
  -> clause;
```

右连:会读取右边数据表的全部数据，即便左边边表无对应数据。

```mysql
SELECT
  -> t1.column1 AS key1,t1.column2 AS key2,t1.column3 AS key3,... ,
  -> t2.column1 AS key6,t2.column2 AS key7,t2.column3 AS key8...
  -> FROM
  -> t1_name t1
  -> RIGHT JOIN
  -> t2_name t2
  -> ON
  -> t1.id = t2.uid
  -> WHERE
  -> clause;
```
