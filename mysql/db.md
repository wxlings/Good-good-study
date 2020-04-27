### Intro：

1. 下载及安装
   [官网下载](https://dev.mysql.com/downloads/mysql/), [安装教程](http://c.biancheng.net/view/2376.html)

2. 所有对数据库及数据表的操作语句后都增加`;`
3. Windows cmd 下中文乱码问题解决策略：

   ```mysql
   SET NAMES GBK;
   ```

   该命令只针对当前终端有效,终端关闭再打开后需要重新设置

   ```mysql
   SHOW VARIABLES LIKE "%char%";
   ```

   这种方式并未改变实际编码，只是设置显示编码格式,可以直接修改 my.ini 属性文件 default-character-set=gbk,只有在 windows 时才会修改；
   另外 win10 cmd 窗口需要使用旧版，新版修改属性无效

4. 存储引擎
   默认 Mysql5.7 以上支持 InnoDB、MyISAM、Memory 等多引擎,InnoDB 事务型数据库的首选引擎,比较常用;
   如果需要修改在创建数据库时使用

   ```mysql
   SET default_storage_engine=<engine_name>
   ```

## <p>

### 启动/停止数据库服务

- 启动数据库服务

  ```mysql
  mysqld [--console]
  ```

  > Mysqld :SQL 后台程序可执行程序, 位于安装路径 bin 目录下,强烈建议将 mysql 添加到配置环境中
  > console 参数可选,可以打印启动过程中的相关日志

- 关闭数据库服务

  ```mysql
  mysqladmin -u root -p SHUTSOWN
  ```

  > Mysqladmin 是可执行程序, 位与安装路径 bin 目录下,执行管理操作的客户程序，例如创建或删除数据库、重载授权表、将表刷新到硬盘上以及重新打开日志文件。
  > Mysqladmin 还可以用来检索版本、进程以及服务器的状态信息。
  > 关闭服务需要验证管理员身份

## <p>

### 连接/断开数据库

- 连接数据库

  ```mysql
  mysql [-h host] -u username -p
  ```

  > 参数 u root ,参数 h localhost, 参数 p password

- 断开数据库连接

  ```mysql
  QUIT / EXIT
  ```

## <p>

### 创建/删除数据库

- 查看当前数据库列表

  ```mysql
  SHOW DATABASES [LIKE "db_name"];
  ```

  > 可以使用`LIKE` 关键字进行检索,注意在使用`LIKE`时从句要用`''`或者`""`包裹

- 创建数据库,命名为 `db_name`,设置编码为 utf-8

  ```mysql
  CREATE DATABASE [IF NOT EXISTS] db_name [DEFAULT CHARSET UTF8];
  CREATE DATABASE [IF NOT EXISTS] db_name [DEFAULT CHARACTER SET='UTF8'];
  ```

- 选择/切换数据库

  ```mysql
  USE db_name;
  ```

- 查看创建数据库的语句

  ```mysql
  SHOW CREATE DATABASE db_name;
  ```

- 删除数据库

  ```mysql
  DROP DATABASE [IF EXISTS] db_name;
  ```

---

<p>

### 其他

- 修改数据库

  ```mysql
  ALTER DATABASE db_name option value;
  ```

  > 例如：`ALTER DATABASE db_name CHARACTER SET gb2312;`

* 元数据:查看当前数据库版本号,当前用户,数据库名称...

  ```mysql
  SELECT VERTION(),USER(),DATABASE(),NOW();
  ```

* 元数据:查看当前数据库版本号,当前用户,数据库名称...

  ```mysql
  SELECT VERTION(),USER(),DATABASE(),NOW();
  ```

* 查看当前数据库配置信息

  ```mysql
  SHOW STATUS;
  ```

* 查看当前数据库配置信息

  ```mysql
  SHOW VARIABLES;
  ```

### 命令导入导出数据库

- 导入:使用`source`

```
source d:/***/user.sql
```

- 导出:
  ```
  mysqldump -u username -p db_name > d:/***/user.sql
  ```
