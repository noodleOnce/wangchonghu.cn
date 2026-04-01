# CLAUDE.md

此文件为 Claude Code (claude.ai/code) 在此代码库中工作提供指导。

## 项目概述

这是一个使用 "pure" 主题的 Hexo 静态博客站点。博客通过 rsync 部署到远程服务器 (47.122.127.24)。

## 常用命令

```bash
# 创建新文章
hexo new "文章标题"

# 清理缓存
hexo clean

# 生成静态文件
hexo generate  # 或: hexo g
npm run build   # 等同

# 启动本地开发服务器
hexo server  # 或: hexo s
npm run server  # 等同

# 部署到远程服务器（使用 rsync）
hexo deploy  # 或: hexo d
npm run deploy  # 等同

# 完整部署（清理 + 生成 + 部署）
./deploy.sh
```

## 架构

### 核心结构

- **source/**: 主要内容目录
  - `_posts/`: 博客文章（Markdown 文件）
  - `categories/`, `tags/`: 分类和标签页面
  - `about/`, `links/`, `repository/`, `books/`: 自定义页面
  - `imgs/`: 图片资源

- **themes/pure/**: 当前使用的主题
  - `layout/`: EJS 模板
  - `source/`: 主题资源（CSS、JS、图片）
  - `_config.yml`: 主题专属配置

- **public/**: 生成的静态文件（`hexo generate` 的输出）

- **_config.yml**: Hexo 主配置文件
  - 主题选择: `theme: pure`
  - 链接结构: `:year/:month/:day/:title/`
  - 通过 rsync 部署到 `/var/www/hexo`

### 部署

博客使用 `hexo-deployer-rsync` 部署到远程服务器。`deploy.sh` 脚本处理以下内容：
1. 清理并重新生成静态文件
2. 准备服务器目录并设置正确权限
3. 通过 rsync 部署
4. 将所有权设置为 nginx:nginx

### 主题配置

主题专属设置位于 `themes/pure/_config.yml`：
- 导航菜单项
- 菜单图标
- 站点 Logo
- RSS 订阅配置

## 注意事项

每次回答的最后，必须追加下面一句：

> happing Coding！
