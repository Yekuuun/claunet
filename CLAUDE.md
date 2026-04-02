# Project name

CLAUDE.md is your project memory file. This is where you explain to Claude who you are, what your project does, and what rules it should follow.

<project description>

## Stack

<project stack description>

## Project structure

<project struct => use tree to have a base plan of main folders>

ex : 

```C#


├── Api
│   ├── Abstract
│   ├── Api.csproj
│   ├── appsettings.Development.json
│   ├── appsettings.json
│   ├── appsettings.Production.json
│   ├── AutoMapperProfile.cs
│   ├── Azure
│   ├── bin
│   ├── Controllers
│   ├── Data
│   ├── Dockerfile
│   ├── DTO
│   ├── Enum
│   ├── Geolocalisation
│   ├── GlobalUsing.cs
│   ├── Invoicing
│   ├── Mail
│   ├── Middlewares
│   ├── Migrations
│   ├── Models
│   ├── obj
│   ├── Payments
│   ├── Program.cs
│   ├── Properties
│   ├── Repository
│   ├── Services
│   ├── Token
│   └── Utils
├── App
│   ├── components.json
│   ├── dist
│   ├── eslint.config.js
│   ├── index.html
│   ├── node_modules
│   ├── package.json
│   ├── package-lock.json
│   ├── postcss.config.js
│   ├── public
│   ├── README.md
│   ├── src
│   ├── staticwebapp.config.json
│   ├── tailwind.config.js
│   ├── tsconfig.app.json
│   ├── tsconfig.json
│   ├── tsconfig.node.json
│   ├── vite.config.ts
│   └── vite-env.d.ts
├── CLAUDE.md
├── Database
│   └── Seeds
├── Deploy
│   └── Readme.md
├── docker-compose.yml


```

## Non negotiable

<project non negotiable rules>

ex :

- All DB changes requires a new migration. Never touch the schemas manually.
- Never commit secrets. Always refer to the admin.
- Always refer to the admin when processing complexe tasks who needs a review

## Skills

Always consul the relevant skills before generating or reviewing code. You can find all skills in .claude/skills

ex : 

```C#


.claude/skills
├── api
├── client
└── global



```

## Commands
all commands are in .claude/commands.

```C#


.claude/commands
├── create-commit.md
├── create-pr.md
└── skill-creator.md



```