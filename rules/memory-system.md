# Memory System — Knowledge That Compounds

Most agent setups are amnesiac: every session starts from zero, and the same
questions get re-answered and the same bugs re-fixed forever. A small,
structured memory turns that around — the agent (and you) get smarter over
time.

This is a lightweight, file-based, 3-layer wiki. No database, no service —
just markdown the agent reads and writes. Adapt the paths to your project.

---

## The 3 layers

```
┌─ Layer 3: SCHEMA — this file ────────────────────────────────┐
│  The governance: what gets saved, how it's structured,       │
│  how stale facts are replaced. Evolves as you learn.         │
└──────────────────────────────────────────────────────────────┘
┌─ Layer 2: WIKI — curated, synthesized ──────────────────────┐
│  memory/wiki/{decisions,lessons,people,references}/          │
│  Short, digested pages. Cross-linked. This is what the       │
│  agent reads for context.                                    │
└──────────────────────────────────────────────────────────────┘
┌─ Layer 1: RAW — immutable source clips ─────────────────────┐
│  memory/raw/  — full articles, transcripts, logs.            │
│  Never edited. Read on demand, not loaded every session.     │
└──────────────────────────────────────────────────────────────┘
```

Keep raw clips **out** of the always-loaded context — they bloat it. The agent
reads Layer 2 by default and dips into Layer 1 only when it needs the source.

---

## The index (`memory/INDEX.md`)

A single, short file of durable pointers — one line per memory. This is the
map the agent loads each session. Keep it under ~150 lines; push detail into
the wiki pages it points to.

```
- [Decision: use Postgres over Mongo](wiki/decisions/2026-05-10-db-choice.md) — why we picked it
- [Lesson: never trust D+1 weekend data](wiki/lessons/weekend-data.md) — wait for D+3
- [Person: Sam @ Vendor X](wiki/people/sam-vendorx.md) — contract renewal in Q3
```

---

## Memory types

| Type | Lives in | Purpose |
|------|----------|---------|
| `decision` | `wiki/decisions/<date>-<slug>.md` | A choice made, with the why and the alternatives |
| `lesson` | `wiki/lessons/<slug>.md` | A hard-won lesson from a bug / incident |
| `reference` | `wiki/references/<slug>.md` | Pointer to an external system, doc, or dashboard |
| `person` | `wiki/people/<slug>.md` | A contact: role, open promises, last contact |

## Page frontmatter (every wiki page)

```yaml
---
name: <human-readable title>
description: <one line — used to decide relevance on recall>
type: decision | lesson | reference | person
created: 2026-06-04
updated: 2026-06-04
confidence: HIGH | MED | LOW
tags: [<topic>, <project>]
---
```

**Confidence** is categorical, not a fake number: `HIGH` = verified & recent,
`MED` = single observation or aging, `LOW` = secondhand or stale.

---

## Supersession (no silent forgetting)

When a new fact contradicts an old one, **don't delete the old page** — replace
it explicitly so the history stays auditable:

1. Write the new page with `supersedes: [old-page.md]` in frontmatter.
2. On the old page, add `superseded_by: new-page.md` and a top banner:
   `> [SUPERSEDED 2026-06-04] See new-page.md — reason: ...`

Explicit supersession beats a "forgetting curve" — decay risks quietly
repeating a past mistake.

---

## Append-only log (`memory/log.md`)

One line per write, never rewritten — a grep-able timeline:

```
## [2026-06-04 14:32] decision | chose Postgres over Mongo | wiki/decisions/2026-05-10-db-choice.md
## [2026-06-04 18:00] lesson | weekend data unreliable | wiki/lessons/weekend-data.md
```

---

## Privacy filter (on every write)

Before anything goes into memory, strip: API keys, tokens, passwords,
personal contact details, and anything the human marked private. Redact with
`<REDACTED>` and note it in the log line. Memory is not a place for secrets —
see `security-and-secrets.md`.

---

## What NEVER goes into memory

- Code structure / file paths → read the current code instead.
- Git history / who-changed-what → `git log` is authoritative.
- One-off debugging recipes → put them in commit messages.
- Ephemeral session state → that's the status file (`session-handoff.md`).

If asked to save one of those anyway, ask: "what's *surprising* or
*non-obvious* here?" — save that part, not the raw fact.
