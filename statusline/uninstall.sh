#!/bin/bash
# Claude Code Status Line 卸载脚本

echo "🗑️  卸载 Claude Code Status Line..."

# 删除 statusline 目录
rm -rf "$HOME/.claude/statusline"

# 从 settings.json 移除配置
SETTINGS="$HOME/.claude/settings.json"
if [ -f "$SETTINGS" ]; then
  TMP=$(mktemp)
  jq 'del(.statusLine)' "$SETTINGS" > "$TMP" 2>/dev/null && mv "$TMP" "$SETTINGS"
fi

# 删除速度缓存
rm -f /tmp/claude-speed.json

echo "✅ 卸载完成"