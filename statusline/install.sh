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
mkdir -p "$HOME/.claude"

# 复制文件
cp statusline.sh "$HOME/.claude/statusline.sh"
chmod +x "$HOME/.claude/statusline.sh"

# 复制配置（如果不存在）
[ ! -f "$HOME/.claude/statusline-config.json" ] && cp config.json "$HOME/.claude/statusline-config.json"

# 更新 settings.json
SETTINGS="$HOME/.claude/settings.json"
if [ -f "$SETTINGS" ]; then
  if ! grep -q '"statusLine"' "$SETTINGS" 2>/dev/null; then
    TMP=$(mktemp)
    jq '. + {"statusLine":{"type":"command","command":"~/.claude/statusline.sh"}}' "$SETTINGS" > "$TMP" && mv "$TMP" "$SETTINGS"
  fi
else
  echo '{"statusLine":{"type":"command","command":"~/.claude/statusline.sh"}}' > "$SETTINGS"
fi

echo "✅ 安装完成"
echo "🔄 重启 Claude Code 生效"