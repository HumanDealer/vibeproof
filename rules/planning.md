# Planning — Think Before You Touch Many Files

Small change? Just do it well. But any task that touches **more than ~3 files**
or has multiple steps gets a written plan *first*. Planning is cheap;
unwinding a half-built wrong approach is not.

---

## When to plan

| Task | Plan? |
|---|---|
| Fix a typo, tweak one function | No — just do it (still verify). |
| Add a field to one model + its one usage | Borderline — a 2-line plan in chat is fine. |
| New feature spanning >3 files | **Yes — write a plan file.** |
| Refactor, migration, anything multi-step | **Yes — write a plan file.** |
| Anything you're unsure how to approach | **Yes — plan, then get a thumbs-up.** |

---

## How to plan

1. **Write the plan to a file:** `docs/plans/YYYY-MM-DD-<scope>.md` (or
   `.claude/plans/...`). Files survive context compaction; chat doesn't.
2. State the **goal** in one sentence, then the **steps** as a checklist:

   ```markdown
   # Plan: password reset flow — 2026-06-04

   Goal: let users reset a forgotten password via email link.

   - [ ] Add `reset_token` + `reset_expires` to the user model
   - [ ] Endpoint: POST /auth/reset-request (sends email)
   - [ ] Endpoint: POST /auth/reset-confirm (validates token, sets password)
   - [ ] Email template + send integration
   - [ ] Tests: request, confirm, expired token, invalid token
   - [ ] Rate-limit the request endpoint
   ```

3. **Note the risky parts** — what could break, what you're unsure about.
4. **Get a thumbs-up** from the human before executing anything non-trivial.
5. **Execute step by step**, checking off `[x]` as you go. Don't skip ahead.
6. If reality diverges from the plan, **update the plan file** — don't just
   wing it silently.

---

## Why a file, not just chat

- It survives the agent's context being compacted mid-task.
- The human can read and correct the approach *before* code is written.
- It's a record of intent you can check the final diff against.
- A second agent (or you tomorrow) can pick it up cold.

---

## Inversion check (before you start building)

Spend 30 seconds on: **"What would make this plan fail?"** Missing edge case,
a dependency that isn't there, an assumption about the data. Catching it now is
free; catching it after implementation is not.
