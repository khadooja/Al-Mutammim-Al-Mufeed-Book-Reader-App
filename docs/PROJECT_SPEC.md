# "Al-Mutammim Al-Mufeed" — Book Reader App
### Project Structure & Spec (hand this directly to Claude Code)

---

## 1. Project idea

Turn a scientific/religious book (currently a PDF/editable document) into a **Flutter mobile app** that displays the book in an organized, comfortable-to-read way, instead of opening it as a raw PDF.

- Number of books is limited (one book, or a few fixed books).
- **No backend, no user accounts.** The app is fully offline — content is bundled locally (assets/JSON), no server, no sync.
- Visual reference: two screenshots of a similar app called "المتمم المفيد" (green theme, rounded cards, circular icons) — attached separately.

---

## 2. Tech stack

| Part | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State management | Provider or Riverpod (simple — nothing heavy needed) |
| Storage | Local JSON/assets — no online database |
| Search | In-memory search over local JSON content |
| Copy/Share | `Clipboard` + `share_plus` package |
| Language/direction | Arabic content, RTL layout |

---

## 3. Suggested folder structure

```
lib/
├── main.dart
├── app.dart                     # MaterialApp + Theme + Routes
│
├── core/
│   ├── theme/
│   │   └── app_theme.dart       # colors, fonts, text styles
│   └── constants.dart
│
├── models/
│   ├── book.dart
│   ├── chapter.dart
│   ├── section.dart
│   └── content_block.dart       # heading / text / image
│
├── data/
│   ├── books_repository.dart    # reads JSON from assets
│   └── search_service.dart      # text search inside book content
│
├── screens/
│   ├── home_screen.dart         # home page + book hero card
│   ├── toc_screen.dart          # book table of contents
│   ├── chapter_screen.dart      # chapter content (text + images)
│   └── search_screen.dart       # search results
│
├── widgets/
│   ├── book_card.dart
│   ├── chapter_tile.dart        # TOC list item (icon + number + title)
│   ├── content_renderer.dart    # renders heading/text/image blocks
│   └── selectable_text_block.dart
│
└── assets_data/
    └── books/
        └── al_mutammim_al_mufeed/
            ├── book.json         # book + chapters text data
            └── images/           # book images
```

---

## 4. Data model

```
Book
 ├── id, title, author, description, coverIcon
 └── chapters: List<Chapter>

Chapter
 ├── id, number, title, icon
 └── sections: List<Section>

Section
 ├── id, title (optional)
 └── blocks: List<ContentBlock>

ContentBlock  (polymorphic)
 ├── HeadingBlock { text, level }
 ├── TextBlock    { text }        // selectable, copyable, shareable
 └── ImageBlock   { assetPath, caption? }
```

Example `book.json` (kept short here):
```json
{
  "id": "al_mutammim_al_mufeed",
  "title": "المتمم المفيد",
  "subtitle": "للمدخل إلى علم التجويد",
  "author": "أبو علي خالد بن علي بابكر",
  "description": "كتاب تعليمي في علم التجويد، يتناول مبادئ العلم، ومخارج الحروف وصفاتها، وأحكام التلاوة.",
  "chapters": [
    {
      "id": "ch1",
      "number": 1,
      "title": "مقدمة الكتاب",
      "icon": "book",
      "sections": [
        {
          "blocks": [
            { "type": "heading", "text": "مقدمة" },
            { "type": "text", "text": "..." },
            { "type": "image", "path": "images/ch1_1.png" }
          ]
        }
      ]
    }
  ]
}
```
Note: field names/code stay in English, but all displayed text content stays Arabic since it's an Arabic book.

---

## 5. Screens (matching the reference screenshots)

### 5.1 Home screen
- Search icon + centered title "المتمم المفيد" in the top bar.
- Large light-green hero card: circular icon + book name + short description + "ابدأ القراءة" (Start Reading) button.
- Section header "محتويات الكتاب" (Table of Contents) + list icon.
- List of chapter cards: number + chapter title + circular icon per chapter, with a `>` chevron.

### 5.2 Table of contents (TOC) screen
- Same chapter-card design as a standalone full page (no hero card), as shown in the second reference screenshot.

### 5.3 Chapter/reader screen
- Sequential rendering of blocks: sub-headings + selectable text + inline images placed correctly within the flow.
- Text selection → copy/share menu.

### 5.4 Search screen
- Search field + results list (chapter name + text snippet containing the match) → tapping jumps to that spot in the chapter.

---

## 6. Feature scope

✅ In scope:
1. Read the book (organized chapters/sections, mobile-friendly)
2. Search inside the book content
3. Select and copy text
4. Share selected text
5. Show images inline, in their correct place in the content
6. Fully offline

🚫 Out of scope for now (do not add unless explicitly requested):
- Login / user accounts
- Backend / API / online database
- Admin dashboard
- Data sync
- User notes
- Quizzes/tests or reading-progress tracking
- Subscriptions / payments / ads

---

## 7. Visual direction

RTL layout throughout, Arabic-friendly fonts, generous line-height for long-form reading. Full design tokens (colors, type, spacing) are specified in the accompanying `ui_mockup.html` file — treat it as the source of truth for the visual design.

---

## 8. Suggested build order for Claude Code

1. Create the Flutter project, set up RTL + Arabic fonts + theme (match `ui_mockup.html`).
2. Build models + read a sample `book.json` (1–2 chapters, for testing).
3. Build `home_screen.dart` to match the mockup.
4. Build `toc_screen.dart` + `chapter_tile.dart`.
5. Build `chapter_screen.dart` with `content_renderer.dart` (text + images).
6. Add search (`search_service.dart` + `search_screen.dart`).
7. Add copy/share on selected text.
8. Fill in the real book content inside `book.json`.
