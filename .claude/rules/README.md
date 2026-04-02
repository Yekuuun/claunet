## 🛡️ `.claude/rules/` → Guardrails It Actually Follows

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