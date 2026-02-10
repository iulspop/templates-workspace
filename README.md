# Templates Workspace

Multi-project workspace containing app templates, reference codebases, and shared tooling.

## Setup

```bash
git clone https://github.com/iulspop/templates-workspace.git
cd templates-workspace
./clone-repos.sh
```

## Projects

### Templates

- [personal-app-template-sqlite-fly-io](https://github.com/iulspop/personal-app-template-sqlite-fly-io) — Starter template for simple apps: personal tools, demos, prototypes. SQLite + Fly.io.
- [production-app-template-postgres-supabase](https://github.com/iulspop/production-app-template-postgres-supabase) — Starter template for production apps. Postgres via Supabase, with auth, org/team management, billing/Stripe, and CI/CD.

### Shared Tooling

- [aidd-skills](https://github.com/iulspop/aidd-skills) — Shared Claude Code skills (plan, commit, unit-tests, brainstorm, etc.) used across projects.

### Reference Only

- [react-router-saas-template](https://github.com/iulspop/react-router-saas-template) — Upstream SaaS template the production template is based on. Do not use directly.
- [epic-stack](https://github.com/epicweb-dev/epic-stack) — Kent C. Dodds' Epic Stack, used as architectural reference. Do not use directly.
