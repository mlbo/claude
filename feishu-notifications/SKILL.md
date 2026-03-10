---
name: feishu-notifications
description: Use when tasks complete or status updates require user notification via Feishu. Triggers on task completion and status changes.
---

# Feishu Notifications

## Overview

Send notifications to Feishu (飞书) when:
- Tasks complete
- Errors occur
- Progress updates needed

## Quick Reference

| Scenario | Command |
|----------|---------|
| Task completed | `feishu-notify completion "消息内容"` |
| Progress update | `feishu-notify progress "当前进度" 50` |
| Error occurred | `feishu-notify error "错误信息"` |

## Configuration

Config stored in `~/.claude/feishu-config.json`:
```json
{
  "appId": "cli_xxxxxxxxxxxx",
  "appSecret": "xxxxxxxxxxxxxxxx",
  "receiverId": "ou_xxxxxxxxxxxx",
  "receiverType": "open_id"
}
```

## Usage Examples

```bash
# 任务完成
feishu-notify completion "代码重构完成，修改 15 个文件"

# 进度更新
feishu-notify progress "正在运行测试" 50

# 错误通知
feishu-notify error "部署失败：连接超时"
```

## Common Mistakes

| Mistake | Fix |
|--------|-----|
| Not configured | Check `~/.claude/feishu-config.json` |
| Invalid receiver | Verify `receiverId` is correct Open ID |
| Token expired | Tokens auto-refresh, check app credentials |
| jq not found | Install: `brew install jq` |
| Message too long (error 9499) | Keep messages under 200 chars |