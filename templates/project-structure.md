# Project Structure Template

Stack-agnostic starting structure for a new app. Adapt paths and filenames to your framework and language, but keep the *separation of concerns* intact.

```
project-root/
  src/                        # Application source code
    api/                      # API routes, controllers, or handlers
    models/                   # Data models, schemas, type definitions
    services/                 # Business logic and domain services
    middleware/               # Auth, validation, rate-limiting middleware
    utils/                    # Shared helpers and constants

  tests/                      # Test files (mirrors src/ structure)
    unit/                     # Fast, isolated tests
    integration/              # Tests that hit a real DB or external service
    e2e/                      # End-to-end tests against a running app

  scripts/                    # Build, deploy, seed, and utility scripts
    build.sh                  # Compile or bundle the application
    seed.sh                   # Populate dev/test databases
    deploy.sh                 # Deployment orchestration

  infrastructure/             # Infrastructure as code
    terraform/                # (or pulumi/, pulumi/, cloudformation/)
    docker/
      Dockerfile              # Container definition
      docker-compose.yml       # Local development environment

  docs/                       # Project documentation
    architecture.md           # System overview, data flow, key decisions
    runbooks/                 # Operational guides (deploy, rollback, debug)
    onboarding.md             # How to set up the dev environment

  .github/
    workflows/                # CI/CD pipeline definitions
      ci.yml                  # Lint, test, build on every push
      cd.yml                  # Deploy on merge to main

  .env.example                # Required env vars with placeholder values (no secrets)
  package.json                # (or pyproject.toml, go.mod, Cargo.toml, Gemfile)
  package-lock.json           # (or uv.lock, poetry.lock, go.sum, etc.)
  .gitignore                  # Ignore node_modules, .env, dist, OS files
```

## Why This Layout

- **`src/` over a flat root** — keeps application code separate from config, tests, and infrastructure. Easier to lint, test, and reason about.
- **`tests/` outside `src/`** — prevents test helpers from being bundled into production builds. Mirrors `src/` so the mapping is obvious.
- **`scripts/` separate from `infrastructure/`** — scripts are one-off or procedural (seed, build). Infrastructure is declarative (Terraform, Docker Compose) and versioned alongside the app.
- **`.env.example` at root** — the first file a new contributor looks for. Lists every required variable with safe defaults or placeholders. Never contains real secrets.
- **`docs/runbooks/`** — operational documentation lives with the code it describes. When an incident happens, the runbook is a `git checkout` away, not buried in a wiki.
- **Lockfiles committed** — `package-lock.json`, `uv.lock`, `go.sum`, etc. guarantee deterministic installs across environments.

## Minimum Viable Start

For the first day of prototyping, you need:

```
project-root/
  src/                        # Your app
  tests/                      # At least one test
  .env.example                # Document required env vars
  package.json + lockfile     # (or your language equivalent)
  .gitignore                  # Must include .env and node_modules (or equivalent)
```

Add `infrastructure/`, `docs/`, and CI workflows before inviting other developers or deploying beyond localhost.
