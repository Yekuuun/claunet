## 📚 `.claude/skills/` → Teach It New Tricks

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