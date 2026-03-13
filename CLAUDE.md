# 项目说明

个人 Claude Code 配置和工具集合。

## 目录结构

```
claude/
├── blog/                    # 博客文章
│   └── statusline.md        # 状态栏实现记录
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

## 依赖

- `jq` - JSON 解析
- `bc` - 数字计算（系统自带）
- `git` - 版本控制和分支显示