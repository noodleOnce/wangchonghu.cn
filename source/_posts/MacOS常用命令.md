---
title: MacOS常用命令
date: 2025-11-17 11:19:19
tags: 工具
---
### 🖥️ 一、系统与文件操作
~~~bash
1. 列出目录
ls              # 列出文件
ls -l           # 详细列表
ls -a           # 显示隐藏文件
ls -lh          # 人类可读的大小显示

2. 进入目录
cd /path/to/dir
cd ..           # 返回上一级
cd ~            # 回到用户主目录

3. 查看当前路径
pwd

4. 创建 / 删除 文件或文件夹
touch file.txt          # 创建文件
mkdir new_folder        # 创建目录
rm file.txt             # 删除文件
rm -rf folder           # 强制删除目录（小心！）

5. 远程登录
ssh -i ~/.ssh/ali-ecs-prikey.pem ecs-user@47.122.127.24

~~~



### 📦 二、文件内容操作
~~~bash
1. 查看文件内容
cat file.txt
more file.txt
less file.txt   # 推荐，可上下翻页

2. 文本查找
grep "keyword" file.txt
grep -r "keyword" ./     # 递归搜索

3. 修改 hosts
sudo nano /etc/hosts
# 或
sudo vi /etc/hosts
~~~
### 🔧 三、权限管理
~~~bash
1. 修改权限
chmod 755 file
chmod +x script.sh       # 赋予执行权限

2. 修改文件所属人
sudo chown user:group file

3. 查看文件权限
ls -l
~~~

### 🌐 四、网络相关（必备）
~~~bash
1. 查看本机 IP
ifconfig
ipconfig getifaddr en0       # Wi-Fi
ipconfig getifaddr en1       # 有线

2. 查看端口占用
lsof -i :8080
sudo lsof -nP -iTCP -sTCP:LISTEN

3. 测试网络
ping baidu.com
curl https://www.apple.com
curl -I https://xxx.com      # 只看响应头

4. DNS 刷新
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder

🐳 五、Docker 常用命令（你经常会用）
docker ps
docker ps -a
docker images
docker logs container_id
docker exec -it container_id bash
docker stop container_id
docker start container_id
docker rm container_id
docker rmi image_id
~~~
### ☕ 六、Java & 开发环境
~~~bash 
1. 查看 Java 版本
java -version

2. 查看端口占用的 Java 进程
jps

3. 查看java安装目录
/usr/libexec/java_home -V

4. 查看并杀死占用的端口
lsof -i :20883
ps -fp 59568
kill -9 59568
~~~

### 📦 七、压缩 / 解压
~~~bash
压缩为 zip
zip -r archive.zip folder

解压 zip
unzip archive.zip
~~~

### 🔑 八、系统管理
~~~bash
1. 查看磁盘空间
df -h

2. 查看内存使用
top

3. 重启电脑（慎用）
sudo shutdown -r now

4. 当前目录备份文件（/etc/nginx/ssl）
cp yunlianshikang.com.crt yunlianshikang.com.crt.back

5. 转移文件到当前目录且重命名
cp /tmp/scs1771505643984_www.yunlianshikang.com_server.crt yunlianshikang.com.crt

~~~~

### 📝 九、Homebrew 常用命令（Mac 必备包管理器）
~~~bash
brew update
brew upgrade
brew install wget
brew uninstall xxx
brew list
~~~

### 🌍 十、Git 常用命令
~~~bash
git status
git pull
git push
git checkout -b new-branch
git checkout master
git branch
git log --oneline
git diff
git stash
git stash pop
~~~
