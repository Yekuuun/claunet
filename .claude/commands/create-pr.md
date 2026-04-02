---
description: Generate a structured PR message in raw markdown based on commits vs a target branch
argument-hint: <target-branch> (e.g. main, develop)
---

## Process

1. Determine the target branch:
   - If `$ARGUMENTS` is provided, use it as the base branch
   - Otherwise, default to `main`

2. Run `git log <target-branch>..HEAD --oneline` to list all commits in scope

3. Run `git log <target-branch>..HEAD` for full commit messages

4. Analyze and group commits by theme (e.g. features, fixes, UX, auth, infra...)

5. Output the full PR message as a raw markdown code block (wrapped in triple backticks)
   so the user can copy-paste it directly into GitHub

## Output format

```markdown

## Title

<small title describing keys changes for the PR>

## Summary

<1 sentence describing the overall goal of this PR>

### <Theme 1>

- <change>
- <change>

### <Theme 2>

- <change>

---

## Test plan

- [ ] <test step>
- [ ] <test step>
```

## Rules

- Always output inside a fenced code block so the markdown is copy-paste ready
- Group commits semantically, not chronologically
- If only 1-2 commits exist, keep the summary short (no need for multiple sections)
- Never include commit hashes in the output
- Write in the same language as the commit messages