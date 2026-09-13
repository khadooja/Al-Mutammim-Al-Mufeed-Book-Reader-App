---
name: code-review
description: Run a self-review checklist after finishing any feature in the Al-Mutammim Al-Mufeed Flutter app, before it's committed and pushed. Use when a feature's code is written, or when the user says "review this", "is this done", or "code review".
allowed-tools: Read Grep Glob Bash(git diff *) Bash(git status *) Bash(flutter analyze) Bash(flutter test)
---

# Code Completion Self-Review

Run this checklist before marking any feature as done. Read-only except for
running `flutter analyze` / `flutter test` — do not otherwise modify code during
this step. Full context: `docs/PROJECT_SPEC.md`, `docs/ui_mockup.html`.

## Correctness

- [ ] The feature matches what `PROJECT_SPEC.md` describes for this milestone — nothing missing, nothing extra.
- [ ] Edge cases handled: empty book/chapter data, missing images, empty search results, empty text selection.
- [ ] No silent failures — a missing/malformed `book.json` field fails loudly (e.g. a clear error/placeholder), not a blank screen.

## Project Architecture Compliance

- [ ] No backend, no HTTP calls, no local database, no auth code introduced — this app is fully offline, bundled-asset only.
- [ ] Data flows as `books_repository.dart` (reads assets) → models (`book.dart`/`chapter.dart`/`section.dart`/`content_block.dart`) → screens/widgets. No screen parses raw JSON directly.
- [ ] Content blocks stay polymorphic (heading/text/image) — no special-casing content types outside `content_renderer.dart`.
- [ ] Colors, fonts, radii, and spacing come from `core/theme/app_theme.dart`, matching `ui_mockup.html` — no hardcoded hex values or ad-hoc font sizes in screens/widgets.
- [ ] RTL is respected everywhere: text direction, icon/chevron direction, padding (`start`/`end`, not `left`/`right`).

## Safety

- [ ] No existing screen or flow broken without the user being told why.
- [ ] No performance regressions (unnecessary rebuilds, missing `const`, heavy `build()` methods, rebuilding search results on every keystroke without debouncing where relevant).
- [ ] No `TextEditingController`/`AnimationController`/`FocusNode` created inside `build()`.
- [ ] No unused imports, dead code, or debug prints left behind.
- [ ] `flutter analyze` runs clean (or any remaining warning is explicitly justified in the report).

## Code Quality

- [ ] Code is clean, readable, and matches the folder structure in `PROJECT_SPEC.md`.
- [ ] Files and functions are small and focused.
- [ ] No unnecessary duplication between `chapter_tile.dart` usage on the home screen and the TOC screen.

## Output

After completing the checklist, provide a brief summary:

1. **What** was changed
2. **Why** it was changed
3. **Why** the solution is safe and matches the spec

If any checklist item fails, fix it and re-run the checklist before handing off to the git-pr skill.
