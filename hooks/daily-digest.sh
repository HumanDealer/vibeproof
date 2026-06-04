#!/usr/bin/env bash
# daily-digest — once per day, have headless Claude read the day's recorded
# sessions + the feedback-signals inbox, extract lessons, and write a CEO
# validation digest into the vault (→ Obsidian Sync → phone).
#
# Idempotent: skips if today's digest already exists. Guarded against recursion.
# Trigger options: SessionStart hook (runs on first session of the day) or
# OS cron/launchd (runs even if Claude isn't opened). Always exits 0.
set +e

[ -n "$VIBEPROOF_DIGEST_RUNNING" ] && exit 0   # never recurse from the headless call
VAULT="${VIBEPROOF_VAULT:-$HOME/ObsidianVault}"
[ -d "$VAULT" ] || exit 0
command -v claude >/dev/null 2>&1 || exit 0

# Default = yesterday (the last completed day). Cross-platform (BSD/macOS + GNU).
yesterday() { date -v-1d +%F 2>/dev/null || date -d "yesterday" +%F 2>/dev/null; }
DATE="${1:-$(yesterday)}"
DIGEST_DIR="$VAULT/_digests"
OUT="$DIGEST_DIR/$DATE.md"
[ -f "$OUT" ] && exit 0                          # already done today
mkdir -p "$DIGEST_DIR"

CONV_DIR="$VAULT/conversations/$DATE"
INBOX="$VAULT/_inbox/feedback-signals.md"
[ -d "$CONV_DIR" ] || { [ -f "$INBOX" ] || exit 0; }   # nothing to digest

# Assemble bounded material (cap to keep token cost sane).
MATERIAL="$(mktemp)"
{
  echo "# Conversations on $DATE"
  for f in "$CONV_DIR"/*.md; do
    [ -f "$f" ] || continue
    echo "--- file: $(basename "$f") ---"
    head -c 12000 "$f"
    echo
  done
  if [ -f "$INBOX" ]; then
    echo "# Feedback signals (CEO dissatisfaction moments)"
    tail -c 8000 "$INBOX"
  fi
} > "$MATERIAL"

PROMPT="You are writing a once-a-day VALIDATION DIGEST for a non-technical CEO who builds with AI agents. Read the day's recorded agent sessions and the captured feedback signals below. Output Markdown only, concise, CEO-style (tables/bullets). Sections:
1. **What shipped today** — one line per real outcome across all sessions.
2. **Lessons extracted** — from the feedback signals (moments the CEO said something was wrong): each lesson = what went wrong + the rule to prevent it. These are the most important.
3. **Needs your validation** — decisions/doc-or-rule changes that need a yes/no from the CEO. Be specific.
4. **Pending / risks** — anything unfinished or risky.
Skip anything trivial. If a section is empty, omit it. End with one line: the single highest-leverage thing to do tomorrow.

=== MATERIAL ===
$(cat "$MATERIAL")"

RESULT="$(VIBEPROOF_DIGEST_RUNNING=1 claude -p "$PROMPT" --model sonnet 2>/dev/null)"
rm -f "$MATERIAL"
[ -z "$RESULT" ] && exit 0

{
  echo "---"
  echo "title: Daily digest — $DATE"
  echo "date: $DATE"
  echo "tags: [digest, validation, learning-loop]"
  echo "---"
  echo
  echo "# 📋 Daily validation — $DATE"
  echo
  echo "$RESULT"
} > "$OUT"

# Archive the consumed signals so they aren't re-digested tomorrow.
if [ -f "$INBOX" ]; then
  mv "$INBOX" "$VAULT/_inbox/feedback-signals.$DATE.archived.md" 2>/dev/null
fi
exit 0
