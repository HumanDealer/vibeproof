# Skills — Composable Mini-Playbooks

A **skill** is a small, focused instruction file that an agent loads when a
task matches it. Where `rules/` are always-on discipline, skills are
*on-demand procedures* for recurring jobs: shipping a change, reviewing a diff,
debugging, capturing a lesson.

Most modern agents support skills natively (Claude Code `Skill` tool, Codex /
Cursor via referenced files). Even without native support, you can paste a
`SKILL.md` into context and say "follow this."

## The skills in this repo

| Skill | Use when | What it does |
|---|---|---|
| [`ship/`](ship/SKILL.md) | change is ready to land | branch → quality gate → commit → PR, the whole sequence |
| [`code-review/`](code-review/SKILL.md) | before merging a diff | structured review for bugs, safety, and simplicity |
| [`debug-root-cause/`](debug-root-cause/SKILL.md) | something is broken | the no-fix-without-root-cause loop |
| [`save-learning/`](save-learning/SKILL.md) | you learned something durable | capture it into the memory wiki |

## Writing your own

A skill is just a markdown file with frontmatter describing *when to use it*,
followed by the procedure:

```markdown
---
name: my-skill
description: Use when <trigger>. Does <what>.
---

# My Skill

## When to use
<the trigger conditions>

## Steps
1. ...
2. ...
```

Keep them short and procedural. A skill the agent can't follow mechanically is
just prose.
