# Git Workflow — Iron Discipline

> If you feel tempted to bypass any rule below, stop and ask the human. Never
> improvise around git. Broken history and lost work are expensive and often
> permanent.

---

## 1. The Five Hard Prohibitions (NEVER, no exceptions)

| # | Rule | Why | If you already broke it |
|---|---|---|---|
| 1 | **Never `git push` to `main`/`master`/`production`** without a merged PR | Direct pushes skip review + CI and break the audit trail | Open a PR retroactively, flag it to the human |
| 2 | **Never `git commit --no-verify`** | Hooks catch real bugs — lint, secrets, type errors | Re-commit without the flag; fix what the hook found |
| 3 | **Never `git push --force` / `--force-with-lease`** to a shared branch | Rewrites history; destroys others' work | Revert the push if possible; tell whoever lost work |
| 4 | **Never `git add -A` / `git add .`** when unreviewed files exist | Sweeps in `.env`, build artifacts, stray files | `git reset`, then add explicit paths |
| 5 | **Never skip a CI failure** ("just docs", "trivial") | One ignored failure normalizes ignoring all of them | Block the merge; fix the root cause, don't `[skip ci]` |

If you think *"this case is special"* — it is not. Stop and ask.

---

## 2. The Mandatory Workflow (every change)

```
1. git fetch origin && git checkout main && git pull
2. git checkout -b <type>/<scope>-<short-description>
3. Make changes in atomic commits (one logical change each)
4. Run the quality gate locally (see code-quality.md):
   tests pass · types clean · lint clean · no secrets
5. git push -u origin <branch>
6. Open a PR (use the repo's PR template)
7. Wait for ALL CI checks to be green
8. Merge (squash or rebase per project convention), delete the branch
9. git checkout main && git pull
```

**Step 4 is not optional.** "I'll push and let CI catch it" wastes minutes of
CI per push for what costs seconds locally. Run it locally.

---

## 3. Branch Naming

```
feat/<scope>-<thing>      new functionality     e.g.  feat/auth-password-reset
fix/<scope>-<thing>       bug fix               e.g.  fix/api-null-pointer
chore/<scope>-<thing>     deps / config / maint e.g.  chore/bump-deps
docs/<scope>-<thing>      documentation only    e.g.  docs/readme-quickstart
refactor/<scope>-<thing>  no behavior change    e.g.  refactor/extract-client
test/<scope>-<thing>      tests only            e.g.  test/edge-cases
```

When several agents work in parallel, prefix with the agent name:
`codex/feat/...`, `claude/fix/...`.

**Rejected branch names:** `update`, `fixes`, `wip`, `temp`, `test`,
`my-branch`. They tell nobody anything.

---

## 4. Commit Messages

```
<type>(<scope>): <short imperative summary, <=72 chars>

<body — what & why, not how. Wrap at 80. Expected for any non-trivial change.>

<footer — Co-Authored-By, BREAKING CHANGE, issue refs>
```

Good:
- `feat(auth): add password-reset email flow`
- `fix(api): handle null customer id in checkout`
- `docs(readme): add 60-second quick start`

Rejected: `update`, `fixed stuff`, `wip`, `more changes`, `trying again`.

Each commit is **one logical change**. If your message needs the word "and",
it is probably two commits.

---

## 5. PR Hygiene

Every PR must have:

- [ ] Title in commit format (`<type>(<scope>): <description>`)
- [ ] Body with **Summary** (what + why) and **Test plan** (how you verified)
- [ ] All CI checks green before requesting merge
- [ ] A self-review of the diff (you are the reviewer of last resort)
- [ ] No commented-out code, no debug prints, no `TODO` without an owner + date
- [ ] No build artifacts (`dist/`, `build/`, `__pycache__/`) in the diff
- [ ] No secrets (scan the staged diff — see `security-and-secrets.md`)

**Self-merge is OK for solo projects** only when: CI is green, the diff
contains exactly what you intended (you re-read it), and history is clean. If
any of those is unclear → ask the human.

---

## 6. The "I'm About To Break a Rule" Test

Before any `push` or `merge`, ask:

1. Am I pushing to `main` directly? → STOP. Branch.
2. Did I run the gate locally? → If no, run it now.
3. Is there a CI failure I'm ignoring? → STOP. Fix it.
4. Am I about to `--force`? → STOP. Ask the human.
5. Is there `--no-verify` or `[skip ci]` in my command? → STOP. Remove it.

All five clean → proceed.

---

## 7. Parallel Work with Worktrees

For multiple features at once, isolate with worktrees **outside** the main
checkout (nesting causes dependency/install conflicts):

```bash
git worktree add ../<project>-<scope> <branch-name>   # note the ../
cd ../<project>-<scope>
# ... work, commit, push ...
# after the PR merges:
git worktree remove ../<project>-<scope>
```

Wrong: `git worktree add ./feature ...` — never nest inside the repo.
