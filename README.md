# Claude Skills

个人 Claude Code 技能集合。

## 技能列表

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