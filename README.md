# vibeproof

**Vibe-code anything. Ship like a senior.**

A drop-in rulebook + skill set that turns any AI coding agent — OpenAI Codex,
Claude Code, Cursor, Copilot — into a disciplined senior engineer. Built for
**domain experts who can't (yet) code**: the marketer, the doctor, the lawyer,
the operations lead who knows *what* to build but keeps shipping broken code
because the agent has no guardrails.

You bring the domain expertise. vibeproof brings the engineering discipline.

---

## The problem this solves

AI agents will happily do the wrong thing with total confidence. Left
unguided they:

| Failure mode | What it looks like in real life |
|---|---|
| **Push straight to `main`** | No review, no CI, broken prod on a Friday |
| **Claim "done" without checking** | "Fixed!" — but tests never ran |
| **Leak secrets** | An API key committed into git history forever |
| **Repeat the same bug** | The mistake you fixed last week, fixed again |
| **Lose the plot mid-task** | Context window fills, the plan evaporates |
| **`git add -A` everything** | `.env`, build junk, a 200MB data file, all staged |

None of these are *coding* problems. They're **discipline** problems. A senior
engineer avoids them through habits learned over years of pain. This repo
encodes those habits as rules an agent reads *before* it touches your code.

## Who it's for

- **Domain experts** building real software with AI for the first time.
- **Solo founders** running a fleet of agents with no human reviewer.
- **Teams** who want one portable standard across every repo and every agent.
- Anyone tired of re-explaining "branch first, test before you claim done."

Industry-agnostic by design. Nothing here assumes web, ML, or any vertical —
the same rules harden a fintech backend, a Shopify app, or a research script.

---

## Quick start (60 seconds)

```bash
# 1. Drop the rulebook into your project
npx degit HumanDealer/vibeproof/rules ./rules
cp templates/new-project/AGENTS.md  ./AGENTS.md   # for Codex / universal
cp templates/new-project/CLAUDE.md  ./CLAUDE.md   # for Claude Code
cp .cursorrules ./.cursorrules                    # for Cursor

# 2. Open your project in your agent of choice and say:
#    "Read AGENTS.md and follow it."

# 3. Ship.
```

Your agent now branches before it codes, runs the quality gate before it
commits, scans for secrets before it pushes, and writes down every lesson so
it never repeats a bug.

---

## What's inside

```
vibeproof/
├── AGENTS.md           # universal entrypoint — Codex & most agents read this
├── CLAUDE.md           # Claude Code variant (same rules, CC conventions)
├── .cursorrules        # Cursor variant (condensed)
├── rules/              # the portable rulebook — read these, they're the point
│   ├── 00-index.md
│   ├── git-workflow.md         # branches, commits, PRs, the 5 hard NEVERs
│   ├── code-quality.md         # the pre-commit & pre-push gates
│   ├── verify-your-work.md     # never claim "done" without evidence
│   ├── security-and-secrets.md # secret scanning, what never gets committed
│   ├── error-prevention.md     # turn every bug into a permanent rule
│   ├── session-handoff.md      # survive context loss on long tasks
│   ├── memory-system.md        # a 3-layer knowledge wiki that compounds
│   └── planning.md             # plan before you touch >3 files
├── skills/             # example agent skills (composable mini-playbooks)
│   ├── ship/                   # branch → gate → PR, one command
│   ├── code-review/            # review a diff before merge
│   ├── debug-root-cause/       # no fix without a root cause
│   └── save-learning/          # capture a lesson into memory
├── templates/          # scaffold for a brand-new project
└── examples/           # a worked walkthrough for a non-coder
```

The **rules** are the heart of it. Everything else is delivery.

---

## The four pillars

1. **Gates, not vibes.** Tests, lint, types, and a secret scan run via
   `vibeproof check` — a real script with a one-line verdict, wired to a
   pre-push hook so it runs before code leaves your machine. Not a request to
   the agent; a command it runs. (`bin/vibeproof`, `rules/code-quality.md`)
2. **Branches, always.** Never push to `main` — and the
   `templates/settings.deny.json` deny-list *blocks the command* so the agent
   can't, even by accident. (`rules/git-workflow.md`)
3. **Evidence over claims.** "Done" requires proof: the `vibeproof check`
   verdict line — `READY` or `BLOCKED` — that you can read without reading code.
   (`rules/verify-your-work.md`)
4. **Memory that compounds.** Every bug becomes a rule; every decision is
   written down. The agent gets smarter, not just busier.
   (`rules/error-prevention.md`, `rules/memory-system.md`)

## Self-improving (optional, automatic)

Opt-in hooks turn every session into compounding knowledge — no manual step:

- **`hooks/conversation-recorder.sh`** — records every dialogue to your Obsidian
  vault as Markdown (Stop hook).
- **`hooks/feedback-detector.sh`** — when you say "this is bad / not what I wanted",
  it captures that exact moment as a lesson (UserPromptSubmit hook).
- **`hooks/daily-digest.sh`** — once a day, headless Claude reads the day's sessions
  + flagged moments and writes you a one-page validation digest.

Wire them via `templates/settings.hooks.json`, point `$VIBEPROOF_VAULT` at your
vault. See [`docs/SELF-IMPROVING.md`](docs/SELF-IMPROVING.md). Built for the
non-coder who can't audit a diff but knows when something's wrong.

---

## Works with

| Agent | File it reads | Status |
|---|---|---|
| OpenAI Codex | `AGENTS.md` | ✅ |
| Claude Code | `CLAUDE.md` | ✅ |
| Cursor | `.cursorrules` | ✅ |
| GitHub Copilot | `AGENTS.md` (point it manually) | ✅ |
| Any other | `AGENTS.md` | ✅ paste it into context |

`AGENTS.md` is the source of truth; the others are thin adapters pointing at
the same `rules/`.

---

## Philosophy

> The 60 seconds you save skipping the gate becomes 60 minutes of cleanup
> later. Discipline *is* the speed.

These rules were distilled from running autonomous agents in production —
every line exists because skipping it once caused real pain. They are
deliberately strict. Loosen them once you understand *why* each one is there,
not before.

## Contributing

Found a failure mode we don't guard against? That's exactly the contribution
we want. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT — see [LICENSE](LICENSE). Use it, fork it, sell services around it. Just
keep it useful.
