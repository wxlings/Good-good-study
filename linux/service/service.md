什么是系统服务？服务是在后台运行的应用程序，并且可以提供一些本地系统或网络的功能。我们把这些应用程序称作服务，也就是 Service,有时也叫做 Daemon (守护进程)
比如，我们的 apache 服务，它是用来实现 Web 服务的。那么启动 apache 服务的进程是哪个进程呢？就是 httpd 这个守护进程（Daemon）。也就是说，守护进程就是服务在后台运行的真实进程。

> Linux 中常见的软件包有两种：一种是 RPM 包；另一种是源码包。通过 RPM 包安装的系统服务就是 RPM 包默认安装的服务（因为 Linux 光盘中全是 RPM 包，Linux 系统也是通过 RPM 包安装的，所以我们把 RPM 包又叫作系统默认包），通过源码包安装的系统服务就是源码包安装的服务。

区别:

1. 源码包是开源的，自定义性强，通过编译安装更加适合系统，但是安装速度较慢，编译时容易报错。RPM 包是经过编译的软件包，安装更快速，不易报错，但不再是开源的。
2. 最主要的区别就是安装位置不同，源码包安装到我们手工指定的位置当中，而 RPM 包安装到系统默认位置当中（可以通过"rpm -ql 包名"命令查询）。也就是说，RPM 包安装到系统默认位置，可以被服务管理命令识别；但是源码包安装到手工指定位置，当然就不能被服务管理命令识别了（可以手工修改为被服务管理命令识别）。

   ![参考](http://c.biancheng.net/uploads/allimg/181024/2-1Q02413195AP.jpg)
   **源码包安装的服务是不能被服务管理命令直接找到的，而且一般会安装到 /usr/local/ 目录中。**

查看已有服务的信息: 可以查看`/etc/services`文件

##### 查看服务是否已经启动

`netstat` 判断服务器中开启的服务还有其他方法（如通过 ps 命令），但是通过端口的方法查看最为准确

管理当前独立服务状态:
`/etc/init.d/`目录是系统的独立服务的程序所在目录,可以使用`ls /etc/init.d`来查看有哪些独立服务
`/etc/init.d/command [options]` 进行独立程序管理
`/etc/init.d/command --help` 查看帮助

`service`命令其实是脚本,在 centos7 以上会重定向到`systemctl`命令执行,同时它只是 Redhad 的产品脚本,其他版本的 Linux 可能就不能正常使用了(测试在 Ubuntu server 该命令有效)

```shell
    service network status
    service network restart
```

`servicectl` 命令是`service`的兼容升级

```shell
    systemctl status sshd
    systemctl restart ssh
```

- `start` 启动服务 command
- `top` 停止服务 command
- `restart` 重启服务 command
- `status` 查看服务状态
- `force-reload` 强行重新 load
