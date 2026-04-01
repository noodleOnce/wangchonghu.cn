---
title: Docker常用命令
date: 2025-10-29 16:16:40
tags: 架构
---
### 🧩 一、容器管理
| 操作            | 命令                                |
| ------------- | --------------------------------- |
| 查看正在运行的容器     | `docker ps`                       |
| 查看所有容器（包括停止的） | `docker ps -a`                    |
| 启动容器          | `docker start <容器名或ID>`           |
| 停止容器          | `docker stop <容器名或ID>`            |
| 重启容器          | `docker restart <容器名或ID>`         |
| 删除容器          | `docker rm <容器名或ID>`              |
| 强制删除容器        | `docker rm -f <容器名或ID>`           |
| 进入容器终端        | `docker exec -it <容器名> /bin/bash` |
| 查看容器日志        | `docker logs -f <容器名>`            |
| 查看容器详细信息      | `docker inspect <容器名>`            |
| 查看容器占用资源      | `docker stats`                    |
### 🐳 二、镜像管理
| 操作      | 命令                               |
| ------- | -------------------------------- |
| 查看本地镜像  | `docker images`                  |
| 拉取镜像    | `docker pull <镜像名>:<标签>`         |
| 构建镜像    | `docker build -t <镜像名>:<标签> .`   |
| 删除镜像    | `docker rmi <镜像名或ID>`            |
| 强制删除镜像  | `docker rmi -f <镜像名或ID>`         |
| 导出镜像到文件 | `docker save -o <文件名>.tar <镜像名>` |
| 导入镜像文件  | `docker load -i <文件名>.tar`       |
| 查看镜像历史层 | `docker history <镜像名>`           |
### 🧹 三、系统清理与空间管理
| 目标               | 命令                                    |
| ---------------- | ------------------------------------- |
| 清理已退出的容器         | `docker container prune -f`           |
| 清理未使用的镜像         | `docker image prune -a -f`            |
| 清理未使用的卷          | `docker volume prune -f`              |
| 清理未使用的网络         | `docker network prune -f`             |
| 清理所有无用资源（推荐测试环境） | `docker system prune -a -f --volumes` |
| 清理构建缓存层          | `docker builder prune -a -f`          |
| 查看 Docker 磁盘占用   | `docker system df -v`                 |
### 📦 四、卷（Volume）与文件挂载
| 操作         | 命令                               |
| ---------- | -------------------------------- |
| 查看所有卷      | `docker volume ls`               |
| 查看卷详情      | `docker volume inspect <卷名>`     |
| 删除指定卷      | `docker volume rm <卷名>`          |
| 清理未使用卷     | `docker volume prune -f`         |
| 容器与宿主机挂载目录 | `docker run -v /宿主机目录:/容器目录 镜像名` |
### 🌐 五、网络与端口
| 操作       | 命令                                                                                   |
| -------- | ------------------------------------------------------------------------------------ |
| 查看网络列表   | `docker network ls`                                                                  |
| 查看网络详情   | `docker network inspect <网络名>`                                                       |
| 创建网络     | `docker network create <网络名>`                                                        |
| 删除网络     | `docker network rm <网络名>`                                                            |
| 将容器连接到网络 | `docker network connect <网络名> <容器名>`                                                 |
| 查看容器的IP  | `docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <容器名>` |
### 🔎 六、日志与调试
| 操作               | 命令                                                 |
| ---------------- | -------------------------------------------------- |
| 查看容器日志（实时）       | `docker logs -f <容器名>`                             |
| 仅查看最后100行日志      | `docker logs --tail 100 <容器名>`                     |
| 导出容器日志           | `docker logs <容器名> > logs.txt`                     |
| 查看容器资源消耗（CPU、内存） | `docker stats`                                     |
| 查看容器文件变化         | `docker diff <容器名>`                                |
| 复制容器内文件到宿主机      | `docker cp <容器名>:/path/in/container /path/on/host` |
| 从宿主机复制文件进容器      | `docker cp /path/on/host <容器名>:/path/in/container` |
### ⚙️ 七、Docker 服务级命令（宿主机级）
| 操作                     | 命令                         |
| ---------------------- | -------------------------- |
| 启动 Docker 服务           | `systemctl start docker`   |
| 停止 Docker 服务           | `systemctl stop docker`    |
| 重启 Docker 服务           | `systemctl restart docker` |
| 查看 Docker 状态           | `systemctl status docker`  |
| 查看 Docker 版本           | `docker version`           |
| 查看 Docker 信息（环境、存储路径等） | `docker info`              |
### 🪄 八、实用排查技巧
| 场景               | 命令                                              |              |
| ---------------- | ----------------------------------------------- | ------------ |
| 找出占空间最大的容器/镜像    | `docker system df -v`                           |              |
| 查看 Redis 容器挂载卷路径 | `docker inspect redis                           | grep Source` |
| 检查 Redis 数据目录空间  | `docker exec -it redis du -sh /data`            |              |
| 清理 overlay2 大目录  | 使用 `docker system prune -a -f --volumes` 而非手动删除 |              |

### 🪄 九、实操
~~~bash
# 1. 停止并删除旧容器
docker stop kafka
docker rm kafka

# 2. 使用新命令启动
docker run -d \
  --name kafka \
  -p 9092:9092 \
  -e ALLOW_PLAINTEXT_LISTENER=yes \
  -e KAFKA_BROKER_ID=1 \
  -e KAFKA_ZOOKEEPER_CONNECT=10.101.0.83:2181 \
  -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://10.101.0.83:9092 \
  -e KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 \
  -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
  bitnami/kafka:2.7.0

# 3. 查看启动日志
docker logs -f kafka

# 4.查看指定容器
docker ps | grep kafka

# 5.进入zookeeper容器
docker exec -it zookeeper-server bash

# 6. 连接到 ZooKeeper 客户端
zkCli.sh -server localhost:2181

# 7. 在 ZK 客户端中执行以下命令
ls /brokers/ids          # 查看当前注册的 broker
delete /brokers/ids/0    # 删除旧的 broker 0
ls /brokers/ids          # 确认删除成功，应该只看到 [1]

# 8. 退出 ZK 客户端
quit

# 9. 退出容器
exit
~~~

### 🪄 10、compose 启动
~~~bash
# /opt/kafka-stack 传经docker-compose.yml

version: '3.8'

services:
  zookeeper:
    image: bitnami/zookeeper:3.5.10
    container_name: zookeeper
    restart: always
    ports:
      - "2181:2181"
    environment:
      - ALLOW_ANONYMOUS_LOGIN=yes

  kafka:
    image: bitnami/kafka:2.7.0
    container_name: kafka
    restart: always
    ports:
      - "9092:9092"
    environment:
      - KAFKA_BROKER_ID=1
      - KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181
      - KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://10.101.0.83:9092
      - KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1
      - ALLOW_PLAINTEXT_LISTENER=yes
    depends_on:
      - zookeeper

  kafka-manager:
    image: registry.cn-hangzhou.aliyuncs.com/cjs-images/tools:kafka-manager-cmak
    container_name: kafka-manager
    restart: always
    ports:
      - "9999:9000"
    environment:
      - ZK_HOSTS=zookeeper:2181
    depends_on:
      - zookeeper
      - kafka

# /root/kafka-stack 目录下执行：
docker-compose up -d

# 验证
docker ps
~~~
