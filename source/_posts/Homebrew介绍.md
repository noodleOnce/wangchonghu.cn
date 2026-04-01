---
title: Homebrew介绍
date: 2023-11-24 10:51:53
tags: 工具
---

![image-20231124105959638](../imgs/image-20231124105959638.png)

Homebrew 是 macOS 上的一款包管理工具，用于简化软件的安装和管理。以下是 Homebrew 的基本使用教程：

### 安装 Homebrew：

打开终端（Terminal）并执行以下命令安装 Homebrew：

```
bashCopy code
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

这个命令会下载并安装 Homebrew。

### 使用 Homebrew 安装软件：

1. **安装软件：**

   使用 Homebrew 安装软件非常简单，只需执行以下命令：

   ```
   bashCopy code
   brew install <软件名称>
   ```

   例如，要安装 Git，可以运行：

   ```
   bashCopy code
   brew install git
   ```

2. **更新 Homebrew：**

   保持 Homebrew 及其软件包是最新的，定期执行以下命令：

   ```
   bashCopy code
   brew update
   ```

3. **卸载软件：**

   卸载已安装的软件包可以使用 `brew uninstall` 命令：

   ```
   bashCopy code
   brew uninstall <软件名称>
   ```

4. **查看已安装的软件：**

   查看已安装的软件列表：

   ```
   bashCopy code
   brew list
   ```

5. **搜索软件包：**

   想要查找特定软件包是否可用，可以使用 `brew search`：

   ```
   bashCopy code
   brew search <关键词>
   ```

   例如，搜索 Python：

   ```
   bashCopy code
   brew search python
   ```

6. **查看软件信息：**

   查看软件包的详细信息：

   ```
   bashCopy code
   brew info <软件名称>
   ```

   例如，查看 Git 的信息：

   ```
   bashCopy code
   brew info git
   ```

7. **清理不需要的文件：**

   清理 Homebrew 下载的临时文件和旧版本：

   ```
   bashCopy code
   brew cleanup
   ```

这些是 Homebrew 的基本用法。使用这些命令，你可以方便地安装、更新和管理软件包。在 Homebrew 中，`Formulae` 和 `Casks` 分别用于管理两类软件包：命令行工具和图形界面应用。以下是它们的区别：

1. **Formulae（公式）：**

   - **类型：** Formulae 是用于安装命令行工具（通常是不带图形界面的程序）的规范。

   - **安装路径：** 安装的命令行工具通常会被放置在 `/usr/local/bin` 目录下，使其可以通过命令行直接调用。

   - 例子：

      安装 Git 或 Python 的命令如下：

     ```
     bashCopy code
     brew install git
     brew install python
     ```

2. **Casks（瓶子）：**

   - **类型：** Casks 用于安装图形界面应用，这些应用通常有用户界面，例如浏览器、编辑器、办公软件等。

   - **安装路径：** Casks 安装的应用通常位于 `/Applications` 目录下，就像你手动安装的应用一样。

   - 例子：

      安装 Google Chrome 或 Visual Studio Code 的命令如下：

     ```
     bashCopy code
     brew install --cask google-chrome
     brew install --cask visual-studio-code
     ```

通过这种方式，Homebrew 提供了一种统一的管理方式，使用户可以方便地通过命令行安装和管理不同类型的软件包。你可以使用 `brew install` 安装 Formulae，而对于 Casks，你需要使用 `brew install --cask`。
