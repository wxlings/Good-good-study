数据库服务：

1. 所有对数据库及数据表的操作语句后都增加`;`
2. Windows 下中文乱码问题解决：

   ```mysql
   SET NAMES GBK;
   ```

   该命令只针对当前终端有效,终端关闭再打开后需要重新设置
   使用 `SHOW VARIABLES LIKE "%char%";`
   这种方式并未改变实际编码，只是设置显示编码格式,可以直接修改 my.ini 属性文件 default-character-set=gbk,只有在 windows 时才会修改；
   另外 win10 cmd 窗口需要使用旧版，新版修改属性无效

3. 存储引擎
   默认 Mysql5.7 以上支持 InnoDB、MyISAM、Memory 等多引擎,InnoDB 事务型数据库的首选引擎,比较常用;
   如果需要修改在创建数据库时使用`SET default_storage_engine=<engine_name>`

---

### 连接/断开数据库

- 下载及安装
  [官网下载](https://dev.mysql.com/downloads/mysql/),[安装教程](http://c.biancheng.net/view/2376.html)

- 启动数据库服务

  ```mysql
  mysqld [--console]
  ```

  > Notes:
  > Mysqld :SQL 后台程序可执行程序, 位与安装路径 bin 目录下,强烈建议将 mysql 添加到配置环境中
  > console 参数可选,可以打印启动过程中的相关日志

- 连接书库库

  ```mysql
  mysql -u username -h host -p
  ```

  > Notes:
  > 参数 u root ,参数 h localhost, 参数 p password

- 断开数据库连接

  ```mysql
  QUIT / EXIT

  ```

- 关闭数据库服务

  ```mysql
  mysqladmin -u root -p SHUTSOWN
  ```

  > Notes:
  > Mysqladmin 是可执行程序, 位与安装路径 bin 目录下,执行管理操作的客户程序，例如创建或删除数据库、重载授权表、将表刷新到硬盘上以及重新打开日志文件。Mysqladmin 还可以用来检索版本、进程以及服务器的状态信息。
  > 关闭服务需要验证管理员身份

---

### 创建/删除数据库

- 查看当前所有数据库列表

  ```mysql
  SHOW DATABASES [LIKE "db_name"];
  ```

  > Notes:
  > 可以使用`LIKE` 关键字进行检索,注意在使用`LIKE`时从句要用`''`或者`""`包裹

- 创建数据库,命名为 db_name,设置编码为 utf-8

  ```mysql
  CREATE DATABASE [IF NOT EXISTS] db_name [DEFAULT CHARSET UTF8];
  ```

- 选择/切换数据库

  ```mysql
  USE db_name;
  ```

- 查看当前数据库状态

  ```mysql
  SELECT DATABASE();
  ```

- 查看创建数据库的语句

  ```mysql
  SHOW CREATE DATABASE db_name;
  ```

- 修改数据库

  ```mysql
  ALTER DATABASE db_name option value;
  ```

  > Notes:
  > 例如：`ALTER DATABASE db_name CHARACTER SET gb2312;`

- 删除数据库

  ```mysql
  DROP DATABASE [IF EXISTS] db_name;
  ```

- 查看当前数据库版本号

  ```mysql
  SELECT VERTION();
  ```

- 查看当前数据库连接的用户列表

  ```mysql
  SELECT USER();
  ```

- 查看当前数据库配置信息

  ```mysql
  SHOW STATUS;
  ```

- 查看当前数据库配置信息
  ```mysql
  SHOW VARIABLES;
  ```

---

### 数据导入与导出

- 导入\*.sql 文件
  ```mysql
  SOURCE ‘*:/\*.sql’
  ```

---

### 数据类型

MySQL 中定义数据字段的类型对数据库的优化是非常重要的。
MySQL 支持多种类型，大致可以分为三类：数值、日期/时间和字符串(字符)类型。

##### 整型

    |      type      | size  |                    scope                    | scope unsigned  |
    | :------------: | :---: | :-----------------------------------------: | :-------------: |
    |   TINYINT(n)   | 1Byte |                 (-128，127)                 |    (0，255)     |
    |  SMALLINT(n)   | 2Byte |               (-32768，32767)               |   (0，65535)    |
    |  MEDIUMINT(n)  | 3Byte |             (-8388608，8388607)             |  (0，16777215)  |
    | INT 或 INTEGER | 4Byte |          (-2147483648，2147483647)          | (0，4294967295) |
    |   BIGINT(n)    | 8Byte | (-9223372036854775808，9223372036854775807) |     太长了      |

<h6/>

##### 浮点型

    |     type     | size  |       scope        |   scope unsigned   |
    | :----------: | :---: | :----------------: | :----------------: |
    |  FLOAT(m,n)  | 4Byte |       太长了       |       单精度       |
    | DOUBLE(m,n)  | 8Byte |       太长了       |       双精度       |
    | DECIMAL(m,n) |  ...  | 依赖于 M 和 D 的值 | 依赖于 M 和 D 的值 |

<h6/>

##### 时间日期

<h6/>

##### 文本
