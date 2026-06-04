# Verify Your Work — Never Claim "Done" Without Evidence

The single highest-leverage habit: **verify your output before claiming it's
complete.** An agent that says "done" without checking is shipping without
testing. With verification, quality jumps noticeably — measured across many
real sessions.

## The Rule

Before you say "done", "fixed", "готово", or mark any task complete, produce
**evidence**.

### For code changes
1. Run the tests — verify they pass (and that they actually ran).
2. Read the diff (`git diff`) — confirm only intended changes are present.
3. For a new function → test its edge cases, not just the happy path.
4. For an API / endpoint change → actually call it and check the response.

### For data / analysis work
1. Sanity-check the numbers: "Does this make sense?"
2. Cross-reference against a known baseline.
3. Check units and timeframes — are you comparing like with like?
4. Verify your filters did what you intended.

### For plans & recommendations
1. Check against the real constraints (budget, time, team, scope).
2. Invert: "What would make this fail?"
3. Name the blind spot: "What am I not seeing?"

### For file edits
1. Re-read the edited section in context — does it still make sense?
2. Check for syntax errors, broken markup, unclosed blocks.
3. Confirm no secret slipped in.

## How to report "done"

Don't just say "done" — show the evidence:

- ✅ "Tests pass (12/12)."
- ✅ "Diff: 3 files changed, all expected."
- ✅ "Endpoint returns 200 with the new field — verified with curl."
- ✅ "Numbers check out: total matches the baseline within rounding."

## When you may skip verification

- Trivial edits (a typo, a comment).
- The human explicitly says "just do it, don't verify."
- Low-risk notes / docs.

Everything else gets verified. "It should work" is not "it works."
