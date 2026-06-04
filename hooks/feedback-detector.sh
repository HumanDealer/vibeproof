#!/usr/bin/env bash
# feedback-detector — UserPromptSubmit hook. When the CEO expresses dissatisfaction
# ("плохо", "не нравится", "не так", "wrong", "this is bad"...), capture that exact
# moment to the vault's lesson inbox so the daily digest can turn it into a rule.
# Fully automatic — no /learn, no manual step. Never blocks; always exits 0.
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

prompt = (hook.get("prompt") or "").strip()
if not prompt:
    sys.exit(0)

# Dissatisfaction / correction markers (RU + UA + EN). Phrase-level to avoid noise.
markers = [
    r"не нравит", r"не нрав", r"плох(о|ая|ой|ие)", r"\bне так\b", r"неправильн",
    r"непра[вв]ильно", r"хуйн", r"говн", r"\bужас", r"бес(и|я)т", r"заеб",
    r"разочаров", r"не работает", r"сломал", r"\bне то\b", r"\bне это\b",
    r"исправь", r"переделай", r"фигн", r"\bстоп\b", r"\bне\s+надо\b",
    r"\bwrong\b", r"\bbad\b", r"this is bad", r"don'?t like", r"doesn'?t work",
    r"\bbroken\b", r"\bterrible\b", r"\bawful\b", r"\bfix this\b", r"\bredo\b",
    r"\bnot what\b", r"\bnope\b", r"\bno,? ", r"\bне верно\b",
]
rx = re.compile("|".join(markers), re.IGNORECASE)
m = rx.search(prompt)
if not m:
    sys.exit(0)

sid = hook.get("session_id", "") or "session"
cwd = hook.get("cwd", "")
now = datetime.datetime.now()
inbox_dir = os.path.join(vault, "_inbox")
os.makedirs(inbox_dir, exist_ok=True)
inbox = os.path.join(inbox_dir, "feedback-signals.md")

# read prior assistant turn (what the CEO is reacting to) from transcript, if any
context = ""
tpath = hook.get("transcript_path", "")
if tpath and os.path.isfile(tpath):
    try:
        last_assistant = ""
        with open(tpath) as f:
            for line in f:
                try: d = json.loads(line)
                except Exception: continue
                if d.get("type") == "assistant":
                    c = d.get("message", {}).get("content")
                    if isinstance(c, list):
                        txt = " ".join(b.get("text","") for b in c if isinstance(b,dict) and b.get("type")=="text")
                        if txt.strip(): last_assistant = txt.strip()
        context = last_assistant[:300]
    except Exception:
        pass

snippet = prompt[:500].replace("\n", " ")
trigger = m.group(0)
line = (f"\n## [{now:%Y-%m-%d %H:%M}] signal: \"{trigger}\" · session {sid[:8]} · {os.path.basename(cwd)}\n"
        f"- **CEO said:** {snippet}\n")
if context:
    line += f"- **reacting to:** {context}…\n"
line += "- **lesson:** _(extracted by daily digest)_\n"

header_needed = not os.path.isfile(inbox)
with open(inbox, "a") as f:
    if header_needed:
        f.write("---\ntitle: Feedback signals — auto-captured dissatisfaction moments\n"
                "tags: [feedback-inbox, learning-loop]\n---\n\n"
                "> Auto-captured when the CEO signals something is wrong. The daily "
                "digest turns these into lessons/rules. Append-only.\n")
    f.write(line)
PY
exit 0
