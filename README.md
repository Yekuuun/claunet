```C#
                 _______  ___      _______  __   __  __    _  _______  _______ 
                |       ||   |    |   _   ||  | |  ||  |  | ||       ||       |
                |       ||   |    |  |_|  ||  | |  ||   |_| ||    ___||_     _|
                |       ||   |    |       ||  |_|  ||       ||   |___   |   |  
                |      _||   |___ |       ||       ||  _    ||    ___|  |   |  
                |     |_ |       ||   _   ||       || | |   ||   |___   |   |  
                |_______||_______||__| |__||_______||_|  |__||_______|  |___|

                      -------Setup CLAUDE in your .NET project-------
```

# Complete Guide: Master Claude Code Setup


A base template repository for configuring CLAUDE in your code projects (focusing on .NET here)

---

## 1. 📁 `.claude/agents/` → AI Teammates That Do Specialized Work

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

---

## 2. ⚡ `.claude/commands/` → One-Word Automations

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

---

## 3. 🪝 `.claude/hooks/` → Auto-run Before Every Commit

Hooks are configured in your settings.json and consist of three parts: an event (when?), a matcher (which tool?), and the action.

**What you need to understand:**
- PreToolUse hooks validate operations before they execute - useful when you want to allow certain operations of a tool while blocking others
- Exit code `2` = **hard stop** (deterministic)
- Exit code `0` = allow

**Example: Block dangerous commands**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/scripts/validate-bash.sh"
          }
        ]
      }
    ]
  }
}
```

Validation script (`~/.claude/scripts/validate-bash.sh`):
```bash
#!/bin/bash
COMMAND=$(echo $1 | jq -r '.tool_input.command')

# Block dangerous commands
if [[ "$COMMAND" =~ "rm -rf" ]] || [[ "$COMMAND" =~ "sudo" ]]; then
  echo "Dangerous command blocked"
  exit 2
fi

exit 0
```

**Pro tips:**
- You can use the interactive `/hooks` command to configure hooks via a menu interface, which is often easier than editing JSON
- Most useful hooks: `PreToolUse`, `PostToolUse`, `UserPromptSubmit`

---

## 4. 🛡️ `.claude/rules/` → Guardrails It Actually Follows

**What you need to understand:**
- As your project grows and your CLAUDE.md gets crowded, start splitting instructions into `.claude/rules/` files, scoped by path where it makes sense
- Rules apply globally to the project

**Template for scoped rules:**
```yaml
# .claude/rules/api-rules.md
---
paths: ["src/api/**"]
---

## API Development Rules

1. Always return 200/400/500 status codes
2. Validate input with zod schemas
3. Use middleware for auth/cors
4. Log errors but don't expose internal details
```

```yaml
# .claude/rules/test-rules.md
---
paths: ["**/*.test.ts", "**/*.spec.ts"]
---

## Testing Rules

1. Use describe/it blocks
2. Test happy path AND error cases
3. Mock external dependencies
4. Keep tests under 50 lines
```

---

## 5. 📚 `.claude/skills/` → Teach It New Tricks

**What you need to understand:**
- Skills are **complex and reusable** workflows
- They can have multiple files and resources
- They are probabilistic (Claude decides when to use them)

**Structure of a skill:**
```
.claude/skills/
└── frontend-optimization/
    ├── SKILL.md          # Main skill
    └── references/
        ├── patterns.md   # Reusable patterns
        ├── examples.md   # Code examples
        └── checklist.md  # Quality checklist
```

**SKILL.md template:**
```markdown
---
name: frontend-optimization
description: Analyze and optimize React component performance, bundle size, and UX
keywords: ["performance", "react", "optimization", "bundle"]
---

# Frontend Optimization Skill

When activated, analyze:
1. Component re-render patterns
2. Unnecessary dependencies
3. Bundle size opportunities
4. Core Web Vitals impact

Provide specific optimization suggestions with before/after code examples.
```

---

## 6. ⚙️ `.claude/settings.json` → The Control Panel

settings.json is the main configuration file for hooks, environment variables, and permissions.

**Minimal configuration:**
```json
{
  "enabledPlugins": {
    "typescript-lsp@claude-plugins-official": true,
    "pyright-lsp@claude-plugins-official": true
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/scripts/validate-bash.sh"
          }
        ]
      }
    ]
  },
  "environment": {
    "NODE_ENV": "development",
    "LOG_LEVEL": "info"
  }
}
```

**Pro tips:**
- `settings.local.json` = **gitignored** for personal configs
- Only commit `settings.json` to the repo

---

## 7. 📖 `CLAUDE.md` → The Project Brain

CLAUDE.md is your project memory file. This is where you explain to Claude who you are, what your project does, and what rules it should follow.

**Optimal structure:**
```markdown
# Project Context

## Overview
- **Stack**: React + Node.js + PostgreSQL
- **Team**: 3 engineers
- **Priority**: Performance & Security

## Architecture
- Frontend: Next.js 14 with App Router
- API: Express.js with TypeORM
- Database: PostgreSQL with migrations

## Conventions
- Use TypeScript strict mode
- Prettier + ESLint configured
- Git commit format: conventional commits

## Critical Paths
- Auth: `/src/auth/` (change rarely)
- Payments: `/src/payments/` (extensive testing)
- Cache: All queries must use Redis

## Known Quirks
- Database migrations must be backward compatible
- Some legacy code in `/src/legacy/` - don't touch unless critical
- External API rate limits: 1000/min

## Key People & Contacts
- DevOps lead: @sarah
- Design system: @mike
```


## 🔥 Pro Tips for Mastering Claude Code

1. **CLAUDE.md is your best friend** - The more you enrich it, the less you need to repeat. Add your discoveries to it.

2. **Hooks > Agents for validations** - Hooks are deterministic. Use them to block errors.

3. **Commands for repetitive tasks** - If you need to copy-paste a prompt 2x, it's a command.

4. **Agents for complex workflows** - When a task has multiple steps and decisions.

5. **Use `/memory`** - Claude automatically saves what it learns. Read and enrich it.

6. **Reuse, don't duplicate** - One skill for all your projects = consistency.

---

## 📚 Key Distinctions

| Component | Deterministic? | Use When | Scope |
|-----------|---|----------|-------|
| **CLAUDE.md** | ✅ Yes | Project context & rules | Global |
| **Commands** | ✅ Yes | Recurring prompts | Personal or project |
| **Hooks** | ✅ Yes | Validation & safety | Personal or project |
| **Rules** | ✅ Yes | Path-based constraints | Project |
| **Skills** | ❌ Probabilistic | Complex workflows | Personal or project |
| **Agents** | ❌ Probabilistic | Specialized subtasks | Personal or project |

---

## 🚀 Real-World Example Setup

```
my-project/
├── CLAUDE.md
├── .claude/
│   ├── settings.json
│   ├── settings.local.json (gitignored)
│   ├── commands/
│   │   ├── review.md
│   │   ├── test.md
│   │   └── fix-issue.md
│   ├── agents/
│   │   ├── code-reviewer.md
│   │   └── performance-auditor.md
│   ├── rules/
│   │   ├── api-rules.md
│   │   ├── test-rules.md
│   │   └── security-rules.md
│   ├── skills/
│   │   └── frontend-optimization/
│   │       ├── SKILL.md
│   │       └── references/
│   │           └── patterns.md
│   └── scripts/
│       └── validate-bash.sh
└── .gitignore
```

---
