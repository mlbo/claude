#!/bin/bash
# Claude Code Status Line 卸载脚本

rm -f "$HOME/.claude/statusline.sh"
rm -f "$HOME/.claude/statusline-config.json"
rm -f /tmp/claude-speed.json

if [ -f "$HOME/.claude/settings.json" ]; then
  TMP=$(mktemp)
  jq 'del(.statusLine)' "$HOME/.claude/settings.json" > "$TMP" 2>/dev/null && mv "$TMP" "$HOME/.claude/settings.json"
fi

echo "✅ 卸载完成"