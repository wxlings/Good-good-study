# [git 官网](https://git-scm.com/)

# [中文文档](https://git-scm.com/book/zh/v2)

### Git
> Git是一个免费的开源分布式版本控制系统，它可以快速高效地处理从小型到大型的项目。

### 安装

直接下载git的安装程序，进行本地安装
检查当前安装情况，使用` git --version`进行查看

### CREATE REPOSITORIES

Start a new repository or obtain one from an existing URL

##### INIT
`git-init` - Create an empty Git repository or reinitialize an existing one

```git
    git init [project]                  # 如果没有指定project参数默认在当前目录创建仓库,如果有指定将会创建子目录然后在子目录中创建仓库
```

> Notes：`git init`是对当前路径进行项目初始化仓库,而`git init <name>`会创建子目录后在初始化仓库

##### CLONE

`git-clone` - Clone a repository into a new directory

```git
    git clone <url> [project]           # clone 项目到本地,可以指定项目名称
    git clone -b <name> <url>           # 指定clone项目的分支
    git clone --depth <number>          # 指定最近提交的数量
```

### CONFIG

配置当前client的信息，主要包括`user.name` 和 `user.email`信息
配置包括`全局配置[--global]`,`当前仓库配置[--local]`,`系统配置[--system]`(默认值)

1. 查看当前配置：
`git config --list [--local | --global]`

2. 执行配置：
`git config [--local | --global ] user.name ***` // 注意这里不需要使用user.name=client
`git config [--local | --global ] user.email ***`

Notes: `local`的优先级高于`global`,如果在当前项目设置信息,git执行时会优先使用local的配置


### BASIC

> Git 有三种状态:已提交（committed）、已修改（modified）和已暂存（staged）;
> committed: 已提交表示数据已经安全的保存在本地数据库中。
> modified: 已修改表示修改了文件，但还没保存到数据库中。
> staged: 已暂存表示对一个已修改文件的当前版本做了标记，使之包含在下次提交的快照中。

##### 查看当前状态
使用`git status`查看当前状态,包括工作区,暂存区,本地仓库的状态

```git
    git status                                  # 对于新增文件,文件修改,加至暂存区都有对应的状态
```
> Notes: `git status`非常常用,可以帮助我们掌握我的当前的状态


##### 添加文件到暂存区
使用 `git add `把工作区新增/变更的文件添加到暂存区

```git
    git add index.js                            # add 指定的文件
    git add index.js log/test.log  readme.md    # add 指定多个文件
    git add  test/                              # add 指定指定文件夹下的所有文件
    git add .                                   # add 当前目录下所有新增/变更的文件
    git add -u                                  # add 所有变更 ( 已经被跟踪 ) 的文件,新创建的文件是不能被add的
```

##### 提交到本地仓库
使用 `git commit `把所有暂存区文件提交到本地仓库

```git
    git commit -m 'fixed bug:***`               # `-m` 指定当前提交的说明信息
    git commit --amend                          # 修改上一次提交信息说明,执行指令后会弹出vi编辑窗口进行说明修改
    git rebase -i parent_commitID               # 使用交互式进行对历史提交说明进行修改,注意命令执行完成后会进入一个中介界面,修改目标原有pick为r,保存退出后自动进入新的编辑界面,修改保存后即可
```

变基rebase:修改已经提交过的commit相关信息
p -> pick : 使用commit
r -> reword : 使用commit,但是需要修改commit massage
s -> sqush(把..压入,挤入) : 使用commit,但是meld(合并)多个commit


Notes: 通常`git add` 会和`git commit`一起用,也可以使用简写`git commit -am 'explain'`

### REFACTOR FILENAMES

Relocate and remove versioned ﬁles

##### MV
`git-mv` - Move or rename a file, a directory, or a symlink

```git 
    git mv -f file new_file                   # 把源文件index.vue 重命名为index.js
```

##### RM    
`git-rm` - Remove files from the working tree and from the index
对已经跟踪的文件进行移除,也可以强制本地操作rm,但是这样还必须add一次,否则暂存区还是存在的 

```git
    git rm file                             # 移除指定文件
    git rm -rf files/                        # 使用递归移除文件夹
    git rm --cached file                    # 移除暂存区文件,对于工作区的文件没有任何影响
```

Notes: 只对已经跟踪的文件生效

#####  分离头指针
意思是当前工作区的HEAD没有与分支或者TAG绑定,处于指针游离状态,如果操作不当可能会造成当前修改的文件都丢失;
原因: 直接使用  `git checkout <commitID>` ,因为`checkout`是切换分支,而给出的参数不是分支名称,所以叫做分离头指针
解决: 在分离头指针的临时分支上提交后使用 `git branch <name> commitID` 为临时分支转正

##### 添加忽略文件

添加或者配置`.gitignore`文件，__在项目的根目录下__,把要进行忽略的文件尽心声明即可    

Notes: 如果文件已经加入到暂存区了 ,再配置.gitignore 就不生效了 ,解决: 使用 `git rm <file>` 即可


### 贮藏保存(SAVA FRAGMENTS)

Shelve and restore incomplete changes(搁置和恢复未完成的更改)

`git-stash` - Stash the changes in a dirty working directory away

> Use git stash when you want to record the current state of the working directory and the index, but want to go back to a clean working directory. The command saves your local modifications away and reverts the working directory to match the HEAD commit.

```git
    git stash create ***                            # 创建一个命名空间的碎片集合(entry)
    git stash                                       # 把当前的变更贮藏到默认的entry中,
    git stash push -m ***                           # 把当前的变更贮藏到指定的命名空间的entry中
    git stash show                                  # 查看stash 的变更
    git stash apply                                 # 恢复最近一次的stash
    git stash pop                                   # 恢复最近一次的stash,并drop已存的stash记录
    git stash list                                  # 列出所有stash记录
    git stash clear                                 # 清除所有stash记录
```

### 查看历史 (REVIEW HISTORY)

Browse and inspect the evolution of project ﬁles (浏览及审查项目的发展过程)

##### LOG

`git-log` - Show commit logs

```git
    git log                                     # 列出所有提交记录
    git log -n <number>                         # Limit the number of commits to output. 列出指定最近的*提交记录
    git log --author=<user.name>                # 过滤指定提交用户的记录
    git log --since=<date>                      # 过滤给出时间之后的记录,等同于 --before=<date>
    git log --until=<date>                      # 过滤给出时间之前的记录 ,等同于--after=<date>
    git log --follow <file>                     # 列出指定文件的变更记录
    git log --oneline                           # 更加简洁的方式,只显示commitID及说明
    git log --all --graph                       # 图形化显示:可以显示多分支的关系
    gitk                                        # 工具图形界面显示
```

##### DIFF

`git-diff` - Show changes between commits, commit and working tree, etc

> Show changes between the working tree and the index or a tree, changes between the index and a tree, changes between two trees, changes between two blob objects, or changes between two files on disk.

```git
    git diff [file]                         # 比较当前工作区与暂存区的差异
    git diff --cached [file]                # 比较暂存区与上一次提交(HEAD)的差异
    git diff commitID1 commitID2 [file]     # 比较两个commit (指定文件) 的差异
    git diff branch1 branch2 [file]         # 比较两个分支{指定文件}的差异
```

##### SHOW

`git-show` - Show various types of objects

> git-show - Show various types of objects

```git
    git show <commitID>             # 显示指定提交记录对应的的变更内容                         
```

###### REFLOG

`git-reflog` - Manage reflog information

```git
    git reflog
```

















### sy  
##### BRANCH
`branch` 对分支的查看及操作

```git
    git branch                  # 列出所有本地分支 等同于加参数`--list`
    git branch temp             # 创建分支temp
    git branch -a               # 列出所有分支,包括本地分支和远程分支
    
    git branch -d temp          # 删除分支
    git branch -D temp          # 强制删除,等同于 --delete --force 
    
    git branch -m temp fix_bug  # 重命名分支
    git branch -M temp fix_bug  # 强制重命名分支,等同于 --move --force
    
    git branch -c temp c_temp   # 复制分支
    git branch -C temp fix_bug  # 强制复制分支,等同于 --copy --force
    
    git branch -r               # 列出所有远程分支:remotes
```

Notes: 通常用小写指令

##### 切换分支/由暂存区检出CHECKOUT
`checkout` 进行分支切换或者检出文件

``` git
    git checkout master                 # 切到其他分支
    git checkout -b temp <commitID>     # 创建(基于指定commitID,如果没有指定默认为当前)并切换到temp分支
    git checkout -B temp <commitID>     # 创建(基于指定commitID,如果没有指定默认为当前)并切换到temp分支,如果分支已存在强制指定head为commitID
   
    git checkout -m temp                # merge 把当前变更的文件'携带'到目标分支

    git checkout -- index.js hello.log  # 由暂存区检出指定文件覆盖工作区的文件,有风险
    git checkout .                      # 由暂存区检出当前目录下的所有文件并覆盖工作区当前文件,有风险
```

##### RESET
`reset` 恢复 暂存区/工作区的状态与 HEAD 一致

```git
    git reset HEAD [file]                       # 检出上一次提交[HEAD]的文件到暂存区,此过程无关工作区
    git reset HEAD~2 [file]                     # 检出上上次提交
    git reset --HARD [commitID]                 # 检出指定的commitID(默认为上一次提交(HEAD))的文件到暂存区及工作区,风险极高
    
```

添加与检出汇总 (目标可以是指定的文件,也可以是all) :
工作区 --- add --> 暂存区 ---commit  --> 仓库
仓  库 ---reset--> 暂存区 ---checkout--> 工作区

协议: 本地协议,http/https协议,ssh协议


##### REMOTE 
`remote` 远端仓库

```git
    git clone url
    git remote add origin url
```


## 禁令
在团队协作的项目里面,谨慎再谨慎使用`git push -f(--force)` ,尤其是在本地回滚代码的情况下,这样操作的风险极高
同时严禁对历史进行变基rebase