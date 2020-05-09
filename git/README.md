#这是一个...，我要慢慢把他维护好！主要做记录用#

# [git 官网](https://git-scm.com/)

# [中文文档](https://git-scm.com/book/zh/v2)

> Git 有三种状态:已提交（committed）、已修改（modified）和已暂存（staged）;
> committed: 已提交表示数据已经安全的保存在本地数据库中。
> modified: 已修改表示修改了文件，但还没保存到数据库中。
> staged: 已暂存表示对一个已修改文件的当前版本做了标记，使之包含在下次提交的快照中。

#### 临时保存(SAVA FRAGMENTS)

`git stash` 把当前变更临时保存,然后切换为上一次提交状态
