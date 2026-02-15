# Authentication Philosophy

## Principles

### Passwordless by default

Passwords are the weakest link in authentication. They get reused, phished, leaked, and brute-forced. Every template uses passwordless auth:

- Email codes (TOTP)
- OAuth (Google, Apple)
- Passkeys (WebAuthn)

Users either click a button or check their email. No passwords to manage, no reset flows, no breach checking. If a user's email account is compromised, that's their email provider's liability — not ours.

### Libraries over frameworks

Auth frameworks (Better Auth, NextAuth, Lucia) abstract away session management, database access, and provider integration. But sessions are just CRUD. The abstraction hides simple operations behind adapters and plugins, creating surface area for bugs — like framework-level CVEs that affect everyone.

The better approach (per Lucia's author, who archived Lucia over this realization): use focused libraries for the genuinely hard parts (crypto, OAuth token exchange, WebAuthn ceremonies) and write the glue yourself. None of these libraries (Oslo, Arctic, SimpleWebAuthn) have been formally audited — they're small enough to read, but that means you are the auditor.

**Use libraries for:**

- Crypto primitives (Oslo, Web Crypto API)
- OAuth flows (Arctic — 50+ providers, thin HTTP client)
- WebAuthn (SimpleWebAuthn)
- TOTP generation (@epic-web/totp)

**Write yourself:**

- Sessions (create, read, destroy — just database rows + signed cookies)
- Cookie management (createCookieSessionStorage from React Router)
- Rate limiting
- CSRF protection

Rolling your own auth is meaningfully more work than `npm install clerk`. The Epic Stack follows this philosophy and has hundreds of lines of auth code across dozens of files. Each piece is simple — session lifecycle, OAuth state management, account linking, passkey counter validation, verification expiry — but the composition is where bugs hide. Don't underestimate the cost.

### The case for rolling your own

There is a middle ground between "use a managed service" and "recklessly build your own." Rolling your own auth, done deliberately, has real benefits:

- **You understand your own threat model.** You know exactly what's protected, how sessions work, what happens on every edge case. No black box. That understanding is itself a security advantage.
- **Simplicity at the code level.** Fewer moving parts, fewer integration points, less surface area for configuration mistakes.
- **Simplicity at the system level.** One critical external dependency removed. No auth provider outage can take your app down. No surprise pricing changes or API deprecations.
- **The cost of understanding is a benefit.** The work of thinking through session lifecycle, cookie attributes, CSRF protection — that knowledge makes you a better engineer and makes your application more robust.

But this comes with honest costs:

- It's real work, not a weekend task. OAuth provider quirks, passkey registration flows, session fixation prevention, rate limiting under load — each is tractable, but together they add up.
- The surface area isn't just code. It's also how you deploy secrets, how cookies behave across environments, how session cleanup runs, whether rate limiting holds under load. Simplicity in code doesn't eliminate operational complexity.
- Nobody is auditing your implementation. You are the security team.
- Migration cost if you outgrow it. Moving from roll-your-own to a managed service means migrating user sessions, re-implementing every auth flow, and potentially disrupting every user. If there's a real chance a project will outgrow the roll-your-own approach, starting with the managed service may be cheaper.

### Managed services when the stakes demand it

You are always responsible for what happens to your users, your clients, and your product. "Our auth provider messed up" is not an excuse. The buck stops with you regardless of how you build it.

Auth deserves the highest scrutiny. It's the front door to everything. The question is whether you can sustain that scrutiny yourself. A solo developer or small team cannot maintain the level of continuous security review that auth demands — dedicated penetration testers, third-party audits, compliance certifications, 24/7 incident response. It doesn't make business sense to internalize that except at enormous scale, and even then most companies outsource it.

For anything with sufficient stakes, you want your security foundation backed by a team with serious resources and serious reputation to defend. Not because it absolves you of responsibility, but because it's the highest standard of care you can provide for your users.

### Risk thresholds

The decision between roll-your-own and managed auth isn't binary. It depends on what you're protecting and what the consequences of a breach look like.

**Roll your own is appropriate when:**

- Single user or small group of known users
- No sensitive PII beyond email addresses
- No financial data, no payment processing
- No regulatory requirements (HIPAA, SOC 2, GDPR data processing)
- No contractual security obligations to clients
- Breach impact is limited: embarrassment, not lawsuits
- Examples: personal tools, internal dashboards, hobby projects, prototypes

**Managed service is appropriate when:**

- Storing sensitive PII (names, addresses, phone numbers, government IDs)
- Handling financial data or payment flows
- Revenue above ~$10K/month or meaningful user base (hundreds+)
- Clients or contracts that require compliance certifications
- Regulatory requirements apply (healthcare, finance, education, EU data processing)
- Breach impact includes: legal liability, financial loss, reputational damage to clients
- Examples: client projects, SaaS products, anything where "we got hacked" makes the news

**Dedicated security team / internal auth is appropriate when:**

- Auth is itself the product or a core differentiator
- Scale justifies the headcount (thousands of employees, millions of users)
- Regulatory environment demands direct control (government, defense, banking)
- You can hire and retain multiple full-time security engineers
- Examples: auth providers themselves, major financial institutions, large enterprises

The middle zone is the hardest call. A production app with 50 users and no sensitive data doesn't need Clerk. A side project that unexpectedly takes off and starts handling PII probably does. When in doubt, ask: if this app's auth were compromised tomorrow, what happens? If the answer involves lawyers or the press, use a managed service.

## Template auth decisions

### Template 1 — Local app

No auth. Single user, runs locally. The operating system's login is the auth layer.

SQLite database, backed up to an iCloud-synced directory.

### Template 2 — Personal app

Roll-your-own auth. Email TOTP codes via Resend. Database-backed sessions with signed cookies. Deployed to Fly.io with SQLite.

This is appropriate because:

- You're the primary user (or a handful of known users)
- The attack surface is minimal: no passwords, no OAuth complexity, just email codes + sessions
- You understand every line of the auth code
- The blast radius of a breach is limited
- The stakes don't justify a managed service dependency

This is a deliberate choice to take responsibility for your own threat model. The benefit is full understanding and zero external auth dependencies. The cost is that you are the security team.

### Template 3 — Production app

Managed auth via Clerk. Postgres on Fly.io, multi-machine deployment, Tigris S3 storage.

This is appropriate because:

- Real users with real data
- Compliance and security questions from clients
- Auth methods include OAuth (Google, Apple) and passkeys alongside email codes
- A managed service provides: third-party security audits, compliance certifications (SOC 2, HIPAA), a dedicated security team, incident response
- The tradeoff (external dependency, potential downtime, cost) is worth the higher standard of care

**Why Clerk:**

- Auth is their entire business — not a side feature of a larger platform
- SOC 2 Type II certified, third-party security audits based on OWASP
- Well-funded, sustainable business with a dedicated security team
- First-class React and server-side TypeScript SDK
- Supports all required auth methods: email codes, Google OAuth, Apple OAuth, passkeys
- Reasonable free tier for development and small apps
