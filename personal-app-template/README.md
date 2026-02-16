# Personal App Template

Starter template for simple apps: personal tools, demos, prototypes. SQLite database deployed to Fly.io. Single-node, low-ops.

Use when you're the primary user or the app doesn't need high availability, multi-user concurrency, or managed database backups.

See `personal-app-template-with-demo` for a working reference implementation.

## Getting Started

```bash
cp -r personal-app-template my-app
cd my-app
pnpm install
cp .env.example .env
pnpm prisma migrate dev --name init
pnpm dev
```

Your application will be available at `http://localhost:5173`.
