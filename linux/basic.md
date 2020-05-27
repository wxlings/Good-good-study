基础命令:这里的文件可以是单个文件也可以是文件夹也可以是软连接类文件，一切皆文件

`$` 环境变量, `@` 主机, `~` 用户, `|` 管道符（**将一个命令的输出定向到另一个命令的输入;也就说前一个命令处理后的数据会作为数据源传递给下一命令继续进行处理**）, `;` 连续（使用;保证命令的连续）
`>` 输出重定向, `<` 输入重定向

```shell
    cat /etc/password | sort | less # 获取password的内容，然后排除，再次使用less查看
    data ; troff -me verylargedoc | lpr ; date # 记录开始时间，然后开始整理一个large doc,完成后再次记录时间，这样就记录了整理文档的耗时
```

> 所有的命令都具有 `--help`，有问题找助手;
> 以下内容中`<source>`是指源文件或者源路径,`<dest>`目标文件或者路径

- **`man <command>` manual 手册:search for files in a directory hierarchy**

- **`pwd` print working directory 打印当前路径**

- **`date` date 打印当前系统时间** 

- **`history <n>` 打印历史限制n个最近命令,默认全部**

- **`type <command>`显示命令的位置**

- **`./jemeter.sh`** 执行一个可执行文件 

#### 
#### 文件基本操作
#### 

- **`cd` change directory 切换路径**
  
  `cd [options] <dest>`

  ```shell
      cd ~ # 切换到HOME
      cd # 切换到HOME
  ```

- **`ls` list 列出文件列表**

  `ls [options] <dest>` 

  - `-a` all 所有文件包括隐藏文件
  - `-l` long 长列表即详情 等同于`ll`

  ```shell
      ls # 默认当前路径
      ls -l /usr/local/bin # 等同于'll'
  ```

- **`cp` copy 复制(并重命名)文件**

  `cp [options] <source> <dest>`

  - `-a` all 全部信息拷贝,连同内链接等一同拷贝 等同于`-dpr`
  - `-r` recursive 递归复制,如果有文件夹会递归复制文件夹中的所有文件
  - `-f` force 强制拷贝,如果有相同的文件名强制覆盖
  - `-i` interactive 交互,有需要提示的给出弹窗

  ```shell
      cp -rf /usr/local/thrid/doc/ /home/doc
  ```

- **`mv` move 移动文件(可以用于重命名文件功能)**

  `mv [options] <source> <desc>`

  - `-f` force 强制拷贝,如果有相同的文件名强制覆盖
  - `-n` no-blobber 不覆盖已经存在的文件
  - `-i` interactive 交互,有需要提示的给出弹窗

  ```shell
      mv -rf /usr/src/log /home/log
      mv /test/php.log /test/coll.log  #如果目标路径是与原路径相同会执行重命名
  ```

- **`rm` remove 移除文件(`rm` 是不能够直接移除非空的文件夹)**

  `rm [options] <desc>`

  - `-r` recursive 递归移除,如果有文件件会递归复制文件件中的所有文件
  - `-f` force 强制拷贝,如果有相同的文件名强制覆盖
  - `-i` interactive 交互,每移除一个文件时都会提示给出弹窗

  ```shell
      rm rf /usr/local/log/temp
  ```

- **`mkdir` make directory 创建路径**

  `mkdir [options] <desc>`

  - `-m` mode 创建路径的同时设置其权限属性
  - `-p` parrents 可以创建目录路径的父类路径

  ```shell
      mkdir -m 711 -pv /usr/local/test/1/2/3/4/5/6/7
  ```

- **`rmdir` remove directory 移除空的路径**

  `mkdir [options] <desc>`

  - `-p` parents 连同上级的空目录一并删除(仅限于空的上级目录)

  ```shell
      rmdir -pv /usr/local/test/1/2/3/4/5/6/7
  ```

- **`touch` touch 创建文件(修改文件的属性)**

  `touch [options] <dest>`

  - `-a` access time 修改文件的访问时间
  - `-m` modification time 修改文件的修改时间

  ```shell
      touch /usr/local/test.log
  ```

- **`ln` link 创建一个连接(在指定路径下创建目标文件的快捷方式)**

  `ln [options] <source> <dest-ln>`
  
  - `-f` force 如果已经存在目标连接名称则强制移除后在创建
  - `-i` interactive 交互,有需要提示的给出弹窗
  - `-s` soft 创建一个软连接

  ```shell
      ln -is /usr/zk /usr/local/bin/zike
  ```

- **`tar` 打包文件，把多个文件打包成一个文件，生成或者提取`.tar`文件**

  > 注意这里并没有**压缩**,仅仅是打包，如果需要压缩请使用`-z`参数，或者使用`gzip`命令

  - `-c` create a new compressed archive 创建(打包)一个压缩文件
  - `-f` use archive file or device ARCHIVE 
  - `-x` extract files from an archive 提取一个包文件
  - `-t` list the contents of an archive 列出包文件的内容
  - `-v` verbosely list files processed 冗长地列出处理过的文件
  - `-z` filter the archive through gzip 通过 gzip 过滤存档即：压缩和解压

  ```shell
      tar -zcvf archive.tar 1.txt 2.log 3.zip files/4.md # 打包并压缩1，2，3/4等文件到archive.tar文件
      tar -tvf archive.tar # 查看.tar文件内容
      tar -zxvf archive.tar # 解压文件包到当前目录
  ```

- **`gzip` 压缩/解压缩文件,会生成或者解压`.gzip`文件**

  > 通常用的比较少，都是直接使用`tar -z`直接使用了

  - `-k` keep 不删除原有文件，默认完成压缩后会删除原有文件
  - `-d` 解压缩文件

  ```shell
      gzip archive.tar archive.tar.gz # 压缩archive.tar 到archive.tar.gz
      du -h archive.tar.gz # 查看压缩包信息
      gzip -d archive.tar.tz # 解压archive.tar.gz 到 archive.tar
  ```

- **`lrzsz` 插件/工具：文件传输器,需要使用`yum`/`apt`进行安装**

  > `rzsz`仅支持单文件处理的传输

  * `rz` 上传
  * `sz` 下载
  
  ```shell
      rz # 回车后会弹出计算机文件选择弹窗，进行文件选择
      sz authorized_keys # 回车后会弹出系统文件保存选择弹窗
  ```
  **_注意：xshell支持，putty是不支持的_**

  如果是ssh协议可以使用`scp`，OpenSSH secure file copy

  `scp [-346BCpqrTv] [-c cipher] [-F ssh_config] [-i identity_file] [-J destination] [-l limit] [-o ssh_option] [-P port] [-S program] source ... target`

    - `-r` recurse 递归，用于复制文件夹
    - `-P` port 指定host端口

  ```shell
    scp d:/res/a.md root@192.168.101.13:~/home/ # 本地上传到linux
    scp -r d:/res/ 192.168.101.13:~/home/res/ # 上传文件夹，然后确认用户名及密码

    scp root@192.168.101.13:/home/res/a.md d:/lin # 由linux下载到本地
    scp -r www.baidu.com:/home/ d:/ln/ # 也可以使用域名
  ```
  > 注意`scp`只能传输`regular`文件,如果是文件夹的话需要使用`-r`参数

- **`zip/unzip` 插件/工具：解压缩文件,需要使用`yum`/`apt`进行安装**

  - `-r` recurse 递归压缩文件夹
  - `-d` delete 删除 zip entry

  ```shell 
      zip -r folder.zip folder 1.txt 2.txt # 压缩文件到zip
      du -h folder.zip # 查看压缩包信息
      unzip folder.zip -d folder # 解压zip文件
  ```

  > 比较之下压缩率：`zip`不及`gzip`

  - **`find` find 命令用来在指定目录下查找文件,[更多使用方法](https://www.runoob.com/linux/linux-comm-find.html)**

    `find path -option [ -print ] [ -exec -ok command ] {} \;`

      `(N can be +N or -N or N): -amin N -anewer FILE -atime N -cmin N
      -cnewer FILE -ctime N -empty -false -fstype TYPE -gid N -group NAME
      -ilname PATTERN -iname PATTERN -inum N -iwholename PATTERN -iregex PATTERN
      -links N -lname PATTERN -mmin N -mtime N -name PATTERN -newer FILE
      -nouser -nogroup -path PATTERN -perm [-/]MODE -regex PATTERN
      -readable -writable -executable
      -wholename PATTERN -size N[bcwkMG] -type [bcdpflsD] -uid N
      -used N -user NAME -xtype [bcdpfls]      -context CONTEXT`

    - `-amin <n>` File was last accessed n minutes ago.
    - `-atime <n>` 过去 n 天内被访问的文件
    - `-cmin <n>` File's status was last changed n minutes ago.
    - `-ctime <n>` 过去 n 天内被修改的文件
    - `-mmin <n>` File's data was last modified n minutes ago.
    - `-mtime <n>` 过去 n 天内被修改过属性的文件
    - `-empty` File is empty and is either a regular file or a directory. (蛋疼会找空的文件)
    - `-name/inamne <pattern>` 文件名符合 str 的文件(iname 忽略大小写) 支持(`*`, `?`,`[]`)进行文件名称匹配
    - `-type [options]` 过滤指定类型的文件: `f` regular file ,`d` directory , `l` link file
    - `-user <uname>` File is owned by user uname
    - `-size +/- <n[c/k/M/G]>` 过滤文件大小(`+/-`大于/小于参数，`c`:bytes,`k`:kb,`M`:Mb,`G`:Gb)
    - `-writable`,`-readable`,`-executable` 可写，可读，可执行的属性

  ```shell
      find . -iname *.log # find 当前目录下以.log结尾的文件
      find /usr/ -type d -cmin 10
      find / -size +500M  # find 单文件容量大于500M的所有文件
  ```

> **总结: 对文件操作时,一般 `-r`是递归完成指令,`-f`是强制完成指令, `-i` 是由需要时给出提示 ,`-v`显示执行过程**

___

#### 
#### 文本文件基本读写查
#### 

- **`cat` Concatenate file 输出文本内容到控制台**

  > 比较适合打开小型文本文件,因为它是一次性读取全部内容；如果内容比较大的文件建议联合`grep`一起使用

  `cat [options] <dest>`

  - `-n` 带有行号打印

  ```shell
      cat -n /usr/lacal/log/temp.log | grep -C error
  ```

- **`tac` 功能和作用与`cat`相同,只不过是文件的读取方向刚好相反**

- **`more` 一次性读取全部文本,可以进入阅读模式,支持内容内容查找**

  `more [options] <dest>`

  *`回车键` 移动下一行*
  *`空格键` 移动下一页*
  *`b` 向上翻一页*
  *`f` 向下翻一页*
  *`d` 向下翻半页*
  *`q` quit 退出阅读模式,或者`ctrl +c`*

- **`less` 一屏一屏的读取,可以进入阅读模式,支持操作查看内容 [更多使用技巧](https://www.runoob.com/linux/linux-comm-less.html)**

  `less [options] <dest>`

    *操作覆盖`more`的外键操作功能,同时支持`方向键`和`PageUp/PageDown`功能键控制*
    *`/` 输入关键字后回车向下搜索*
    *`?` 输入关键字后回车向上搜索*
    *支持`F`键开启文件新内容监听,类似`tail -F`*

  - `-o` 保存到其他文件
  - `-N` 显示行号

  例如:分页显示进程

  ```shell
      ps -ef | less -N
  ```

- **`head` 输出文件头部指定行数** 

  `head [options] <dest>`

  - `-c` bytes 指定的字节数
  - `-l` lines 指定的行数(没有指定`-c`可以省略)

  ```shell
      head -20 /usr/local/requeset.log
  ```

- **`tail` 输出文件尾部指定行数**

  `tail [options] <dest>`

  - `-c` bytes 指定的字节数
  - `-l` lines 指定的行数(没有指定`-c`可以省略)
  - `-f` follow 监听文件,**常用于监听日志,抓取指定日志,进入等待模式**
  - `-F` follow retry

  ```shell
    tail -F /usr/local/src/www/login.log
  ```
___

#### 
#### 三剑客(grep,sec,awk)
#### 

- **`grep` 查找文件里符合条件的字符串**
  > `grep`可以直接查文档，也可以接收流

  `grep [options] <str> <dest>`

  - `-c` count 计算符合样式的行数
  - `-r` 使用递归的方式查文件夹
  - `-A <n>` after 找到目标的后n行
  - `-B <n>` before 找到目标的前n行
  - `-C <n>` 找到目标词汇的前后n行
  - `-v <str>`  

  ```shell
      grep -C 10 "error" php_access_log.txt # 查找文件中包含关键词的前后各10行的内容
  ```

- `sed` 一种在线编辑器，一次处理一行数据
  
  > 多用于行数据处理

  `sed [options] 'n [,m] action'`

  options:
  - `-n` --silent,quiet 沉静的，**如果没有指定该参数那么在使用action/p(打印)中指定的行号无效**
  - `-i` 默认所有的操作都是在使用内存的副本，并不对文件本身进行修改，如果需要修改文件就需要使用`-i`参数
  
  actions:
  格式：[n,[m]] function
  - `-a` 新增行，需要指定在第几行后追加，可以标记新增行的内容，例如：`2a hello,world`
  - `-c` 替换行
  - `-d` 删除行，不可与`option`中的`-n`同时使用
  - `-i` 插入行
  - `-p` [指定行号/查询]打印，如果指定了行号需要联合`option`中的`-n`使用
  - `-s` 替换，直接进行取代工作; `s/source/target/g`全局替换

  ```shell
      sed '2p' data.ini # 打印所有内容，没有指定'-n'参数默认打印全部行数
      sed -n 'p' data.ini # 打印所有行内容
      sed -n '2,4p' data.ini # 打印第2行-第4行内容
      sed '3d' data.ini # 删除第3行，这里不需要加`-n`参数，只是删除显示中数据不会删除元数据
      sed '2a hello,word' data.ini # 在第2行后新建行插入hello.word
      sed -n '/hello/p' data.ini # 打印包含字段的行
      sed -i 's/hello/world/g' data.ini # 替换文件中全部的hello字段为world
      sed 's/ /hello/g' data.ini | sort | uniq -c | sort -r | head -5 # 查一篇文章中出现频率最高的5个词
  ```

- `awk` 对文件进行格式化的工具

  > 多用于列数据进行处理

  `awk [options] 'pattern{action}' file,file,...`
  
  options: 
  - `-F` --field-separator指定分割符，以分隔符为标识把行数据进行分割为多列；默认为空白字符

  pattern：符合pattern的才会传递给action(简单理解为符合该条件)可以使用`&&`,`||`...等逻辑判断符
  - `$n` 可以直接获取第n列的值与指定条件比较，例如：`$2=="order"`
  - `NF` 分割后的字段列的数量(支持==,>,<等比较操作)
  - `NR` 当前行的行号
  

  action : 
  - `print $n` 打印第n列($n)数据内容

  ```shell
      awk '{print "TAG:" $5," msg:" $6}' php_login_0202.log # 输出文件中以空白字符为分割标识后的第5列及第6列的内容
      awk -F '-' 'NF>=4 && ($1=="order"||$1=="t_order") {print  "uid:" $2,"order_id:" $4}' php_order_all.log # 输出文件中指定以`-`分割且分割后列数>=4的行信息中第2列及第4列的内容
      awk '{print $7}' php_access_log.txt | awk -F '?' '{$1}'| sort | uniq -c | sort -rn | head -10
  ```

 > 涉及第几列的数据优先使用`awk`，因为`awk`会对行依据分隔符进行分列，有列的概念

- `sort` 把文件内容中以行为单位进行比较，按照首字符向后

  - `-r` reverse 反转
  - `-n` numerical value 数值

  > 通常会和其它命令联合使用，例如：`uniq`,`awk`

  ```shell
      sort -rn login.log # 排序文件中的行数据
  ```

- `uniq` 去重，去除重复数据，前提条件是**相邻数据相同**才会被执行去重

  > 在使用  `uniq`之前要用`sort`进行排序，目的是使相同的数据相邻，这样`uniq`才会更准确
  
  - `-c` 统计出现的次数

  > 通常会和其它命令联合使用，例如：`sort`,`awk`

  ```shell
       awk -F "," 'NF>2 {print $1,$2}' awk.txt | sort | uniq -c | sort -rn | head -3 # 读取文件以','进行分割，满足至少两个字段后进行过滤然后按照出现频率又少到多进行排序 
  ```

---

总结：
  `awk` 适合对行内有规律的列数据进行处理，通常用于找到(行分割后的)列数据进行统计分析，较多情况需要结合`sort -rn`,`uniq -c`使用
  `sed` 适合对行数据进行处理,可以增删改查  用于修改文件内容例如：`sed -i 's/source/target/g file'
  `grep` 适合对文本数据进行过滤处理  较多使用`-C <n>`过滤文件关键字

---

#### 
#### 磁盘系统
#### 

- **`df` (disk free：report file system disk space usage) 显示磁盘可用空间数目信息**

  > 目标是系统文件:检查文件系统的磁盘空间占用情况。可以利用该命令来获取硬盘被占用了多少空间，目前还剩下多少空间等信息

  `df [options] <test>`

  - `-a` all
  - `-k` k byte
  - `-m` M byte
  - `-h` 自行显示相关单位，人性化的单位,**常用**

  ```shell
      df -h 
  ```

- **`du` estimate file space usage**

  > 目标是用户文件/目录

  - `-a` all 列出该目录的子目录的已用容量
  - `-k` k byte
  - `-m` M byte
  - `-h` 自行显示相关单位，人性化,**常用**
  - `-s` 对于目录：列出该目录的总体积，而不列出每个各别的目录占用容量；

  ```shell
      du -hs /usr/local/log # 查看 log目录总体积
  ```

- **`fdisk` 磁盘分区(manipulate disk partition table)**

  `fdisk [options] device`

  - `-l` 输出后面接的装置所有的分区内容

  ```shell
      fdisk -l /dev/sda1 # 查看指定设备的磁盘及分区信息
  ``` 

  > 这个命令的输出内容有点专业，表示似懂非懂


- **`mount` 磁盘挂载 (mount a filesystem)**

  `mount [options] <device> <dir>`
  
  ```shell
      fdisk -l # 查找接入设备的信息，主要指设备名称 /dev/sdb1
      # Device     Boot Start     End Sectors Size Id Type
      # /dev/sdb1          63 4108607 4108545   2G  e W95 FAT16 (LBA)
      mkdir -p /mnt/usb/temp
      mount /dev/sdb1 /mnt/usb/temp
      cd /mnt/usb/temp # 就可以看到u盘内容了,使用文件
  ```

- **`umount` 磁盘挂载**

    - `-f` force 强制卸载

    ```shell
        umount /dev/sdb1
    ```

- **`fsck` 磁盘检查**

  `mkfs [options] <device>`

  > 没有怎么用到

- **`mkfs` make file system 格式化文件系统**

  `mkfs [options] <device>`

  - `-t <type>` 指定格式化后的文件系统格式,例如'ext2'

  ```shell
      mkfs -t ext3 /dev/sdc
  ```

#### 
#### 安装软件包
#### 

- `rpm` 

- **`yum` Centos发行版本的包管理器,使用于`yum源`上已有的资源**

  - `list <package>` list packages based on package names
  - `install/reinstall -y <package_name>` install/reinstall package
  - `search <package>` list packages based on package names
  - `remove <package>` 卸载指定的软件包
  - `update/downgrade <package>` 升/降级已经安装的软件包

- **`apt` Ubuntu发行版本的包管理，默认使用Ubuntu平台的资源**

  - `list <package>` list packages based on package names
  - `search <package>` list packages based on package names
  - `show <package>` show package details
  - `install/reinstall -y <package>` install/reinstall package 
  - `remove <package>` 卸载指定的软件包
  - `upgrade <package>` 升级已经安装的软件包



- **`wget` 插件/工具：文件下载器,需要使用`yum`/`apt`进行安装**



#### 系统相关

- `ip` how / manipulate(操纵) routing, network devices, interfaces and tunnels

  > `ifconfig` 默认centos7及Ubuntu都已经去掉了该工具,可以使用`sudo yum/apt instatll -y ifconfig`进行安装

  - `addr/address` 查看IP地址 protocol (IP or IPv6) address on a device.
  - `route` 路由主机 routing table entry.
  - `link` network device.

- `systectl` 服务控制器 Control the [systemd](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html) system and service manager

  > `systemctl`暂且可以看作是命令`service`的升级兼容版本
  > 同时等效于直接启动`/etc/init.d/<service_name> [options]`

  `systemctl [options] <test>` [`status` | `start` | `stop` | `restart`(restart service) | `force-reload`(reload config file)`]

  ```shell
      systemctl start mysqld.service
      systemctl stop mysqld.service
      systemctl restart mysqld.service
  ```

- `ps` process status 进程状态(类似 windows 的任务管理器) report a snapshot of the current processes.ps displays information about a selection of the active processes.

  `ps [options]`

  - `-auxf` To see every process on the system using BSD syntax
  - `-ef` To see every process on the system using standard syntax
  - `-ejH` To print a process tree

  ```shell
      ps -ef | grep sshd # 使用标准的语法查看系统进程，并使用grep进行过滤
      ps -aux | grep sshd # 使用bsd语法查看系统进程，
      ps -ejH
  ```
  > Notes:可以用于查看指定应用的进程是否已经启动

- `kill` send a signal to a process 发送一个信号给进程

  >  `kill` 有多个signal，可以使用 `kill -l`查看,参数`-9`是`SIGKILL`杀掉进程

  `kill [options] <pid>`

  ```shell
      kill -9 -1 # Kill all processes you can kill.
  ```

- `nohup` 以后台进程的方式启动,避免控制台阻塞式启动

  `nohup [opitons]`

  ```shell
      nohup ./jemter.sh > run.log # 以后台的方式运行./jemeter.sh 并把输出信息保存到run.log文件
  ```
  > 如果没有权限运行可以先确认脚本文件是否有`x`可执行权限,使用`chmod +x <file>`增加可执行属性
  > 如果用户角色权限不够请切换`su`,·sudo passwd root·修改root密码

- `netstat` 显示协议统计信息和当前 TCP/IP 网络连接 prints information about the Linux networking subsystem. 
  
  `netstat [options]`

  - `-a` 显示所有连接
  - `-n` 以数字形式显示地址和端口号

  ```shell
      netstat -anp | grep 3306
  ```