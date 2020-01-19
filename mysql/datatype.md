### 数据类型

MySQL 中定义数据字段的类型对数据库的优化是非常重要的。
MySQL 支持多种类型，大致可以分为三类：数值、日期/时间和字符串(字符)类型。

##### 整型:

|      type      | size  |          scope           | scope unsigned  |
| :------------: | :---: | :----------------------: | :-------------: |
|   TINYINT(n)   | 1Byte |        (-128,127)        |    (0，255)     |
|  SMALLINT(n)   | 2Byte |      (-32768,32767)      |   (0，65535)    |
|  MEDIUMINT(n)  | 3Byte |    (-8388608,8388607)    |  (0，16777215)  |
| INT 或 INTEGER | 4Byte | (-2147483648,2147483647) | (0，4294967295) |
|   BIGINT(n)    | 8Byte |          太长了          |     太长了      |

<h6/>
##### 浮点型:

|     type     | size  |       scope        |   scope unsigned   |
| :----------: | :---: | :----------------: | :----------------: |
|  FLOAT(m,n)  | 4Byte |       太长了       |       单精度       |
| DOUBLE(m,n)  | 8Byte |       太长了       |       双精度       |
| DECIMAL(m,n) |  ...  | 依赖于 M 和 D 的值 | 依赖于 M 和 D 的值 |

<h6/>
##### 时间日期:

所有日期时间类型的值在`INSERT INTO` 时值否可以时字符,但是要满足对应的格式;

About 'zero' default value:

|            DATE             |            TIME             |       DATETIME        |               TIMESTAMP               |  YEAR  |
| :-------------------------: | :-------------------------: | :-------------------: | :-----------------------------------: | :----: |
|        '0000-00-00'         |         '00:00:00'          | '0000-00-00 00:00:00' |         '0000-00-00 00:00:00'         |  0000  |
|        'YYYY-MM-DD'         |         'hh:mm:ss'          | 'YYYY-MM-DD hh:mm:ss' |         'YYYY-MM-DD hh:mm:ss'         | 'YYYY' |
| CURRENT_DATE() 或 CURDATE() | CURRENT_TIME() 或 CURTIME() |   NOW() /SYSTIME(()   | CURRENT_TIMESTAMP() 或 CURTIMESTAMP() |  ---   |

> 在 Mysql5.7 以后`DATETIME`和`TIMESTAMP`支持默认值自动初始化和自动更新能力;在 Mysql5.5 只有`TIMESTAMP`支持;可以设置初始化的常量值`CURRENT_TIMESTAMP`

> 对于部分版本的 Mysql 如果需要实现自动更新到当前时间戳还要加上`ON UPDATE CURRENT_TIMESTAMP`子句;

例如:

```mysql
CREATE TABLE IF NOT EXISTS t_date(
    -> timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'This is a example.',
    -> updatetimestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMPON UPDATE CURRENT_TIMESTAMP COMMENT 'This is a update example.'
);
```

<h6/>
##### 文本:
```
