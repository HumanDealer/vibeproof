#!/usr/bin/env bash
# conversation-recorder — append/refresh the current session as a Markdown note
# in the Obsidian vault. Wired to the Stop hook: re-renders the session note each
# turn, so the dialogue is recorded live and survives a crash.
#
# Vault path is configurable so the SAME script works on Mac, servers, Codex:
#   export VIBEPROOF_VAULT=/path/to/vault   (defaults to the local Knowledge Vault)
#
# Defensive by contract: never fails the session. Always exits 0.
set +e

VAULT="${VIBEPROOF_VAULT:-$HOME/ObsidianVault}"
INPUT="$(cat 2>/dev/null)"
[ -d "$VAULT" ] || exit 0

VIBEPROOF_VAULT="$VAULT" python3 - "$INPUT" <<'PY' 2>/dev/null
import json, os, sys, datetime, re

vault = os.environ["VIBEPROOF_VAULT"]
try:
    hook = json.loads(sys.argv[1]) if len(sys.argv) > 1 and sys.argv[1].strip() else {}
except Exception:
    hook = {}

tpath = hook.get("transcript_path", "")
cwd = hook.get("cwd", os.getcwd())
sid = hook.get("session_id", "") or "session"
if not tpath or not os.path.isfile(tpath):
    sys.exit(0)

def text_from(content):
    """Extract visible text from a user/assistant message content."""
    if isinstance(content, str):
        return content.strip(), []
    if not isinstance(content, list):
        return "", []
    parts, tools = [], []
    for b in content:
        if not isinstance(b, dict):
            continue
        bt = b.get("type")
        if bt == "text":
            parts.append(b.get("text", ""))
        elif bt == "tool_use":
            tools.append(b.get("name", "tool"))
        elif bt == "tool_result":
            pass  # skip tool output noise from the readable dialogue
    return "\n".join(p for p in parts if p).strip(), tools

msgs = []
first_ts = None
with open(tpath) as f:
    for line in f:
        try:
            d = json.loads(line)
        except Exception:
            continue
        t = d.get("type")
        if t not in ("user", "assistant"):
            continue
        m = d.get("message", {})
        if m.get("role") not in ("user", "assistant"):
            continue
        txt, tools = text_from(m.get("content"))
        ts = d.get("timestamp", "")
        if ts and not first_ts:
            first_ts = ts
        # skip pure tool-result user turns and empty assistant turns
        if not txt and not tools:
            continue
        msgs.append((m.get("role"), txt, tools))

if not msgs:
    sys.exit(0)

# dedupe consecutive identical (Stop can re-emit)
clean = []
for role, txt, tools in msgs:
    if clean and clean[-1] == (role, txt, tools):
        continue
    clean.append((role, txt, tools))

now = datetime.datetime.now()
date = (first_ts[:10] if first_ts and len(first_ts) >= 10 else now.strftime("%Y-%m-%d"))
project = os.path.basename(cwd.rstrip("/")) or "unknown"
short = sid[:8]

# one folder per day, one file per session — Obsidian-friendly
outdir = os.path.join(vault, "conversations", date)
os.makedirs(outdir, exist_ok=True)
outfile = os.path.join(outdir, f"{date}-{short}.md")

def trunc(s, n=4000):
    s = s.strip()
    return s if len(s) <= n else s[:n] + "\n\n…[truncated]"

lines = [
    "---",
    f"date: {date}",
    f"session: {sid}",
    f"project: {project}",
    f"cwd: {cwd}",
    "tags: [conversation, agent-session]",
    f"updated: {now.strftime('%Y-%m-%d %H:%M')}",
    "---",
    "",
    f"# Session {short} — {project}",
    "",
    f"> {len(clean)} turns · {cwd}",
    "",
]
for role, txt, tools in clean:
    who = "🧑 **User**" if role == "user" else "🤖 **Claude**"
    lines.append(f"### {who}")
    if txt:
        lines.append(trunc(txt))
    if tools:
        lines.append(f"\n`tools: {', '.join(tools)}`")
    lines.append("")

with open(outfile, "w") as f:
    f.write("\n".join(lines))
PY
exit 0
