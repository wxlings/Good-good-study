> Android 调试桥 (adb) 是一种功能多样的命令行工具，可让您与设备进行通信。adb 命令可用于执行各种设备操作（例如安装和调试应用），并提供对 Unix shell（可用来在设备上运行各种命令）的访问权限。它是一种客户端-服务器程序，包括以下三个组件：

- **客户端：** 用于发送命令。客户端在开发计算机上运行。您可以通过发出 adb 命令来从命令行终端调用客户端。
- **守护进程 (adbd)：** 在设备上运行命令。守护进程在每个设备上作为后台进程运行。
- **服务器：** 管理客户端和守护进程之间的通信。服务器在开发机器上作为后台进程运行。

#### adb 下载与安装:

> 如果经常使用`adb`工具，强烈建议把 adb 运行路径配置到系统的运行环境中

1. 如果你安装了`android`开发环境，那么你可以直接打开`Android sdk`的安装路径,找到文件夹`android_sdk/platform-tools/`,就可以找到`adb.exe`，然后通过命令行模式使用`adb`命令了；
2. 当然也支持下载`adb`独立程序，请点击[下载](https://developer.android.google.cn/studio/releases/platform-tools "adb下载")；下载完成后解压并进入目录即可;

#### adb 工作原理

当启动某个 adb 客户端时，客户端会先检查是否有 adb 服务器进程正在运行。如果没有，它将启动服务器进程。**服务器在启动后会与本地 TCP 端口 5037 绑定，并监听 adb 客户端发出的命令 - 所有 adb 客户端均通过端口 5037 与 adb 服务器通信。**

```
C:\Users\admin>adb start-server
* daemon not running; starting now at tcp:5037
* daemon started successfully
```

然后，服务器会与所有正在运行的设备建立连接。它通过扫描 5555 到 5585 之间（该范围供前 16 个模拟器使用）的奇数号端口查找模拟器。服务器一旦发现 adb 守护进程 (adbd)，便会与相应的端口建立连接。请注意，**每个模拟器都使用一对按顺序排列的端口 - 用于控制台连接的偶数号端口和用于 adb 连接的奇数号端口**。例如：

    模拟器 1，控制台：5554
    模拟器 1，adb：5555
    模拟器 2，控制台：5556
    模拟器 2，adb：5557
    依此类推

如上所示，在端口 5555 处与 adb 连接的模拟器与控制台监听端口为 5554 的模拟器是同一个。

服务器与所有设备均建立连接后，您便可以使用 adb 命令访问这些设备。由于服务器管理与设备的连接，并处理来自多个 adb 客户端的命令，因此您可以从任意客户端（或从某个脚本）控制任意设备。

#### 在设备上启动 ADB 调试

想要连接 Android 设备并使用`adb`命令必须在设备的系统设置中`启用USB调试`（位于开发者选项下）
在搭载 Android 4.2 及更高版本的设备上，`开发者选项`屏幕默认情况下处于隐藏状态。如需将其显示出来，请依次转到`设置` > `关于手机`，然后点按`版本号`七次。返回上一屏幕，在底部可以找到`开发者选项`进入该页面打开`USB调试`即可。

> 部分机型还要修改`USB连接方式`为`传输文件`模式,才可以正常连接

#### 通过 adb 服务连接 Android 设备

通常连接 Android 设备我们都是通过 USB 数据线进行连接，这是被大家周知的；在确保设备打开了调试模式的前提，连接设备后计算机会自动检测 usb 驱动进行适配连接，然后屏幕右下角会给出相对应的弹窗提示；
然后使用命令行终端进行连接状态查看：`adb devices`(如果没有把`adb.exe`配置到系统的环境变量中操作台会提示‘没有 adb 命令'等类似错误信息，那就只能切换到`adb.exe`所在目录再试，例如命令行输入`cd d:/sdk/platform-tools/`)

```
C:\Users\admin>cd /d d:\adb\
D:\adb> adb devices
UYT7N17A28000401        device
```

除了线连以外还可以使用`wlan`的方式进行连接，需要在通过 USB 完成一些初始设置后通过 WLAN 使用 adb：

1. 将 Android 设备和 adb 主机连接到这两者都可以访问的同一 WLAN 网络。请注意，并非所有接入点都适用；您可能需要使用防火墙已正确配置为支持 adb 的接入点。
2. 如果您要连接到 Wear OS 设备，请关闭与该设备配对的手机上的蓝牙。
3. 使用 USB 数据线将设备连接到主机。
4. 设置目标设备以监听端口 5555 上的 TCP/IP 连接。

```
    adb tcpip 5555
```

5. 拔掉连接目标设备的 USB 数据线。
6. 找到 Android 设备的 IP 地址。例如，对于 Nexus 设备，您可以在设置 > 关于平板电脑（或关于手机）> 状态 > IP 地址下找到 IP 地址.
7. 通过 IP 地址连接到设备。

```
    adb connect 192.168.***.***
```

8. 确认主机连接状态：

```
    adb devices
```

**如果连接过程中断开了，在确保设备和连接计算机在同一网络中后，可以使用`adb connect [*:port]`进行重新连接，如果还没有解决问题，那就重置一下 adb 服务 `adb kill-server` （与启动服务相对应`start-server`,注意没有'restart-server'操作）重新开始 adb 连接流程**

#### 常用的 adb 命令 [更多详细命令](https://developer.android.google.cn/studio/command-line/adb.html#-t-option 官方介绍)

- `adb --help` 有问题找助手

* `adb start-server` 启动 adb 服务
* `adb kill-server` 停止 adb 服务，通常与`adb start-server`联合做重启服务使用

* `adb reboot [bootloader | recovery]` 重启 Android 设备（刷机模式|恢复模式）注意：由于很多品牌商对系统的修改的原因`刷机模式`可能不能正常启动

* `adb pull <device> <host>` 拉取 Android 设备上的文件到本地主机，注意本地文件路径不能是根目录，例如：
  ```
    adb pull -s WOSWRKP799999999 /sdcard/storage/user.txt d:/adb/
  ```
* `adb push <host> <device>` 复制本地主机文件并推送到 Android 设备，如果指定目标文件名已经存在会替换已有文件，例如：

  ```
    adb push d:/adb/hello.png /sdcard/temp.png
  ```

* `adb devices [-l]` 查看连接 adb 服务的设备列表，参数 `-l` 仅返回在线设备
* `adb -s <WOSWRKP799999999> [command]` 如果主机连接有多台设备，想要给指定的设备发命令请用`-s`指定该设备的标识，如果多设备时没有使用`-s`的话 adb 会报错 s

* `adb install [options] <**.apk>` 使用`install`进行安装指定路径的 apk 文件；
  `options` 可以包含：
  1.  `-r` 重新安装当前 apk 文件，保留已有数据
  2.  `-t` 允许安装测试 apk 文件
  3.  `-g` 授权所有清单文件
* `adb unistall [-k] <package>` 使用`uninstall`进行指定包名卸载，参数`-k`清除文件

* `adb shell dumpsys package <package>` 查看 app 的相关信息 `重要，重要`

#### 连接 shell

`adb shell` 使用 shell 命令通过 adb 发出设备命令，也可以启动交互式 shell;（连接设备 shell）连接后简单理解直接在 Android 设备上使用命令行，这时就可以使用一些`unix`的命令,当然会有很多命令是不能执行的，因为它们被厂商`阉割`掉了，这种`阉割`在不同厂商、不同版本的表现还不一致，还有一些是因为 Android 内核的安全策略限制引起的；可以使用`adb shell ls /system/bin`进行查看可以使用的`unix`命令

> 对于`shell`的操作可以一条一条的进行执行，例如： `adb shell pwd`,`adb shell ls`,`adb shell ...`,也可以直接进入`shell`然后统一操作
> 如果要退出`shell`界面，可以使用`ctrl + d` 使用 `exit` 命令也可以
> 注意：部分需要有 root 权限才可以执行

#### 调用 Activity 管理器(am)

了解更多请[点击](https://developer.android.google.cn/studio/command-line/adb.html#am "官网")

出命令以执行各种系统操作，如启动 Activity、强行停止进程、广播 intent、修改设备屏幕属性，等等
`am <command [options]>` 是`shell`内部命令，需要结合`adb shell`进行使用,例如：

```
    adb shell am start -a android.intent.action.VIEW
```

- `start [options] <intent>` 启动由'intent'指定的 Activity
  1. `-d` 启动调试功能
  2. `-S`：在启动 Activity 前，强行停止目标应用
  3. `--start-profiler <file>`：启动分析器并将结果发送至 file。
- `startService [options] <intent>` 启动由'intent'指定的 service
- `broadcast [options] <intent>` 发出广播 intent。
- `force-stop <package>` 强行停止与 package 相关的进程
- `kill <package>` 终止与 package 相关的进程，仅终止可安全终止且不会影响用户体验的进程
- `kill-all` 终止所有后天进程
- `monitor --gdb` 开始监控崩溃/anr
- `dumpheap <process> <file>` 转储 process 的堆，存入到 file
- `profile start <process> <file>` 开始分析进程并保存到日志
- `profile stop <process>` 停止分析进程
- `instrument [options] <component>` 使用 [Instrumentation](https://developer.android.google.cn/reference/android/app/Instrumentation) 实例启动监控。通常情况下，目标 component 采用 test_package/runner_class 格式。

#### 调用软件包管理器(pm)

了解更多请[点击](https://developer.android.google.cn/studio/command-line/adb.html#pm "官网")

在 adb shell 中，您可以使用软件包管理器 (pm) 工具发出命令，以对设备上安装的应用软件包执行操作和查询。
`pm <command [options]>` 也是`shell`内部命令，也是需要结合`adb shell`进行使用,例如：

```
    adb shell pm uninstall -k <package> // 使用包管理器卸载指定的包名应用
```

- `list package [options] <filter>` 输出所有软件包，或者，仅输出软件包名称包含 filter 中的文本的软件包。

  1. `-s`：进行过滤以仅显示系统软件包。
  2. `-3`：进行过滤以仅显示第三方软件包。
  3. `-e`：进行过滤以仅显示已启用的软件包.
  4. `-d`：进行过滤以仅显示已停用的软件包。
  5. `-i`：查看软件包的安装程序。

  ```
    adb shell pm list packages -3 -i com.tencent
    adb shell pm list packages | grep com.tencent
  ```

- `list permission-groups` 输出所有已知的权限组
- `install [options] <**.apk>` 同上
- `uninstall -k <package>` 卸载指定的包名的应用
- `clear <package>` 清除指定包名的应用的所有数据，与刚安装完的状态相同

#### 查看系统信息

- `adb shell dumpsys meminfo <package>` 查看当前包运行的内存情况

#### 查系统日志

`logcat [options]` 可以获取到系统的日志信息，需要结合`adb shell`进行使用
详细请[点击](https://developer.android.google.cn/studio/command-line/logcat#filteringOutput "官网")

- `-b` log 模块有个缓存的概念，默认开启`main`,`system`,和`crash`三个缓存域，但是华为 mate10 默认并没有加载`crash`,这个缓存域有一个策略周期性清除
- `-c` 清除（清空）所选的缓冲区并退出，默认缓冲区集为 main、system 和 crash。要清除所有缓冲区，请使用 -b all -c。
- `f </sdcard/file>` 把当前日志或缓存域日志信息报存到文件
- `-s [TAG:property]` 设置日志过滤条件，在 Android 打印的使用：

```
  Log.e(TAG,'content') // 日志级别分为'v':'verbose','d':'debug','i':'info','w':'warn','e':'error'
  adb shell logcat -s SplashActivity:E -f /sdcard/log.txt // 打印`Log.e()`的日志信息
```

打印的格式是 `date time process_id-thread-id/package-name log-level/TAG: content` ,在设置过滤的时候通过`-s`控制`TAG`和日志级别
例如：`W/MainActivity` 要符合`*:TAG`,其中级别分别对应原生级别大写首字母：`V`,`I`,`D`,`W`,`E`

- `-S` 在输出中包含统计信息，以帮助您识别和定位日志垃圾信息发送者。
- `-P <whiteList ~blackList>` 设置日志过滤的白名单和黑名单，白名单"list" 就是进程 pid 及 uid ，黑明单就是前面加上"~"

#### 调用设备政策管理器 (dpm)

`adb shell dpm <command>`为便于开发和测试设备管理（或其他企业）应用，您可以向设备政策管理器 (dpm) 工具发出命令。使用该工具可控制活动管理应用，或更改设备上的政策状态数据。

> 由于用到的比较少，了解更多请[点击](https://developer.android.google.cn/studio/command-line/adb.html#dpm "官网")

#### 截取屏幕图片

`screencap /sdcard/.../**.png` 命令是一个用于对设备显示屏截取屏幕截图的 shell 实用程序,例如：

```
    $adb shell
    shell@ $ screencap /sdcard/screen.png
    shell@ $ exit
    $adb pull /sdcard/screen.png d:/adb/
```

#### 录制视频

`screenrecord [options] /sdcard/.../**.mp4` 命令是一个用于录制设备（搭载 Android 4.4（API 级别 19）及更高版本）显示屏的 shell 实用程序。该实用程序将屏幕 Activity 录制为 MPEG-4 文件。

> 注意：在很多真机上面改命令被移除或者改名了，比如在`华为Mate10 /system/bin`目录下是没有这个可执行程序的

- `--help` 帮助
- `--size <width>*<height>` 设置视频的分辨率,默认是 1280\*720
- `--time-limit <time>` 设置视频最大时长，以秒为单位，默认值和最大值均为 180s(3 分钟)
- `--bit-rate <rate>` 设置视频的比特率（MB/s)，默认 4M/s,例如设置 6M/s：

  ```
    screenrecord --bit-rate 6000000 /sdcard/demo.mp4
  ```

- `--verbose` 打印录制相关信息

例如：

```
    $adb shell
    shell@ $ screenrecord --size 1920*1080 --time-limit 30 --verbose /sccard/video.mp4
    shell@ $ exit
    $adb pull /sdcard/video.mp4 d:/adb/

```

#### sqlite

`sqlite3` 可启动用于检查 sqlite 数据库的 sqlite 命令行程序。它包含用于输出表格内容的 .dump 以及用于输出现有表格的 SQL CREATE 语句的 .schema 等命令。
了解详细[sqlite3 相关命令](https://www.sqlite.org/cli.html "官网")

> 注意：在很多真机上该命令都被移除或者改名了，比如在`华为Mate10`目录下是没有这个可执行程序的

```
    $adb shell
    shell@ $ sqlite3 /data/data/com.example/databases/test.db // 真机通常会被系统权限控制拒绝访问
    shell@ $ .tables
    shell@ $ CREATE TABLE test(id INT(4) AUTO_INCREMENT PRIMARY KEY,name VARCHAR(30) NOT NULL,...)

```

> 汇总:

`adb start-server` 开启 adb 服务
`adb kill-server` 结束 adb 服务
`adb devices` 列出所有设备列表
`adb -s <****> [command]` 对指定的设备执行命令
`adb reboot [options]` 重启设备,可选参数:`bootloader`=> 刷卡界面 `recovery`=> 恢复模式;
`adb install [options] <***.apk>` 安装 apk 文件 ,可选参数:`-r`=> 覆盖安装
`adb uninstall [-k] <package` 卸载指定包名的 apk ,参数:`-k`=> 清除相关缓存
`adb push <SOURCE> <DIST>` 推送并复制本地计算机文件 (source) 到 Android 设备指定路径下 (dist)
`adb pull <SOURCE> <DIST>` 拉取并复制 Android 设备文件 (source) 到本地计算机 指定路径下 (dist)
`adb shell` 进入设备的`shell`层,可以使用`exit`退出

###### `pm` Android 设备包管理器

`pm list package [opitons] <filter>` 列出并过滤已经安装的包名应用程序,参数:`-3`=> 第三方应用程序,`-s`=> 系统的应用程序,`-i` => 软件包的安装程序 例如:`adb shell pm list -i package com.tencent`
`pm clear <package>` 清除指定包名的应用程序的数据(和第一次安装的状态相同)
`pm install <package>` 及 `pm uninstall [-k] <package>` 与上面相同

###### `am` Android 设备程序(ActivityManagerService)管理器

`am [options]`
`am start <intent>` 启动指定 intent 的 Activity
`am startService <intent>` 启动指定 intent 的 service
`am broadcast intent>` 发送指定 intent 的广播
`am force-stop <package>` 强制停止和指定包名关联的进程

`adb shell screencap /sdcard/.../**.jpg` 截取屏幕,可以使用`adb shell ls -l /sdcard/...**.jpg`进行结果查看
`adb shell screenrecord [options] /sdcard/.../**.MP4` 部分机该命令被阉割,录制屏幕默认 180s 时间,可以使用`ctrl + c`停止,options: `--limit-time`=> 设置录制时长, `--size WIDTHxHEIGHT`=> 指定视频的分辨率
`adb shell logcat [options]` 获取系统的日志,options: `-s <TAG/LEVEL>`=> 对日志进行过滤,需要满足格式`MainActivity/E`,`-P`=> 设置日志过滤的白名单,指定应用的进程 id
