# The vibeproof Formula

> How a domain expert with zero coding knowledge ships code a senior engineer
> can't distinguish from their own — because **machine gates, not prompts,
> enforce correctness.**

This formula was not invented. It was stress-tested by a team of agents against
a real workspace and **3 of 4 "obvious" mechanisms failed reality** (private
repos on a free GitHub plan can't use branch protection; gate tools weren't
installed; CI mostly didn't exist). What survived is below.

## The core insight

> **Rules text cannot prevent mistakes. The agent can ignore any prompt.**
> Only a mechanism that runs *outside the agent's discretion* prevents a mistake.

But "outside the agent's discretion" does NOT have to mean a paid server.
The agent runs `git`. So the cheapest, most reliable gate is **a command the
agent is physically denied from running** — local, free, bypass-proof.

## Three layers — in priority order

### Layer 1 — Deny-list (the real enforcement, free, works today)
`~/.claude/settings.json` denies dangerous commands: push to `main`,
`--no-verify`, `--force`, reading `.env`/secret files. The agent **cannot run
them** — not "is asked not to." This is the single highest-leverage layer and
it costs nothing. → `templates/settings.deny.json` (hardened).

### Layer 2 — `vibeproof check` (self-bootstrapping local gate)
One CLI, one **layperson verdict line**, independent of the agent's self-report:

```
READY — every gate green. Safe to ship.
BLOCKED — fix the ✗ lines above before you ship.
```

It **detects the stack**, **probes each tool** (`command -v`), and if a tool is
missing it prints a copy-paste fix instead of a silent green or a cryptic crash.
Secret scan is **value-oriented** (matches real tokens, not the word "password")
— gitleaks is an optional upgrade, not a requirement. Branch check is
"are you on main?" (local, free) — NOT server-side branch protection.

Runs as a **pre-push git hook**: the verdict reaches the human on every push,
on every repo, with zero CI minutes.

### Layer 3 — Server-side CI (OPTIONAL, plan-gated, probe-and-skip)
Where it's free or already paid: a gitleaks CI job (copied from a proven config),
required status checks, branch protection. **Never a hard dependency** — setup
probes `gh api .../protection`; on a `403 Upgrade to Pro` it skips gracefully
with a one-line note. The product works fully on a free plan without it.

## Why this is honest

Every guarantee word ("blocked", "cannot", "fails closed") maps to a real
mechanism. `vibeproof doctor` **fails the build if a doc claims enforcement
with no wiring behind it** — the docs structurally cannot lie. That is the most
senior trait of all.

## What we explicitly rejected

| Tempting | Why we killed it |
|----------|------------------|
| "Branch protection via `gh api`" as the primary guard | 403 on private free-plan repos. Fiction for most users. |
| "pre-commit fails CLOSED regardless of agent" | One `--no-verify` bypasses it. Tools often not installed. |
| ".github ruleset YAML committed to repo" | GitHub rulesets aren't configured by a committed file. Invented. |
| Regex secret scan on bare words | 113 false hits on one real repo. Noise = ignored = useless. |
