---
title: Gradle与GradleWrapper的区别
date: 2025-04-16 19:00:02
tags: 工具
---

在日常 Java 后端开发中，Gradle 已成为构建自动化的重要工具。本文将围绕以下三个常见问题展开讨论，帮助大家深入理解和高效使用 Gradle：

1. Gradlew（Gradle Wrapper）的常用命令及解读  
2. 如何查看指定子模块的依赖树  
3. Gradle 与 Gradlew 的核心区别

---

## 一、Gradlew 常用命令及解读

`gradlew` 是 Gradle Wrapper 的执行脚本，确保在不同环境下使用项目指定版本的 Gradle 构建。以下是 Java 后端项目中最常用的 10 个命令：

| 命令 | 用途说明 |
|------|----------|
| `./gradlew build` | 编译、测试并打包生成构建产物（如 `.jar`） |
| `./gradlew clean` | 清除构建生成的临时输出（`build/` 目录） |
| `./gradlew bootRun` | 启动 Spring Boot 项目（依赖 boot 插件） |
| `./gradlew bootJar` | 构建可执行的 Spring Boot fat jar |
| `./gradlew test` | 执行所有单元测试 |
| `./gradlew dependencies` | 打印当前模块的依赖树 |
| `./gradlew --refresh-dependencies` | 强制刷新并重新下载所有依赖 |
| `./gradlew tasks` | 列出当前项目支持的所有构建任务 |
| `./gradlew properties` | 查看项目属性，如 group、version、路径等 |
| `./gradlew build -x test` | 构建时跳过测试任务（开发调试用） |

**进阶使用：**

```bash
./gradlew bootRun --args='--spring.profiles.active=dev'
```

## 二、查看指定子模块的依赖树

如果你的项目是一个多模块 Gradle 项目，并且你想查看某个子模块（例如 `ylsk-message`）的依赖结构，可以使用以下命令：

```
bash


复制编辑
./gradlew :wyt-backend:dependencies
```

### 可选参数（查看不同配置）：



| 命令                                   | 用途           |
| -------------------------------------- | -------------- |
| `--configuration compileClasspath`     | 查看编译期依赖 |
| `--configuration runtimeClasspath`     | 查看运行时依赖 |
| `--configuration testCompileClasspath` | 查看测试依赖   |

例如：

```
bash


复制编辑
./gradlew :wyt-backend:dependencies --configuration compileClasspath
```

输出中常见格式说明：

```
lua


复制编辑
+--- org.springframework.boot:spring-boot-starter-web -> 2.7.4
|    +--- org.springframework.boot:spring-boot-starter
|    |    +--- org.springframework.boot:spring-boot ...
```

- `+---` 表示直接依赖
- `|    +---` 表示传递依赖
- `->` 表示版本被替换（依赖冲突时的版本解析结果）

## 三、Gradle 与 Gradlew 有什么区别？

虽然 `gradle` 和 `gradlew` 作用类似，但它们背后的机制和使用场景有明显差异：

| 对比项         | `gradle`                    | `gradlew`                          |
| -------------- | --------------------------- | ---------------------------------- |
| 是否需本地安装 | ✅ 需要安装 Gradle           | ❌ 不需要，项目内自带 wrapper       |
| 版本控制       | 不可控，取决于本地版本      | 可控，项目中可指定版本             |
| 构建一致性     | ❌ 易因版本差异导致问题      | ✅ 保证不同环境构建结果一致         |
| CI/CD 支持     | 不推荐使用                  | 强烈推荐使用                       |
| 使用方式       | 直接运行，如 `gradle build` | 运行项目脚本，如 `./gradlew build` |

### Wrapper 文件组成：

```
text


复制编辑
gradlew                 // Linux/macOS 脚本
gradlew.bat             // Windows 脚本
gradle/wrapper/gradle-wrapper.properties
gradle/wrapper/gradle-wrapper.jar
```

### 如何添加 wrapper 到项目中？

如果你的项目没有 Gradle Wrapper，可通过以下命令生成：

```
bash


复制编辑
gradle wrapper --gradle-version 8.2
```

------

## ✅ 总结

- **推荐始终使用 `./gradlew` 来执行构建任务**，确保构建环境一致性
- 使用 `:moduleName:dependencies` 精确查看模块依赖，有助于排查依赖冲突
- 掌握常用命令能大幅提升开发效率，配合 CI/CD 使用更佳