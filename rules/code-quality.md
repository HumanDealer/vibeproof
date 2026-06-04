# Code Quality Gates — Run Before Every Commit & Push

> Skipping gates = shipping untested code. Never OK — especially for "quick
> fixes." Run the gates locally before every commit and every push.

The exact commands depend on your stack. Replace the examples below with your
project's real commands and record them in your `AGENTS.md` so the agent always
knows them.

---

## 1. The Pre-Commit Gate (mandatory before EVERY commit)

Run **all four**, fix anything that fails, then commit:

| Check | What it does | Example commands |
|---|---|---|
| **Lint** | style + obvious errors | `ruff check .` · `eslint .` · `golangci-lint run` |
| **Types** | static type safety | `mypy .` · `tsc --noEmit` · `go vet ./...` |
| **Tests** | behavior is correct | `pytest -q` · `vitest run` · `go test ./...` |
| **Secret scan** | nothing sensitive staged | `gitleaks detect --staged` (see below) |

If a tool isn't installed, **install it** — don't skip the check.

### Secret scan (always run, any language)

```bash
# Preferred, if installed:
gitleaks detect --staged --no-git --verbose

# Fallback grep over the staged diff:
git diff --staged | grep -iE \
  'api[_-]?key|secret|password|token|bearer [a-z0-9]|sk-[a-z0-9]{20}|ghp_[a-z0-9]{30}'
# Empty output = OK.
```

A hit means **stop** — see `security-and-secrets.md`.

---

## 2. "The Test Output Says PASS" Verification

After running tests, **read the output.** Don't trust the exit code alone.

| Check for | Looks like |
|---|---|
| All tests actually ran | `21 passed` — not `0 selected`, not `1 of 21` |
| No silently skipped tests | investigate every `skip` / `xfail` |
| No accidental focus | no `.only` / `-k onefn` left committed |
| Type checker is clean | `0 errors` — not "1 suppressed with ignore" |

If you added a test, confirm it actually *ran and passed* — not just collected.

---

## 3. The Pre-Push Gate (mandatory before EVERY push)

```bash
# 1. Are you about to push to a protected branch?
git branch --show-current
#    main / master / production  → STOP. Open a branch.

# 2. Re-run the full pre-commit gate (you may have several commits).

# 3. Re-read the whole diff one last time:
git log -p origin/main..HEAD

# 4. Push to your feature branch:
git push -u origin <your-branch>
```

---

## 4. Post-Push CI Verification

1. Wait for CI to finish (`gh pr checks <n> --watch` or poll).
2. **All checks green** before requesting merge.
3. A check fails → read the log, fix the *root cause*, push the fix.
4. Never merge a red check. Never bypass with admin override.

---

## 5. Rules That Never Bend

- **Tests fail** → fix before committing. Never `skip`/`xfail` without a
  comment + a tracked ticket.
- **Lint errors** → fix. Never blanket-disable a rule without a comment + ticket.
- **Type errors** → fix. Never `ignore` / `as any` / `@ts-expect-error` to
  silence them.
- **Secrets found** → STOP. Move to `.env` / a secret manager. Rotate the
  leaked secret. Never commit it.
- **Debug prints** → remove before committing.
- **`--no-verify` / `[skip ci]`** → never. If a hook is wrong, fix the hook.

---

## 6. Quality Is Not Optional — Especially for "Quick Fixes"

The 60 seconds you save skipping the gate becomes 60 minutes of cleanup later.
Always run the gates. Always.
