## 📁 `.claude/agents/` → AI Teammates That Do Specialized Work

Agents are defined in Markdown files with YAML frontmatter, and you can create them manually or via the `/agents` command.

**What you need to understand:**

- Agents get their own context window, their own tool access, and their own instructions
- Unlike commands, they are **probabilistic** = Claude decides when to use them
- Each can have its own tools, permissions, and hooks

**Minimal template for a custom agent:**

```yaml
---
name: code-reviewer
description: Review code changes for bugs, security, and performance
tools: [Bash, Write, Edit]
permission_mode: auto
---

# Code Reviewer Agent

You are a senior code reviewer focused on:
1. Finding actual bugs (not nitpicking)
2. Security vulnerabilities
3. Performance issues
4. Architectural patterns

Review the code and provide specific, actionable feedback.
```

**Pro tips:**

- Place them in `~/.claude/agents/` to reuse everywhere
- Or in `.claude/agents/` for project-specific agents
- Use `/agents` to create them interactively