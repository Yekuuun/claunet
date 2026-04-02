# [Project Name]

> One-sentence description of what this project does and who it serves.

---

## Stack

List the main technologies and their versions. Be specific — version matters.

| Layer      | Technology              |
|------------|-------------------------|
| Backend    | e.g. ASP.NET Core 8     |
| Frontend   | e.g. React 18 + Vite    |
| Database   | e.g. PostgreSQL 16      |
| ORM        | e.g. Entity Framework 9 |
| Auth       | e.g. JWT / Azure AD B2C |
| Hosting    | e.g. Azure App Service  |

---

## Project Structure

Only list meaningful folders. Omit `bin`, `obj`, `node_modules`, `dist`.

```
├── Api/                    # ASP.NET Core Web API
│   ├── Controllers/
│   ├── DTO/
│   ├── Models/
│   ├── Repository/
│   ├── Services/
│   ├── Migrations/
│   └── Program.cs
├── Database/
│   └── Seeds/
├── Deploy/
├── docker-compose.yml
└── CLAUDE.md
```

---

## Environment & Secrets

- Never commit `.env` files or secrets. Ask the admin for credentials.
- Environment variables are documented in `.env.example`.
- Secrets are stored in [e.g. Azure Key Vault / 1Password / team vault].

---

## Common Commands

```bash
# Backend
dotnet run --project Api
dotnet test
dotnet ef migrations add <Name> --project Api

# Frontend
cd App && npm install
npm run dev
npm run build
npm run lint
```

---

## Coding Conventions

Rules that apply to all code in this repo:

(add more here...)

ping to a dedicated skill based on the tech stack.
---

## Non-Negotiable Rules

These are hard stops. Do not work around them without explicit admin approval.

- **Migrations**: All DB schema changes require a new EF migration. Never edit schemas manually.
- **Secrets**: Never hardcode or commit credentials, keys, or connection strings.
- **Breaking changes**: Flag any public API contract change before implementing.
- **Complex tasks**: Pause and consult the admin before proceeding on tasks that touch auth, payments, or data migrations.

(add more here...)

---

## Skills

Skills extend Claude's capabilities for recurring patterns in this project.
All skills live in `.claude/skills/`. Always check for a relevant skill before writing boilerplate.

| Skill | When to use |
|-------|-------------|
| _(add skills here)_ | |

---

## Commands

Slash commands for common workflows. All commands live in `.claude/commands/`.

| Command | What it does |
|---------|--------------|
| `/commit` | Generate a conventional commit from staged changes |
| `/create-pr` | Draft a structured PR description |
| _(add more)_ | |

---

## Agents

Rules for spawning sub-agents in this project.

- Use agents for parallelizable research (e.g. reading multiple files simultaneously).
- Do not use agents for tasks that mutate shared state concurrently.
- _(Add project-specific agent rules here)_

---

## Hooks

Hooks are shell commands that run automatically on Claude Code events.
Configured in `.claude/settings.json`.

| Event | Hook | Purpose |
|-------|------|---------|
| _(add hooks here)_ | | |
