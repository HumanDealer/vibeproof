# Walkthrough: A Domain Expert Ships a Feature Safely

A worked example of vibeproof in action. The human here is a **marketer**, not
a programmer. They know exactly what they want; the agent supplies the
discipline. No prior coding knowledge assumed.

---

## The setup (one time, 2 minutes)

The marketer has a small internal tool — a web app that tracks campaigns.
They drop vibeproof in:

```bash
npx degit HumanDealer/vibeproof/rules ./rules
cp templates/new-project/AGENTS.md ./AGENTS.md   # then fills in the commands
```

They open the project in their AI agent and type:

> "Read AGENTS.md and follow it for everything."

That's it. The agent now has guardrails.

---

## The task

> **Marketer:** "Add a button that exports the campaign list to CSV."

Watch what the agent does *differently* because of vibeproof.

### 1. It plans first (the task touches several files)

Per `rules/planning.md`, the agent writes a short plan and shows it:

```
Goal: add a "Export CSV" button to the campaign list.
- [ ] Add an /export endpoint that returns CSV
- [ ] Add the button to the campaign list page
- [ ] Handle the empty-list case
- [ ] Test: export with data, export with no data
```

> **Marketer:** "Looks good, go." ← they understood every line. That's the point.

### 2. It branches (never works on main)

Per `rules/git-workflow.md`:

```bash
git checkout -b feat/campaigns-csv-export
```

The marketer didn't have to know to ask for this. The rule made it automatic.

### 3. It builds — and catches its own edge case

The agent implements the endpoint and the button, then remembers the
empty-list case from its own plan, and handles it. Per
`rules/verify-your-work.md`, it doesn't assume — it tests both paths.

### 4. It runs the quality gate before committing

Per `rules/code-quality.md`:

```
✓ lint clean
✓ types clean
✓ tests: 4 passed
✓ secret scan: clean
```

The marketer sees real evidence, not "I think it works."

### 5. It almost leaks a secret — and stops

While wiring the export, the agent considered hardcoding an API token for an
email notification. The secret scan in the gate would have caught it; the rule
in `rules/security-and-secrets.md` caught it earlier. It moves the token to
`.env` and references it from there. **A leak that never happened.**

### 6. It opens a PR, waits for green CI, then merges

```
PR #12: feat(campaigns): add CSV export
  Summary: adds an Export CSV button + /export endpoint
  Test plan: 4 tests (with data, empty, malformed, large) — all pass
  CI: ✓ green
```

The marketer reviews a clean diff they can mostly read, and clicks merge.

### 7. It records what it learned

The empty-list case had bitten a previous export feature too. Per
`skills/save-learning/SKILL.md`, the agent notes a one-line lesson in memory so
the *next* export feature handles it from the start.

---

## What just happened

The marketer made **zero** engineering decisions. They never said "branch
first" or "run the tests" or "don't commit that key." The rulebook did. They
stayed in their zone — *what to build* — and got senior-engineer execution for
free.

That's vibeproof: **you bring the domain, the rules bring the discipline.**
