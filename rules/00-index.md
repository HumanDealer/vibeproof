# The vibeproof Rulebook — Index

These rules encode the habits of a senior engineer so an AI agent can follow
them mechanically. They are deliberately strict. Each one exists because
skipping it once caused real, expensive pain.

**How to use them:** the agent reads the relevant rule *before* acting, not
after. The index in `AGENTS.md` maps situations → rules.

| Rule | Read it when | One-line summary |
|---|---|---|
| [`git-workflow.md`](git-workflow.md) | committing, pushing, opening a PR | Branch first. Never push to main. Atomic commits. |
| [`code-quality.md`](code-quality.md) | before every commit & push | Tests + lint + types + secret scan, all green, locally. |
| [`verify-your-work.md`](verify-your-work.md) | before claiming "done" | Evidence over claims. Prove it works. |
| [`security-and-secrets.md`](security-and-secrets.md) | handling keys, input, auth, data | Never commit a secret. Validate input. |
| [`error-prevention.md`](error-prevention.md) | you hit any bug | Root cause first. Turn the bug into a permanent rule. |
| [`session-handoff.md`](session-handoff.md) | long / multi-session tasks | Survive context loss. Persist plans and state. |
| [`memory-system.md`](memory-system.md) | you learned something durable | A 3-layer knowledge wiki that compounds over time. |
| [`planning.md`](planning.md) | task touches >3 files | Plan to a file, get sign-off, then execute. |

## The one principle behind all of them

> **Discipline is speed.** The minute you save skipping a gate becomes an hour
> of cleanup later. Slow is smooth, smooth is fast.

## Customizing for your project

Every rule here is industry-agnostic. To adapt:

1. In `code-quality.md`, replace the example commands with your real test /
   lint / type commands.
2. In `error-prevention.md`, start collecting *your* project's gotchas — the
   file ships nearly empty on purpose. It fills as you learn.
3. Add project-specific context to your `AGENTS.md` / `CLAUDE.md`, not here.
   Keep `rules/` portable so you can reuse it across repos.
