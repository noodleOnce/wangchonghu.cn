#!/bin/bash

echo "开始部署博客..."

# 清理和生成
echo "清理和生成静态文件..."
hexo clean && hexo generate

# 确保服务器目录权限正确
echo "准备服务器目录..."
ssh ecs-user@47.122.127.24 "sudo rm -rf /var/www/hexo/* && sudo chown -R ecs-user:ecs-user /var/www/hexo && sudo chmod -R 755 /var/www/hexo"

# 部署
echo "部署到服务器..."
hexo deploy

# 部署后设置权限
echo "设置最终权限..."
ssh ecs-user@47.122.127.24 "sudo chown -R nginx:nginx /var/www/hexo && sudo chmod -R 755 /var/www/hexo"

echo "部署完成！"