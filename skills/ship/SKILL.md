---
name: ship
description: Use when a change is ready to land. Runs the full sequence — branch, quality gate, commit, push, PR — so nothing gets skipped.
---

# Ship

Take a finished change from working tree to an open PR, with every gate
enforced. Never skips a step, never pushes to main.

## When to use

The human says "ship it", "deploy this", "open a PR", "push it up", or the
implementation is done and the next step is to land it.

## Steps

1. **Confirm you're not on a protected branch.**
   ```bash
   git branch --show-current
   ```
   If `main` / `master` / `production` → create a feature branch now:
   `git checkout -b <type>/<scope>-<desc>` (see rules/git-workflow.md).

2. **Run the quality gate locally** (rules/code-quality.md):
   - lint · types · tests · secret scan — all green.
   - Read the test output; confirm the count, no silent skips.
   - Fix anything that fails before continuing. Do not proceed on red.

3. **Review the diff yourself.**
   ```bash
   git diff
   ```
   No secrets, no debug prints, no commented-out code, no stray files.

4. **Commit atomically.** One logical change per commit, message in
   `<type>(<scope>): <summary>` format (rules/git-workflow.md).

5. **Push the branch.**
   ```bash
   git push -u origin <branch>
   ```

6. **Open the PR** with a Summary (what + why) and a Test plan (how you
   verified). Use the repo's PR template if present.

7. **Wait for CI to be green.** A failure → read the log, fix the root cause,
   push the fix. Never merge red.

8. **Merge** (squash/rebase per convention), delete the branch, return to a
   fresh `main`.

## Never

- Push straight to main.
- `--no-verify` or `[skip ci]`.
- Claim shipped before CI is green.
