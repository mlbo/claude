# Claude Code Tools

个人 Claude Code 配置和工具集合，用于分享 skill 和工具。

## 核心规范

> ⚠️ 必须遵守的规则

| 规则 | 说明 |
|------|------|
| **Commit 前确认** | 先总结修改内容，询问用户是否提交 |
| **Push 前确认** | 推送到远程仓库前需用户确认 |
| **不随意删除文件** | `git rm`、删除目录前先确认用户意图 |
| **gitignore 谨慎修改** | 涉及删除/忽略规则时先确认 |
| **Skill 位置** | 项目里放根目录（分享用），实际使用在 `~/.claude/skills/` |

## 目录结构

```
claude/
├── blog/md/                 # Markdown 博客
├── blog/html/               # 公众号 HTML
├── blog-writer/             # 博客生成技能
├── claude-md-checker/       # CLAUDE.md 检查器
├── statusline/              # 状态栏工具
├── feishu-notifications/    # 飞书通知技能
├── CLAUDE.md
└── README.md
```

## 创建新工具

### 目录模板

```
工具名/
├── README.md        # 使用文档
├── 主脚本           # 核心代码
├── config.json      # 配置（可选）
├── install.sh       # 安装脚本
└── uninstall.sh     # 卸载脚本
```

### 安装位置

文件安装到 `~/.claude/<工具名>/`，同一功能放同一目录。

### 跨平台兼容

| 差异 | macOS | Linux |
|------|-------|-------|
| sed | `sed -i ''` | `sed -i` |
| date | BSD 语法 | GNU 语法 |
| Unicode | 避免 `tr`，用循环替代 |

## 创建 Skill

```
skill名/
├── SKILL.md             # 技能定义（必需）
└── *.html               # 模板文件（按需）
```

安装：`cp <skill名>/SKILL.md ~/.claude/skills/<skill名>/`

## 博客生成

输出位置：`blog/md/` 和 `blog/html/`

模板：`blog-writer/wechat-template.html`

## 服务器验证

连接信息在全局记忆中，需验证时查阅全局记忆。

## 依赖

- `jq` - JSON 解析
- `bc` - 数字计算
- `git` - 版本控制

## README 更新规范

新增内容时更新 README.md：
- Skill：Skills 表格添加一行
- Tool：Tools 表格添加一行
- 博客：博客文章列表添加链接