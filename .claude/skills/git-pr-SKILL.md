---
name: git-pr
description: Branch, commit, push, and open a pull request for a finished feature in the Al-Mutammim Al-Mufeed app. Invoke automatically AFTER the code-review skill passes — do not ask for confirmation first, this is the agreed default for this project. Use when the user says "push this", "create PR", or "ship it".
allowed-tools: Bash(git *) Bash(gh *)
---

# Git & Pull Request

Run this immediately after code-review passes for a feature. No confirmation needed before pushing — auto-push + auto-PR is the agreed workflow for this project.

## Branch Name

```
feat/<short-milestone-description>
fix/<short-description>
chore/<short-description>
```

Lowercase, hyphen-separated, concise, matching the milestone name from `PROJECT_SPEC.md`. Example: `feat/home-screen`, `feat/search`, `feat/toc-screen`.

## Commit Message

Conventional commit format:

```
<type>(<scope>): <short summary>

<optional body — explain why, not what>
```

- Types: `feat`, `fix`, `refactor`, `chore`, `docs`
- Scope: the piece touched, e.g. `home`, `toc`, `reader`, `search`, `models`, `theme`
- Summary: imperative mood, no period, max 72 characters

Examples:
```
feat(home): build hero card and chapter list per mockup
feat(models): add Book/Chapter/Section/ContentBlock data model
feat(search): add in-memory search with tap-to-jump
```

## Steps

1. `git checkout -b <branch-name>` from the current base branch.
2. Stage and commit only the files belonging to this feature.
3. `git push -u origin <branch-name>`.
4. Open the PR with `gh pr create`, using the title/description below.
5. Report the branch name, commit message, and PR link back to the user (as part of the feature-workflow report — don't post it separately).

## Pull Request Title

Matches the commit type/scope. Example: `feat(home): Build home screen with hero card and chapter list`

## Pull Request Description

```markdown
## Summary
Which milestone from PROJECT_SPEC.md this implements, in one or two sentences.

## Changes
- Key change 1
- Key change 2

## Scope check
Confirms this stays within PROJECT_SPEC.md scope (offline, no backend/accounts, no extra features).

## Testing
How it was verified (flutter analyze, flutter test, manual run on emulator/device).
```
