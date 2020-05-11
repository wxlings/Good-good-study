ssh命令是openssh套件中的客户端连接工具，可以给予ssh加密协议实现安全的远程登录服务器，实现对服务器的远程管理


Client:
这里需要使用支持`bash`工具，建议使用`Git`客户端，以下假设已经安装了`Git`；

1. 进入系统的`home`目录（系统都有`home`路径的概念,也就是`~`）
```shell
    cd ~ 
```

2. 生成公/私钥：可以使用'-C'参数
> `ssh-keygen`安装了`git`就可以使用了
- `-t` type 指定加密类型,支持：`rsa`,`dsa`,`ecdsa`,...
- `-f` file 指定文件名
- `-C` comment 增加备注

```shell
    ssh-keygen -t rsa -C 'emai@**.com'
    ls ./ssh
    `id_rsa` #私钥
    `id_rsa.pub` #公钥 
```

创建过程中会给出一些数据输入确认，可以输入，也可以直接回车下一步，完成会自动创建`./ssh`隐藏文件

3. 复制公钥
```shell
    cd ~./ssh
    cat id_rsa.pub
```
可以直接复制内容然后使用`shell`连接，也可以把文件上传到Linux，然后在操作


Server:
1. 检查`sshd`状态：
> 如果没有安装进行第2步，如果已经安装没有启动服务执行第3步
```shell
    systemctl status sshd # 也可以使用 `service ssh start`,'systemctl'是'service'的兼容版，都是脚本
```
2. 安装`openssh`（以下方式二选一）
```shell
    # centos
    sudo yum install ssh 
    # ubuntu
    sudo apt install ssh 
```
3. 启动`openssh`服务
```shell
    sudo systemctl start ssh 
```
4. 保存指定的公钥到`authorized_keys`文件
> 切换到连接用户的`home`路径，找到`authorized_keys`文件，如果没有则新建一个即可，然后保存客户端的公钥即可
```shell
    cd ~
    vi authorized_keys
```

这样在客户端就可以使用`bash`工具链接linux了
`ssh linux_user_name@host_ip [options]`

```shell
    ssh admin@192.168.101.13 
```