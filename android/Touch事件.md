事件方向:

1. touch 事件是如何从驱动层传递给 Framework 层的 InputManagerService；

2. WMS 是如何通过 ViewRootImpl 将事件传递到目标窗口；

3. touch 事件到达 DecorView 后，是如何一步步传递到内部的子 View 中的。





##为什么 DOWN 事件特殊

