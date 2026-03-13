# 我和 Claude Code 一起写了个状态栏

最近用 Claude Code 时总有个烦恼：聊着聊着上下文就满了，然后被迫压缩对话，之前的上下文就丢了。想着要是能实时看到上下文使用情况就好了。

于是我问 Claude Code："帮我装一个可以看到上下文消耗的插件"。

## Claude Code 的回答

Claude Code 没有直接给我装插件，而是告诉我它有内置的 `/statusline` 功能。它发了一堆文档过来，我才知道原来 Claude Code 原生支持自定义状态栏。

机制是这样的：

```
Claude Code → stdin JSON → 你的脚本 → stdout → 显示在终端
```

每次交互后，Claude Code 会把会话数据打包成 JSON，传给你配置的脚本。你的脚本处理后输出什么，就显示什么。简单直接。

## 开始实现

我先让 Claude Code 写了个基础版本：

```bash
MODEL=$(echo "$input" | jq -r '.model.display_name')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
echo "[$MODEL] $PCT%"
```

跑起来后，我想加更多东西。于是陆陆续续提需求：

- "加上当前目录"
- "显示 git 分支"
- "运行时长也加上"
- "成本不用了"
- "显示 tokens 数量，不要百分比"

Claude Code 每次都很配合地改。最有趣的是中间踩的一个坑。

## Unicode 字符的坑

我想加个进度条，看起来直观。Claude Code 用 `█` 和 `░` 这两个 Unicode 字符来实现。

在 macOS 上测试没问题，显示得很漂亮。但我让 Claude Code 在服务器上验证时，进度条变成了乱码。

我："不好看哎"。

Claude Code 开始排查。它先检查服务器的 locale 设置，发现服务器支持 UTF-8，直接 `printf` 也能正常显示 Unicode 字符。但通过脚本输出就乱码。

最后发现是 `tr` 命令的问题。`tr` 是按字节处理字符的，遇到多字节的 UTF-8 字符就会出错。

解决方案是用循环构建字符串：

```bash
# 这样不行
BAR=$(printf '%*s' "$F" | tr ' ' '█')

# 这样才行
BAR=""
for ((i=0; i<F; i++)); do BAR="${BAR}█"; done
```

这个过程让我感受到：有个能直接在服务器上跑命令验证的搭档，确实方便。

## 配置灵活性

做到一半，我觉得应该让这个脚本可配置。不是所有人都想要所有信息。

Claude Code 就加了个配置文件支持：

```json
{
  "showDuration": true,
  "showDirectory": true,
  "showGitBranch": true,
  "showTokens": true,
  "showSpeed": true
}
```

不想显示哪项就改成 `false`。

## 最终效果

```
[Opus] 📁 myproject  git:(main) | ⏱️ 3m5s
███░░░░░░░ 35% | 53k/200k | out: 12k | 42.1 t/s
```

- 第一行：模型、目录、分支、时长
- 第二行：进度条、上下文使用、输出 tokens、生成速度

进度条颜色会变：绿色正常，黄色警告，红色危险。

## Claude Code 给我提供的字段

我问 Claude Code 还有哪些数据可以用，它列了一堆：

| 字段 | 说明 |
|------|------|
| `model.display_name` | 模型名称 |
| `workspace.current_dir` | 当前目录 |
| `context_window.used_percentage` | 上下文使用百分比 |
| `context_window.total_output_tokens` | 累计输出 tokens |
| `cost.total_cost_usd` | 会话成本 |
| `cost.total_duration_ms` | 运行时长 |
| `cost.total_lines_added` | 新增代码行数 |

想要什么自己加就行。

## 一些思考

整个实现过程大概半小时。我只需要描述需求，Claude Code 负责写代码、测试、调试。遇到问题它自己会去查文档、跑命令验证。

有意思的是，它不是给我推荐一个现成的插件，而是告诉我 Claude Code 本身就有这个能力。这让我意识到：Claude Code 的设计哲学是提供机制而不是提供产品——给你一个管道，你想显示什么自己写。

这种设计对开发者很友好。你不需要等官方加功能，自己就能扩展。当然前提是你得知道有这个能力，这方面文档还是得翻一翻。

## 开源实现现状

其实社区已经有比较成熟的状态栏项目：

**[claude-hud](https://github.com/jarrodwatts/claude-hud)** by Jarrod Watts

这是目前最完善的状态栏插件，功能包括：
- 工具活动追踪（正在读/编辑哪些文件）
- 子代理状态显示
- Todo 进度条
- Pro/Max 用户的用量限制显示
- 多种预设主题

安装方式是通过 Claude Code 的插件系统：
```
/plugin marketplace add jarrodwatts/claude-hud
/plugin install claude-hud
```

我的实现更轻量，就是一个独立的 shell 脚本，不依赖插件系统。如果你想要开箱即用的完整体验，推荐用 claude-hud；如果像我一样想自己掌控、便于修改，可以参考我的脚本。

## 参考文档

- **[Claude Code Statusline 官方文档](https://code.claude.com/docs/en/statusline)** - 所有可用字段、配置方式、示例代码
- **[claude-hud 源码](https://github.com/jarrodwatts/claude-hud)** - 参考了速度追踪的实现思路

## 安装

如果你想用，一行命令：

```bash
mkdir -p ~/.claude
curl -fsSL https://raw.githubusercontent.com/mlbo/claude/main/statusline/statusline.sh -o ~/.claude/statusline.sh
curl -fsSL https://raw.githubusercontent.com/mlbo/claude/main/statusline/config.json -o ~/.claude/statusline-config.json
chmod +x ~/.claude/statusline.sh
```

然后在 `~/.claude/settings.json` 加上：

```json
"statusLine": {
  "type": "command",
  "command": "~/.claude/statusline.sh"
}
```

代码在 [GitHub](https://github.com/mlbo/claude/tree/main/statusline)，有问题可以提 issue。