---
title: ClaudeCode开发者速查表
date: 2026-03-05 00:08:08
tags: 工具
---

> 完整命令 + 实战使用场景，涵盖 CLI 命令、Slash 命令、快捷键、CLAUDE.md 配置与高阶工作流

- **安装**：`npm install -g @anthropic-ai/claude-code`
- **需要**：Claude Pro / Max 订阅或 API Key
- **支持平台**：macOS · Linux · Windows (WSL)

---

## 一、CLI 基础命令

### 启动 / 会话

```bash
# 打开交互式 REPL，从头开始新会话
claude

# 带初始提示启动，直接进入话题
claude "解释这个项目的架构"

# 继续上一次会话（保留完整上下文）
claude -c

# 通过 Session ID 恢复指定历史会话
claude -r "abc123" "继续实现这个 PR"
```

> **场景**：每次开新功能前用 `claude` 启动，切换任务时用 `-c` 无缝接续，跨天切换用 `-r`

### 非交互 / 脚本模式

```bash
# 打印模式：回答后立即退出，适合脚本调用
claude -p "解释这个函数"

# 管道模式：将文件/命令输出传给 Claude 处理
cat error.log | claude -p "分析这些错误并分类"

# 以 JSON 格式输出，便于程序解析
claude -p "query" --output-format json

# CI/CD 流水线中调用（GitHub Actions 等）
claude -p "修复 lint 错误并建议提交信息"
```

> **场景**：自动化脚本、Git hooks、CI 检查、批量代码分析

### 维护命令

```bash
claude update    # 更新到最新版本
claude -v        # 查看当前版本号
claude --verbose # 详细日志模式，调试时开启
```

---

## 二、常用 CLI Flags

### 模型 & 模式控制

| Flag | 说明 |
|------|------|
| `--model sonnet` | 指定模型（sonnet / opus / haiku / 完整名称） |
| `--permission-mode plan` | 以计划模式启动（只读，不修改文件） |
| `--max-turns 5` | 限制 Agent 最多执行 N 轮（非交互模式） |
| `--dangerously-skip-permissions` | 跳过权限确认（CI 环境用，**谨慎！**） |
| `--fallback-model sonnet` | 主模型过载时自动切换备用模型 |

### System Prompt 定制

| Flag | 说明 |
|------|------|
| `--system-prompt` | 完全替换系统提示词（完全自定义） |
| `--system-prompt-file` | 从文件加载系统提示词（打印模式） |
| `--append-system-prompt` | 追加到默认提示词后（**推荐！** 保留内置能力） |
| `--append-system-prompt-file` | 从文件追加，适合团队共享提示词模板 |

> 💡 **最佳实践**：大多数情况用 `--append-system-prompt`，只有需要完全接管时才用 `--system-prompt`

### 工具权限 & 目录

| Flag | 说明 |
|------|------|
| `--allowedTools "Bash(git log:*)" "Read"` | 白名单工具（无需确认） |
| `--disallowedTools "Edit"` | 黑名单工具（禁止使用） |
| `--tools "Bash,Edit,Read"` | 指定本次可用工具集 |
| `--add-dir ../lib` | 添加额外工作目录（多仓库场景） |

### 输出 & 调试

| Flag | 说明 |
|------|------|
| `--output-format json` | JSON 格式输出（脚本/自动化） |
| `--output-format stream-json` | 流式 JSON 输出（实时处理） |
| `--json-schema '{...}'` | 强制按 JSON Schema 输出结构化数据 |
| `--debug "api,mcp"` | 启用调试日志（可过滤分类） |
| `--fork-session` | 恢复时创建新 Session ID（分叉实验） |

---

## 三、Slash 命令（交互模式内）

### 会话管理

| 命令 | 说明 | 使用时机 |
|------|------|---------|
| `/clear` | 清空上下文，重新开始（保留设置） | 上下文过长时 |
| `/compact` | 压缩对话历史，保留关键信息 | 节省 token |
| `/compact [说明]` | 压缩时指定保留哪些内容 | 精准控制 |
| `/resume` | 从列表选择历史会话恢复 | 切换项目 |

### 项目 & 配置

| 命令 | 说明 | 使用时机 |
|------|------|---------|
| `/init` | 分析项目并生成 CLAUDE.md 记忆文件 | **新项目必做** |
| `/config` | 查看/修改配置（模型、权限等） | 调参 |
| `/doctor` | 检查环境健康状态和配置问题 | 排查问题 |
| `/mcp` | 查看已连接的 MCP 服务器状态 | 集成检查 |

### 模式 & 工作流

| 命令 | 说明 | 使用时机 |
|------|------|---------|
| `/plan` | 切换到计划模式（只读分析，不执行） | **大改动前必用** |
| `/think` | 开启扩展思考（复杂推理问题） | 架构决策 |
| `/memory` | 查看和编辑 Claude 的项目记忆 | 管理上下文 |
| `/review` | 要求 Claude 回顾并评审最近的改动 | 提交前检查 |

### 插件 & 洞察

| 命令 | 说明 | 使用时机 |
|------|------|---------|
| `/plugins` | 管理已安装的插件（list / install / update） | 扩展能力 |
| `/insights` | 生成过去一个月使用情况的 HTML 分析报告 | 优化工作流 |
| `/help` | 查看所有可用命令（含自定义 Skills） | 任何时候 |

### `/compact` 精准压缩示例

```
/compact Focus on preserving our auth implementation and the database schema decisions we made
```

> 上下文快满时，用自然语言告诉 Claude 压缩哪些内容、保留什么关键信息

---

## 四、交互模式快捷键

### 输入控制

| 快捷键 | 功能 |
|--------|------|
| `Enter` | 发送消息 |
| `Shift + Enter` | 换行（多行输入） |
| `Ctrl + J` | 粘贴多行内容 |
| `Ctrl + C` | 清空输入行 |
| `↑` | 上一条命令 |

### 模式切换

| 快捷键 | 功能 |
|--------|------|
| `Esc` | 中断当前输出 |
| `Esc Esc` | 退出 / 返回上级 |
| `Ctrl + P` | 切换计划模式 |
| `Ctrl + F` × 2 | 终止后台 Agent |
| `Ctrl + D` | 退出程序 |

### Prompt 内联语法

| 语法 | 功能 |
|------|------|
| `@路径` | 引用文件（如 `@./src/auth.ts`） |
| `@./src/` | 引用整个目录 |
| `!命令` | 执行 Shell 命令（如 `!npm test`） |
| `Alt + B/F` | 光标按 Word 跳转 |

---

## 五、CLAUDE.md — 项目记忆文件

### 完整模板示例

```markdown
## 项目概述
电商平台后台管理系统，Next.js + TypeScript

## 技术栈
- Frontend: Next.js 14 + TypeScript + Tailwind
- Backend: Node.js + Express + Prisma
- Database: PostgreSQL (生产) / SQLite (开发)
- State: Zustand (客户端) + React Query (服务端)

## 编码规范
- 所有新代码用 TypeScript，strict 模式
- 组件用函数式 + Hooks，禁止 class 组件
- 新函数必须写 Jest 单元测试
- 遵循现有 ESLint 配置，提交前必须通过

## 目录约定
- 组件: src/components/（按功能域分子目录）
- 工具函数: src/utils/
- 测试文件: 与源文件同目录，.test.ts 后缀

## 当前任务
- 正在开发用户权限模块（分支: feat/rbac）
- # Claude：请优先参考 src/auth/ 下的已有实现
```

### 文件层级策略

```
project/
├── CLAUDE.md          # 全局：整体架构 + 规范
├── src/
│   ├── CLAUDE.md      # 前端：组件约定 + 状态管理
│   └── api/
│       └── CLAUDE.md  # API：端点规范 + 认证逻辑
└── tests/
    └── CLAUDE.md      # 测试：框架 + 覆盖率要求
```

> Claude 会自动向上查找并合并多层 CLAUDE.md，越具体的目录优先级越高

### 快速生成 & 维护

```bash
# 首次初始化（Claude 自动分析项目）
/init

# 完成功能后让 Claude 更新记忆
刚刚完成了 RBAC 权限模块，请更新 CLAUDE.md

# 查看/编辑当前记忆
/memory
```

> 💡 **关键洞察**：CLAUDE.md 是项目基础设施，不是临时笔记。把它纳入版本控制，让团队成员都能受益

---

## 六、文件引用 @ 与 Shell 命令 !

### @ 文件/目录引用

```
# 引用单个文件，让 Claude 聚焦分析
Review @./src/components/Button.tsx for accessibility issues

# 引用整个目录，让 Claude 了解模块结构
Analyze the architecture of @./src/

# 同时引用多个文件进行对比分析
Compare @./old-api.js and @./new-api.ts and suggest migration steps

# 引用需求文档，按规格实现功能
Based on @./docs/spec.md, implement the user auth flow
```

> 最佳实践：用精确路径 `@src/auth.ts` 代替模糊描述"找那个认证文件"

### ! Shell 命令（直接执行）

```bash
!npm test                          # 不离开 Claude 直接运行测试
!git log --oneline -10             # 查看提交历史，获取上下文
!ls -la ./src/                     # 确认文件路径是否正确
!npm run build 2>&1 | head -30     # 查看构建错误，然后让 Claude 修复
```

> 场景：TDD 开发时频繁运行测试、检查文件结构、获取 git 状态再让 Claude 处理

---

## 七、MCP 服务器集成

### MCP 管理命令

```bash
# 添加本地 MCP 服务器
claude mcp add my-server -- /path/to/server

# 添加 SSE 远程 MCP 服务器
claude mcp add --transport sse https://mcp.example.com/sse

# 从配置文件批量加载 MCP 服务器
claude --mcp-config ./mcp.json

# 严格模式：只用配置文件中的 MCP（忽略全局配置）
claude --strict-mcp-config --mcp-config ./mcp.json
```

### 常用 MCP 集成场景

| 集成 | 用途 | 推荐度 |
|------|------|--------|
| **GitHub** | 直接操作 Issue / PR / 代码 | ⭐⭐⭐ 高频 |
| **数据库** | 查询 / 分析 / 生成迁移 | ⭐⭐⭐ 实用 |
| **Slack** | 读取消息，发送通知 | ⭐⭐ 协作 |
| **Sentry** | 读取错误报告，分析堆栈 | ⭐⭐ 调试 |
| **Figma** | 读取设计稿，生成组件代码 | ⭐⭐ 设计 |
| **Jira / Linear** | 读取任务，生成代码 | ⭐⭐ PM |

---

## 八、Subagents — 子代理定义

### 命令行定义（临时）

```bash
claude --agents '{
  "reviewer": {
    "description": "代码改动后主动触发审查",
    "prompt": "你是资深代码审查员，专注安全、性能、可维护性",
    "tools": ["Read", "Grep", "Glob"],
    "model": "sonnet"
  },
  "debugger": {
    "description": "遇到报错或测试失败时触发",
    "prompt": "你是调试专家，分析根因并提供修复方案"
  }
}'
```

### 文件定义（持久，推荐）

```markdown
<!-- .claude/agents/reviewer.md -->
---
name: reviewer
description: 代码改动后审查质量和安全
model: sonnet
color: orange
tools:
  - Read
  - Grep
  - Glob
  - Bash
---

你是资深代码审查员。
重点关注：安全漏洞、性能瓶颈、可维护性
每次审查输出结构化报告
```

> 放入 `.claude/agents/` 目录，Claude 自动加载，团队共享

> 💡 **子代理优势**：每个子代理有独立上下文窗口，避免主会话上下文膨胀；专业化提示词带来更高质量输出；按域分工节省 token 成本

---

## 九、实战工作流

### 场景 1：新功能开发（TDD 流程）

`/plan 分析` → `生成失败测试` → `!npm test 验证` → `实现代码` → `测试通过`

```bash
# 第一步：计划模式分析，不改代码
/plan
为用户注册功能设计完整的 JWT 认证流程，参考 @./src/auth/

# 第二步：生成失败测试
先写一个关于用户注册的失败单元测试
!npm test -- auth.test.ts

# 第三步：实现功能
现在实现让测试通过的代码
```

### 场景 2：大型重构

```bash
# 先用计划模式，只读不写
claude --permission-mode plan
分析 @./src/ 整体架构，识别需要重构的地方，不要修改任何文件

# 认可计划后，用 worktree 隔离改动
claude -w

# 分步执行，每步完成后检查
先只重构 UserService，完成后告诉我，我再决定是否继续
```

> 用 `-w` 在隔离的 git worktree 中工作，不影响主分支；随时可以丢弃

### 场景 3：调试线上错误

```bash
# 管道传入错误日志
cat production-error.log | claude -p "分析错误模式，找出根本原因，按优先级排序"

# 或在交互模式中
!tail -100 /var/log/app.log
分析上面的错误日志，重点关注 TypeError 和 null 引用
查看 @./src/user-service.js 对应的代码片段
```

### 场景 4：代码审查 & 提交

```bash
# 提交前自动审查
!git diff HEAD
Review 上面的改动：安全漏洞、性能问题、代码规范

# 生成提交信息
!git diff --staged
基于改动生成符合 Conventional Commits 规范的提交信息

# CI 中自动审查（脚本模式）
claude -p "审查 staged 改动，如有 lint 错误请修复" \
  --allowedTools "Bash(npm run lint:*)" "Edit"
```

### 场景 5：长任务 / 上下文管理

```bash
# 任务太大时，先生成计划文件
把这个功能拆解成分步计划，保存到 Plan.md

# 完成一步后保存状态，清空上下文
更新 Plan.md 标记进度
/compact Focus on preserving the Plan.md progress and auth module decisions
# 或
/clear
参考 @./Plan.md，继续第二步
```

> ⚠️ **注意**：即使 Sonnet 有 1M token 上下文，保持上下文聚焦仍能提高准确性并降低成本。当 Claude 开始重复或遗忘时，立即执行 `/compact` 或 `/clear`

---

## 十、实用 Prompt 模板

### 代码理解

```
Analyze @./src/ structure and suggest improvements
Explain the data flow in @./src/api/orders.ts
What does @./utils/parser.js do? List all edge cases
```

### 功能实现

```
Implement JWT auth with refresh tokens, refer to @./src/auth/
Add rate limiting to @./src/routes/api.ts, 100 req/min per user
Refactor @./EmailService.js using dependency injection
```

### 测试 & 文档

```
Generate unit tests for @./src/utils/validation.js
Generate API docs for all endpoints in @./src/routes/
Debug this error: "TypeError: Cannot read 'id' of undefined" @./src/user-service.js
```

---

## 十一、安装与环境配置

### 安装

```bash
# 全局安装
npm install -g @anthropic-ai/claude-code

# Windows（WSL 推荐）
npm config set os linux
npm install -g @anthropic-ai/claude-code --force --no-os-check

# 验证安装
claude -v
```

### 认证方式

```bash
# 方式 1：Claude 订阅（推荐日常使用）
# Pro $20/月 或 Max $100/月
claude  # 首次运行会引导登录

# 方式 2：API Key（推荐 CI/自动化）
export ANTHROPIC_API_KEY=sk-ant-...
claude

# 方式 3：Bedrock / Vertex
export CLAUDE_CODE_USE_BEDROCK=1
```

### 常用全局配置

```bash
# 设置通知方式
claude config set --global preferredNotifChannel terminal_bell

# 关闭遥测
export CLAUDE_CODE_DISABLE_TELEMETRY=1

# 禁用 1M 上下文（性能调优）
export CLAUDE_CODE_DISABLE_1M_CONTEXT=1
```

---

> 基于官方文档整理 · 2025年3月 · [docs.claude.com](https://docs.claude.com) · [code.claude.com](https://code.claude.com)
