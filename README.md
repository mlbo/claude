# Claude Code Tools

个人 Claude Code 工具和配置集合。

## 目录结构

```
claude/
├── blog/                    # 博客文章
├── statusline/              # 状态栏工具
└── feishu-notifications/    # 飞书通知技能
```

## 工具列表

### statusline

Claude Code 状态栏，实时显示上下文消耗、tokens 使用量、生成速度等信息。

**效果预览：**
```
[Opus] 📁 myproject  git:(main) | ⏱️ 3m5s
███░░░░░░░ 35% | 53k/200k | out: 12k | 42.1 t/s
```

**一键安装：**
```bash
mkdir -p ~/.claude
curl -fsSL https://raw.githubusercontent.com/mlbo/claude/main/statusline/statusline.sh -o ~/.claude/statusline.sh
curl -fsSL https://raw.githubusercontent.com/mlbo/claude/main/statusline/config.json -o ~/.claude/statusline-config.json
chmod +x ~/.claude/statusline.sh
```

然后在 `~/.claude/settings.json` 添加：
```json
"statusLine": {
  "type": "command",
  "command": "~/.claude/statusline.sh"
}
```

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

- [打造 Claude Code 状态栏](blog/statusline.md) - 记录 statusline 的实现过程

## 依赖

- `jq` - JSON 解析
- `bc` - 数字计算（系统自带）
- `git` - 版本控制