## 🪝 .claude/hooks/ → Auto-run Before Every Commit

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