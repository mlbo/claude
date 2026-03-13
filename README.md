# Claude Code Tools

个人 Claude Code 工具和配置集合。

## 目录结构

```
claude/
├── blog/                    # 博客文章
├── blog-writer/             # 博客生成技能
├── statusline/              # 状态栏工具
└── feishu-notifications/    # 飞书通知技能
```

## Skills

### blog-writer

生成博客文章，支持 Markdown 和微信公众号 HTML 两种格式。

**功能：**
- 自动生成技术博客结构
- 公众号 HTML 格式（markdown-nice 风格）
- 代码高亮、引用块、列表等样式

**安装：**
```bash
mkdir -p ~/.claude/skills/blog-writer
cp blog-writer/SKILL.md blog-writer/wechat-template.html ~/.claude/skills/blog-writer/
```

**用法：**
对 Claude Code 说：
- "写一篇关于 XXX 的博客"
- "帮我写个文章记录这个功能"

详细文档：[blog-writer/SKILL.md](blog-writer/SKILL.md)

## Tools

## Tools

### statusline

Claude Code 状态栏，实时显示上下文消耗、tokens 使用量、生成速度等信息。

**效果预览：**
```
[Opus] 📁 myproject  git:(main) | ⏱️ 3h8m4s
███░░░░░░░ 35% | 53k/200k | out: 12k | 42.1 t/s
```

**安装：**
```bash
git clone https://github.com/mlbo/claude.git ~/claude
cd ~/claude/statusline && ./install.sh
```

文件安装到 `~/.claude/statusline/`，配置也在该目录。

**详细文档：** [statusline/README.md](statusline/README.md)

### feishu-notifications

发送飞书通知的技能。

**使用场景：**
- 任务完成通知
- 进度更新
- 错误报警

**配置：**

在 `~/.claude/feishu-config.json` 中配置：
```json
{
  "appId": "cli_xxxxxxxxxxxx",
  "appSecret": "xxxxxxxxxxxxxxxx",
  "receiverId": "ou_xxxxxxxxxxxx",
  "receiverType": "open_id"
}
```

**用法示例：**
```bash
# 任务完成
feishu-notify completion "代码重构完成"

# 进度更新
feishu-notify progress "正在运行测试" 50

# 错误通知
feishu-notify error "部署失败"
```

## 博客文章

- [打造 Claude Code 状态栏](blog/md/statusline.md) - 记录 statusline 的实现过程

## 依赖

- `jq` - JSON 解析
- `bc` - 数字计算（系统自带）
- `git` - 版本控制