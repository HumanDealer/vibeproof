# The self-improving loop — every token makes us better

> No manual `/learn`. Nothing is saved by remembering to save it. The system
> captures everything, extracts lessons from the moments that matter, and hands
> the CEO a once-a-day validation — automatically.

```
every turn          conversation-recorder.sh  → Knowledge Vault/conversations/<date>/
                    (Stop hook)                  full dialogue, idempotent, crash-proof

every CEO message   feedback-detector.sh      → _inbox/feedback-signals.md
                    (UserPromptSubmit hook)      flags "плохо / не так / wrong" + what it
                                                 was reacting to. THIS is how dissatisfaction
                                                 becomes a lesson without anyone typing /learn.

once a day          daily-digest.sh           → _digests/<date>.md
                    (launchd 08:00 + SessionStart  headless Claude reads the day's sessions +
                     fallback)                   signals → extracts lessons → writes a CEO
                                                 validation digest. Signals archived after.

→ Obsidian Sync carries all of it to the CEO's phone. The CEO reads ONE note/day
  and says yes/no. Confirmed lessons graduate into rules (error-prevention.md) and
  are loaded every session → never repeated.
```

## Why this shape
- **The CEO doesn't code.** The only reliable lesson signal is "this is bad / I
  don't like this." The detector catches exactly that, automatically.
- **Models and tools change weekly.** Capturing everything means the digest can
  surface "your docs reference an old model/tool" without anyone auditing by hand.
- **Nothing is wasted.** Every session is on disk; every dissatisfaction is a
  flagged lesson; every day is a validation. Tokens compound into a better system.

## Install (one time, per machine)
1. Scripts live in `hooks/` — copy to `~/.claude-config/hooks/` (Mac) or
   `~/.claude/hooks/` (a remote server).
2. Wire hooks in `~/.claude/settings.json`: `conversation-recorder.sh` on **Stop**,
   `feedback-detector.sh` on **UserPromptSubmit**, `daily-digest.sh` on
   **SessionStart** (backgrounded). See `templates/settings.hooks.json`.
3. For guaranteed daily timing (even if Claude isn't opened): load
   `templates/com.vibeproof.daily-digest.plist` (macOS) or a cron line (Linux).
4. Set `VIBEPROOF_VAULT` to the machine's vault path.

## Cross-tool (Codex, remote servers)
The scripts are tool-agnostic — they read JSONL transcripts and write Markdown.
Point `$VIBEPROOF_VAULT` at the same synced vault on each machine; git or Obsidian
Sync merges them. Codex (no Stop hook) is handled by the daily-digest ingesting
its transcript dir — configure the path in the digest's gather step.
