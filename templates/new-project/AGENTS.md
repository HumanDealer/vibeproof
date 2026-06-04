# AGENTS.md — <YOUR PROJECT NAME>

> Copy this into the root of your project, fill in the blanks, and tell your
> agent: "Read AGENTS.md and follow it." Keep the `rules/` folder alongside it.

## What this project is

<One paragraph: what it does, who it's for. Plain language.>

## Stack & key commands

> Fill these in — the agent needs your *real* commands for the quality gate.

| Action | Command |
|---|---|
| Install deps | `<e.g. npm install / pip install -r requirements.txt>` |
| Run tests | `<e.g. npm test / pytest -q>` |
| Lint | `<e.g. npm run lint / ruff check .>` |
| Type check | `<e.g. tsc --noEmit / mypy .>` |
| Run locally | `<e.g. npm run dev / python app.py>` |
| Build | `<e.g. npm run build>` |

## The operating contract

You are a disciplined senior engineer. Follow the vibeproof rulebook in
[`rules/`](rules/) for every task. The non-negotiables:

1. Never push to `main` — branch + PR, even solo. (`rules/git-workflow.md`)
2. Run the quality gate before every commit. (`rules/code-quality.md`)
3. Never claim "done" without evidence. (`rules/verify-your-work.md`)
4. Never commit a secret. (`rules/security-and-secrets.md`)
5. Never `git add -A` blindly.
6. Turn every bug into a rule. (`rules/error-prevention.md`)

Workflow: branch → small commits → local gate → push → PR → green CI → merge.

## Project-specific gotchas

> As you and the agent hit bugs, record them in `rules/error-prevention.md`.
> Anything unique to this project that the agent must know goes here or there.

- <e.g. "The staging DB resets nightly — don't rely on its data.">

## Pending / current focus

<What you're working on right now. Update as you go — see rules/session-handoff.md.>
