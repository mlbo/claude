# 项目说明

个人 Claude Code 配置和工具集合。

## 目录结构

```
claude/
├── blog/                    # 博客文章
│   ├── md/                  # Markdown 版本
│   │   └── statusline.md
│   └── html/                # 公众号 HTML 版本
│       └── statusline-wechat.html
├── blog-writer/             # 博客生成技能
│   ├── SKILL.md             # 技能定义
│   └── wechat-template.html # 公众号模板
├── statusline/              # 状态栏工具
│   ├── README.md            # 使用文档
│   ├── statusline.sh        # 主脚本
│   ├── config.json          # 配置文件
│   ├── install.sh           # 安装脚本
│   └── uninstall.sh         # 卸载脚本
├── feishu-notifications/    # 飞书通知技能
├── CLAUDE.md                # 本文件
└── README.md                # 项目说明
```

## 创建新工具的工作流

### 1. 目录组织

每个工具独立一个文件夹，包含：
- `README.md` - 使用文档
- 主脚本/代码文件
- `config.json` - 配置文件（如需要）
- `install.sh` / `uninstall.sh` - 安装卸载脚本

**文件放置原则：**
- 安装后文件放在 `~/.claude/<工具名>/` 目录
- 同一功能的文件放在同一文件夹，不散落到 `~/.claude/` 根目录
- 例如：`~/.claude/statusline/statusline.sh`、`~/.claude/statusline/config.json`

**跨平台支持：** 脚本需同时兼容 macOS 和 Linux，注意：
- `sed` 命令差异（macOS 用 `sed -i ''`，Linux 用 `sed -i`）
- `date` 命令差异
- 使用 `printf` 替代 `echo -e` 提高兼容性
- 避免使用 `tr` 处理 Unicode 字符（用循环替代）

### 2. 服务器验证

服务器连接信息已记录在全局记忆中，需要验证时查阅全局记忆。

### 3. 博客记录

实现完成后，在 `blog/` 目录创建文章记录：
- 实现过程
- 踩过的坑
- 设计决策
- 如何与 Claude Code 协作

**同时生成两个版本：**
- `<主题>.md` - 技术博客（Markdown 格式）
- `<主题>-wechat.html` - 公众号版本（HTML 格式）

**公众号 HTML 格式规范（参考 markdown-nice）：**
- 字体：PingFang SC, Microsoft YaHei 等中文字体
- 字号：正文 16px，标题 22px，小标题 17px
- 行高：1.75
- 小标题：左边框 + 绿色（#42b983）
- 代码块：暗色背景（#282c34）+ 等宽字体
- 行内代码：浅灰背景 + 橙色（#e96900）
- 引用块：浅灰背景 + 左边框
- 模板参见 `blog-writer/wechat-template.html`

## 依赖

- `jq` - JSON 解析
- `bc` - 数字计算（系统自带）
- `git` - 版本控制和分支显示