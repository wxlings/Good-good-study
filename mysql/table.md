1. 所有对数据库及数据表的操作语句后都增加`;`
2. Windows 下中文乱码问题解决：
   `SET NAMES GBK;` 该命令只针对当前终端有效,终端关闭再打开后需要重新设置
   使用 `SHOW VARIABLES LIKE "%char%";`
   这种方式并未改变实际编码，只是设置显示编码格式,可以直接修改 my.ini 属性文件 default-character-set=gbk,只有在 windows 时才会修改；
   另外 win10 cmd 窗口需要使用旧版，新版修改属性无效

---

- 创建表,设置数据表 t_name

```mysql
CREATE TABLE t_name(
    -> column_name column_type[(length)] column_modifier column_modifier1 ...,
    -> column_name1 column_type[(length)] column_modifier column_modifier1 ...,
    -> column_name2 column_type[(length)] column_modifier column_modifier1 ...,
    -> [PRIMARY KEY (),]
    -> [UNIQUE INDEX (),]
    -> ...
    )

```

> Notes:
> 修饰符：

- 查看当前库中的列表

  ```mysql
  SHOW TABLES [LIKE "t_name"];
  ```

  > Notes:
  > 可以使用`LIKE` 关键字进行检索,注意在使用`LIKE`时从句要用`''`或者`""`包裹

- 查看当前表的创建语句

  ```mysql
  SHOW CREATE TABLE t_name;
  ```

  > Notes:
  > 　该语法和查看数据库的创建语句相同

- 查看表的结构

```mysql
    DESC / DESCRIBE t_name;
    SHOW COLUMNS FROM t_name;
```

- 查看表的索引结构

```mysql
SHOW INDEX FROM t_name;
```

- 删除数据表

```mysql
DROP TABLE t_name;
```

---

### ALTER 修改表及表结构

<h6/>
- ADD 增加字段,即增加"列"

```mysql
ALTER TABLE t_name ADD [COLUMN] column_name column_type[(length)] column_modifier column_modifier1 ... AFTER/FIRST exist_column_name;
```

> Notes:
> COLUMN 可以省略不写,为默认值
> column_type 必须赋值
> 可以使用`AFTER`和`FIRST`进行控制添加列的位置,注意该修饰只能在整个语句的最尾端

<h6/>
- DROP 删除字段,即删除"列"

```mysql
ALTER TABLE t_name DROP [COLUMN] column_name,column_name1,...;
```

> Notes:
> COLUMN 可以省略不写,为默认值

<h6/>
- MODIFY 修改列的属性

```mysql
ALTER TABLE t_name MODIFY exists_column_name column_type[(length)] column_modifier column_modifier1 ... AFTER/FIRST exist_column_name;
```

> Notes:
> 所需要的修饰必须重新添加,会使用新赋值的参数替换原有,包括 column_type

<h6/>
- CHANGE 修改列名称或修改列的属性

```mysql
ALTER TABLE t_name CHANGE exists_column_name new_column_name column_type[(length)] column_modifier column_modifier1 ... AFTER/FIRST exist_column_name;
```

> Notes:
> 所需要的修饰必须重新添加,会使用新赋值的参数替换原有,包括 column_type
> 与 MODIFY 区分,MODIFY 只可以修改列的属性,不能修改列名称,而 CHANGE 都可以

<h6/>
- RENAEM 重命名表

```mysql
ALTER TABLE t_name RENAME column_name new_column_name ;
```

TODO 增加移除键
