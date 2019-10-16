class Animal:

  eysNums = 2 # 类方法的属性，能够在类方法中访问因为需要cls

  @classmethod  #  修饰类方法
  def see(cls,what): # 传入 cls 用于引用本类中的变量或者函数
    print("Animal hava "+  str(cls.eysNums) + " 只眼睛 and 看到了：" + str(what))

  @staticmethod  # 静态方法
  def live():
    print("动物活着都需要呼吸...")

  def  __init__(self,name):
        self.name = name
        self.gender = "male"
        self.age = 18
        self.weight = 45.52
        print("父类构造方法")

  def say(self):
    print("Animal:" + self.name + "发出了叫声、、、")

  def eat(self):
    print("Animal:" + self.name + "在吃食物了 ！！！")

  def setGender(self,gender):
    self.gender = gender

  def setAge(self,age):
    self.age = age

  def setWeight(self,weight): 
    self.weight = weight

  def getInfo(self):
    return "Animal:" + str(self.name) + " isMale:" + str(self.gender) + " age:" + str(self.age) + " weight:" + str(self.weight) 



# 继承的实现： 只需要在子类后面增加父类的名字即可,但是python中类的继承是可以多继承的 ,e.g. class Cat(Animal,Lifes,...)
class Cat(Animal):
  
  # 构造方法也是一样的.只要重写了父类就没有任何意义了 ，同时重写了父类中声明的变量如果子类没有声明是不能能够直接使用的
  def  __init__(self,gender):
        self.name = "猫"
        self.gender = gender
        self.age = 2
        self.weight = 5.68
        print("子类构造方法")

  def setName(self,name):
    self.name = name

  # 子类可以有自己的新增方法；
  def play(self):
    print("这只" + self.name + "抓到一只耗子。。。")

  # 子类中同样支持父类方法的重写，同时只有这时可以重载,一旦重写了方法父类的方法就不会调用了 
  def eat(self,food):
    print("这只" + self.name + "在吃" + str(food) + "...")

  # 静态方法也可以重写,一样是不能够使用或者增加当前类的属性调用的，静态是先载入的，不能使用self 
  @staticmethod
  def live():
    print("这只猫活着也需要呼吸滴...")

  #下面的是不可以的，就是在同一个类里面不可以重载
  # def eat(self):
  #   print("这只猫在吃在吃食物了 ！！！")

  
#下面的方法属于module 并不属于、Animal类
def sleep():
  print("生物都需要睡觉来养息神经 、、、")

def eat():
  print("生物都需要吃东西来维持生命 ！！！")