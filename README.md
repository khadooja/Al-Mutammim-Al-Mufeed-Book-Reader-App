# المتمم المفيد — Tajweed Library App

A fully offline Flutter app that turns two related books on Tajweed — *"المدخل إلى علم التجويد"* (the introduction) and its sequel *"المتمم المفيد"* — into an organized, comfortable-to-read mobile reading experience, instead of raw PDFs.

The home screen is a small library with a card per book; opening a book leads to its own table of contents, reader, and search.

## Features

- **Read** each book organized by chapters and sections, with headings, paragraphs, and inline images rendered in order.
- **Search** within the open book's content in-memory; tap a result to jump straight to that spot in the chapter.
- **Select, copy, and share** any passage of text.
- **Fully offline** — no backend, no accounts, no network calls. All content ships bundled with the app as local JSON/assets.

## Tech stack

| Part | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Storage | Local JSON assets — no database, no server |
| Search | In-memory search over the loaded book |
| Copy/Share | `Clipboard` (via `SelectionArea`) + `share_plus` |
| Language/direction | Arabic content, RTL layout throughout |

## Project structure

```
lib/
├── main.dart / app.dart        # Entry point, MaterialApp + theme + RTL
├── core/                       # Design tokens (colors, fonts, spacing)
├── models/                     # Book → Chapter → Section → ContentBlock
├── data/                       # books_repository.dart, search_service.dart
├── screens/                    # home (library), toc, chapter (reader), search
├── widgets/                    # book_card, chapter_tile, content_renderer, ...
└── assets_data/books/          # One folder per book: book.json (+ images/)
```

Full spec: [`docs/PROJECT_SPEC.md`](docs/PROJECT_SPEC.md). Visual reference: [`docs/ui_mockup.html`](docs/ui_mockup.html).

## Getting started

```bash
flutter pub get
flutter run
```

Run the test suite:

```bash
flutter test
flutter analyze
```

## Content

Both books' text was produced by OCR from the source PDFs (their original text layers were corrupted). Accuracy is high but **not final** — a small share of lines are OCR noise from decorative page borders, and occasional word-level misreads are possible. This is religious/Quranic content, so **neither book should ship publicly without a human proofreading pass**, ideally by the author.

One referenced image is not yet bundled — see [`docs/IMAGES_NEEDED.md`](docs/IMAGES_NEEDED.md). Missing images render with a clear fallback in the reader rather than a broken image.
