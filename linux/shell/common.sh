# url
url='https://github.com'

# function
function show(){
    echo 'This is a function!'
}

calculate(){
    echo '这是一个简单的小游戏'
    echo '请输入一个数字：'
    read a
    echo '再次输入一个数字'
    read b
    return $(($a + $b))
}

function recalculate(){
    echo "All params length:$#,and content:$*"
    if [ $1 == $2 ]
    then
        echo "$1 == $2"
    elif [ $3 -ge $4 ]
    then
        echo "$3 >= $4"
    elif test $2 -le $4
    then
        echo "$2 <= $4"
    elif test -z $6
    then 
        echo "$6 length 不为0"
    else 
        echo "default"
    fi
}
