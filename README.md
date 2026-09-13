# المتمم المفيد — Book Reader App

A fully offline Flutter app that turns the book *"المتمم المفيد" (للمدخل إلى علم التجويد)* into an organized, comfortable-to-read mobile reading experience — instead of a raw PDF.

## Features

- **Read** the book organized by chapters and sections, with headings, paragraphs, and inline images rendered in order.
- **Search** the entire book's content in-memory; tap a result to jump straight to that spot in the chapter.
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
├── screens/                    # home, toc, chapter (reader), search
├── widgets/                    # book_card, chapter_tile, content_renderer, ...
└── assets_data/books/          # Bundled book.json + images
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

The bundled book's images are not all final yet — see [`docs/IMAGES_NEEDED.md`](docs/IMAGES_NEEDED.md) for the list of placeholders pending real artwork. Missing images render with a clear fallback in the reader rather than a broken image.
