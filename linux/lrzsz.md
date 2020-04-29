`lrzsz` 是一款 linux 下命令行界面上支持上传和下载的第三方工具，能够起到很方便的作用。
我们可以使用它在操作计算机和 Linux 服务器之间传输文件

> `rz` 文件由本地计算机上传到 Linux
> `sz <source-file>` 文件由 Liunx 下载到本地计算机
> 这个命令工具在`xshell`是有效的,在`putty`是无效的

#### 检查安装

> `lrzsz`并不是 Linux 内置工具，需要进行外部的安装，对于系统上面是否已经安装了`lrzsz`,直接在命令行下输入`rz`或者`sz`,如果提示`command not found`那就是没有安装了

```
[root@localhost /]# rz
-bash: sz: command not found
```

#### 安装

> 在 Linux 里安装软件包有多种方式，这里简单介绍两种：

1. 使用`yum`查找`yum源`中的资源自动下载并安装
2. 解压`.gz`等源码压缩文件,使用`make && make install`进行编译安装
3. 对于一些大型软件包需要使用`rpm -i`(Red Hat Package Manager)进行安装

##### 1. 通过`yum`进行安装

> `yum`(全称为 Yellow dog Updater, Modified)是 Linux 前端软件包管理器,基於 RPM 包管理，能够从指定的服务器(Yum 源)自动下载 RPM 包并且安装，可以自动处理依赖性关系，并且一次安装所有依赖的软体包，无须繁琐地一次次下载、安装。

    -  `list` 软件包信息列表
    -  `install/reinstall` 安装软件包
    -  `remove` 移除已经安装的软件包

查看平台软件包信息：

```
[root@localhost bin]# yum list lrzsz
    Loaded plugins: fastestmirror
    Loading mirror speeds from cached hostfile
    * base: mirrors.ustc.edu.cn
    * extras: mirrors.163.com
    * updates: mirrors.ustc.edu.cn
Available Packages
lrzsz.x86_64                                      0.12.20-36.el7
```

可以看到`Available Packages` 的包信息是`lrzsz.x86_64 0.12.20-36.el7`,接下来就可以直接安装了，`-y`参数自动确认安装过程中的弹窗询问
`yum install -y lrzsz.x86_64`

```
[root@localhost bin]# yum install -y lrzsz.x86_64
    ...
Installed:
lrzsz.x86_64 0:0.12.20-36.el7
Complete!
```

到这里`lrzsz`就已经安装完成了，我们可以在命令行使用`rz`,`sz`了
<br/>

##### 2. 通过编译的方式安装

- 下载`lrzsz`的源码文件
  可以在 windows 先下载然后使用`yum`,`scp`或者`xftp`(工具)上传到 Linux，也可以使用`wget`直接在 Linux 上去[官网](https://www.ohse.de/uwe/software/lrzsz.html)下载：
  上传这里就不多说了，这里简单说一下`wget`下载

> `wget` 也不是 Linux 的内置执行程序需要安装 通过上述方式可以直接进行安装操作`yum install -y wget`,这里我们假设已经安装好了

`wget https://www.ohse.de/uwe/releases/lrzsz-0.12.20.tar.gz`

```
[root@localhost ~]# wget https://www.ohse.de/uwe/releases/lrzsz-0.12.20.tar.gz
    ...
    Length: 280938 (274K) [application/x-gzip]
    Saving to: ‘lrzsz-0.12.20.tar.gz’
    ...
```

待下载完成之后使用`ls` 就可以看到`lrzsz-0.12.20.tar.gz`已经下载完成

```
[root@localhost ~]# ll
total 1
-rw-r--r--. 1 root root 280938 Dec 31  1998 lrzsz-0.12.20.tar.gz
```

- 解压下载文件，`.gz`是压缩文件,需要使用`tar -xvf`解压
  `tar -zxvf lrzsz-0.12.20.tar.gz`

```
[root@localhost ~]# tar -xvf lrzsz-0.12.20.tar.gz
```

解压完成后使用`cd`进入文件夹

```
[root@localhost ~]# cd lrzsz-0.12.20.tar
```

- 配置安装路径
  `./configure`

```
[root@localhost lrzsz-0.12.20]# ./configure
creating cache ./config.cache
checking for a BSD compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking whether make sets ${MAKE}... yes
checking for working aclocal... missing
checking for working autoconf... missing
checking for working automake... missing
checking for working autoheader... missing
checking for working makeinfo... missing
checking for gcc... no
checking for cc... no
configure: error: no acceptable cc found in $PATH
```

如果报错`error: no acceptable cc found in $PATH`,是当前没有安装`gcc`(编译工具),使用`yum install -y gcc`,待`gcc`安装完成重新执行`./configure`继续配置安装路径

- 编译安装

> `make` 是编译的指令

`make && make install`

```
[root@localhost lrzsz-0.12.20]# make && make install
    ...
```

上面安装过程默认把 lsz 和 lrz 安装到了/usr/local/bin/目录下：

```
[root@localhost lrzsz-0.12.20]# cd /usr/local/bin
[root@localhost bin]# ls
lrb  lrx  lrz  lsb  lsx  lsz
```

到这里`lrzsz`就已经安装完成了，可以直接在`当前路径`使用`lrz`和`lsz`命令了，但这并不是我们想要的，想要在其他路径也能够使用，这样就需要配置`软连接`就可以了

- 创建软连接

`ln -s /usr/local/bin/lrz /bin/rz`

```
[root@localhost bin]# ln -s /usr/local/bin/lrz /bin/rz
[root@localhost bin]# ln -s /usr/local/bin/lsz /bin/sz
```

这样切换到任意路径就可以直接使用`rz`和`sz`命令了

<br/>
<br/>
<br/>

文章参考: <https://www.cnblogs.com/pipiyan/p/10471242.html/>
