####  ArrayList
ArrayList : 本质是Object[],也就具有数组所有的特性;所以内存连续;
有点: 查询/更新快,使用指定的索引;
缺点: 扩容/插入/移除可能消耗性能,需要对扩容及插入/移除位置后的数据需要进行拷贝;

使用注意: 在创建实例时最好指定List的容量长度;否则会不断进行扩容行为,扩容就意味着拷贝原有数组;

```java 
    // 不同版本 源码不同
    public class ArrayList<E> extends AbstractList<E> implements List<E>,..{

        private static final Object[] EMPTY_ELEMENTDATA = new Object[0];
        private static final Object[] DEFAULTCAPACITY_EMPTY_ELEMENTDATA = new Object[0];
        transient Object[] elementData;
        private int size;

        // 默认构造方法;会直接使用空的Object[];
         public ArrayList() {
            this.elementData = DEFAULTCAPACITY_EMPTY_ELEMENTDATA;
        }
        // 指定容量;
        public ArrayList(int var1) {
            if (var1 > 0) {
                this.elementData = new Object[var1];  // 指定数组长度;
            } else {
                if (var1 != 0) {
                    throw new IllegalArgumentException("Illegal Capacity: " + var1);
                }

                this.elementData = EMPTY_ELEMENTDATA;
            }

        }
        // add 之前,先检查容量够不够,不够就进行扩容
        public boolean add(E var1) {
            this.ensureCapacityInternal(this.size + 1);
            this.elementData[this.size++] = var1;
            return true;
        }

         private void ensureExplicitCapacity(int var1) {
            ++this.modCount;
            if (var1 - this.elementData.length > 0) {
                this.grow(var1);
        }
        
        // 数组增益及原数组的拷贝;
        private void grow(int var1) {
            int var2 = this.elementData.length;
            int var3 = var2 + (var2 >> 1);
            if (var3 - var1 < 0) {
                var3 = var1;
            }

            if (var3 - 2147483639 > 0) {
                var3 = hugeCapacity(var1);
            }

            this.elementData = Arrays.copyOf(this.elementData, var3);  // 拷贝
        }

        // 移除元素: 需要进行数据的拷贝
         public E remove(int var1) {
            this.rangeCheck(var1);
            ++this.modCount;
            Object var2 = this.elementData(var1);
            int var3 = this.size - var1 - 1;
            if (var3 > 0) {
                System.arraycopy(this.elementData, var1 + 1, this.elementData, var1, var3);
            }

            this.elementData[--this.size] = null;
            return var2;
        }
    
    }
```

#### LinkedList

LinkedList: 本质是双链表结构;有头尾顺序,头接上一个的尾,尾接下一个数据的头;
特点: 内存不用连续;
读写快慢这个概念模糊; 对于头尾操作绝对优于ArrayList;
它的数据结构式内部类`Node`双链表

```java
    /**
     * Pointer to first node.Invariant: (first == null && last == null) ||(first.prev == null && first.item != null)
     */
    transient Node<E> first;  

    /**
     * Pointer to last node. Invariant: (first == null && last == null) ||(last.next == null && last.item != null)
     */
    transient Node<E> last;

    /**
     * Constructs an empty list.
     */
    public LinkedList() {
    }

    /**
     * Appends the specified element to the end of this list.

     */
    public boolean add(E e) {
        linkLast(e);
        return true;
    }

     /**
     * Links e as last element.
     */
    void linkLast(E e) {
        final Node<E> l = last;
        final Node<E> newNode = new Node<>(l, e, null);
        last = newNode;
        if (l == null)
            first = newNode;
        else
            l.next = newNode;
        size++;
        modCount++;
    }

     /**
     * Returns the (non-null) Node at the specified element index.
     所用通过索引的都要获取指定索引位置的Node;
     获取给出索引的Node; 这里就很有意思 :先看索引倾向头还是倾向尾,如果倾向头就从头开始,否则就从尾开始
     */
    Node<E> node(int index) {
        // assert isElementIndex(index);

        if (index < (size >> 1)) {
            Node<E> x = first;
            for (int i = 0; i < index; i++)
                x = x.next;
            return x;
        } else {
            Node<E> x = last;
            for (int i = size - 1; i > index; i--)
                x = x.prev;
            return x;
        }
    }

    // 节点: 包含了三个变量:数据,上个节点引用,下个节点引用
    private static class Node<E> {
        E item;
        Node<E> next;
        Node<E> prev;

        Node(Node<E> prev, E element, Node<E> next) {
            this.item = element;
            this.next = next;
            this.prev = prev;
        }
    }
```

#### LinkedArrayList

```java
    /**
    * A list implementation which combines an ArrayList with a LinkedList to
    * avoid copying values when the capacity needs to be increased.
    * <p>
    * The class is non final to allow embedding it directly and thus saving on object allocation.
    */
    public class LinkedArrayList {
         /** The capacity of each array segment. */
    final int capacityHint;
    /**
     * Contains the head of the linked array list if not null. The
     * length is always capacityHint + 1 and the last element is an Object[] pointing
     * to the next element of the linked array list.
     */
    Object[] head;
    /** The tail array where new elements will be added. */
    Object[] tail;
}
```

#### Vector

它是线程安全的'ArrayList',所有的关键方法都用了`synchronized`关键字进行修饰;

```java
    public class Vector<E>
    extends AbstractList<E>
    implements List<E>, RandomAccess, Cloneable, java.io.Serializable{

        protected Object[] elementData;
        protected int elementCount;

        /**
        * Constructs an empty vector so that its internal data array has size {@code 10} and its standard capacity increment iszero.
        * 默认长度10
        */
        public Vector() {
            this(10);
        }

        public synchronized void addElement(E obj) {
            modCount++;
            ensureCapacityHelper(elementCount + 1);
            elementData[elementCount++] = obj;
        }

    }

```
