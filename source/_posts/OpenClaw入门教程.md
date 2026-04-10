---
title: OpenClaw入门教程
date: 2026-04-09 15:16:51
tags: 工具
---

# 简介
openClaw = 大模型驱动的“自动化工作流执行器”

# 安装
1. npm安装
~~~bash
npm install -g openclaw@latest
~~~
2. 初始化配置
- 模型
- 渠道
- skill
- 网关
* 模型建议使用kimi 2.5 ，其它配置建议在初始化时跳过，后面可以在控制面板上配
3. telegram 机器人的配置
- 在telegram搜索BotFather
- 在BotFather聊天窗口发送/start
- 接着发送/newbot
- 按照提示一步一做
- 最后会生成一个xxx_ai_bot的机器人，将机器人的token配置到OpenClaw(对话在聊天回复中)
~~~bash
 "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "xxxxx:xxxxxxx",
      "dmPolicy": "pairing",
      "groups": {
        "*": { "requireMention": true }
      }
    }
  }
~~~
- 选择机器人聊天，输入/start，注意看回复消息内容（openclaw pairing approve telegram xxxx）
- 在终端执行：openclaw pairing approve telegram xxxxxx
- 自此，telegram 已跟openClaw连接起来了
- 输入：“你好，介绍一下你自己”，开始你们的第一次会话吧

# OpenClaw的工作原理
telegram / 飞书 
     ↓
openClaw（Gateway）
     ↓
大模型（云API）
     ↓
调度agent
     ↓
使用工具、skill完成任务
     ↓
返回结果
     ↓
再回到聊天工具

# Skills 安装
* 方式一：官网clawhub.ai安装
~~~bash
# 1. 先安装clawhub
npm i -g clawhub
# 2. 在安装skills，比如:
clawhub install "tivily-web-search"
~~~
* 方式二：npx 安装
~~~bash
# 安装baoyu的微信公众文章内容生产和发布skills
npx skills add https://github.com/JimLiu/baoyu-skills/tree/main/skills/baoyu-post-to-wechat
~~~