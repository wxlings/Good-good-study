# 执行python脚本 使用：python *.py 即可
# python解释型语言：python res code -> interpreter -> can run code 官方说python也是面向对象的编程语言
# python中使用#进行注释
length = len("list") # 返回字符串或者数组的长度
strs = str(1000) # 返回数据的字符串形式值,可传入number,boolean,list,... 如果需要与字符串类型数据拼接处理一定要转换
i = int("20")
print("example",str(length) ," | " +  strs) #python3.x 以后 print后面必须使用（）包裹要打印的内容,可以打印大类型的值例如:list,number,boolean等


# 声明变量：python声明变量不需要指定变量的数据类型,直接申明变量名然后进行赋值即可(python 会自动推断类型)
# 同样python命名时注意不能够使用数字开始，建议使用驼峰命名
# python 中有四种基本变量类型：integer(whole numbers)、string(text)、boolean(True/False)、float of integer(floating point numbers)
# python 变量的作用域也遵循正常的全局变量和局部变量的逻辑
name = "wxling" 
age = 18
weight = 68.66
isMale = True   # False python中的写法：True和False首字母需要大写

# str() 把integer，float，boolean转到string类型；
# int() 把string转到integer(本身一定是number的整型形式，不然报异常)  例如：print(int("12"))  
# float() 把string转到float of integer(本身一定是number的整型形式，不然报异常)  例如：print(float("12")) 或者 print(float("12.20")) 
# bool() 返回内容的bool值; 注意bool("False") 为真值，在处理string类型时候只有str=""为Fasle，其余均为True,在处理number时所有非零的值均为True
def print_info():
    # print("name:"+ name + " age:" + age + " weight:" + weight); #不支持直接把字符串和数字进行拼接,不用的类型不能直接操作 需要转型
    print(int("12"))
    print(float("12"))  # 12.0
    print(float("12.12")) # 12.12
    print(bool(" ")) # True
    print(bool(0)) # False
    print(bool(0.0))
    print(bool("False")) # True
    print("name: " + name + "\nmale: " + str(isMale) + "\nage: " + str(age) + "\nweight: " + str(weight) + "kg")
    
#  对于字符串同样支持:%s (字符串) %d (整型)
def string_fun():
    variable = "Hello,world !!" # define string 同样python在声明字符串时要使用双引号进行标识
    variable = "Hello,world !! %s" %"@#$%^*&" # 这里有点类似%s做为一个引用
    print(variable)
    char = variable[5]  #获取字符串指定索引位置的字符值
    print("char:" + char) # 纯字符串类型的数据可以使用"+"进行拼接
    sub = variable[4:7] #取指定位标之间的子串，区间不闭合  这种写法类似java的subStr()方法  也可用于list数组：依据原有的字符串变量或者数组给出指定的位标生成新的字串或者子数组，原有数据保持不变
    print("sub:" + sub)
    sub_extend = variable[:5] #取0-指定位标之间的字串，区间不闭合
    print("sub_extend:" + sub_extend)
    
    replace = variable.replace("world","wxlife") #替换指定的字段内容(生成新的值,原有值保持不变)
    print("replace word: " + replace)
    replace = variable.replace("!","^",1) # 参数3表示替换的次数,如果有多个从前向后累计次数
    print("replace add params of three: " + replace)

    find = variable.find("world")   #查找并返回其所在索引,如果没找到返回-1
    print("find word:"+str(find))
    find = variable.find("o",6)    #可以指定在索引的范围区间内查找
    print("find with params of two: %s" % str(find))

    if "wxling" in variable:    #var in variable 就是判断是否包含
        print("The variable contain \'wxling\'")
    elif "wxling" == variable:
        print ("wxling == " + variable)
    else:
        print("The variable don`t contain \'wxling\'")

    words = ["My","name","is","wxlife","!!"] # join 使用指定的字符标识把一个数组拼接为字符串
    join = "-".join(words)   #使用'-'作为间隔符把数组拼接为字符串 //My-name-is-wxlife-!!
    print("join:" + join)
    join_extend = (name,str(isMale),str(age),str(weight)) #使用括号把str包裹起来,这种形式不用于数组
    print(join_extend)
    print(" ".join(join_extend))
    
    li= variable.split(",") # 把字符串通过某种标识分割成数组
    print("list:" + str(li))
    print("list.len:"+ str(len(li)))
    strs = variable.split() # split 和 join 基本相反
    print(strs)  # 默认不指定具体的分割标识符，会以单词为节点

    print(list(variable)) #适用于把字符串直接分割为数组
    return

# 随机数需要导入module
def random_fun():
    import random
    print(random.random()) # 随机浮点数  基本没有这样的需求
    print(random.randrange(0,100)) #指定范围内的随机整数
    print(random.uniform(0,15)) #指定范围内的随机浮点数

#终端、控制台输入：如果是python2.x使用raw_input()
def input_fun():
    inp = input("请输入你的钟意数字:") # 变量inp是输入的变量
    if inp == "admin":   # 注意if-else的语法结构使用:==, !=, >=, <=  条件可以使用 or 、 and
       print("验证通过!!")
    elif int(inp) <= 10:
       print(inp)
    else:
        li = list(inp)
        print(li)
        for i in li:  # 遍历数组使用 for <item> in <list>与js相同,while和Java相同
            print(i)
    return inp  #如果函数需要返回值直接使用return 如果没有返回不要使用，不要声明返回值类型

#list 及其他语言的数组
def list_fun():
    li = []
    li = [1,3,4,6,4,7,8,2,3]
    for item in li:  #使用for...in ...遍历数组
        print(item)

    print(sum(li))
    print(min(li))
    print(max(li))

    print(li[0])    #返回数组中指定index的元素值,默认从0开始
    print(li[-1])   #如果是负数的话相当于从后向前计算
    
    li.append(110)  #数组向后面增加元素使用append()
    li.append(112)
    li.append(119)
    print(li)
    li.pop()    #移除数组的最后一个元素
    print(li)

    strs = ["my","name","is","an","Boy"]
    strs.sort()   #sort()数组排序,number类型按照从小到大，字符型按照字典排序·
    print(strs)

    strsre = reversed(strs) # 反转排序这个数组的内容，本身应该是一个对象的概念
    print(list(strsre))
    stsbest = strs[::-1] #官方说最优秀的反转排序方式
    print(stsbest)

    nums = [ ("name","wxling"),("age",7),("gender","male"),("info","高富帅")]  # 这是二维数组么？不是
    print(nums)

    sub = nums[1:2]
    print(sub)

    print(range(100))
    # li = list(range(100))
    l = list(range(50,100))
    print(l)

# python 中的dict就是对象的概念，调用时和js完全一样,简单理解就是一个（key：value）的list集合
def dict_fun():
    info = {"name":"wxling","age":18}
    info["BMP"] = "Bitmap"
    info["BTW"] = "By The Way"
    info["BRB"] = "Be Right Back"

    print(info["age"])
    print(info)
    for key in info:
        print(key + ":" + str(info[key]))  # python 中对数据类型操作时敏感

# 读写文件都是python的基础模块，不需要导入任何资源包
# 不论读取文件还是写入文件：使用file = open("file_name",["params"])函数,进行打开文件并返回一个文件资源引用，这里和php相似，操作完成后一定要调用资源文件file.close()
# python读取文件有两种形式：
#   1. 一行一行的读取，最终会以行（hang）为单元保存到一个数组里面（即一行作为数组的一个元素）；
#   2. 一个块级别的方式读取，适用于二进制文件
def read_file_fun():
    file_name = "../kuaidi100/debugtalk.py"
    with open(file_name) as file:  # open（）创建或者打开一个文件
        content = file.readlines()
        print(content)

    print("\n--------------------一条完美的分割线----------------------\n")

    file = open(file_name,"r")  # 以文本实际内容的的形式展现，保留文件的内部样式，记住用完后要关闭文件流
    result = file.read()
    file.close()
    print(result)

# 读取文件时：打开文件使用open()函数，打开开始使用资源readlines()或者加参数“r”使用read(),写文件时使用write（）函数，如果替换原有文件open时使用“w”，如果继续写入open时使用“a”参数 
def write_file_fun():
    file = open("file.log" ,"a")    #append继续写入文件
    # file = open("file.log" ,"w") #清除原有记录
    file.write("# 这是一个文档的注释@@@")
    info = "姓名：" + name + "\n性别：男 " + "\n年龄：" + str(age)  + "\n体重:" + str(weight) + "kg"
    file.write(info)
    result = "结束语：再见！！"
    file.write(result)
    file.close()

    file = open("file.log")
    data = file.read()
    file.close()
    print(data)

# python最牛逼的地方，一次可以放回多个变量，句官方文档说次功能独此一语言有，其他language都没有
# 在接受数据的地方变量的顺序要一致
def multe_variable_return_fun():
    info = "性别：男 " + "体重:" + str(weight) + "kg"
    return name,age,weight,info


# python中time不是标准库,需要导入"import time"
 # time.localtime（）返回一个数组 e.g:time.struct_time(tm_year=2019, tm_mon=9, tm_mday=10, tm_hour=11, tm_min=24, tm_sec=8, tm_wday=1, tm_yday=253, tm_isdst=0)
 # 数组中元素的顺序是固定的 [年，月，日，时，分，秒，当前星期的第几天，当前年的第几天]

def time_date_fun():
    import time
    print("time.time():",str(time.time()))
    time_now = time.localtime(time.time()) 
    print(time_now)
    time.sleep(10) # 当前终端或者进程暂停/休眠指定的时间 一秒为单位

    #修改时间也是一样只需要修改数组time.struct_time（）中的各个元素值就可以了
    year,month,day,hour,minute = time_now[0:5] # 使用多参数及slice方式获取
    print(str(day) + "/" + str(month) + "/" + str(year) + " "+ str(hour) + ":" + str(minute))
    print(time.gmtime())

# 捕获异常和Java相似,finally最终都会执行
def try_except_finally_fun(first):
    tips = "请输入你的钟意数字："
    if first == False :
        tips = "请再次输入你的钟意数字:"
    try:
        ins = input(tips)
        print(ins + 520)
    except :
        print("sorry,捕获了一个异常！请在代码中修改,字符串不能和数字类型的数据直接进行'+'操作")
        # try_except_finally_fun(False)
    finally:
        print("finally !!")

# 类也是要用class声明，python中暂时把：看做是{}的作用吧
# __init__() 是类的默认构造器，创建实例时先调用，像java一样做赋值初始化的操作，同时构造函数的参数必须存在self参数，否则编译不过
# 可以声明类的属性，但是要在__init__()构造方法中声明，同时要初始化默认值
class Person:

    def __init__(self,name): # 构造器包含除了self参数时，在创建实例的时候必须传入对应的值
        self.name = name
        self.age = 0  # 声明这个类的属性，这样就可以直接使用类实例.age了
        
    # def __init__(self,name,age): #python的构造函数不能够重载，只能显示的声明一个构造器，也就是只用实例化这个类就只会调用这个构造器函数
    #     self.name = name
    #     self.age = age 

    def setAge(self,age):  #如果需要调用类本身的方法或者变量时就需要使用self参数（可以先把self看做this）
        self.age = age

    def getAge(self):
        return self.age

    def getInfo(self):
        return "姓名:" + self.name + " 年龄:" + str(self.age)

    def say(self,msg):
        print("Person say: " + str(msg) + " -。 what ？ ")

# 方法中如果需要引用类时要在方法的上面申明，否则找不到类名
# 同样 创建一个类对象时直接类名加括号及参数即可 ，不需要new 关键字
def object_fun():
    person = Person(name)  # 必须传入__init__（params）中指定的参数，直接使用类名
    person.setAge(18)
    person.weight = 160     # 增加新的属性同时赋值
    print(person.name)
    print(person.age)
    print(person.weight)
    print(person.getInfo())

# module 其实就像是工具类提供了公共的函数方法 ，不需要创建对象实例，导入就可以使用，
def module_fun():
    import os
    print(os.system("dir")) # 回去当前目录列表,和 ls 功能完全一样
    
    from AnimalExample import sleep # 从module中导入具体的函数
    sleep() 

    import AnimalExample # 导入module中的所有函数
    AnimalExample.eat()
    AnimalExample.sleep()

# 继承和java很像，只不过不需要使用extend关键字
# 如果使用外部文件请先使用import导入
def inheritance_fun():
    import AnimalExample
    cat = AnimalExample.Cat("male")
    cat.setName("波斯猫")
    cat.say()
    cat.setWeight("0.25")
    cat.eat("鱼")
    cat.play()
    cat.eysNums=3 #  使用对象去修改类方法的属性是无效的
    AnimalExample.Cat.eysNums=1  #同样类方法也是不需要初始化实例就可以用的 ；与静态方法的区别：静态方法不关联类自己，而类方法则相反，意思就是静态方法不能够访问类内部的非静态属性或方法，而类方法则可以，同时类方法还关联了cls参数
    cat.see("一条小鱼")
    AnimalExample.Animal.eysNums = 3
    AnimalExample.Animal.see("世界") #类方法可以是直接使用类名进行调用也可以使用对象进行调用
    info = cat.getInfo() # 调用父类函数，要注意父类方法中需要的参数或者函数子类也要有
    print(info)
    AnimalExample.Cat.live() # 静态方法：直接使用类名.函数名 调用静态函数不需要创建类实例，而非静态函数则需要创建类的实例

def iterable_fun():
    d = { "one": 1, "two": 2, "three": 3, "four": 4, "five": 5 }
    iterable = d.keys() # 返回当前map的所有key的数组 相当于java的keySet
    print(iterable)
    for key in iterable: 
        print(key +  ":" + str(d[key]))

    for key in d:    # 这里的key就是每一个键值对的key值
        print(key+":"+str(d[key]))

    iterator = iter(iterable) #相当于遍历数组
    print( next(iterator) ) # 获取数组的第一个元素
    print( next(iterator) ) # 获取数组的第二个元素,以此类推
    
    items = [ "1","2","3","4" ]
    iterator = iter(items)
    x = next(iterator) 
    y = next(iterator) 
    z = next(iterator) 
    print(x)    
    print(y) 
    print(z) 

    
# ------------------------------------------------------------------------------------------------------------------
print_info()
# string_fun()
# random_fun()
# input_fun()
# list_fun()
# dict_fun()
# read_file_fun()
# write_file_fun()
# mName,mAge,mWeight,mInfo = multe_variable_return_fun()
# print(mName,str(mAge),mInfo)
# time_date_fun()
# try_except_finally_fun(True)
# object_fun()
# module_fun()
# inheritance_fun()
# iterable_fun()

