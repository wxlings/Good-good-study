print("hello,world")
# python终端: 安装python后配置环境变量即可;
# `>>>` 表示主输入标识 ,`...` 标识继续输入标识, python 对代码首部对其要求严格,如果是次级代码块一定要使用`tab`做标识;

# 终端计算器: 支持 +,-,*,/,%,//,**...等 `//`表示除法取整,`**`表示取乘方 如果在终端中不需要使用print()函数
print(100+100) # 加法
print(100-100) # 减法
print(100*100) # 乘法
print(100/100) # 除法
print(100%23) # 取余数
print(100//23) # 取商数 
print(100**2) # 幂函数
print(pow(100,2)) # 幂函数
print(abs(-100)) # 绝对值
print(int(13.14)) #转为整数
print(float(1314)) # 转为float
print(str(1000)) # 转为s


# 数据类型: 
# 1. 内置类型: 字符串(string),数值整型(integer),数值浮点型(float),布尔类型(True/False)
# 2. 引用类型: 对象,数组...
#  变量声明: 直接声明变量,不需要指定类型
str = "This is a str!" 
int = 1024
float = 520.1314
bool = True

# 字符串: python中也可以把字符串的实现是char数组,\
# python中字符出也是不可变的 
# 声明: 可以使用单引号,也可以使用双引号,还可以使用三重引号即保持原有格式

str = "Hello,world @@ !!"
# 获取指定index的字符,如果inex<0 ,以反方向计算index
char = str[5] 
char = str[-3]
print(char) 
# 获取指定index区间的字串,如果inex<0 ,以反方向计算index
sub = str[2:5] 
sub = str[:5]
sub = str[5:]
print(sub)
# 字符串拼接可以使用 `+`
add = "New + str :" + char + sub 
print(add)
# 获取字符串或者数组的长度
length = len(str)
print(length)
# 替换,可以增加替换次数参数
replace = str.replace("@@","$%^+")
replace = str.replace("@","$%^+",1)
print(replace)
# 比较
new = "hello,world!!"
print(str == new)
# 是否以...结束
end = str.endswith("!")
print(end)
#保留原有的格式
str  = """
        Title
    This is content !@!
.......................
.......................
"""
print(str)