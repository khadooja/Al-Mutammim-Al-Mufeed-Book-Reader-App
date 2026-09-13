---
name: feature-workflow
description: Use at the start of any new task, feature, or milestone in this project (the Al-Mutammim Al-Mufeed book reader app). Also use when the user says "start the next feature", "let's continue", or similar. Ensures every feature is grounded in the project spec, implemented one at a time, self-reviewed, and shipped to GitHub before moving on.
allowed-tools: Read Grep Glob Bash(git diff *) Bash(git status *)
---

# Feature Workflow

This project is built from a fixed milestone list agreed with the user. Follow this process for every feature, without needing to be told again.

## Before starting a feature

- [ ] Re-read `docs/PROJECT_SPEC.md` (structure, data model, feature scope, constraints).
- [ ] Re-read `docs/ui_mockup.html` (colors, fonts, spacing, screen layout) if the feature touches any UI.
- [ ] Confirm the feature matches the agreed milestone list. Do not invent or reorder milestones without asking.
- [ ] Confirm the feature stays inside scope: no login, no backend/API, no accounts, no database sync, no notes, no quizzes, no subscriptions/payments/ads — unless the user has explicitly asked for one of these in this conversation.

## While working

- Work on **one feature/milestone only** — do not start the next one in the same pass.
- If a technical decision isn't already specified in `PROJECT_SPEC.md` or the mockup (e.g. a package choice, a naming convention, a fallback for missing data), make a reasonable choice but flag it clearly in the report — don't silently decide something structural.
- Keep code Arabic-content-friendly and RTL-safe throughout (widgets, padding direction, text alignment).

## After the feature is implemented

1. Run the **code-review** skill. Do not skip this step and do not mark the feature done without it.
2. If code-review finds a failing item, fix it and re-run the check before continuing. Do not push failing code.
3. Once code-review passes, run the **git-pr** skill to branch, commit, push, and open the pull request — this happens automatically, without asking the user first, since that's the agreed default for this project.

## After finishing a feature — report back

Always end the turn with a short report, not just the code:

1. **What was built** — one or two lines per file/piece of functionality.
2. **Files added or changed** — a plain list of paths.
3. **Code review result** — pass, and anything worth noting.
4. **Git/PR output** — branch name, commit message, and the PR link/number.
5. **Decisions made that need approval** — anything not explicitly specified in the spec/mockup. If none, say so explicitly.
6. **What's next** — name the next milestone from the list and wait for a go-ahead before starting it.

Do not move to the next milestone until the user confirms.
