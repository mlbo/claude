#!/bin/bash
# Claude Code Status Line 安装脚本

set -e

echo "🚀 安装 Claude Code Status Line..."

# 检查 jq
if ! command -v jq &> /dev/null; then
  echo "❌ 需要安装 jq"
  echo "   macOS: brew install jq"
  echo "   Ubuntu: sudo apt install jq"
  exit 1
fi

# 创建目录
mkdir -p "$HOME/.claude/statusline"

# 复制文件
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
cp "$SCRIPT_DIR/statusline.sh" "$HOME/.claude/statusline/"
cp "$SCRIPT_DIR/config.json" "$HOME/.claude/statusline/"
chmod +x "$HOME/.claude/statusline/statusline.sh"

echo "✅ 文件已复制到 ~/.claude/statusline/"

# 更新 settings.json
SETTINGS="$HOME/.claude/settings.json"
if [ -f "$SETTINGS" ]; then
  if grep -q '"statusLine"' "$SETTINGS" 2>/dev/null; then
    # 更新已有配置
    TMP=$(mktemp)
    jq '.statusLine.command = "~/.claude/statusline/statusline.sh"' "$SETTINGS" > "$TMP" && mv "$TMP" "$SETTINGS"
    echo "✅ 已更新 settings.json"
  else
    # 添加新配置
    TMP=$(mktemp)
    jq '. + {"statusLine":{"type":"command","command":"~/.claude/statusline/statusline.sh"}}' "$SETTINGS" > "$TMP" && mv "$TMP" "$SETTINGS"
    echo "✅ 已添加 statusLine 配置"
  fi
else
  echo '{"statusLine":{"type":"command","command":"~/.claude/statusline/statusline.sh"}}' > "$SETTINGS"
  echo "✅ 已创建 settings.json"
fi

echo "🔄 重启 Claude Code 生效"