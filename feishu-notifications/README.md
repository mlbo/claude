# Claude Code 飞书通知技能 (feishu-notifications)

这是一个用于在任务完成或状态更新时发送消息到飞书的技能。

## 简介

Claude Code 飞书通知技能能够自动将任务执行的结果、进度以及错误信息推送到指定的飞书用户或群组。它支持在 macOS 和 Linux 上运行，并通过飞书机器人 API 实现消息发送。

## 快速安装

### 1. 安装依赖

确保系统中已安装 `jq` 和 `curl`：

- **macOS (Homebrew):**
  ```bash
  brew install jq curl
  ```
- **Linux (Ubuntu/Debian):**
  ```bash
  sudo apt-get update && sudo apt-get install -y jq curl
  ```
- **Linux (CentOS/RHEL):**
  ```bash
  sudo yum install -y jq curl
  ```

### 2. 部署技能文件

将技能文件夹放到你的 Claude Code 技能目录下（通常是 `~/.claude/skills/feishu-notifications`）：

```bash
mkdir -p ~/.claude/skills
# 复制文件夹到该目录下
cp -r feishu-notifications ~/.claude/skills/
chmod +x ~/.claude/skills/feishu-notifications/feishu-notify.sh
```

## 配置说明

### 1. 创建配置文件

在 `~/.claude/feishu-config.json` 中添加以下凭据：

```json
{
  "appId": "cli_xxxxxxxxxxxx",
  "appSecret": "your-app-secret",
  "receiverId": "ou_xxxxxxxxxxxx",
  "receiverType": "open_id"
}
```

### 2. 获取凭据

1.  **App ID & App Secret**:
    *   访问 [飞书开放平台](https://open.feishu.cn/)。
    *   创建一个“企业自建应用”或进入已有应用。
    *   在“凭证与基础信息”中复制 **App ID** 和 **App Secret**。
    *   在“权限管理”中添加 `im:message:send_as_bot` 权限并发布版本。
2.  **Receiver ID (Open ID)**:
    *   访问 [飞书开放平台 API 调试台](https://open.feishu.cn/api-explorer/)。
    *   在左侧搜索并选择 「发送消息」 或 「通过手机号或邮箱获取用户 ID」 接口
    *   在 「查询参数」 页签，将 user_id_type 设置为 open_id
    *   点击 「快速复制 open_id」 按钮
    *   在弹窗中搜索或选择指定用户，点击 「复制成员 ID」

  优点： 可视化操作，适合快速获取少量用户的 Open ID。

## 使用方法

### 命令行调用

可以直接在命令行中使用 `feishu-notify` 脚本（或通过 Claude 调用）：

- **任务完成通知：**
  ```bash
  feishu-notify completion "任务已完成"
  ```
- **进度更新 (0-100)：**
  ```bash
  feishu-notify progress "正在处理" 50
  ```
- **错误通知：**
  ```bash
  feishu-notify error "发生错误：连接超时"
  ```

### Hook 自动通知 (可选)

在 `~/.claude/settings.json` 中添加以下 Hook 以便在系统事件发生时自动触发：

```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/skills/feishu-notifications/feishu-notify.sh completion \"$CLAUDE_NOTIFICATION_MESSAGE\""
          }
        ]
      }
    ]
  }
}
```

*注：推荐让 Claude 在任务完成时主动调用，而不是全局使用 Hook，以避免通知过于频繁。*

## 常见错误与排查

| 错误现象 | 可能原因 | 解决方案 |
| :--- | :--- | :--- |
| `jq not found` | 未安装 jq | 执行 `brew install jq` 或对应系统的安装命令 |
| 配置文件不存在 | 路径不正确或未创建 | 确认存在 `~/.claude/feishu-config.json` |
| `9499` 错误 | 消息长度超限 | 飞书 API 限制消息约为 200 字符，请缩短消息内容 |
| Token 获取失败 | 凭据错误 | 检查 `appId` 和 `appSecret` 是否正确 |

## 文件结构

```text
~/.claude/
├── feishu-config.json   # 飞书应用凭据
├── .feishu-token        # Token 缓存 (自动生成)
└── skills/
    └── feishu-notifications/
        ├── SKILL.md      # 技能说明 (Claude 使用)
        ├── README.md     # 使用文档 (你正在阅读的)
        └── feishu-notify.sh # 通知脚本
```

## 卸载

```bash
rm -rf ~/.claude/skills/feishu-notifications
rm ~/.claude/feishu-config.json
```
