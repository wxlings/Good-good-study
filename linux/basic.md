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

- **`cd` change directory 切换路径**

- **`date` date 打印当前系统时间** 

- **`history <n>` 打印历史限制n个最近命令,默认全部**

- **`type <command>`显示命令的位置**

#### 
#### 文件基本操作
#### 

- **`ls` list 列出文件列表**

  `ls [options] <dest>` 

  - `-a` all 所有文件包括隐藏文件
  - `-l` long 长列表即详情 等同于`ll`

  ```shell
      ls # 默认当前路径
      ls -l /usr/local/bin
  ```

- **`cp` copy 复制/并重命名文件**

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

- **`mkdir` make directory 创建路径**

  `mkdir [options] <desc>`

  - `-m` mode 创建路径的同时设置其权限属性
  - `-p` parrents 可以创建目录路径的父类路径

  ```shell
      mkdir -m 711 -pv /usr/local/test/1/2/3/4/5/6/7
  ```

- **`rmdir` remove directory 移除路径**

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
      tar -zxvf archive.tar # 解压文件包
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

    - `-amin <n>` 过去 n 分钟被读取的文件
    - `-cnewer file` 过去 n 分钟创建的文件
    - `-atime <n>` 过去 n 天内被读取的文件
    - `-cmin <n>` 过去 n 分钟内被修改的文件
    - `ctime <n>` 过去 n 天内被修改的文件
    - `-empty` 空文件
    - `-name/inamne <str>` 文件名符合 str 的文件(iname 忽略大小写)
    - `-type` 过滤指定类型的文件: `f` 一般文件,`d` 文件夹文件
    - `size` 过滤文件大小

  ```shell
      find . -name "*.log" # find 当前目录下以.log结尾的文件
      find /usr/ -type f -cmin 10
      find / -size +500M 
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
  *`u` 向上翻半页*
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

  ```
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
  - `-C <n>` 除了显示符合样式的那一行之外，并显示该行之前后各n行的内容
  - `-i` ignore 忽略字符串匹配大小写
  - `-r` 使用递归的方式查文件夹

- `sed`


- `awk`

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


- `systectl` 服务控制器

  ```
  systemctl start mysqld.service
  systemctl stop mysqld.service
  systemctl restart mysqld.service
  ```

- `ps` process status 进程状态(类似 windows 的任务管理器)
  - `-auxf`
  - `-ef`
