#!/bin/bash
# Claude Code Status Line
input=$(cat)

# 加载配置
CONFIG="$HOME/.claude/statusline-config.json"
[ -f "$CONFIG" ] && eval "$(jq -r 'to_entries[] | "SHOW_\(.key | tr "a-z" "A-Z")=\(.value)"' "$CONFIG" 2>/dev/null)"
[ -z "$SHOW_DURATION" ] && { SHOW_DURATION=true; SHOW_DIRECTORY=true; SHOW_GIT_BRANCH=true; SHOW_CONTEXT_BAR=true; SHOW_TOKENS=true; SHOW_OUTPUT_TOKENS=true; SHOW_SPEED=true; }

# 提取数据
MODEL=$(jq -r '.model.display_name' <<< "$input")
DIR=$(jq -r '.workspace.current_dir' <<< "$input")
PCT=$(jq -r '.context_window.used_percentage // 0' <<< "$input")
IN_TOK=$(jq -r '.context_window.current_usage.input_tokens // 0' <<< "$input")
CACHE_R=$(jq -r '.context_window.current_usage.cache_read_input_tokens // 0' <<< "$input")
CACHE_C=$(jq -r '.context_window.current_usage.cache_creation_input_tokens // 0' <<< "$input")
OUT_TOK=$(jq -r '.context_window.total_output_tokens // 0' <<< "$input")
CTX_SIZE=$(jq -r '.context_window.context_window_size // 200000' <<< "$input")
DUR_MS=$(jq -r '.cost.total_duration_ms // 0' <<< "$input")

DIR_NAME="${DIR##*/}"
SEC=$((DUR_MS / 1000)); H=$((SEC / 3600)); M=$(((SEC % 3600) / 60)); S=$((SEC % 60))
[ "$H" -gt 0 ] && DURATION="${H}h${M}m${S}s" || DURATION="${M}m${S}s"

# Git 分支
[ "$SHOW_GIT_BRANCH" = true ] && BRANCH=$(git -C "$DIR" branch --show-current 2>/dev/null) && [ -n "$BRANCH" ] && ! git -C "$DIR" diff --quiet 2>/dev/null && BRANCH="$BRANCH*"

# Token 格式化
fmt() { [ "$1" -ge 1000000 ] && { bc <<< "scale=1;$1/1000000" | tr -d '\n'; echo -n "M"; } || { [ "$1" -ge 1000 ] && echo -n "$(($1/1000))k" || echo -n "$1"; }; }
TOTAL=$((IN_TOK + CACHE_R + CACHE_C))

# 速度计算
SPEED=""; CACHE="/tmp/claude-speed.json"
[ "$SHOW_SPEED" = true ] && [ -f "$CACHE" ] && { PO=$(jq -r '.out // 0' "$CACHE" 2>/dev/null); PT=$(jq -r '.ts // 0' "$CACHE" 2>/dev/null); NOW=$(date +%s)000; DT=$((OUT_TOK - PO)); DM=$((NOW - PT)); [ "$DT" -gt 0 ] && [ "$DM" -gt 0 ] && [ "$DM" -lt 3000 ] && SPEED=$(bc <<< "scale=1;$DT*1000/$DM"); }
echo "{\"out\":$OUT_TOK,\"ts\":$(date +%s)000}" > "$CACHE"

# 进度条
P=${PCT%.*}; F=$((P / 10)); E=$((10 - F))
BAR=""
for ((i=0; i<F; i++)); do BAR="${BAR}█"; done
for ((i=0; i<E; i++)); do BAR="${BAR}░"; done

# 颜色
G='\033[32m'; Y='\033[33m'; R='\033[31m'; X='\033[0m'
C="$G"; [ "$P" -ge 70 ] && C="$Y"; [ "$P" -ge 90 ] && C="$R"

# 第一行
L1="[$MODEL]"
[ "$SHOW_DIRECTORY" = true ] && L1="$L1 📁 $DIR_NAME"
[ -n "$BRANCH" ] && L1="$L1  git:($BRANCH)"
[ "$SHOW_DURATION" = true ] && L1="$L1 | ⏱️ $DURATION"

# 第二行
L2=""
[ "$SHOW_CONTEXT_BAR" = true ] && L2="${C}${BAR}${X} ${P}%"
[ "$SHOW_TOKENS" = true ] && { [ -n "$L2" ] && L2="$L2 | "; L2="$L2$(fmt $TOTAL)/$(fmt $CTX_SIZE)"; }
[ "$SHOW_OUTPUT_TOKENS" = true ] && { [ -n "$L2" ] && L2="$L2 | "; L2="${L2}out: $(fmt $OUT_TOK)"; }
[ -n "$SPEED" ] && L2="$L2 | ${SPEED} t/s"

echo -e "$L1"
[ -n "$L2" ] && echo -e "$L2"