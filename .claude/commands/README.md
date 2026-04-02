## ⚡ `.claude/commands/` → One-Word Automations

Every markdown file in `.claude/commands/` becomes a slash command - a file named `review.md` creates `/project:review`.

**What you need to understand:**

- It's a **quick syntax** for recurring prompts
- Commands are deterministic - they execute every time with no exceptions
- They're lighter than agents

**Template for a good command:**

```yaml
---
description: Deep dive into the current branch changes
argument-hint: <none>
---

## Git Diff Analysis

!`git diff main...HEAD`

Review these changes for:
1. **Bugs** - Logic errors, off-by-one mistakes
2. **Security** - SQL injection, XSS, auth issues
3. **Tests** - Missing or incomplete coverage
4. **Performance** - N+1 queries, unnecessary loops

Provide specific file-by-file feedback with line numbers.
```

**Pro tips:**

- Use `!` to execute shell commands directly
- `~/.claude/commands/` = available in **all** your projects
- `.claude/commands/` = project-specific