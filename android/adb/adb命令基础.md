### [官链](https://developer.android.google.cn/studio/command-line/adb?hl=zh_cn#issuingcommands)

 Android 调试桥 (`adb`) 是一种功能多样的命令行工具，可让您与设备进行通信。`adb` 命令可用于执行各种设备操作（例如安装和调试应用），并提供对 Unix shell（可用来在设备上运行各种命令）的访问权限。 

>  `adb`的使用需要保证Android设备开启调试模式，并且与`host`正常连接

安装`adb`下载：https://developer.android.google.cn/studio/releases/platform-tools?hl=zh-cn



### 常用

查看帮助： `adb help` ， `adb logcat help`

查看版本：`adb version`

开启`adb`服务：`adb start-server`

结束`adb`服务：`adb kill-server`

**查看设备连接：`adb devices -l`** 

>  **注意**：如果您在多个设备可用时发出命令但未指定目标设备，`adb` 会生成错误。 

如果多设备连接时需要指定具体设备，使用`-s serialNumber`

```

adb -s emulate-5554 push c:/a.text /sdcard/a.temp

```



### 文件复制/移动

 使用 `pull` 和 `push` 命令将文件复制到设备或从设备复制文件。 

命令语法`adb pull remote local `,`adb push local remote `

>  将 `local` 和 `remote` 替换为开发机器（本地）和设备（远程）上的目标文件/目录的路径。 

```

adb pull d:/a.png /sdcard/pc/a.png
adb push /sdcard/pc/a.png d:/b.png

```



### 安装应用

1. 使用  `install` 命令在模拟器或连接的设备上安装 `Apk`包

   命令语法： `adb install [options] <path/packageName>`

2. 使用 `uninstall`名利卸载指定设备上的安装包

   命令语法`adb uninstall [options] <packageName>`,如果使用`-k`则会保留该包的缓存数据

   > 详细参数参考下方`pm install/uninstall`命令

```

adb install -r c:/base.apk
adb uninstall wshifu.app.android 

```



### **`adb shell` **

通过`shell`(壳)命令可以进入Android内核环境（基于Linux），这时就可以使用大部分Linux命令了，例如：通过`ls -l` 来查看目录，通过`top`来查看当前正在运行的进程信息， 通过`touch`来创建文件等，具体支持的命令可以进入`/system/bin/`目录下查看可以存在的命令程序。 对于大多数命令，都可通过 `--help` 参数获得命令帮助。许多 shell 命令都由 [toybox](http://landley.net/toybox/) 提供。 



### 屏幕截图

 命令是一个用于对设备显示屏截取屏幕截图的 shell 实用程序。 `screencap /sdcard/fileName.png`

> 注意文件名仅支持`.png` 

```

adb shell screencap /sdcard/a.png

```



### 屏幕录制

` screenrecord ` 大部分真机不支持该命令



### [调用Activity管理器](https://developer.android.google.cn/studio/command-line/adb?hl=zh_cn#am)

 在 `adb shell` 中，您可以使用 Activity 管理器 (`am`) 工具发出命令以执行各种系统操作，如启动 Activity、强行停止进程、广播 intent、修改设备屏幕属性，等等 

命令语法： `adb shell am [options] <intent>`

> `am` 是`android shell`的特有命令，Linux是没有的

1. `start [options] <intent>`启动一个`android Activity`

2. `startService <intent>` 启动一个`android Service`

3. ` broadcast <intent>` 发送一个`android Broadcast`

4. ` monitor` 开始监听崩溃/`ANR`

5. ` force-stop <packageName>`  强行停止与 `package`关联的所有进程。 

   例如： 

   ```
   
   adb shell am monitor
   adb shell am force-stop wshifu.app.android
   
   ```

   

### [调用软件包管理器 ](https://developer.android.google.cn/studio/command-line/adb?hl=zh_cn#pm)

 使用软件包管理器 (`pm`) 工具发出命令，以对设备上安装的应用软件包执行操作和查询。 

命令语法：`adb shell pm [options] <intent>`

1. ` list packages [options] filter` 列出所有的应用包名

   `-s`系统应用，`-3`第三方应用， `-i`应用的安装程序

2. `install [options] <path>`安装指定路径下的`apk`包

   `-r`重新安装并保留数据，`-d`允许版本降级

3. `uninstall <packageName>`卸载指定包名名的应用

4. `clear <packageName>`清除指定包名的所有数据（实用）

   例如：

   ```
   
   adb shell pm list packages -3 com.huawei
   adb shell pm install -d -r d:/base.apk
   adb shell pm clear wshifu.app.android
   
   ```

   

### `Logcat`

 `Logcat` 是一个命令行工具，用于转储系统消息日志，包括设备抛出错误时的堆栈轨迹，以及从您的应用使用 `Log` 类写入的消息。 

 Android 日志记录系统是系统进程 `logd` 维护的一组结构化环形缓冲区。这组可用的缓冲区是固定的，并由系统定义。最相关的缓冲区为：`main`（用于存储大多数应用日志）、`system`（用于存储源自 Android 操作系统的消息）和 `crash`（用于存储崩溃日志）。每个日志条目都包含一个优先级（`VERBOSE`、`DEBUG`、`INFO`、`WARNING`、`ERROR` 或 `FATAL`）、一个标识日志来源的标记以及实际的日志消息。 

命令语法：`adb logcat [<option>] ... [<filter-spec>] ...`

`-b <buffier>` 指定缓冲区,包含`main`,`system`,`crash`,`radio`和`events`

`-c `|`--clear` 清除当前缓冲区（这个很重要，日志是存在系统的缓冲区，有历史数据）

`-e <expr>` 根据指定的`expr`表达式进行过滤

`--pid=<pid>`指定进程ID(重要，不然会输出所有的进程的香瓜信息)

`-s` 等同于`*:S`, 将所有标记的优先级设为“静默” ,这样可以使`tag/properties`生效（重要)

> 如果不适用`-s`|`*:S`那么会输出说有的日志信息，及通过`TAG/PROPERTIES`的过滤是无效的。所有如果指定`TAG/PROPERTIES`进行过滤必须加`-s` | `*:S`.

例如：

```

# 仅过滤 TAG=Sensor && LEVEL=ERROR || TAG=SA.SensorsDataAPI && LEVEL=INFO
adb shell logcat -s Sensor:E SA.SensorsDataAPI:I

```



`-v <format>`  设置日志消息的输出格式 

​	`-v color`不同级别显示不同颜色，`-v long` 日志使用空格分割, ...

> 注意：`-v` 仅接收第一个参数，如果多属性可以使用多个`-v <property>`

例如：

```

adb shell logcat -v color -v long -thread

```



##### 日志的过滤：

详细的日志过滤需要根据`TAG`和`LEVEL`行过滤. 

 优先级是以下字符值之一（按照从最低到最高优先级的顺序排列） 

- `V`：详细（最低优先级）

- `D`：调试

- `W`：警告

- `E`：错误

- `F`：严重错误

- `S`：静默（最高优先级，绝不会输出任何内容）

   过滤器表达式采用 `tag:priority ...` 格式，其中 `tag` 指示您感兴趣的标记，`priority` 指示可针对该标记报告的最低优先级。 

  例如：

```JAVA

adb logcat -s MainActivity:W test:E Sensor:E

// 原生端打印日志
Log.v(TAG, String)（详细）
Log.d(TAG, String)（调试）
Log.i(TAG, String)（信息）
Log.w(TAG, String)（警告）
Log.e(TAG, String)（错误）
    
```



  

一个日志输出脚本：

```

@echo off

chcp 65001
setlocal enabledelayedexpansion
set host=wshifu.app.android

for /f %%i in ('adb shell pidof %host%') do @set pid=%%i

@echo 当前应用进程ID:  %pid%
adb logcat -c
@echo 清空历史缓存数据

adb logcat --pid=%pid% -v color -v long -s Sensor:E SA.SensorsDataAPI:I 

pause 

```

