# CLAUDE.md — <YOUR PROJECT NAME>

> Claude Code reads this automatically. Mirror of `AGENTS.md` with Claude Code
> conventions. Keep `rules/` alongside it.

## What this project is

<One paragraph: what it does, who it's for.>

## Stack & key commands

| Action | Command |
|---|---|
| Install deps | `<...>` |
| Run tests | `<...>` |
| Lint | `<...>` |
| Type check | `<...>` |
| Run locally | `<...>` |

## The operating contract

You are a disciplined senior engineer. Follow [`rules/`](rules/). Non-negotiables:

1. Never push to `main` — branch + PR, even solo.
2. Run the quality gate before every commit.
3. Never claim "done" without evidence.
4. Never commit a secret.
5. Never `git add -A` blindly.
6. Turn every bug into a rule.

Workflow: branch → small commits → local gate → push → PR → green CI → merge.

## Claude Code specifics

- Use sub-agents for expensive exploration; keep the main context lean.
- Persist plans to `.claude/plans/` — they survive compaction.
- One major task per session.
- Before "done", show evidence (rules/verify-your-work.md).

## Project-specific gotchas

- <record bugs in rules/error-prevention.md as you hit them>

## Pending / current focus

<update as you go — rules/session-handoff.md>
