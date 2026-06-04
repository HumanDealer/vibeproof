# Error Prevention — Turn Every Bug Into a Permanent Rule

The compounding habit: when you hit a bug, you don't just fix it — you make
sure **it can never happen again**. Over time this file becomes your project's
institutional memory, and the agent stops repeating mistakes.

---

## Root cause before fix (the Iron Law)

When something breaks, do **not** patch the symptom. Work the four phases:

1. **Investigate** — reproduce it. Read the actual error, the actual stack
   trace, the actual inputs. Don't guess.
2. **Analyze** — find *why* it happens, not just *where*. Trace it to the
   source.
3. **Hypothesize** — form one testable hypothesis about the root cause.
   Confirm it before changing anything.
4. **Fix** — fix the root cause. Add a test that fails before and passes after.

A fix without a confirmed root cause is a guess that will break again.
See `skills/debug-root-cause/SKILL.md`.

---

## When you hit a NEW error — the four steps

1. Fix the immediate problem (root cause, per above).
2. **Add it to the gotchas list below** — what happened, why, how to prevent.
3. If it's project-specific, also note it in your `AGENTS.md` / `CLAUDE.md`.
4. If it caused real damage (prod incident, data loss) → write a short
   post-mortem and a lesson in `memory-system.md`.

This is the loop that makes the agent smarter instead of just busier.

---

## Project Gotchas (start empty — fill as you learn)

> This section ships nearly empty on purpose. Every entry should come from a
> bug *you* actually hit. Format each one so the agent can act on it.

Template for a new entry:

```
### <Area> — <short title>
- **What happened:** <the observed failure>
- **Why:** <the root cause>
- **Prevent:** <the concrete rule the agent should follow from now on>
```

Example entries (replace with your own as they occur):

### Git — staged the wrong files
- **What happened:** `git add -A` swept a local config file into a commit.
- **Why:** blanket staging with unreviewed files present.
- **Prevent:** stage explicit paths; never `git add -A` / `git add .`.

### Dependencies — "works on my machine"
- **What happened:** build passed locally, failed in CI on a missing dep.
- **Why:** a dependency was installed globally, not declared in the manifest.
- **Prevent:** install from a clean checkout before pushing; declare every dep.

### Tests — false green
- **What happened:** "all tests pass" but the new test never ran.
- **Why:** a typo in the test name meant it wasn't collected.
- **Prevent:** read the test count; confirm the new test is in it.

---

## General gotcha categories worth watching

These tend to bite across most stacks — add specifics as you encounter them:

- **Timezones & dates** — naive vs aware datetimes; off-by-one on day
  boundaries; assuming UTC when it's local.
- **Floating point & money** — never store money as a float; rounding drift.
- **Async / concurrency** — race conditions, unawaited promises, shared state.
- **Encoding** — UTF-8 vs latin-1; smart quotes breaking parsers.
- **Caching** — stale reads after a write; cache key collisions.
- **Pagination & limits** — silently truncated results; default page sizes.
- **Off-by-one & null handling** — the classics; guard the empty/null case.
- **Cost / rate limits** — expensive API or query calls in a loop; estimate
  before you run something that scans or bills a lot.
