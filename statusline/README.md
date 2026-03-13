# Claude Code Status Line

Claude Code 状态栏脚本，显示模型、目录、Git 分支、运行时长、上下文使用量、输出 tokens、生成速度。

## 预览

```
[GLM-5] 📁 claude  git:(main) | ⏱️ 3m5s
███░░░░░░░ 35% | 53k/200k | out: 12k | 42.1 t/s
```

## 一键安装

```bash
mkdir -p ~/.claude
curl -fsSL https://raw.githubusercontent.com/mlbo/claude/main/statusline/statusline.sh -o ~/.claude/statusline.sh
curl -fsSL https://raw.githubusercontent.com/mlbo/claude/main/statusline/config.json -o ~/.claude/statusline-config.json
chmod +x ~/.claude/statusline.sh
```

然后编辑 `~/.claude/settings.json`，添加：

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh"
  }
}
```

## 手动安装

1. 复制文件：
   ```bash
   mkdir -p ~/.claude
   cp statusline.sh ~/.claude/
   cp config.json ~/.claude/statusline-config.json
   chmod +x ~/.claude/statusline.sh
   ```

2. 编辑 `~/.claude/settings.json`，添加 `statusLine` 配置

## 卸载

```bash
rm ~/.claude/statusline.sh ~/.claude/statusline-config.json
# 并从 settings.json 中删除 statusLine 配置
```

## 配置

编辑 `~/.claude/statusline-config.json`：

```json
{
  "showDuration": true,
  "showDirectory": true,
  "showGitBranch": true,
  "showContextBar": true,
  "showTokens": true,
  "showOutputTokens": true,
  "showSpeed": true
}
```

将对应项设为 `false` 即可隐藏。

## 自定义扩展

### 可用数据

Claude Code 通过 stdin 传递 JSON 数据，可用字段：

| 字段 | 说明 |
|------|------|
| `model.id` / `model.display_name` | 模型标识/显示名 |
| `workspace.current_dir` | 当前目录 |
| `context_window.used_percentage` | 上下文使用百分比 |
| `context_window.current_usage.input_tokens` | 输入 tokens |
| `context_window.current_usage.output_tokens` | 输出 tokens |
| `context_window.current_usage.cache_read_input_tokens` | 缓存读取 tokens |
| `context_window.current_usage.cache_creation_input_tokens` | 缓存创建 tokens |
| `context_window.context_window_size` | 上下文窗口大小 |
| `context_window.total_input_tokens` | 累计输入 tokens |
| `context_window.total_output_tokens` | 累计输出 tokens |
| `cost.total_cost_usd` | 会话成本（美元）|
| `cost.total_duration_ms` | 会话时长（毫秒）|
| `cost.total_api_duration_ms` | API 调用时长 |
| `cost.total_lines_added` / `total_lines_removed` | 增删代码行数 |
| `session_id` | 会话 ID |
| `version` | Claude Code 版本 |

### 添加自定义显示

编辑 `statusline.sh`，参考现有代码添加：

```bash
# 示例：添加成本显示
COST=$(jq -r '.cost.total_cost_usd // 0' <<< "$input")
# 在第二行追加
L2="$L2 | \$${COST}"
```

### 调试

手动测试脚本：

```bash
echo '{"model":{"display_name":"Opus"},"workspace":{"current_dir":"/tmp/test"},"context_window":{"used_percentage":50,"context_window_size":200000,"current_usage":{"input_tokens":50000,"output_tokens":10000},"total_output_tokens":10000},"cost":{"total_duration_ms":120000}}' | ~/.claude/statusline.sh
```

## 参考

- [Claude Code Statusline 文档](https://code.claude.com/docs/en/statusline)
- [claude-hud](https://github.com/jarrodwatts/claude-hud) - 参考了 token 计算和速度追踪的实现

## License

MIT