#!/bin/bash
# Feishu Notification Helper for Claude Code
# Usage: feishu-notify <type> <message> [options]

set -e

CONFIG_FILE="$HOME/.claude/feishu-config.json"
TOKEN_CACHE="$HOME/.claude/.feishu-token"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

require_jq() {
    if ! command -v jq &> /dev/null; then
        log_error "jq is required. Install with: brew install jq"
        exit 1
    fi
}

get_token() {
    require_jq

    if [[ ! -f "$CONFIG_FILE" ]]; then
        log_error "配置文件不存在，请先配置 ~/.claude/feishu-config.json"
        exit 1
    fi

    local app_id=$(jq -r '.appId' "$CONFIG_FILE")
    local app_secret=$(jq -r '.appSecret' "$CONFIG_FILE")

    # Check cached token
    if [[ -f "$TOKEN_CACHE" ]]; then
        local cached_token=$(jq -r '.token' "$TOKEN_CACHE" 2>/dev/null)
        local expires_at=$(jq -r '.expiresAt' "$TOKEN_CACHE" 2>/dev/null)
        local now=$(date +%s)

        if [[ -n "$cached_token" && "$cached_token" != "null" && "$expires_at" -gt "$now" ]]; then
            echo "$cached_token"
            return 0
        fi
    fi

    # Request new token
    local response=$(curl -s --connect-timeout 10 --max-time 30 -X POST \
        "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal" \
        -H "Content-Type: application/json" \
        -d "{\"app_id\":\"$app_id\",\"app_secret\":\"$app_secret\"}")

    local token=$(echo "$response" | jq -r '.tenant_access_token')
    local expire=$(echo "$response" | jq -r '.expire')

    if [[ "$token" == "null" || -z "$token" ]]; then
        log_error "获取 token 失败: $response"
        exit 1
    fi

    # Cache token
    local expires_at=$(($(date +%s) + expire - 300))
    echo "{\"token\":\"$token\",\"expiresAt\":$expires_at}" > "$TOKEN_CACHE"
    echo "$token"
}

send_text() {
    local token=$1
    local receiver_id=$2
    local receiver_type=$3
    local message=$4

    local response=$(curl -s --connect-timeout 10 --max-time 30 -X POST \
        "https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=$receiver_type" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -d "{
            \"receive_id\": \"$receiver_id\",
            \"msg_type\": \"text\",
            \"content\": \"{\\\"text\\\":\\\"$message\\\"}\"
        }")

    local code=$(echo "$response" | jq -r '.code')
    if [[ "$code" != "0" ]]; then
        log_error "发送消息失败: $response"
        return 1
    fi

    echo "$response" | jq -r '.data.message_id'
}

main() {
    local command=${1:-help}
    shift || true

    case "$command" in
        completion|done)
            require_jq
            local message="$1"
            local token=$(get_token)
            local receiver_id=$(jq -r '.receiverId' "$CONFIG_FILE")
            local receiver_type=$(jq -r '.receiverType // "open_id"' "$CONFIG_FILE")

            send_text "$token" "$receiver_id" "$receiver_type" "✅ $message"
            log_info "通知已发送"
            ;;
        progress)
            require_jq
            local message="$1"
            local percent="${2:-0}"
            local token=$(get_token)
            local receiver_id=$(jq -r '.receiverId' "$CONFIG_FILE")
            local receiver_type=$(jq -r '.receiverType // "open_id"' "$CONFIG_FILE")

            local bar=$(printf '█%.0s' $(seq 1 $((percent/10))))$(printf '░%.0s' $(seq 1 $((10-percent/10))))
            send_text "$token" "$receiver_id" "$receiver_type" "📊 [$bar] $percent% - $message"
            log_info "进度已更新: $percent%"
            ;;
        error)
            require_jq
            local message="$1"
            local token=$(get_token)
            local receiver_id=$(jq -r '.receiverId' "$CONFIG_FILE")
            local receiver_type=$(jq -r '.receiverType // "open_id"' "$CONFIG_FILE")

            send_text "$token" "$receiver_id" "$receiver_type" "❌ $message"
            log_info "错误通知已发送"
            ;;
        *)
            cat << EOF
Feishu Notification Helper

Usage: feishu-notify <command> [arguments]

Commands:
  completion <message>         发送完成通知
  progress <msg> <percent>     发送进度更新
  error <message>              发送错误通知

Examples:
  feishu-notify completion "任务已完成"
  feishu-notify progress "正在处理..." 50
  feishu-notify error "部署失败"
EOF
            ;;
    esac
}

main "$@"