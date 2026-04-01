---
title: 什么是zshrc
date: 2026-02-25 11:35:17
tags: 运维
---


## 1. 什么是 `.zshrc`

`.zshrc` 是 **Zsh** 的配置文件。

简单理解：

* 每次你打开一个终端窗口
* Zsh 就会自动读取这个文件
* 里面的配置（比如 alias、环境变量、PATH 等）就会生效

例如你刚刚加的：

```bash
alias zkstart='cd /Users/wangchonghu/Applications/apache-zookeeper-3.8.0-bin/bin && ./zkServer.sh start'
```

就是告诉系统：

> 以后输入 `zkstart`，就执行这一串命令。

所以 `.zshrc` 就相当于 **终端的个人设置文件**。

在 macOS 里常见的 shell 配置文件有：

```
~/.zshrc      当前最常用（macOS默认）
~/.bashrc
~/.bash_profile
```

---

## 2. `~` 是什么目录

`~` 表示 **当前用户的家目录（Home目录）**。

你的电脑里实际上是：

```
/Users/wangchonghu
```

所以：

```
~ = /Users/wangchonghu
```

例如：

```
~/Desktop
```

其实就是

```
/Users/wangchonghu/Desktop
```

再举几个例子：

```
~/.zshrc
~/Downloads
~/Applications
```

对应：

```
/Users/wangchonghu/.zshrc
/Users/wangchonghu/Downloads
/Users/wangchonghu/Applications
```

---

## 3. `.` 代表什么

`.` 在 Linux / macOS 里有两个常见含义。

### 第一种：当前目录

例如：

```bash
cd .
```

意思是：

```
进入当前目录（其实就是不动）
```

再比如：

```bash
./zkServer.sh
```

意思是：

```
执行当前目录里的 zkServer.sh
```

因为默认情况下，系统不会自动在当前目录找程序，所以需要 `./`。

---

### 第二种：隐藏文件

在 macOS / Linux 里：

```
以 . 开头的文件 = 隐藏文件
```

例如：

```
.zshrc
.git
.env
```

默认 Finder 看不到。

如果想看：

```bash
ls -a
```

就能看到：

```
.zshrc
.zprofile
.bash_history
```

---

## 4. 你现在编辑的其实是这个文件

你在 VSCode 里编辑的：

```
~/.zshrc
```

真实路径是：

```
/Users/wangchonghu/.zshrc
```

---

## 5. 小技巧（很多人不知道）

可以直接用 VSCode 打开这个文件：

```bash
code ~/.zshrc
```

或者打开你的 home 目录：

```bash
code ~
```

---

## 6. Zookeeper启动脚本制作案例

1. 编辑.zshrc文件
```bash
vs ~/.zshrc
```

2. 在.zshrc文件末尾添加以下代码
```bash
# 启动
alias zkstart='cd /Users/wangchonghu/Applications/apache-zookeeper-3.8.0-bin/bin && ./zkServer.sh start'
# 暂停
alias zkstop='cd /Users/wangchonghu/Applications/apache-zookeeper-3.8.0-bin/bin && ./zkServer.sh stop'
# 查看
alias zkstatus='cd /Users/wangchonghu/Applications/apache-zookeeper-3.8.0-bin/bin && ./zkServer.sh status'
```

3. 更新.zshrc，让配置生效
```bash
soure ~/.zshrc
```

4. 终端窗口启动zk
```bash
zkstart
```