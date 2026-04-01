---
title: hexo个人博客搭建
date: 2023-11-21 11:06:46
tags: 工具
---

### 为什么要搭建个人博客
1. 俗话说：“好记性不如烂笔头”
2. 记录在本地磁盘痛点：检索困难、容易丢失、分类归档体验差等
3. 记录在第三方平台（简书、CSDN、掘金）痛点：UI界面丑、有违规风险、账号密码记不住等

### 搭建个人博客工具调研
* WordPress是一款强大的内容管理系统，适合非技术用户，有大量主题和插件。但可能需要更多资源，对定制性有一定限制。
* Jekyll和Hugo是静态网站生成器，生成速度快，安全性高。Jekyll基于Ruby，Hugo基于Go，两者都适合技术用户，但Jekyll在大型项目中可能较慢，而Hugo则更快。
* Hexo是基于Node.js的静态博客生成器，简单易用，生成速度快，适合追求速度和轻量级的用户。然而，相比Jekyll和Hugo，Hexo的生态相对较小。

***

# Hexo
### 环境准备
1. **Node.js和npm：**
   在[Node.js官网](https://nodejs.org/en)下载最新版本的Node.js安装包，并按照安装向导进行安装。Node.js会自动包含npm。
   
   ~~~
   ~ node -v
   v14.20.1
   ~ npm -v
   6.14.17
   ~~~
2. **Git：**
   在[Git官网](https://git-scm.com/)下载最新版本的Git安装包，按照安装向导进行安装。Git是Hexo用于版本控制的工具。
   
   ~~~
   ~ git --version
   git version 2.32.1 (Apple Git-133)
   ~~~
### 搭建步骤

1. **安装Hexo：**

   - 打开命令行或终端，运行以下命令安装Hexo：

   ```
   npm install -g hexo-cli
   ```

2. **创建博客：**

   - 在你希望创建博客的文件夹内，运行以下命令初始化Hexo博客：

   ```
   hexo init myblog
   ```

3. **进入博客目录：**

   ```
   cd myblog
   ```

4. **安装依赖：**

   ```
   npm install
   ```

5. **启动本地服务器：**

   ```
   hexo server
   ```

   在浏览器中访问 `http://localhost:4000`，你将能够看到正在搭建的博客。

6. **选择主题：**

   - Hexo支持许多主题，你可以在[Hexo官方主题列表](https://hexo.io/themes/)中选择一个你喜欢的主题，并按照主题文档进行安装和配置。

   - 这里选择：https://github.com/leedom92/hexo-theme-leedom
      ~~~
      npm i hexo-theme-leedom
      ~~~
      
   - 在根目录下的_config.yml文件中修改主题的配置

      ~~~
      # Extensions
      ## Plugins: https://hexo.io/plugins/
      ## Themes: https://hexo.io/themes/
      ##theme: pure
      theme: leedom
      ~~~
   - 重新构建，焕然一新
      ~~~
      hexo clean
      hexo s
      ~~~
      

7. **编写文章：**

   - 在 `source/_posts` 目录下创建Markdown文件，写下你的文章内容。

8. **生成静态文件：**

   ```
   bashCopy code
   hexo generate
   ```

   这会在 `public` 目录下生成最终的静态文件。

9. **部署博客：**

   - 如果你想将博客部署到GitHub等平台，按照相应平台的配置和Hexo文档中的部署章节进行操作。
   
     安装 Hexo 的 GitHub 部署插件：
   
     ```
     npm install hexo-deployer-git --save
     ```
     在 _config.yml 中配置 GitHub Pages 部署信息：
     ~~~
     deploy:
     		type: git
     		repo: https://github.com/username/username.github.io.git
     		branch: master
     ~~~
		运行以下命令将 Hexo 站点部署到 GitHub Pages：
		~~~
		hexo clean
   	hexo generate
		hexo deploy
		~~~
10. **hexo常用命令：**
    
    ~~~
    # 1.初始化博客
    hexo init <folder>
    # 2.启动本地服务器
    hexo server
    # 3.创建新文章
    hexo new <title>
    # 4.生成静态文件
    hexo generate
    # 5.部署博客
    hexo deploy
    # 6.清理缓存
    hexo clean
    # 7.查看帮助
    hexo --help
~~~