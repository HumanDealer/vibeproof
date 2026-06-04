# Contributing to vibeproof

The best contribution is a **failure mode we don't guard against yet.** If your
AI agent did something dumb or dangerous and a rule would have stopped it, that
rule belongs here.

## What we want

- **New gotchas** — a real way agents break things, plus the rule to prevent it.
- **New skills** — a reusable procedure for a recurring job.
- **Adapter improvements** — better support for a specific agent (Codex,
  Claude Code, Cursor, Copilot, Aider, others).
- **Clarity fixes** — a rule that's ambiguous or that an agent misread.

## What we don't want

- Anything industry-specific. Rules must be portable across every domain.
- Secrets, proprietary logic, or real company data in examples — use
  placeholders (`<YOUR_API_KEY>`, `Vendor X`).
- Rules that are opinions about style with no failure mode behind them. Every
  rule must answer: "what breaks if you skip this?"

## How to contribute

1. Fork, branch (`feat/...` or `docs/...` — yes, we follow our own rules).
2. Make the change. Keep rules short, procedural, and mechanically followable.
3. Open a PR with a Summary and, for a new rule, the **failure mode** it
   prevents.

## The bar for a new rule

A rule earns its place if it's:

- **Portable** — works in any language / industry.
- **Mechanical** — an agent can follow it without judgment calls.
- **Justified** — there's a real, costly failure it prevents.

Discipline only helps if it's followed. Keep it simple enough to follow.
