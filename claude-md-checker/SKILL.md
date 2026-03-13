---
name: claude-md-checker
description: 检查 CLAUDE.md 是否符合官方最佳实践规范。使用时机：用户要求检查、审计、优化 CLAUDE.md 文件。
---

# CLAUDE.md 规范检查器

检查项目的 CLAUDE.md 文件是否符合 Claude Code 官方最佳实践。

## 使用场景

用户说：
- "检查一下 CLAUDE.md 写得对不对"
- "审计一下我的 CLAUDE.md"
- "优化一下 CLAUDE.md"
- "我的 CLAUDE.md 合规吗"

## 检查清单

### 1. 大小检查

| 标准 | 要求 | 检查方法 |
|------|------|----------|
| 行数 | ≤ 200 行 | 统计文件行数 |
| 每行价值 | 删除后会导致 Claude 犯错吗？ | 人工判断 |

**判定：**
- ✅ ≤ 200 行
- ⚠️ 100-200 行，建议精简
- ❌ > 200 行，必须精简

### 2. 结构检查

| 标准 | 要求 |
|------|------|
| 使用 Markdown 标题 | 有 `#` `##` `###` 层级 |
| 使用列表和表格 | 相关内容分组 |
| 避免大段文字 | 每段 2-3 句 |

**判定：**
- ✅ 结构清晰
- ⚠️ 部分可改进
- ❌ 结构混乱

### 3. 具体性检查

对比指令是否可验证：

| ❌ 模糊 | ✅ 具体 |
|--------|--------|
| "Format code properly" | "Use 2-space indentation" |
| "Test your changes" | "Run `npm test` before committing" |
| "Keep files organized" | "API handlers live in `src/api/handlers/`" |
| "写好代码" | "使用 2 空格缩进" |

**判定：**
- ✅ 指令具体可验证
- ⚠️ 部分指令模糊
- ❌ 大量模糊指令

### 4. 内容检查

**✅ 应该包含：**
- Claude 猜不到的 Bash 命令
- 与默认不同的代码风格规则
- 测试指令和偏好
- 仓库规范（分支命名、PR 惯例）
- 项目特有的架构决策
- 开发环境 quirks（必需的环境变量）
- 常见的坑

**❌ 不应该包含：**
- Claude 读代码就能知道的信息
- 标准语言约定
- 详细 API 文档（应链接到文档）
- 频繁变化的信息
- 冗长的解释或教程
- 文件级别的代码库描述

### 5. 一致性检查

- 检查是否有冲突的规则
- 检查是否有重复的内容
- 检查是否有过时的指令

### 6. 高级特性检查

| 特性 | 适用场景 |
|------|----------|
| `@import` | 内容可拆分到多个文件 |
| `.claude/rules/` | 大型项目，规则需要按文件类型分组 |
| `paths` frontmatter | 规则只对特定文件生效 |

## 输出格式

```markdown
## CLAUDE.md 检查报告

### 总体评分：X/10

### ✅ 做得好的地方
- ...

### ⚠️ 可以优化的地方
| 问题 | 位置 | 建议 |
|------|------|------|
| ... | ... | ... |

### ❌ 必须修改的问题
- ...

### 优化建议
...
```

## 执行步骤

1. 读取项目的 CLAUDE.md 文件
2. 按检查清单逐项检查
3. 输出检查报告
4. 如果用户同意，帮助优化文件

## 官方参考

- [Claude Code Memory 官方文档](https://code.claude.com/docs/en/memory)
- [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)