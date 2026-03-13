# Claude Code Status Line

Claude Code 状态栏脚本，显示模型、目录、Git 分支、运行时长、上下文使用量、输出 tokens、生成速度。

## 预览

```
[Opus] 📁 myproject  git:(main) | ⏱️ 3h8m4s
███░░░░░░░ 35% | 53k/200k | out: 12k | 42.1 t/s
```

## 安装

```bash
# 克隆仓库
git clone https://github.com/mlbo/claude.git ~/claude

# 运行安装脚本
cd ~/claude/statusline
./install.sh
```

文件会安装到 `~/.claude/statusline/` 目录：
```
~/.claude/statusline/
├── statusline.sh    # 主脚本
└── config.json      # 配置文件
```

## 配置

编辑 `~/.claude/statusline/config.json`：

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

## 卸载

```bash
cd ~/claude/statusline
./uninstall.sh
```

## 自定义扩展

### 可用数据

Claude Code 通过 stdin 传递 JSON 数据，可用字段：

| 字段 | 说明 |
|------|------|
| `model.display_name` | 模型名称 |
| `workspace.current_dir` | 当前目录 |
| `context_window.used_percentage` | 上下文使用百分比 |
| `context_window.current_usage.input_tokens` | 输入 tokens |
| `context_window.current_usage.output_tokens` | 输出 tokens |
| `context_window.total_output_tokens` | 累计输出 tokens |
| `context_window.context_window_size` | 上下文窗口大小 |
| `cost.total_cost_usd` | 会话成本 |
| `cost.total_duration_ms` | 会话时长 |

### 调试

```bash
echo '{"model":{"display_name":"Opus"},"workspace":{"current_dir":"/tmp"},"context_window":{"used_percentage":50,"context_window_size":200000,"current_usage":{"input_tokens":50000,"output_tokens":10000},"total_output_tokens":10000},"cost":{"total_duration_ms":120000}}' | ~/.claude/statusline/statusline.sh
```

## 参考

- [Claude Code Statusline 文档](https://code.claude.com/docs/en/statusline)
- [claude-hud](https://github.com/jarrodwatts/claude-hud)

## License

MIT