# Session Handoff — Survive Context Loss on Long Tasks

AI agents have a finite context window. On a long task it fills up, gets
compacted, and the plan you carefully built evaporates. The fix: **put durable
state in files, not in the conversation.** Files survive; chat history doesn't.

---

## At the START of a session

1. Read the project's status / handoff file if one exists (e.g.
   `STATUS.md` or `.last-session.md`).
2. Read the project contract (`AGENTS.md` / `CLAUDE.md`) for current state and
   pending items.
3. Check for an active plan file (see `planning.md`).
4. If continuing prior work, summarize where you left off in 1–2 lines and
   confirm with the human before charging ahead.

## At the END of a significant session

1. Update any state files with new decisions made.
2. Record unfinished work in a `## Pending` list (see below).
3. If a plan exists, mark done vs remaining items.
4. Offer to save durable learnings to memory (`memory-system.md`).

---

## Pending-items tracking

Keep a running table in your status file so nothing falls through:

```
## Pending
| Item | Since | Priority | Notes |
|------|-------|----------|-------|
| Wire up password-reset email | 2026-06-01 | HIGH | blocked on SMTP creds |
```

Resolved → remove it. New blocker → add it immediately.

---

## Plan persistence

For any task touching more than a few files, write the plan to a file
(`docs/plans/YYYY-MM-DD-<scope>.md` or `.claude/plans/...`). Track progress
with `[ ]` / `[x]` checkboxes. **Plan files survive compaction; conversation
context does not.** See `planning.md`.

---

## Efficiency notes (for agents with sub-tasks / sub-agents)

- One major task per session — very long sessions get expensive to compact.
- Use sub-agents for expensive *exploration* so the main context stays lean;
  read-only search can run on a cheaper model.
- Don't re-read the entire codebase at session start — that's costly and
  rarely necessary. Read the status file and the relevant slice.

## What NOT to do

- Don't ask "what are we working on?" if the status file makes it obvious.
- Don't dump a wall of previous-session context when the human clearly wants
  something new.
- Don't keep critical state only in your head / the chat — write it down.
