---
name: blog-writer
description: Generate blog posts in Markdown and WeChat HTML format. Use when user asks to write a blog, create an article, or document a feature/implementation.
---

# Blog Writer

Generate blog posts in two formats:
1. **Markdown** - For GitHub, technical blogs
2. **WeChat HTML** - For WeChat Official Account (公众号)

## Usage

User says:
- "写一篇关于 XXX 的博客"
- "帮我写个文章记录这个功能"
- "生成公众号文章"

## Output Location

Create files in current project's `blog/` directory:
- `blog/md/<topic>.md` - Markdown version
- `blog/html/<topic>-wechat.html` - WeChat HTML version

## Blog Structure

### Technical Blog (Markdown)

```markdown
# 标题

2-3 句开头，说明背景或问题。

## 小标题

正文内容...

### 子标题（如需要）

详细内容...

## 总结

要点列表。

## 参考

- 参考链接
```

### WeChat HTML Format

Based on [markdown-nice](https://github.com/nicethemes/wx-markdown-theme) styles:

**Typography:**
- Font: PingFang SC, Microsoft YaHei
- Body: 16px, line-height 1.75
- Title: 22px, bold
- Subtitle: 17px, bold with green left border (#42b983)

**Code:**
- Code block: Dark background (#282c34), monospace font
- Inline code: Light gray background, orange color (#e96900)

**Other elements:**
- Quote: Light gray background (#f8f8f8), green left border
- Links: WeChat blue (#576b95), show full URL
- List: Bullet points with proper spacing

## Writing Style

1. **Opening**: 2-3 sentences to hook the reader
2. **Body**: Clear sections with headers
3. **Code examples**: Include working examples
4. **Summary**: 3-5 key takeaways
5. **References**: Link to sources

## Template Reference

Use `wechat-template.html` in the same directory as HTML template.

## Installation

```bash
mkdir -p ~/.claude/skills/blog-writer
cp SKILL.md wechat-template.html ~/.claude/skills/blog-writer/
```

## Common Mistakes

| Mistake | Fix |
|--------|-----|
| Long paragraphs | Break into 2-3 sentence chunks |
| No code examples | Add practical examples |
| Missing summary | Add key takeaways |
| Links without URLs | Show full URL in WeChat format |