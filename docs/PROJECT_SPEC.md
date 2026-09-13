# Tajweed Library App
### Project Structure & Spec (hand this directly to Claude Code)

---

## 1. Project idea

Turn two related religious books — **"المدخل إلى علم التجويد"** (the prerequisite/intro book) and **"المتمم المفيد"** (its sequel/completion) — into a **Flutter mobile app** that displays them in an organized, comfortable-to-read way, instead of opening them as raw PDFs.

- **Two books today**, both by the same author, meant to be read in order (المدخل → المتمم). More books may be added later by the same author — treat the number of books as small and fixed, not unbounded.
- **No backend, no user accounts.** The app is fully offline — content is bundled locally (assets/JSON), no server, no sync.
- Visual reference: two screenshots of a similar app called "المتمم المفيد" (green theme, rounded cards, circular icons) — see `ui_mockup.html`.

### Update to the home screen (multi-book library)

The home screen is now a small **library** rather than a single-book hero:
- Instead of one hero card, show a card per book (currently 2): title, short description, "ابدأ القراءة" button — same visual style as the original single-book hero card, just repeated per book.
- Tapping a book's card/button opens that book's own TOC → reader flow (unchanged from before).
- Search can stay per-book (search inside the currently open book) for now; a global cross-book search is not required for v1.

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
        ├── al_madkhal_ila_ilm_al_tajweed/
        │   └── book.json          # no images in this book
        └── al_mutammim_al_mufeed/
            ├── book.json          # book + chapters text data
            └── images/            # real extracted book images (63 files)
```

Two content files are provided alongside this spec:
- `book_madkhal.json` → goes to `assets_data/books/al_madkhal_ila_ilm_al_tajweed/book.json`
- `book_mutammim.json` → goes to `assets_data/books/al_mutammim_al_mufeed/book.json`, and the `mutammim_images/` folder → goes to `assets_data/books/al_mutammim_al_mufeed/images/` (copy the files in as-is, keep the same filenames — the `path` field in each image block already points to `images/<filename>`)

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

## 7.5 Known content-quality caveat (important)

Both `book_madkhal.json` and `book_mutammim.json` were generated by OCR-scanning the source PDFs (the original text layer in both PDFs was corrupted/unreadable, so OCR was the only option). OCR accuracy is high but not perfect:
- A small percentage of lines (rough estimate: under 10%) are OCR noise from decorative page borders/calligraphy headers and should be deleted once spotted — they read as garbled nonsense mixed with a few real Arabic letters, easy to spot visually.
- Occasional individual-word misreads are possible in otherwise-correct sentences (normal OCR error rate).
- This is religious/Quranic content, so wording accuracy matters — **do not ship either book publicly without a human proofreading pass** (ideally the author, since he knows the exact intended wording). Treat the current JSON as a strong first draft, not final copy.
- This caveat does not block frontend/feature development — Claude Code can build and test every screen against this content normally; only the final wording needs a review pass before real release.

## 8. Suggested build order for Claude Code

1. Create the Flutter project, set up RTL + Arabic fonts + theme (match `ui_mockup.html`).
2. Build models + read a sample `book.json` (1–2 chapters, for testing).
3. Build `home_screen.dart` to match the mockup.
4. Build `toc_screen.dart` + `chapter_tile.dart`.
5. Build `chapter_screen.dart` with `content_renderer.dart` (text + images).
6. Add search (`search_service.dart` + `search_screen.dart`).
7. Add copy/share on selected text.
8. Fill in the real book content inside `book.json`.
