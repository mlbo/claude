# 如何写好 CLAUDE.md：官方文档最佳实践

最近整理 Claude Code 配置时，发现官方文档里有一套完整的 CLAUDE.md 最佳实践。结合自己的踩坑经验，分享一下如何写好这个文件。

## CLAUDE.md 是什么？

CLAUDE.md 是 Claude Code 在启动时自动读取的项目指令文件。官方文档称之为"给 Claude 的持久化上下文"——每次对话开始，Claude 都会先读这个文件，了解项目规范和工作方式。

除了 CLAUDE.md，Claude Code 还有 **Auto Memory** 功能。两者配合使用：

| 功能 | 谁写的 | 内容 | 作用域 |
|------|--------|------|--------|
| CLAUDE.md | 你 | 指令和规则 | 项目/用户/组织 |
| Auto Memory | Claude | 学习到的知识 | 项目 |

## 放在哪里？

官方支持多个位置，按优先级从低到高：

| 位置 | 作用域 | 用途 |
|------|--------|------|
| `/etc/claude-code/CLAUDE.md` | 组织级 | 公司统一规范（IT 管理） |
| `~/.claude/CLAUDE.md` | 用户级 | 个人偏好，所有项目共享 |
| `./CLAUDE.md` 或 `./.claude/CLAUDE.md` | 项目级 | 项目规范，团队共享 |

**推荐做法**：项目规范写在 `./CLAUDE.md` 并提交到 git，个人偏好写在 `~/.claude/CLAUDE.md`。

## 如何写好 CLAUDE.md？

官方文档强调四个原则：**大小、结构、具体性、一致性**。

### 大小：控制在 200 行以内

CLAUDE.md 会消耗 context window。文件越长，消耗越多，Claude 遵循指令的效果越差。

官方建议：**每一行都要问自己——删掉这行会导致 Claude 犯错吗？** 如果不会，就删掉。

### 结构：用 Markdown 组织

使用标题和列表分组，Claude 扫描结构的方式和人类一样——有组织的章节比大段文字更容易遵循。

### 具体性：可验证的指令

官方给出了对比：

| ❌ 模糊 | ✅ 具体 |
|--------|--------|
| "Format code properly" | "Use 2-space indentation" |
| "Test your changes" | "Run `npm test` before committing" |
| "Keep files organized" | "API handlers live in `src/api/handlers/`" |

指令要具体到可以验证。

### 一致性：避免冲突

如果两个规则冲突，Claude 可能随意选一个。定期检查 CLAUDE.md，删除过时或矛盾的指令。

## 应该写什么？

官方给出了明确的建议：

### ✅ 应该包含

- Claude 猜不到的 Bash 命令
- 与默认不同的代码风格规则
- 测试指令和偏好
- 仓库规范（分支命名、PR 惯例）
- 项目特有的架构决策
- 开发环境 quirks（必需的环境变量）
- 常见的坑

### ❌ 不应该包含

- Claude 读代码就能知道的信息
- 标准语言约定
- 详细 API 文档（链接到文档）
- 频繁变化的信息
- 冗长的解释或教程
- 文件级别的代码库描述

## 使用 @import 引入其他文件

CLAUDE.md 支持 `@path/to/import` 语法引入其他文件：

```markdown
See @README.md for project overview and @package.json for available npm commands.

# Additional Instructions
- Git workflow: @docs/git-instructions.md
- Personal overrides: @~/.claude/my-project-instructions.md
```

这让你可以把详细内容拆分到多个文件，保持 CLAUDE.md 简洁。

## 用 .claude/rules/ 组织规则

对于大型项目，可以用 `.claude/rules/` 目录组织指令：

```
your-project/
├── .claude/
│   ├── CLAUDE.md
│   └── rules/
│       ├── code-style.md
│       ├── testing.md
│       └── security.md
```

还可以用 `paths` frontmatter 限定规则只对特定文件生效：

```markdown
---
paths:
  - "src/api/**/*.ts"
---

# API Development Rules

- All API endpoints must include input validation
- Use the standard error response format
```

## Auto Memory：让 Claude 自己记笔记

Auto Memory 是 Claude Code 的自动学习功能。当你在对话中纠正 Claude 或表达偏好时，Claude 会自动记录。

存储位置：`~/.claude/projects/<project>/memory/`

```
~/.claude/projects/<project>/memory/
├── MEMORY.md      # 索引，每次对话加载前 200 行
├── debugging.md   # 详细笔记
└── api-conventions.md
```

使用 `/memory` 命令可以查看和管理这些记忆。

## 常见问题

### Claude 不遵循我的 CLAUDE.md

官方诊断步骤：

1. 运行 `/memory` 确认文件被加载
2. 检查文件位置是否正确
3. 让指令更具体
4. 检查是否有冲突的指令

如果 Claude 总是忽略某条规则，可能是文件太长，规则被淹没了。

### CLAUDE.md 太大怎么办

超过 200 行会影响效果。解决方案：

- 用 `@import` 拆分内容
- 用 `.claude/rules/` 组织规则
- 删除 Claude 不需要的内容

### 与 Skills 的区别

官方文档强调：CLAUDE.md 是每次都加载的上下文，Skills 是按需加载的知识。

- 放在 CLAUDE.md：适用于所有场景的规则
- 放在 Skills：特定场景才需要的知识

## 快速开始

官方提供了一个便捷命令：`/init`

这个命令会分析你的代码库，检测构建系统、测试框架和代码模式，自动生成一个 CLAUDE.md 草稿。然后你可以在此基础上 refinement。

## 检查工具：claude-md-checker

我基于官方最佳实践创建了一个 skill，可以自动检查 CLAUDE.md 是否合规。

**安装：**
```bash
mkdir -p ~/.claude/skills/claude-md-checker
cp claude-md-checker/SKILL.md ~/.claude/skills/claude-md-checker/
```

**使用：**
对 Claude Code 说：
- "检查一下 CLAUDE.md 写得对不对"
- "审计一下我的 CLAUDE.md"
- "我的 CLAUDE.md 合规吗"

**检查项：**
1. 大小检查（≤ 200 行）
2. 结构检查（Markdown 标题、列表、表格）
3. 具体性检查（可验证的指令）
4. 内容检查（应该/不应该包含的内容）
5. 一致性检查（冲突、重复、过时）
6. 高级特性检查（@import、.claude/rules/）

工具会输出评分和具体的优化建议，省去每次手动对照规范的时间。

## 总结

结合官方文档和个人经验，写好 CLAUDE.md 的关键：

1. **控制大小** - 200 行以内，每行都值得
2. **具体可验证** - "Run `npm test`" 而不是 "Test your changes"
3. **组织结构** - 用 Markdown 标题和列表
4. **善用工具** - @import、.claude/rules/、Auto Memory
5. **定期维护** - 删除过时指令，保持一致性

好的 CLAUDE.md 就像是给 Claude 的操作手册，投入时间打磨，会让协作效率大幅提升。

## 参考

- [Claude Code Memory 官方文档](https://code.claude.com/docs/en/memory)
- [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)