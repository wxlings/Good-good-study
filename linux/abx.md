基础命令:这里的文件可以是单个文件也可以是文件夹也可以是软连接类文件，一切皆文件

> 所有的命令都具有 `--help`，有问题找助手,文中`<source>`是指向原文件,`<dest>`目标文件或者路径

- `man` manual 手册

- `pwd` print working directory 打印当前路径

#### 文件基本操作

- `cd` change directory 切换路径
  `cd <dest>`

- `ls` list 列出文件列表
  `ls [options] <dest>` 默认当前路径

  - `-a` all 所有文件包括隐藏文件
  - `-l` long 长列表即详情 等同于`ll`
    例如:

  ```mysql
  ls -l /usr/local/bin
  ```

- `cp` copy 复制/并重命名文件(可以用于重命名功能)
  `cp [options] <source> <dest>`

  - `-a` all 全部信息拷贝,连同内链接等一同拷贝 等同于`-dpr`
  - `-r` recursive 递归复制,如果有文件件会递归复制文件件中的所有文件
  - `-f` force 强制拷贝,如果有相同的文件名强制覆盖
  - `-i` interactive 交互,有需要提示的给出弹窗

  ```
  cp -rf /usr/local/thrid/doc/ /home/doc
  ```

- `mv` move 移动文件(可以用于重命名文件功能)
  `mv [options] <source> <desc>`

  - `-f` force 强制拷贝,如果有相同的文件名强制覆盖
  - `-i` interactive 交互,有需要提示的给出弹窗

  ```
  mv -rf /usr/src/log /home/log
  mv /test/php.log /test/coll.log // 如果目标路径是与原路径相同会执行重命名
  ```

- `rm` remove 移除文件(`rm` 是能够直接移除非空的文件夹路径)
  `mv [options] <desc>`

  - `-r` recursive 递归移除,如果有文件件会递归复制文件件中的所有文件
  - `-f` force 强制拷贝,如果有相同的文件名强制覆盖

- `mkdir` make directory 创建路径
  `mkdir [options] <desc>`

  - `-m` mode 创建路径的同时设置其权限属性
  - `-p` parrents 可以创建目录路径的父类路径
    例如:

  ```
  mkdir -m 711 -pv /usr/local/test/1/2/3/4/5/6/7
  ```

- `rmdir` remove directory 移除路径
  `mkdir [options] <desc>`

  - `-p` parrents 连同上级的空目录一并删除(仅限于空的上级目录)

  例如:

  ```
  rmdir -pv /usr/local/test/1/2/3/4/5/6/7
  ```

- `touch` touch 创建文件(参数不常用)
  `touch [options] <dest>`

  - `-a` change only the access time
  - `-m` change only the modification time
  - `-d` parse STRING and use it instead of current time

  例如:

  ```
  touch /usr/local/test.log
  ```

- `ln -s` link -soft 创建一个软连接(在指定路径下创建目标文件的快捷方式)
  例如:
  ```
  ln -s /usr/zk /usr/local/bin/zike
  ```

> **总结: 对文件操作时,一般 `-r`是递归完成指令,`-f`是强制完成指令, `-i` 是由需要时给出提示 ,`-v`显示执行过程**

#### 文本文件基本读写查

- `cat` Concatenate file 输出文本内容到控制台

  > 比较适合打开小型文本文件,因为它是一次性加载全部内容并打印到控制台，如果是内容比较多的文件还需要联合`grep`一起使用

  `cat [options] <dest>`

  - `-n` 带有行号打印

- `tac` 功能和作用与`cat`相同,就是自下而上的输出到控制台

- `more` 一次性加载全部文本,进入阅读模式,支持操作查看内容

  **`回车键` 移动下一行**
  **`空格键` 移动下一页**
  **`b` 向上翻一页**
  **`u` 向上翻半页**
  **`f` 向下翻一页**
  **`d` 向下翻半页**
  **`q` quit 退出阅读模式,或者`ctrl +c`**

  `more [options] <dest>`

- `less` 一屏一屏的加载,并且进入阅读模式,支持操作查看内容 [更多使用技巧](https://www.runoob.com/linux/linux-comm-less.html)

  **操作覆盖`more`的外键操作功能,同时支持`方向键`和`PageUp/PageDown`功能键控制**
  **`/` 输入关键字后回车向下搜索, `?` 输入关键字后回车向上搜索**
  **`F` 开启文件新内容监听,类似`tail -F`**

  `less [options] <dest>`

  - `-o` 保存到其他文件
  - `-N` 显示行号

  例如:分页显示进程

  ```
  ps -ef | less -N
  ```

* `head` 输出文件头部指定行数
  `head [options] <dest>`

  - `-c` bytes 指定的字节数
  - `-l` lines 指定的行数(没有指定`-c`可以省略)

  例如:

  ```
  head -20 /usr/local/requeset.log
  ```

* `tail` 输出文件尾部指定行数
  `tail [options] <dest>`

  - `-c` bytes 指定的字节数
  - `-l` lines 指定的行数(没有指定`-c`可以省略)
  - `-f` follow 监听文件,**常用于监听日志,抓取指定日志,进入等待模式**
  - `-F` follow retry

  例如:

  ```
  tail -F /usr/local/src/www/login.log
  ```

#### 安装软件包

- `yum` 插件/第三方软件安装器,使用于`yum源`上已有的资源
  - `list <package_name>` 显示列表
  - `install/reinstall -y <package_name>` 安装/重新安装指定的软件包
  - `remove <package_name>` 卸载指定的软件包
  - `update/downgrade <package_name>` 升/降级已经安装的软件包

* `wget` 插件/工具：文件下载器

* `lrzsz` 插件/工具：文件传输器
  `rz` 上传
  `sz` 下载

* `zip/unzip` 解压缩文件

* `tar` 打包文件，把多个文件打包成一个文件，生成或者提取`.tar`文件

  > 注意这里并没有**压缩**,仅仅是打包，如果需要压缩请使用`-z`参数，或者使用`gzip`命令

  - `-c` create a new compressed archive 创建(打包)一个压缩文件
  - `-x` extract files from an archive 提取一个包文件
  - `-t` list the contents of an archive 列出包文件的内容
  - `-v` verbosely list files processed 冗长地列出处理过的文件
  - `-z` filter the archive through gzip 通过 gzip 过滤存档即：压缩和解压
    例如：z
    ```
    tar -zcvf archive.tar 1.txt 2.log 3.zip files/4.md
    tar -tvf archive.tar
    tar -zxvf archive.tar
    ```

* `gzip` 压缩/解压缩文件,会生成或者解压`.gzip`文件
  - `-d` 解压缩文件
    例如：
    ```
    gzip archive.tar.gz
    gzip -d archive.tar.tz
    ```

- `find` find 命令用来在指定目录下查找文件,[更多使用方法](https://www.runoob.com/linux/linux-comm-find.html)
  `find path -option [ -print ] [ -exec -ok command ] {} \;`

  - `-amin <n>` 过去 n 分钟被读取的文件
  - `-atime <n>` 过去 n 天内被读取的文件
  - `-cnim <n>` 过去 n 分钟内被修改的文件
  - `ctime <n>` 过去 n 天内被修改的文件
  - `-name/inamne <str>` 文件名符合 str 的文件(iname 忽略大小写)
  - `-type` 过滤指定类型的文件: `f` 一般文件,`d` 文件夹文件
  - `size` 过滤文件大小

  ```
  find . -name "*.log" // find 当前目录下以.log结尾的文件
  find /usr/ -type f -cmin 10
  ```

- `systectl` 服务控制器

  ```
  systemctl start mysqld.service
  systemctl stop mysqld.service
  systemctl restart mysqld.service
  ```

- `ps` process status 进程状态(类似 windows 的任务管理器)
  - `-auxf`
  - `-ef`
