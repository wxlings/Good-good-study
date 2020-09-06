对于Fragment的操作都需要使用`FragmentTransaction`事务进行操作,

```java

    val manager = supportFragmentManager  // 只有继承FragamentActivity才能使用
    val transaction = manger.beginTransaction()


    // add 
    transaction.add(R.id.container,Fragament(),"tag")

    /**
     * Calls {@link #add(int, Fragment, String)} with a null tag.
     */
    @NonNull
    public FragmentTransaction add(@IdRes int containerViewId, @NonNull Fragment fragment) {
        doAddOp(containerViewId, fragment, null, OP_ADD);
        return this;
    }

    // replace 
    transaction.replace(R.id.container,Fragament(),"tag",...)
     @NonNull
    public FragmentTransaction replace(@IdRes int containerViewId, @NonNull Fragment fragment,
            @Nullable String tag)  {
        if (containerViewId == 0) {
            throw new IllegalArgumentException("Must use non-zero containerViewId");
        }
        doAddOp(containerViewId, fragment, tag, OP_REPLACE);
        return this;
    }

    // show
    transaction.show()
    @NonNull
    public FragmentTransaction show(@NonNull Fragment fragment) {
        addOp(new Op(OP_SHOW, fragment));

        return this;
    }
    ... 


    // 通过事务对象调用的方法都会创建一个Op对象,然后设置`cmdId`并加入到集合

    // 一些常用的标记位
    static final int OP_NULL = 0;
    static final int OP_ADD = 1;
    static final int OP_REPLACE = 2;
    static final int OP_REMOVE = 3;
    static final int OP_HIDE = 4;
    static final int OP_SHOW = 5;
    static final int OP_DETACH = 6;
    static final int OP_ATTACH = 7;

    // 每次的一个操作都创建一个Op对象,来保存需要的操作;
    void doAddOp(int containerViewId, Fragment fragment, @Nullable String tag, int opcmd) {
        final Class<?> fragmentClass = fragment.getClass();
        final int modifiers = fragmentClass.getModifiers();
        i...

        if (tag != null) {
            ...
            fragment.mTag = tag;
        }

        if (containerViewId != 0) {
            ...
            fragment.mContainerId = fragment.mFragmentId = containerViewId;
        }

        addOp(new Op(opcmd, fragment));
    }
    // 集合
    ArrayList<Op> mOps = new ArrayList<>();
    void addOp(Op op) {
        mOps.add(op);
        op.mEnterAnim = mEnterAnim;
        op.mExitAnim = mExitAnim;
        op.mPopEnterAnim = mPopEnterAnim;
        op.mPopExitAnim = mPopExitAnim;
    }

    // 内部类Options,包含多数据
    static final class Op {
            int mCmd;
            Fragment mFragment;
            int mEnterAnim;
            int mExitAnim;
            int mPopEnterAnim;
            int mPopExitAnim;
            Lifecycle.State mOldMaxState;
            Lifecycle.State mCurrentMaxState;
    }
    
    
```

可以看出:通过事务对Fragament的所有操作都创建一个Op对象,把相关联的操作指令加入到`ArrayList<Op>`中,到底是怎样执行的呢?来看一`transaction.commit()`

```java

    transaction.submit()

    /**
     * Schedules a commit of this transaction.  The commit does
     * not happen immediately; it will be scheduled as work on the main thread
     * to be done the next time that thread is ready.
     * 这是一个抽象方法
     */
    public abstract int commit();

    final class BackStackRecord extends FragmentTransaction implements
        FragmentManager.BackStackEntry, FragmentManager.OpGenerator {

        ...

        @Override
        public int commit() {
            return commitInternal(false);
        }
    
        int commitInternal(boolean allowStateLoss) {
            ....
            mCommitted = true;
            if (mAddToBackStack) {
                mIndex = mManager.allocBackStackIndex();
            } else {
                mIndex = -1;
            }
            mManager.enqueueAction(this, allowStateLoss);
            return mIndex;
        }
    }

    private final ArrayList<OpGenerator> mPendingActions = new ArrayList<>();

     /**
     * Adds an action to the queue of pending actions.
     *
     * @param action the action to add
     * @param allowStateLoss whether to allow loss of state information
     * @throws IllegalStateException if the activity has been destroyed
     */
    void enqueueAction(@NonNull OpGenerator action, boolean allowStateLoss) {
        ....
        synchronized (mPendingActions) {
            ....
            mPendingActions.add(action);
            scheduleCommit();
        }
    }

     /**
     * Schedules the execution when one hasn't been scheduled already. This should happen
     * the first time {@link #enqueueAction(OpGenerator, boolean)} is called or when
     * a postponed transaction has been started with
     * {@link Fragment#startPostponedEnterTransition()}
     */
    @SuppressWarnings("WeakerAccess") /* synthetic access */
    void scheduleCommit() {
        synchronized (mPendingActions) {
            boolean postponeReady =
                    mPostponedTransactions != null && !mPostponedTransactions.isEmpty();
            boolean pendingReady = mPendingActions.size() == 1;
            if (postponeReady || pendingReady) {
                mHost.getHandler().removeCallbacks(mExecCommit);
                mHost.getHandler().post(mExecCommit);
                updateOnBackPressedCallbackEnabled();
            }
        }
    }
```