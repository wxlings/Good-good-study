Shell 是一个用 C 语言编写的程序，它是用户使用 Linux 的桥梁。Shell 既是一种命令语言，又是一种程序设计语言。
Ken Thompson 的 sh 是第一种 Unix Shell，Windows Explorer 是一个典型的图形界面 Shell。
业界所说的 shell 通常都是指 shell 脚本，
在一般情况下，人们并不区分 Bourne Shell 和 Bourne Again Shell，所以，像 #!/bin/sh，它同样也可以改为 #!/bin/bash。

`#!` 告诉系统其后路径所指定的程序即是解释此脚本文件的 Shell 程序。

**内容输出**
`echo -e` 打印内容到控制台,这与 php 极度相似,`-e`开启转义

```shell
    echo `date` #命令结果使用``
```

**变量声明与使用**
声明变量：直接声明变量名即可,注意变量名和赋值之间不能有空格,不像其他语言
使用变量：需要使用`$`或者`${}`对变量尽心包裹,`{}`可以是变量表达式

```shell
    message='Hello,shell'
    echo $message
    message='hello,world'
    echo ${message}
```

**只读变量:`readonly`**

> 声明后不再可重新赋值,类似`final`修饰

```shell
    readonly message='This is a readonly variable'
    message='temp'
    echo $message
```

**删除变量 `unset`**

> 对于`readonly`修饰的变量删除无效

```shell
    message='tmp'
    unset message
    echo $message
```

#### **字符串**

像 php,Java 语言一样字符串可以有`''`和`""`两种包裹方式,单引号不会解析内部引用,效率高;双引号会对内容进行解析,如果有变量引用会获取变量的实际值,相对单引号效率会低

```shell
    message='hello,world'
    echo 'this is a $message'
    echo "this is a $message"
```

**字符串拼接**

> 字符串的拼接不需要使用`+`等相关符号;对于双引号建议直接使用变量引用的方式,单引号只需要按顺序引用

```shell
    m='hello'
    e='world'
    echo "||$m$e//",,,,'@@'$m$e'##',
```

**字符串的长度`#`**

> 使用`${#variable_name}`

```shell
    message='Hello,world'
    echo ${#message}
```

**字符串字串**

> 使用`${variable_name:start_index:end_index}`

```shell
    message='Hello,world'
    echo 'echo ${message:5}'${message:5} # 获取由5至最后的子串
    echo 'echo ${message:2:5}'${message:2:5} # 获取2-5的子串
```

#### 数组

bash 仅仅支持一维数组
在 Shell 中，用括号来表示数组，数组元素用"空格"符号分割开

```shell
    persons=('Jack' 'Lee' 'Helin')
    persons[3]='Soun' # 对数组的元素赋值
    echo ${persons[2]} # 读取指定索引的元素值
    echo ${persons[@]} # @/* 读取所有的元素
    echo ${persons[*]}
    echo ${#persons[@]} # 读取所有的元素
    echo ${#persons[*]}
```

#### 传递参数

向脚本传递参数，脚本内获取参数的格式为：\$n。n 代表一个数字，1 为执行脚本的第一个参数，2 为执行脚本的第二个参数，以此类推……
如果脚本没有可执行权限,请使用:`chmod +x script_name.sh`
`$#` 传递到脚本的参数个数
`$*` 以一个单字符串显示所有向脚本传递的参数。
如"$*"用「"」括起来的情况、以"$1 $2 … $n"的形式输出所有参数。
`$$` 脚本运行的当前进程 ID 号

```shell
    # 假设我们创建脚本文件
    echo "传入参数的length:$#,具体内容:$*"
    echo '第一个参数:'$1
    echo "第二个参数长度:${#2}"
```

#### printf 命令

printf 命令模仿 C 程序库（library）里的 printf() 程序。

`printf [format-string] [args]`

```shell
    printf `%s %d\n` '123' '123'
```

#### [基本运算符](https://www.runoob.com/linux/linux-shell-basic-operators.html)

Shell 和其他编程语言一样，支持多种运算符，包括：

`算数运算符`,`关系运算符`,`布尔运算符`,`字符串运算符`,`文件测试运算符`
原生 bash 不支持简单的数学运算，但是可以通过其他命令来实现，例如 awk 和 expr，expr 最常用。expr 是一款表达式计算工具，使用它能完成表达式的求值操作。
**所有的表达式都需要使用空格隔开**

**算数运算符**
支持`+`,`-`,`\*`,`/`,`%`,`==`,`!=`,`=` 注意:乘法需要使用`\*`

```shell
    a=23
    b=52
    echo `expr $a + $b`
    echo `expr $a \* $b`
```

**关系运算符**
关系运算符只支持数字，不支持字符串，除非字符串的值是数字。

`-eq` 检测两个数是否相等，相等返回 true `==`
`-ne` 检测两个数是否不相等，不相等返回 true `!=`
`-gt` 检测左边的数是否大于右边的，如果是，则返回 true `a > b`
`-lt` 检测左边的数是否小于右边的，如果是，则返回 true `a < b`
`-ge` 检测左边的数是否大于等于右边的，如果是，则返回 true `a >= b`
`-le` 检测左边的数是否小于等于右边的，如果是，则返回 true `a <= b`

**字符串运算符**

**逻辑运算符**
支持使用`&&`,`||`

#### 流程控制

`if` 逻辑:

```shell
if condition
then
    clause
elif condition
then
    clause
else
    clause
fi

# 例如:
if [ $(ps -ef | grep -c "ssh") -gt 1 ]; then echo "true"; fi
```

`for` 循环:

```shell
# 遍历一组数据
for item in 1 2 3 4 5 6
    do echo item
done
# 遍历一个数组
people=('hello' 'world' '@@')
for item in ${people[*]}
    do echo item
done
```

while 逻辑: 与`for`类似

```shell
while condition
    do clause
done
```

case 逻辑:
这个是与

#### Shell 函数

shell 可以用户定义函数，然后在 shell 脚本中可以随便调用。
可以使用`function`进行修饰,当然也可以不声明

```shell
    # 创建脚本文件`common.sh`
    # 声明一个简单的函数
    function show(){
        echo 'This is a function!'
    }
    # 声明一个有返回数据的函数
    calculate(){
        echo '请输入一个数字：'
        read a # 由控制台获取数据
        echo '再次输入一个数字'
        read b
        return $(($a + $b)) # 返回两个数的和
    }



    # 在当前脚本文件中
    source ./common.sh
    show # 直接调用
    calcalate
    echo "你的理想数字:$?"
```

##### SHELL 输入/输出重定向

一个命令通常从一个叫标准输入的地方读取输入，默认情况下，这恰好是你的终端。同样，一个命令通常将其输出写入到标准输出，默认情况下，这也是你的终端。
`command > file` 内容输出重定向到 file ,默认覆盖原有内容
`command < file` 内容输入重定向到 file
`command >> file` 将输出内容以追加的方式重定向到 file

一般情况下，每个 Unix/Linux 命令运行时都会打开三个文件：

标准输入文件(stdin)：stdin 的文件描述符为 0，Unix 程序默认从 stdin 读取数据。
标准输出文件(stdout)：stdout 的文件描述符为 1，Unix 程序默认向 stdout 输出数据。
标准错误文件(stderr)：stderr 的文件描述符为 2，Unix 程序会向 stderr 流中写入错误信息。

什么叫重定向?举个栗子

重定向输出:

```shell
    # 假设我们有一个文件叫做`readme.md`,文件有一些内容
    cat readme.md
    # 控制台会打印文件的内容...
    cat readme.md >> temp.txt
    # 这样控制台就没有任何输出,所有的内容都写到temp.txt文件中了
```

重定向输入:

```shell
    # 假设我们有一个文件叫做`readme.md`,文件有一些内容
    wc -l readme.md # wc -l 获取文件的行数
    # 48 readme.md
    wc -l < readme.md
    # 48
    # 混合使用:把指定的输入重定向输出文件
    wc -l < readme.mc > temp.line
```

重定向错误文件:
`command 2 >> file`

#### Shell 文件包含

Shell 也可以包含外部脚本。这样可以很方便的封装一些公用的代码作为一个独立的文件。基本语法和 php 相似
包含(引入)其他脚本文件两种方式:

1. 使用`.`,例如:`. common.sh`
2. 使用`source` ,例如: `source common.sh`
   包含其他脚本文件后就可以直接使用变量了
