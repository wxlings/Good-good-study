
对于数组排序,我们可以直接使用api `Arrays.sort()`,下面只是用于练习

#### 冒泡排序

过程形似水开时的气泡,由小到大的过程
1. 逐一比较相邻的数组元素,如果前者大于后者则交换位置
2. 一轮下来就会得到一个当前最大的值,并且放在后面
3. 经过n-1轮后完成排序

```java
    public void bubbleSort() {
		int numbers[] = {5,2,9,1,6,0,7,4,3};
		int temp;
		for (int i = 0; i < numbers.length-1; i++) {
			for (int j = 0; j < numbers.length-i-1; j++) {
				if (numbers[j] > numbers[j+1]) {         // 因为这里用到的j+1,所以上面j的取值范围就是numbers.length-i-1
					temp = numbers[j+1];
					numbers[j+1] = numbers[j];
					numbers[j] = temp;
				}
			}
			System.out.println(Arrays.toString(numbers));
		}
	}
```

执行结果:

```java
    [2, 5, 1, 6, 0, 7, 4, 3, 9]
    [2, 1, 5, 0, 6, 4, 3, 7, 9]
    [1, 2, 0, 5, 4, 3, 6, 7, 9]
    [1, 0, 2, 4, 3, 5, 6, 7, 9]
    [0, 1, 2, 3, 4, 5, 6, 7, 9]
    [0, 1, 2, 3, 4, 5, 6, 7, 9]
    [0, 1, 2, 3, 4, 5, 6, 7, 9]
    [0, 1, 2, 3, 4, 5, 6, 7, 9]
```

#### 选择排序

1. 将数组的每一个元素与第一个元素进行比较,如果小于则进行交换
2. 依此逻辑,再把其余元素与第二个,第三个进行比较,...,每一个完成一个循环都会确认前面为最小值
3. 经过n-1次循环及完成排序

```java
    public void selectSort() {
    int numbers[] = {5,2,9,1,6,0,7,4};
    int temp;
    for (int i = 0; i < numbers.length-1; i++) {
        for (int j = i+1; j < numbers.length; j++) {
            if (numbers[i] > numbers[j]) {
                temp = numbers[i];
                numbers[i] = numbers[j];
                numbers[j] = temp;
            }
        }
        System.out.println(Arrays.toString(numbers));
    }
	}
```

执行结果如下:

```java
    [0, 5, 9, 2, 6, 1, 7, 4]
    [0, 1, 9, 5, 6, 2, 7, 4]
    [0, 1, 2, 9, 6, 5, 7, 4]
    [0, 1, 2, 4, 9, 6, 7, 5]
    [0, 1, 2, 4, 5, 9, 7, 6]
    [0, 1, 2, 4, 5, 6, 9, 7]
    [0, 1, 2, 4, 5, 6, 7, 9]
```

#### 插入排序

1. 把数组分为两个部分;把后面部分的元素与前面部分的元素一一由后向前比较比较,然后把插入到合适的位置
2. 每经过一次外层循环,前面就会形成正确的排序逻辑
3. 经过n-1论比较完成排序

```java
    public void insertSort() {
		int numbers[] = {5,2,9,1,6,0,7,4};
		int temp;
		for (int i = 1; i < numbers.length; i++) {
			for (int j = i; j > 0; j--) {
				if (numbers[j-1]>numbers[j]) {  // 这里用的时n-1,就是前一个值所以上面j的取值范围时j>0,对于j的初始值不是固定的,也可以时i-1,这样的话取值范围时j>=0,下面就不能用j-1了
					temp = numbers[j-1];
					numbers[j-1] = numbers[j];
					numbers[j] = temp;
				} else {
					break;                  // 这里进行优化,如果后面值大于前面值跳过后面比较
				}
			}
			System.out.println(Arrays.toString(numbers));
		}
	}
```

#### 快速排序
[参考](https://www.runoob.com/w3cnote/quick-sort.html)

该方法的基本思想是：

1．先从数列中取出一个数作为基准数。
2．分区过程，将比这个数大的数全放到它的右边，小于或等于它的数全放到它的左边。
3．再对左右区间重复第二步，直到各区间只有一个数。

```java
    public void quickSort(int[] array,int low,int high) {
		if (low < high) {
			int flag = array[low],i = low,j=high;
			while (i < j) {
				while (i<j && array[j] >= flag) {
					j--;
				}
				if (array[j] < flag) {
					array[i++] = array[j];
				}
				
				while (i<j && array[i] <= flag) {
					i++;
				}
				if (array[i] > flag) {
					array[j--] = array[i];
				}
			}
			array[i] = flag;
			quickSort(array, low, i-1);
			quickSort(array, i+1, high);
		}
    }

    public static void main(String[] args){
        int[] numbers = {5,2,9,1,6,0,7,4,3};
		quickSort(numbers,0,numbers.length-1);
        System.out.println(Arrays.toString(numbers))
    }
```

#### 二分查找

二分查找又称折半查找,只能用于有序序列数组

系统提供了工具类api:`Arrays.binarySearch()`,下面仅仅为练习;

```java
	public void binarySearch () {
		int numbers[] = {1,3,5,7,9,15,21,35};
		int target = 35;
		int index = -1,low = 0,high = numbers.length,middle;
		while (low <= high) {
			middle = (low + high )/2;
			if (numbers[middle] == target) {
				index = middle;
				break;
			}else if (numbers[middle] > target) {
				high = middle - 1;
			}else {
				low = middle + 1;
			}
		}
		System.out.println("INDEX;" + index);
	}
```


#### 下面写了一个生成彩票的逻辑6+1

1. 先生成所有数据源有序的序列数组pools
2. 生成0-32的随机数,然后获取其对应的数据源,如果目标数组中已经存在重新生成
3. 最后生成0-15的随机数作为蓝色球的对应索引

```java
	public void generateLottery() {
		String[] pools = new String[33];
		boolean[] flags = new boolean[pools.length];
		for (int i = 0; i < pools.length; i++) {
			pools[i] = i < 9 ? "0"+(i+1) : String .valueOf(i+1);
		}
		
		String[] targets = new String[7];
		int index = 0;
		while (index < targets.length-1) {  // index的取值范围是0-5, 6是蓝色球的值
			Random random = new Random();
			int temp = random.nextInt(pools.length-1); // 获取0-32的值
			if (flags[temp]) {
				continue;
			}else {
				targets[index] = pools[temp]; 
				flags[temp] = true;
				++index;
			}
		}
		targets[targets.length-1] = String.valueOf("99");
		Arrays.sort(targets);
		Random random = new Random();
		targets[targets.length-1] = pools[random.nextInt(15)];
		System.out.println("双色球中奖号码:"+Arrays.toString(targets));
	}
```