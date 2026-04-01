---
title: Git常用命令
date: 2023-10-19
tags: 工具
---
1. 查看当前项目的所有远程分支
~~~
git branch -r
# 如果只想查看远程分支的名称，可以使用 --list 或 -l 选项
git branch -r --list
# 查看当前分支的远程地址
git remote show origin
# 删除远程分支
git push origin --delete feature/branch-1
~~~
2. 查看当前项目的所有本地分支
~~~
git branch 
# 如果只想查看远程分支的名称，可以使用 --list 或 -l 选项
git branch --list
# 如果想查看本地分支的详细信息，可以使用 -v 选项
git branch -v
# 删除本地分支
git branch -d feature/branch-1
~~~
3. 查看某个分支的最近一次提交
~~~
# 使用 -1 选项可以限制日志输出为只显示一次提交
git log -1 prod-v3.9.1
~~~
4. 查看某个作者的最近一次提交
~~~
# <author-name> 是你要查找的作者的名称
git log --author="John Doe" -n 1
~~~
5. 查看当前分支某个文件的最近一次提交
~~~
# HEAD表示最新的提交
git show head src/main/java/com/ylsk/b2b3/service/sys/UserAgentService.java 
~~~
6. 查看某一次提交的所有文件

~~~
# <commit-hash> 是你要查看的提交的哈希值或引用
git show --name-only 4505f7817a4f56b4e8581ea8985609b7ef47748b
~~~
7. 查看某一次提交的某个文件的详细内容
~~~
git show 4505f7817a4f56b4e8581ea8985609b7ef47748b wyt/custMap/CustMapSurveyInfoToESRepo.yml
~~~
8. 合并分支
~~~
# 注意如果有冲突发生，你需要解决冲突并手动提交修改。冲突文件会在合并日志中显示
git merge <other_branch>

# 放弃合并
git merge --abort
~~~
9. 暂存当前分支改动
~~~
# 1.暂存当前分支的改动代码
git stash
# 2.切换到目标分支
git checkout feature/branch-2
# 3.切换到当前分支
git checkout feature/branch-1
# 4.弹出之前分支暂存的改动代码
git stash pop
# 5 查看暂存列表
git stash list
# 6 删除暂存明细（删除指定一条）
git stash drop stash@{0}
# 6 清空暂存明细
git stash clear

~~~
10. git clone --recursive  这个参数告诉 Git 在克隆主仓库的同时，递归地初始化和更新该仓库中的子模块。
~~~
git clone --recursive https://git.yun-sk.com/electronic/dzsy-parent.git
~~~
11. 回滚错误的提交
~~~
# 此方法有风险
# 1.查看提交历史
git log --oneline
# 2.回滚到特定提交
git reset --hard 提交ID
# 3.强制推送到远程
git push -f origin 分支名
~~~
~~~
# 安全的回滚方法
# 1.查看提交历史
git log --oneline
# 2.回退最近提交，保留改动
git reset --soft HEAD~1
# 3.新建分支，把改动放过去
git checkout -b feature-branch
git commit -m "Move changes to feature branch"
# 4.回到 main 分支
git checkout main
# 5.把 main 分支强推回上一个状态
git push origin main --force
~~~
12. 查看当前项目的远程分支地址
~~~
# origin 是远程仓库的默认名称
git remote show origin 
~~~
13. git 的仓库概念（很重要）
~~~html
工作区（你写代码）
   ↓ git add
暂存区（准备提交）
   ↓ git commit
本地仓库（生成一个版本）
   ↓ git push
远程仓库（GitLab）
~~~
14. 使用场景
* 日常迭代
~~~bash 
# 1. 将工作区的代码提交到暂存区
git add .
# 2. 把“暂存区（stage）中的内容”生成一个版本快照，提交到本地仓库
git commit -m "xxx"
# 3. 把本地仓库的代码推送到远程仓库
git push
~~~
* 修复线上BUG
~~~ bash
# 1. 把当前开发分支改动的代码藏起来
git stash -u // 包含未被跟踪的代码         
# 2. 切换到线上分支
git checkout master
# 3. 拉取线上分支最新代码
git pull
# 4. 修复bug
# 5. 暂存代码
git add .
# 6.提交代码
git commit -m "fix: xxx"
# 7. 推送代码
git push
~~~
* 恢复单个文件
~~~bash 
# 1. 查看单个文件的历史提交记录
用法：git log <file_path>
示例：git log src/views/index/components/china-map-core.vue 
# 2. 查看单个文件某个提交版本的修改内容
用法：git show <commit_id>:<file_path>
示例：git show 13a9a38b50d6f24771a6bab3ee0e3b0bcc513faf:src/views/index/components/china-map-core.vue
# 3. 恢复指定版本
用法：git restore --source <commit_id> <file_path>
示例：git restore --source 13a9a38b50d6f24771a6bab3ee0e3b0bcc513faf src/views/index/components/china-map-core.vue
~~~

