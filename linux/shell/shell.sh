echo 'This is a shell file!'
# 注释
message='Hello,shell'
echo $message
message="Hello,world"
unset message
echo 'unset'
echo `${message}`+'unset'


readonly name
echo $name

message='hello,world'
echo 'this is a $message'
echo "this is a $message"

m='hello'
e='world'
echo '@@'$m$e'##',"$m$e"

message='Hello,world'
echo ${#message}

people=('hello' 'world' 'jeck')
for var in ${people[*]}
    do echo $var
done

exit

message='Hello,world'
echo 'echo ${message:5}'${message:5}
echo 'echo ${message:2:5}'${message:2:5}

persons=('Jack' 'Lee' 'Helin')
persons[3]='Soul'
echo ${persons[2]}
echo ${persons[@]}
echo ${persons[*]}
echo ${#persons[*]}

echo "传入参数的length:$#,具体内容:$*"
echo '第一个参数:'$1
echo "第二个参数长度:${#2}"



a=12
b=52
echo `expr $a + $b`

if [ $a > $b ]
then echo 'a>b'
else 
echo 'a<=b'
fi
echo '---------------function----------------------'
source ./common.sh
echo "Common's variable url:$url"
show

calculate
echo "你的理想数字: $?"

recalculate 5 10 0 100 20 'hello' 'word'

# calculate 1 2 3 4 5