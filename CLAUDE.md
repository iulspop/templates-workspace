# Templates Workspace

Multi-project workspace containing app templates, reference codebases, and shared tooling.

## Directories

### `personal-app-template-sqlite-fly-io`
Starter template for simple apps: personal tools, demos, prototypes. SQLite database deployed to Fly.io. Single-node, low-ops. Use when you're the primary user or the app doesn't need high availability, multi-user concurrency, or managed database backups.

### `production-app-template-postgres-supabase`
Starter template for production apps that need reliability, data durability, and multi-user support (dozens to tens of thousands of users). Postgres via Supabase, with auth, org/team management, billing/Stripe, and CI/CD. Use for client projects or any app where uptime and data integrity matter.

### `aidd-skills`
Shared Claude Code skills (conventional-commit, unit-tests, documentation, brainstorm, etc.) used across projects.

Install all skills into a project:
```
npx skills add iulspop/aidd-skills --yes --agent claude-code
```

Install a single skill:
```
npx skills add iulspop/aidd-skills/skills/<skill-name> --yes --agent claude-code
```

After updating a skill in `aidd-skills/`, commit and push, then propagate to all three repos:
```
cd personal-app-template-sqlite-fly-io && npx skills add iulspop/aidd-skills --yes --agent claude-code && cd ..
cd production-app-template-postgres-supabase && npx skills add iulspop/aidd-skills --yes --agent claude-code && cd ..
cd react-router-saas-template && npx skills add iulspop/aidd-skills --yes --agent claude-code && cd ..
```

### `misc-skills`
Third-party Claude Code skills from remix-run and sergiodxa (React Router, React, Tailwind, accessibility, i18n, async patterns, JS performance, OWASP security, etc.). Used as reference and installed alongside aidd-skills.

Install all skills into a project:
```
npx skills add iulspop/misc-skills --yes --agent claude-code
```

### `react-router-saas-template`
Reference only. The upstream SaaS template that the production template is based on. Do not use directly.

### `epic-stack`
Reference only. Kent C. Dodds' Epic Stack, used as architectural reference. Do not use directly.

---

# Coding Guidelines

Act as a top-tier software engineer with serious JavaScript/TypeScript discipline to carefully implement high quality software.

## Before Writing Code

- Read the lint and formatting rules.
- Observe the project's relevant existing code.
- Conform to existing code style, patterns, and conventions unless directed otherwise. Note: these instructions count as "directed otherwise" unless the user explicitly overrides them.

## Principles

- DOT
- YAGNI
- KISS
- DRY
- TDD
- SDA - Self Describing APIs
- Simplicity - "Simplicity is removing the obvious, and adding the meaningful."
  - Obvious stuff gets hidden in the abstraction.
  - Meaningful stuff is what needs to be customized and passed in as parameters.
  - Functions should have default parameters whenever it makes sense so that callers can supply only what is different from the default.

## Testing

Develop **test-driven** (TDD): write a failing test first, then the minimal implementation to pass it, then refactor.

- Every new function, component, or behavior must have tests.
- Domain pure functions: unit tests in `*-domain.test.ts` (colocated in `domain/`).
- UI components: render tests in `*.test.tsx` (colocated in `application/`).
- Infrastructure facades: integration tests in `*.spec.ts` when needed.
- Test names follow the pattern: `given: <precondition>, should: <expected behavior>`.
- Use factories (`*-factories.server.ts`) to build test data — never hardcode full objects inline.
- Use Vitest with describe, expect, and test.
- Use cuid2 for IDs unless specified otherwise.
- Capture `actual` and `expected` values in variables before asserting with `toEqual`.
- Avoid `expect.any(Constructor)` in assertions. Expect specific values instead.

## JavaScript / TypeScript

Constraints {
  Be concise.
  Favor functional programming; keep functions short, pure, and composable.
  Favor map, filter, reduce over manual loops.
  Prefer immutability; use const, spread, and rest operators instead of mutation.
  One job per function; separate mapping from IO.
  Obey the projects lint and formatting rules.
  Omit needless code and variables; prefer composition with partial application and point-free style.
  Chain operations rather than introducing intermediate variables, e.g. `[x].filter(p).map(f)`
  Avoid loose procedural sequences; compose clear pipelines instead.
  Avoid `class` and `extends` as much as possible. Prefer composition of functions and data structures over inheritance.
  Keep related code together; group by feature, not by technical type.
  Put statements and expressions in positive form.
  Use parallel code for parallel concepts.
  Avoid null/undefined arguments; use options objects instead.
  Use concise syntax: arrow functions, object destructuring, array destructuring, template literals.
  Avoid verbose property assignments. bad: `const a = obj.a;` good: `const { a } = obj;`
  Assign reasonable defaults directly in function signatures.
    `const createExpectedUser = ({ id = createId(), name = '', description = '' } = {}) => ({ id, name, description });`
  Principle: SDA. This means:
    Parameter values should be explicitly named and expressed in function signatures:
      Bad: `const createUser = (payload = {}) => ({`
      Good: `const createUser = ({ id = createId(), name = '', description = ''} = {}) =>`
      Notice how default values also provide hints for type inference.
  Avoid IIFEs. Use block scopes, modules, or normal arrow functions instead. Principle: KISS
  Avoid using || for defaults. Use parameter defaults instead. See above.
  Prefer async/await or asyncPipe over raw promise chains.
  Use strict equality (===).
  Modularize by feature; one concern per file or function; prefer named exports.
}

NamingConstraints {
  Use active voice.
  Use clear, consistent naming.
  Functions should be verbs. e.g. `increment()`, `filter()`.
  Predicates and booleans should read like yes/no questions. e.g. `isActive`, `hasPermission`.
  Prefer standalone verbs over noun.method. e.g. `createUser()` not `User.create()`.
  Avoid noun-heavy and redundant names. e.g. `filter(fn, array)` not `matchingItemsFromArray(fn, array)`.
  Avoid "doSomething" style. e.g. `notify()` not `Notifier.doNotification()`.
  Lifecycle methods: prefer `beforeX` / `afterX` over `willX` / `didX`. e.g. `beforeUpdate()`.
  Use strong negatives over weak ones: `isEmpty(thing)` not `!isDefined(thing)`.
  Mixins and function decorators use `with${Thing}`. e.g. `withUser`, `withFeatures`, `withAuth`.
}

Comments {
  Favor docblocks for public APIs - but keep them minimal.
  Ensure that any comments are necessary and add value. Never reiterate the style guides. Avoid obvious redundancy with the code, but short one-line comments that aid scannability are okay.
  Comments should stand-alone months or years later. Assume that the reader is not familiar with the task plan or epic.
}

## React

- Display/container component pattern
  - Split your component into display components, which are pure functions that map props to JSX, and container components, which are (optional) stateful components that wrap one display component.
  - Then compose them together in the parent or page/route component.

ReactConstraints {
  Be concise.
  You're using React Router V7 (the successor to Remix).
  Use ShadCN/ui for components. If a component is missing, install it.
  Modularize by feature; one concern per file or component; prefer named exports.
  This project uses TailwindCSS V4, so you can use things like container queries and child selectors.
}

NamingConstraints {
  Use clear, descriptive, consistent naming.
  Components should be postfixed with `Component`.
  Props should be the component's name, postfixed with `ComponentProps`.
}

TypeConstraints {
  Use proper React TypeScript types: MouseEventHandler<HTMLButtonElement>, ChangeEventHandler<HTMLInputElement>, ReactNode, React.Ref<T>, ComponentProps<'element'>, etc. Never use generic () => void or (event: any) => void.
  When extending HTML elements or existing components, use ComponentProps to inherit their props: ComponentProps<'input'>, ComponentProps<'button'>, ComponentProps<typeof ExistingComponent>.
  This project uses Prisma. If a prop comes from a database entity, use the entities type for it, e.g.:
    - type UserMenuProps = Pick<UserAccount, 'id' | 'name' | 'email'> & {
        onLogout: MouseEventHandler<HTMLInputElement>;
        organizationName: Organization['name'];
      }
  When using server/database return types: Awaited<ReturnType<typeof serverFunction>>, wrap with NonNullable<> if guaranteed to exist.
}

## Hexagonal Feature-Slice Architecture

Each feature lives under `app/features/<name>/` with three subdirectories:

```
app/features/<name>/
├── domain/          # Pure types, functions, constants — zero external imports
├── infrastructure/  # Database facades, test factories — Prisma/DB only
└── application/     # Actions, schemas, UI — thin adapters mapping domain to web interface
```

ArchitectureLayers {
  Domain (`domain/`):
    - `*-domain.ts` — Types + pure functions + result types. Zero external imports, pure TS only.
    - `*-domain.test.ts` — Unit tests for pure functions. Imports: Vitest + domain file.
    - `*-constants.ts` — Intent strings, magic values. Zero imports.
  Infrastructure (`infrastructure/`):
    - `*-model.server.ts` — Database facades (single Prisma op each). Imports: Prisma, `~/utils/db.server`.
    - `*-factories.server.ts` — Test data factories. Imports: Faker, cuid2, Prisma types.
  Application (`application/`):
    - `*-action.server.ts` — Thin adapter: map web request to domain + infra calls. Imports: domain, model, schemas, React Router.
    - `*-schemas.ts` — Validate raw form input (structural). Imports: `zod`, constants.
    - `*-page.tsx`, `*.tsx` — Display/container components. Imports: domain (pure helpers), React, RR, i18n.
  Routes (`app/routes/*.tsx`):
    - Thin wiring: loader/action/component. Imports: feature modules.
}

ImportRules {
  Domain files (`*-domain.ts`) must have zero imports.
  Constants files (`*-constants.ts`) must have zero imports.
  Schema files import only from `zod` and `../domain/` constants.
  Model files import only from Prisma and `~/utils/db.server`.
  Action files adapt web requests to domain + infra: `../domain/` + `../infrastructure/` + local schemas.
  UI files can import `../domain/` pure helpers but never model/action files.
}

KeyPatterns {
  One generic `Result<T, E>` replaces per-operation result types.
  SDA function params replace Command objects.
  `ts-pattern` exhaustive matching in action handlers.
}

## Facade Functions

FacadeConstraints {
  Apply only to functions in `*-model.server.ts` files.
  Function names must follow `<action><Entity><OptionalWith...><DataSource><OptionalBy...>()` pattern.
  Allowed actions: save | retrieve | update | delete.
  Entity names are singular, in PascalCase.
  Use "With..." to indicate included relations before "From/In/ToDatabase".
  Use "By..." to indicate lookup key(s) last; key names must match schema fields exactly.
  Use "And" to chain multiple included relations or keys.
  Use "ToDatabase" for create, "FromDatabase" for reads, "InDatabase" for updates, "FromDatabase" for deletes.
  Facades must perform a single database operation (no business logic).
  Facades must always return raw Prisma results (no transformations).
  Include JSDoc with description, @param, and @returns tags matching the function name and purpose.
  Prefer explicit Prisma includes/selects; avoid `include: { *: true }`.
  Function bodies must use the `prisma.<entity>.<operation>` pattern directly.
}

## shadcn / Base UI Components

- Config: `components.json` (style `base-vega`, icon library `@tabler/icons-react`)
- Components live in `app/components/ui/`, copied from shadcn (not installed via CLI package)
- Use `cn()` from `~/lib/utils` for conditional class merging
- Use semantic color tokens (`text-foreground`, `text-muted-foreground`, `bg-primary`, `border-border`, etc.) instead of hardcoded Tailwind colors (`text-gray-900`, `bg-blue-600`, etc.)
- Use `Button`, `Input`, `Textarea`, `FieldError` instead of raw HTML `<button>`, `<input>`, `<textarea>`, `<p role="alert">`
- Hidden form inputs (`type="hidden"`) stay as plain `<input>` elements
- Use Tabler icons (`@tabler/icons-react`) instead of inline SVGs
- Dark mode via `className="system"` on `<html>` + `@custom-variant dark` in CSS (OS `prefers-color-scheme`)
